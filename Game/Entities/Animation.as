package Game.Entities {
	import flash.events.Event;
	import flash.display.DisplayObject;
	import Game.Entity;
	import Game.GameEvent;
	
	public class Animation extends Entity {
		public var target:DisplayObject;
		protected var isLooping:Boolean;
		protected var duration:int;
		
		public override function Initialize () {
			gotoAndPlay (1);
			Activate ();
		}
		
		public override function Activate () {
			play ();
		}
		
		public override function Deactivate () {
			stop ();
		}
		
		public override function Update () {
			if (target != null) {
				x = target.x;
				y = target.y;
			}
			
			if (isLooping == false) {
				if (currentFrame == totalFrames) {
					dispatchEvent (new GameEvent (GameEvent.AnimationDone));
				}
			} else {
				duration--;
				
				if (duration <= 0) {
					dispatchEvent (new GameEvent (GameEvent.AnimationDone));
				}
			}
		}
		
		public function SetTarget (Target:DisplayObject) {
			target = Target;
		}
	}
}