package Game.Entities.Alphas {
	import Game.Entities.Alpha;
	
	public final class FadeAlpha extends Alpha {
		private static const minAlpha:Number = 0.1;
		private static const fadePeriod:int = 30;          //Frames it takes to fade to min alpha
		
		private var fadingOut:Boolean = true;
		
		public override function Initialize () {
			speed = 2;
			super.Initialize ();
			showName = "Fade";
			score = 100;
		}
		
		public override function Update () {
			super.Update ();
			
			var fadeIncrement:Number = 1 / fadePeriod;
				
			if (fadingOut) {
				if (alpha - fadeIncrement < minAlpha) {
					alpha = minAlpha;
					fadingOut = false;
				} else {
					alpha -= fadeIncrement;
				}
			} else {
				if (alpha + fadeIncrement > 1) {
					alpha = 1;
					fadingOut = true;
				} else {
					alpha += fadeIncrement;
				}
			}
		}
	}
}