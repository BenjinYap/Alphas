package Game.Entities {
	import flash.events.*;
	import flash.geom.Point;
	import flash.text.TextField;
	import Game.*;
	import Game.Abilities.SlowAbility;
	import Game.Abilities.FreezeAbility;
	
	public class Alpha extends Entity {
		private static const angleRange:Number = Math.PI / 2;

		protected var dead:Boolean = false;
		private var slowed:Boolean = false;
		private var slowCountdown:int = 0;
		private var frozen:Boolean = false;
		private var freezeCountdown:int = 0;
		
		public var showName:String;
		public var score:int;
		protected var speed:Number;
		private var xSpeed:Number;
		private var ySpeed:Number;
		
		public var txt:TextField;
		
		public override function Initialize () {
			txt = TextField (getChildByName ("tf"));
			
			var alphabets:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
			txt.text = alphabets.charAt (Math.floor (Math.random () * alphabets.length));
			
			var angleRad:Number = (Math.PI - angleRange) / 2 + Math.random () * angleRange;
			xSpeed = Math.cos (angleRad) * speed;
			ySpeed = Math.sin (angleRad) * speed;
			
			x = width / 2 + Math.random () * stage.stageWidth - width;
			y = -height / 2;
		}
		
		public override function Update () {
			if (dead == false) {
				if (slowed) {
					slowCountdown = (slowCountdown > 0) ? slowCountdown - 1 : slowCountdown;
					
					if (slowCountdown <= 0) {
						slowed = false;
						xSpeed /= SlowAbility.slowFactor;
						ySpeed /= SlowAbility.slowFactor;
					}
				}
				
				if (frozen) {
					freezeCountdown = (freezeCountdown > 0) ? freezeCountdown - 1 : freezeCountdown;
					frozen = (freezeCountdown <= 0) ? false : true;
					
					if (frozen == false) {
						dispatchEvent (new GameEvent (GameEvent.AlphaUnfreeze));
					}
					
					x -= xSpeed;
					y -= ySpeed;
				}
				
				x += xSpeed;
				y += ySpeed;
				
				if (x - width / 2 < 0) {
					x = width / 2;
					xSpeed *= -1;
				} else if (x + width / 2 > stage.stageWidth) {
					x = stage.stageWidth - width / 2;
					xSpeed *= -1;
				}
				
				if (y > stage.stageHeight - 40) {
					dispatchEvent (new GameEvent (GameEvent.AlphaOffStage));
				}
			}
		}
		
		public function SetSpeedAngle (speed:Number, angleRad:Number) {
			xSpeed = Math.cos (angleRad) * speed;
			ySpeed = Math.sin (angleRad) * speed;
		}
		
		public function SetAlphabet (alphabet:String) {
			txt.text = alphabet;
		}
		
		public function Slow () {
			slowed = true;
			slowCountdown = SlowAbility.duration;
			xSpeed *= SlowAbility.slowFactor;
			ySpeed *= SlowAbility.slowFactor;
		}
		
		public function Freeze () {
			frozen = true;
			freezeCountdown = FreezeAbility.duration;
		}
	}
}