package Game {
	import flash.events.Event;
	
	public class Cloud extends Entity {
		private var speed:Number;
		
		public override function Initialize () {
			gotoAndStop (Math.ceil (Math.random () * totalFrames));
			speed = Math.random () * 2 + 1;
			x = Math.random () * stage.stageWidth;
			y = Math.random () * stage.stageHeight;
		}
		
		public override function Update () {
			x -= speed;
			
			if (x + width / 2 < 0) {
				gotoAndStop (Math.ceil (Math.random () * totalFrames));
				speed = Math.random () * 2 + 1;
				x = stage.stageWidth + 200;
				y = Math.random () * stage.stageHeight;
			}
		}
	}
}