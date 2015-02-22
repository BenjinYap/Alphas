package Screener.ModalScreens {
	import flash.display.*;
	import flash.events.*;
	import flash.ui.*;
	import flash.utils.*;
	import Screener.*;
	import Game.*;
	import Game.Abilities.*;
	
	public final class PauseScreen extends BaseScreen {
		private var mouseDownTargets:Array;
		private var items:Array;
		private var currentItem:Item;
		
		private var abilities:Array;
		private var techPoints:int;
		
		public override function Initialize (arg:Object = null) {
			if (arg.mode == GameMode.Hardcore) {
				gotoAndStop ("Hardcore");
			} else {
				gotoAndStop ("Normal");
			}
			
			abilities = arg.abilities;
			techPoints = arg.techPoints;
			
			mouseDownTargets = [bttMenu, bttSound, bttMusic, bttPurchase, bttResume];
			items = [slow1, slow2, freeze1, freeze2, explosion1, explosion2, multikill1, multikill2];
			
			for (var i:int = 0; i < mouseDownTargets.length; i++) {
				mouseDownTargets [i].addEventListener (MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
			}
			
			for (var i:int = 0; i < items.length; i++) {
				items [i].addEventListener (MouseEvent.ROLL_OVER, onItemOver, false, 0, true);
				items [i].addEventListener (MouseEvent.ROLL_OUT, onItemOut, false, 0, true);
				items [i].addEventListener (MouseEvent.MOUSE_DOWN, onItemDown, false, 0, true);
			}
			
			txtPoints.text = techPoints.toString () + " Tech points";
			itemGlow1.visible = false;
			itemGlow2.visible = false;
			bttPurchase.visible = false;
			UpdateItems ();
			
			bttSound.alpha = (SoundManager.soundOn) ? 1 : 0.2;
			bttMusic.alpha = (SoundManager.musicOn) ? 1 : 0.2;
			
			setTimeout (Activate, 1);
		}
		
		public override function Activate (arg:Object = null) {
			if (arg != null) {
				if (arg.message == "quit") {
					screenMgr.RemoveModalScreen ({message:"quit"});
				}
			} else {
				stage.addEventListener (KeyboardEvent.KEY_DOWN, onStageKeyDown, false, 0, true);
				stage.focus = stage;
			}
		}
		
		public override function Deactivate () {
			stage.removeEventListener (KeyboardEvent.KEY_DOWN, onStageKeyDown);
		}
		
		public override function PrepareToDie () {
			Deactivate ();
			
			for (var i:int = 0; i < mouseDownTargets.length; i++) {
				mouseDownTargets [i].removeEventListener (MouseEvent.MOUSE_DOWN, onMouseDown);
			}
		}

		private function onMouseDown (e:MouseEvent) {
			if (e.currentTarget == bttMenu) {
				screenMgr.AddModalScreen (ScreenType.Confirm);
			} else if (e.currentTarget == bttSound) {
				SoundManager.soundOn = (SoundManager.soundOn) ? false : true;
				bttSound.alpha = (SoundManager.soundOn) ? 1 : 0.2;
			} else if (e.currentTarget == bttMusic) {
				SoundManager.musicOn = (SoundManager.musicOn) ? false : true;
				bttMusic.alpha = (SoundManager.musicOn) ? 1 : 0.2;
				
				if (SoundManager.musicOn) {
					SoundManager.UnmuteMusic ();
				} else {
					SoundManager.MuteMusic ();
				}
			} else if (e.currentTarget == bttPurchase) {
				techPoints -= currentItem.cost;
				txtPoints.text = techPoints.toString () + " Tech points";
				var ability:Ability = abilities [int (items.indexOf (currentItem) / 2)];
				ability.level++;
				currentItem.dispatchEvent (new MouseEvent (MouseEvent.MOUSE_DOWN));
				UpdateItems ();
				UpdateAbilities ();
				stage.focus = stage;
			} else if (e.currentTarget == bttResume) {
				UpdateAbilities ();
				screenMgr.RemoveModalScreen ({message:"resume", techPoints:techPoints});
			}
		}
		
		private function onItemOver (e:MouseEvent) {
			if (currentItem == null) {
				itemGlow1.x = e.currentTarget.x;
				itemGlow1.y = e.currentTarget.y;
				itemGlow1.visible = true;
			} else {
				itemGlow2.x = e.currentTarget.x;
				itemGlow2.y = e.currentTarget.y;
				itemGlow2.visible = true;
			}
		}
		
		private function onItemOut (e:MouseEvent) {
			if (currentItem == null) {
				itemGlow1.visible = false;
			} else {
				if (currentItem != e.currentTarget) {
					itemGlow2.visible = false;
				}
			}
		}
		
		private function onItemDown (e:MouseEvent) {
			var item:Item = Item (e.currentTarget);
			var ability:Ability = abilities [int (items.indexOf (item) / 2)];
			
			currentItem = item;
			itemGlow1.x = item.x;
			itemGlow1.y = item.y;
			itemGlow2.visible = false;
			
			txtNextDesc.text = "";
			
			txtName.text = item.gameName;
			
			if (item.isOneTime) {
				if (ability.level == 0) {
					txtCost.text = "Costs " + item.cost.toString () + " Tech points";
					bttPurchase.visible = (techPoints >= item.cost) ? true : false;
				} else {
					txtCost.text = "Already purchased";
					bttPurchase.visible = false;
				}
			} else {
				if (ability.level == ability.maxLevel) {
					txtCost.text = "Maxed out";
					bttPurchase.visible = false;
				} else {
					txtCost.text = "Costs " + item.cost.toString () + " Tech points";
					txtNextDesc.text = item.nextDesc.replace ("@", (ability.startValue + ability.level * ability.valueIncrement).toString ());
					bttPurchase.visible = (techPoints >= item.cost && ability.level > 0) ? true : false;
				}
			}
			
			txtDesc.text = item.desc.replace ("@", (ability.startValue + (ability.level - 1) * ability.valueIncrement).toString ());
			
			stage.focus = stage;
		}
		
		private function onStageKeyDown (e:KeyboardEvent) {
			if (e.keyCode == Keyboard.ESCAPE) {
				UpdateAbilities ();
				screenMgr.RemoveModalScreen ({message:"resume", techPoints:techPoints});
			}
		}
		
		private function UpdateItems () {     //Sets the alpha of the repeating items
			for (var i:int = 0; i < items.length; i++) {
				if (items [i].isOneTime == false) {
					items [i].alpha = (abilities [int (i / 2)].level > 0) ? 1 : 0.5;
				}
			}
		}
		
		private function UpdateAbilities () {  //Sets the new values for each ability
			for (var i:int = 0; i < abilities.length; i++) {
				abilities [i].value = abilities [i].startValue + (abilities [i].level - 1) * abilities [i].valueIncrement;
			}
		}
	}
}