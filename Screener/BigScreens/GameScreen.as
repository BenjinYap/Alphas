package Screener.BigScreens {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.ui.*;
	import Screener.*;
	import Game.*;
	import Game.Entities.*;
	import Game.Entities.Alphas.*;
	import Game.Entities.Animations.*;
	import Game.Abilities.*;
	
	public final class GameScreen extends BaseScreen {
		private static const numAlphaTypes:int = 6;
		private static const alphaClasses:Array = [NormalAlpha, GrowAlpha, FadeAlpha, BlurAlpha, SwitchAlpha, SplitAlpha];
		private static const alphaDebuts:Array = [0, 0, 900, 1800, 2700, 3600];
		private static const alphaStartRates:Array = [30, 60, 90, 90, 120, 150];
		private static const alphaEndRates:Array = [30, 30, 30, 30, 30, 30];
		private static const alphaDecreaseRates:Array = [150, 150, 150, 150, 150, 150];
		
		private static const timedDuration:int = 7200;
		
		private static const hitsPerUpgrade:int = 25;
		
		private var alphaRates:Array = [];
		private var alphaCountdowns:Array = [];
		
		private var abilityEngine:AbilityEngine = new AbilityEngine ();
		
		private var misses:int = 0;
		private var hits:int = 0;
		private var accuracy:Number = 0;
		private var hitsSinceUpgrade:int = 0;
		
		private var explosionsLeft:int = 0;
		private var multikillsLeft:int = 0;
		
		private var maxHP:int = 50000;
		private var hp:int = maxHP;
		private var score:int = 0;
		
		private var abilities:Array = [new SlowAbility (), new FreezeAbility (), new ExplosionAbility (), new MultikillAbility ()];
		private var techPoints:int = 0;
		
		private var cloudCont:Sprite = new Sprite ();     //Contains the clouds
		private var entityCont:Sprite = new Sprite ();    //Contains the alphas and their animations
		private var scoreCont:Sprite = new Sprite ();     //Contains the floating scores
		
		private var entityPool:Array = [];
		
		private var deadEntities:Array = [];
		
		private var gameOver:Boolean = false;
		private var mode:String;
		
		private var frame:int = 0;
		
		public override function Initialize (arg:Object = null) {
			GameData.Reset ();
			
			mode = arg.mode;
			
			(mode == GameMode.Timed) ? hud.gotoAndStop ("Timed") : hud.gotoAndStop ("Endless");
			
			alphaRates = alphaStartRates.concat ();
			alphaCountdowns = alphaRates.concat ();
			
			addChild (cloudCont);
			addChild (entityCont);
			addChild (scoreCont);
			
			var lines:Array = ["ENEMY", "ALPHAS", "INBOUND"];
			
			for (var i:int = 0; i < lines.length; i++) {
				var lineLength:int = lines [i].length;
				
				for (var j:int = 0; j < lineLength; j++) {
					CreateAlpha (AlphaType.Normal, new Point (stage.stageWidth / 2 - 30 * lineLength / 2 + j * 30 + 15, 0 - i * 50), 2, Math.PI / 2, lines [i].charAt (j));
				}
			}
			
			abilityEngine.addEventListener (GameEvent.AbilityRecharge, onAbilityRecharge, false, 0, true);
			
			for (var i:int = 0; i < 5; i++) {
				var cloud:Cloud = new Cloud ();
				cloudCont.addChild (cloud);
				cloud.Initialize ();
			}
			
			techPointNotice.stop ();
			addChild (techPointNotice);
			deadPaper.stop ();
			deadPaper.visible = false;
			addChild (deadPaper);
			
			addChild (hud);
			
			txtCapture.needsSoftKeyboard = true;
			
			Activate ({message:"resume", techPoints:techPoints});
		}
		
		public override function Activate (arg:Object = null) {
			if (arg != null) {
				if (arg.message == "quit") {
					screenMgr.NewBigScreen (ScreenType.Menu);
				} else if (arg.message == "resume") {
					techPoints = arg.techPoints;
					
					addEventListener (Event.ENTER_FRAME, onFrame, false, 0, true);
				
					abilityEngine.SetAbilities (abilities);
					
					for (var i:int = 0; i < entityCont.numChildren; i++) {
						Entity (entityCont.getChildAt (i)).Activate ();
					}
					
					techPointNotice.play ();
					paper.play ();
					
					txtCapture.addEventListener (KeyboardEvent.KEY_DOWN, onStageKeyDown, false, 0, true);
					stage.focus = txtCapture;
				}
			}
		}
		
		public override function Deactivate () {
			removeEventListener (Event.ENTER_FRAME, onFrame);
			
			for (var i:int = 0; i < entityCont.numChildren; i++) {
				Entity (entityCont.getChildAt (i)).Deactivate ();
			}
			
			techPointNotice.stop ();
			paper.stop ();
			
			txtCapture.removeEventListener (KeyboardEvent.KEY_DOWN, onStageKeyDown);
		}
		
		public override function PrepareToDie () {
			Deactivate ();
			
			for (var i:int = 0; i < entityCont.numChildren; i++) {
				Entity (entityCont.getChildAt (i)).PrepareToDie ();
			}
		}
		
		private function onFrame (e:Event) {
			stage.focus = txtCapture;
			
			if (gameOver == false) {
				abilityEngine.Update ();
				HandleAlphaSpawning ();
				
				var entityConts:Array = [cloudCont, entityCont, scoreCont];
				var numEntityConts:int = entityConts.length;
				
				for (var i:int = 0; i < numEntityConts; i++) {
					var entityCont:Sprite = entityConts [i];
					var numKids:int = entityCont.numChildren;
					
					for (var j:int = 0; j < numKids; j++) {
						Entity (entityCont.getChildAt (j)).Update ();
					}
				}
				
				var numDeadEntities:int = deadEntities.length;
				
				for (var i:int = 0; i < numDeadEntities; i++) {
					var deadEntity:Entity = deadEntities [i];
					deadEntity.PrepareToDie ();
					
					if (deadEntity is Alpha) {
						if (deadEntity is SplitAlpha) {
							deadEntity.removeEventListener (GameEvent.AlphaSplit, onAlphaSplit);
						}
						
						deadEntity.removeEventListener (GameEvent.AlphaOffStage, onAlphaOffStage);
						deadEntity.removeEventListener (GameEvent.AlphaUnfreeze, onAlphaUnfreeze);
					}
					
					deadEntity.parent.removeChild (deadEntity);
					entityPool.push (deadEntity);
				}
				
				deadEntities = [];
				
				if (mode == GameMode.Timed) {
					if (frame == timedDuration) {
						GameOver ();
					}
					
					hud.timeBar.bar.scaleX = 1 - frame / timedDuration;
				}
				
				frame++;
			} else {
				if (deadPaper.currentFrame == deadPaper.totalFrames) {
					screenMgr.NewBigScreen (ScreenType.GameOver, {mode:mode, score:score, accuracy:accuracy});
				}
			}
		}
		
		private function onStageKeyDown (e:KeyboardEvent) {
			var key:uint = e.keyCode;
			
			if (key == Keyboard.ESCAPE) {
				screenMgr.AddModalScreen (ScreenType.Pause, {mode:mode, techPoints:techPoints, abilities:abilities});
			} else if (key >= 65 && key <= 90) {
				CheckForHits (String.fromCharCode (key));
			}
			
			txtCapture.text = "";
		}
		
		private function onAlphaOffStage (e:GameEvent) {
			DestroyAlpha (Alpha (e.currentTarget), false);
			hp--;
			paper.gotoAndPlay ("Hurt");
			hud.hpBar.bar.scaleX = hp / maxHP;
			
			if (hp <= 0) {
				GameOver ();
			}
		}
		
		private function onAlphaSplit (e:GameEvent) {
			var alpha:Alpha = Alpha (e.currentTarget);
			CreateAlpha (AlphaType.Normal, new Point (alpha.x, alpha.y));
			CreateAlpha (AlphaType.Normal, new Point (alpha.x, alpha.y));
			DestroyAlpha (alpha, false);
		}
		
		private function onAbilityRecharge (e:GameEvent) {
			var ability:Ability = e.data.ability;
			
			if (ability.type == AbilityType.Slow) {
				SlowAlphas (ability.value);
			} else if (ability.type == AbilityType.Freeze) {
				FreezeAlphas (ability.value);
			} else if (ability.type == AbilityType.Explosion) {
				explosionsLeft = ability.value;
			} else if (ability.type == AbilityType.Multikill) {
				multikillsLeft = ability.value;
			}
		}
		
		private function onScoreGainDone (e:GameEvent) {
			deadEntities.push (Entity (e.currentTarget));
		}
		
		private function onAnimationDone (e:GameEvent) {
			deadEntities.push (Entity (e.currentTarget));
		}
		
		private function onAlphaUnfreeze (e:GameEvent) {
			DisplayObject (e.currentTarget).removeEventListener (GameEvent.AlphaUnfreeze, onAlphaUnfreeze);
			CreateAnimation (FreezeBreakAnimation, new Point (DisplayObject (e.currentTarget).x, DisplayObject (e.currentTarget).y));
			//CreateFreezeBreakAnimation (new Point (DisplayObject (e.currentTarget).x, DisplayObject (e.currentTarget).y));
			SoundManager.PlayFreezeBreak ();
		}
		
		private function DestroyAlpha (alpha:Alpha, giveScore:Boolean) {
			if (deadEntities.indexOf (alpha) == -1) {
				deadEntities.push (Entity (alpha));
				
				for (var i:int = 0; i < entityCont.numChildren; i++) {
					var entity:Entity = Entity (entityCont.getChildAt (i));
					
					if (entity is Animation) {
						if (Animation (entity).target == alpha) {
							deadEntities.push (entity);
						}
					}
				}
				
				if (giveScore) {
					score += alpha.score;
					hud.txtScore.text = score.toString ();
					
					var scoreGain:ScoreGain = new ScoreGain ();
					scoreGain.addEventListener (GameEvent.ScoreGainDone, onScoreGainDone, false, 0, true);
					entityCont.addChild (scoreGain);
					scoreGain.SetText (alpha.showName + "\n" + alpha.score.toString ());
					scoreGain.SetCoords (new Point (alpha.x, alpha.y));
					
					CreateAlphaDeathAnimation (new Point (alpha.x, alpha.y));
				}
			}
		}
		
		private function HandleAlphaSpawning () {
			for (var i:int = 0; i < numAlphaTypes; i++) {
				if (frame >= alphaDebuts [i]) {
					alphaCountdowns [i] = (alphaCountdowns [i] > 0) ? alphaCountdowns [i] - 1 : alphaCountdowns [i];
					
					if (alphaCountdowns [i] <= 0) {
						alphaCountdowns [i] = alphaRates [i] * (1 + Math.random () * (0.2) - 0.1);
						CreateAlpha (alphaClasses [i]);
					}
					
					if (alphaRates [i] > alphaEndRates [i]) {
						alphaRates [i] = (frame % alphaDecreaseRates [i] == 0) ? alphaRates [i] - 1 : alphaRates [i];
					}
				}
			}
		}
		
		private function CreateAlpha (type:Class, coords:Point = null, speed:Number = NaN, angleRad:Number = NaN, alphabet:String = null) {
			var alpha:Alpha;
			var foundInPool:Boolean = false;
			
			for (var i:int = 0; i < entityPool.length; i++) {
				if (entityPool [i] is type) {
					alpha = entityPool [i];
					entityPool.splice (i, 1);
					foundInPool = true;
					break;
				}
			}
			
			alpha = (foundInPool == false) ? new type () : alpha;
			alpha.addEventListener (GameEvent.AlphaOffStage, onAlphaOffStage, false, 0, true);
			
			if (type == SplitAlpha) {
				alpha.addEventListener (GameEvent.AlphaSplit, onAlphaSplit, false, 0, true);
			}
			
			entityCont.addChild (alpha);
			alpha.Initialize ();
			
			if (coords != null) {
				alpha.SetCoords (coords);
			}
			
			if (isNaN (speed) == false) {
				alpha.SetSpeedAngle (speed, angleRad);
			}
			
			if (alphabet != null) {
				alpha.SetAlphabet (alphabet);
			}
		}
		
		private function FindMatchingAlphas (alphabet:String):Array {
			var numEntities:int = entityCont.numChildren;
			
			var matchedAlphas:Array = [];
			
			for (var i:int = 0; i < numEntities; i++) {
				var entity:Entity = Entity (entityCont.getChildAt (i));
				
				if (entity is Alpha) {
					if (Alpha (entity).txt.text == alphabet) {
						if (deadEntities.indexOf (entity) == -1) {
							matchedAlphas.push (Alpha (entity));
						}
					}
				}
			}
			
			return matchedAlphas;
		}
		
		private function SortMatchingAlphas (alphas:Array) {
			var alphasLength:int = alphas.length;
			
			for (var i:int = 0; i < alphasLength; i++) {
				for (var j:int = i + 1; j < alphasLength; j++) {
					if (alphas [j].y > alphas [i].y) {
						var temp:Alpha = alphas [i];
						alphas [i] = alphas [j];
						alphas [j] = temp;
					}
				}
			}
		}
		
		private function GetTargetAlpha (alphas:Array):Alpha {
			var alphasLength:int = alphas.length;
			var lowestAlpha:Alpha = alphas [0];
			
			for (var i:int = 1; i < alphasLength; i++) {
				lowestAlpha = (alphas [i].y > lowestAlpha.y) ? alphas [i] : lowestAlpha;
			}
			
			return lowestAlpha;
		}
		
		private function CheckForHits (alphabet:String) {
			var matchedAlphas:Array = FindMatchingAlphas (alphabet);
			
			if (matchedAlphas.length == 0) {
				misses++;
			} else {
				var targetAlpha:Alpha = GetTargetAlpha (matchedAlphas);
				matchedAlphas.splice (matchedAlphas.indexOf (targetAlpha), 1);
				DestroyAlpha (targetAlpha, true);
				hits++;
				hitsSinceUpgrade++;
				SoundManager.PlayType ();
				
				if (explosionsLeft > 0) {
					explosionsLeft--;
					SoundManager.PlayExplosion ();
					
					for (var i:int = 0; i < entityCont.numChildren; i++) {
						if (entityCont.getChildAt (i) is Alpha) {
							var alpha:Alpha = Alpha (entityCont.getChildAt (i));
							
							if (alpha != targetAlpha) {        //Don't blow up the original alpha again
								if (Point.distance (new Point (targetAlpha.x, targetAlpha.y), new Point (alpha.x, alpha.y)) <= 100) {
									DestroyAlpha (alpha, true);
									hits++;
									hitsSinceUpgrade++;
								}
							}
						}
					}
				}
				
				while (multikillsLeft > 0) {
					multikillsLeft--;
					
					matchedAlphas = FindMatchingAlphas (alphabet);
					
					if (matchedAlphas.length > 0) {
						var p1:Point = new Point (targetAlpha.x, targetAlpha.y);
						targetAlpha = GetTargetAlpha (matchedAlphas);
						var p2:Point = new Point (targetAlpha.x, targetAlpha.y);
						CreateAnimation (MultikillAnimation, {p1:p1, p2:p2});
						DestroyAlpha (targetAlpha, true);
						hits++;
						hitsSinceUpgrade++;
					}
				}
			}
			
			hud.txtKills.text = hits.toString ();
			accuracy = hits / (hits + misses);
			hud.txtAccuracy.text = Math.round (accuracy * 100).toString () + "%";
			
			if (mode != GameMode.Hardcore) {
				if (hitsSinceUpgrade >= hitsPerUpgrade) {
					hitsSinceUpgrade -= hitsPerUpgrade;
					techPoints++;
					techPointNotice.gotoAndPlay ("Notice");
				}
			}
		}
		
		private function GetPercAlphas (perc:Number):Array {
			var alphas:Array = [];
			
			for (var i:int = 0; i < entityCont.numChildren; i++) {
				var entity:DisplayObject = DisplayObject (entityCont.getChildAt (i));
				
				if (entity is Alpha) {
					alphas.push (entity);
				}
			}
			
			for (var i:int = 0; i < alphas.length; i++) {
				var rand:int = Math.floor (Math.random () * alphas.length);
				var temp:Alpha = alphas [rand];
				alphas [rand] = alphas [i];
				alphas [i] = temp;
			}
			
			if (int (alphas.length * perc / 100) < 1) {
				alphas = [alphas [0]];
			} else {
				alphas = alphas.slice (0, int (alphas.length * perc / 100));
			}
			
			return alphas;
		}
		
		private function SlowAlphas (perc:Number) {
			var alphas:Array = GetPercAlphas (perc);
			
			for (var i:int = 0; i < alphas.length; i++) {
				alphas [i].Slow ();
				CreateAnimation (SlowedAnimation, alphas [i]);
			}
		}
		
		private function FreezeAlphas (perc:Number) {
			var alphas:Array = GetPercAlphas (perc);
			
			for (var i:int = 0; i < alphas.length; i++) {
				alphas [i].addEventListener (GameEvent.AlphaUnfreeze, onAlphaUnfreeze, false, 0, true);
				alphas [i].Freeze ();
				CreateAnimation (FrozenAnimation, alphas [i]);
			}
			
			(alphas.length > 0) ? SoundManager.PlayFreeze () : 1;
		}
		
		private function CreateAnimation (animationClass:Class, arg:Object) {
			var animation:Animation;
			var foundInPool:Boolean = false;
			
			for (var i:int = 0; i < entityPool.length; i++) {
				if (entityPool [i] is animationClass) {
					animation = entityPool [i];
					entityPool.splice (i, 1);
					foundInPool = true;
					break;
				}
			}
			
			animation = (foundInPool == false) ? new animationClass () : animation;
			
			if (arg is Point) {
				animation.SetCoords (Point (arg));
			} else if (arg is DisplayObject) {
				animation.SetTarget (DisplayObject (arg));
			} else {
				MultikillAnimation (animation).SetPoints (arg.p1, arg.p2);
			}
			
			animation.addEventListener (GameEvent.AnimationDone, onAnimationDone, false, 0, true);
			entityCont.addChild (animation);
			animation.Initialize ();
		}
		
		private function CreateAlphaDeathAnimation (coords:Point) {
			var animation:Animation = new AlphaDeathAnimation ();
			animation.SetCoords (coords);
			animation.addEventListener (GameEvent.AnimationDone, onAnimationDone, false, 0, true);
			entityCont.addChild (animation);
			animation.Initialize ();
		}
		
		private function CreateSlowedAnimation (animationTarget:DisplayObject) {
			var animation:Animation = new SlowedAnimation ();
			animation.SetTarget (animationTarget);
			animation.addEventListener (GameEvent.AnimationDone, onAnimationDone, false, 0, true);
			entityCont.addChild (animation);
			animation.Initialize ();
		}
		
		private function CreateFrozenAnimation (animationTarget:DisplayObject) {
			var animation:Animation = new FrozenAnimation ();
			animation.SetTarget (animationTarget);
			animation.addEventListener (GameEvent.AnimationDone, onAnimationDone, false, 0, true);
			entityCont.addChild (animation);
			animation.Initialize ();
		}
		
		private function CreateFreezeBreakAnimation (coords:Point) {
			var animation:Animation = new FreezeBreakAnimation ();
			animation.SetCoords (coords);
			animation.addEventListener (GameEvent.AnimationDone, onAnimationDone, false, 0, true);
			entityCont.addChild (animation);
			animation.Initialize ();
		}
		
		private function CreateMultikillAnimation (p1:Point, p2:Point) {
			var animation:MultikillAnimation = new MultikillAnimation ();
			animation.SetPoints (p1, p2);
			animation.addEventListener (GameEvent.AnimationDone, onAnimationDone, false, 0, true);
			entityCont.addChild (animation);
			animation.Initialize ();
		}
		
		private function GameOver () {
			gameOver = true;
			deadPaper.visible = true;
			deadPaper.gotoAndPlay (1);
			Deactivate ();
			addEventListener (Event.ENTER_FRAME, onFrame, false, 0, true);
		}
	}
}