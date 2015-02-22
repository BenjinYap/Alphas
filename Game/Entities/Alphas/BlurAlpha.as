package Game.Entities.Alphas {
	import flash.filters.BlurFilter;
	import Game.Entities.Alpha;
	
	public final class BlurAlpha extends Alpha {
		private static const blurPeriod:int = 30;          //Frames it takes to reach max blur from no blur
		private static const maxBlur:int = 4;              //Max blurX and blurY
		
		private var blurring:Boolean = true;
		
		public override function Initialize () {
			speed = 2;
			super.Initialize ();
			showName = "Blur";
			score = 100;
			filters = [new BlurFilter ()];
		}
		
		public override function PrepareToDie () {
			filters = [];
		}
		
		public override function Update () {
			super.Update ();
			
			var blurIncrement:Number = maxBlur / blurPeriod;
			var blur:BlurFilter = filters [0];
			
			if (blurring) {
				if (blur.blurX + blurIncrement > maxBlur) {
					blur.blurX = maxBlur;
					blurring = false;
				} else {
					blur.blurX += blurIncrement;
				}
			} else {
				if (blur.blurX - blurIncrement < 0) {
					blur.blurX = 0;
					blurring = true;
				} else {
					blur.blurX -= blurIncrement;
				}
			}
			
			blur.blurY = blur.blurX;
			filters = [blur];
		}
	}
}