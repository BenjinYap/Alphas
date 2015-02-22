package Game.Entities.Animations {
	import flash.display.*;
	import flash.geom.Point;
	import Game.Entities.Animation;
	
	public class MultikillAnimation extends Animation {
		
		public function MultikillAnimation () {
			isLooping = true;
			duration = 10;
			super ();
		}
		
		public function SetPoints (p1:Point, p2:Point) {
			var g:Graphics = graphics;
			g.lineStyle (2, 0x990000, 0.5);
			g.moveTo (p1.x, p1.y);
			g.curveTo (p1.x, p2.y, p2.x, p2.y);
			g.moveTo (p1.x, p1.y);
			g.curveTo (p2.x, p1.y, p2.x, p2.y);
		}
	}
}