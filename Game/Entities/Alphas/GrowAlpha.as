package Game.Entities.Alphas {
	import Game.Entities.Alpha;
	
	public final class GrowAlpha extends Alpha {
		private static const maxScale:Number = 2;
		private static const growPeriod:int = 30;          //Frames it takes to grow to max size
		
		private var growing:Boolean = true;
		
		public override function Initialize () {
			speed = 2;
			super.Initialize ();
			showName = "Grow";
			score = 75;
		}
		
		public override function Update () {
			super.Update ();
			
			var growIncrement:Number = 1 / growPeriod;
				
			if (growing) {
				if (scaleX + growIncrement > maxScale) {
					scaleX = maxScale;
					growing = false;
				} else {
					scaleX += growIncrement;
				}
			} else {
				if (scaleX - growIncrement < 1) {
					scaleX = 1;
					growing = true;
				} else {
					scaleX -= growIncrement;
				}
			}
			
			scaleY = scaleX;
		}
	}
}