package Game.Entities.Alphas {
	import Game.Entities.Alpha;
	import Game.GameEvent;
	
	public final class SplitAlpha extends Alpha {
		private static const splitTimer:int = 150;          //Frames before the alpha splits in 2
		private static const maxSplitScale:Number = 2;     //Max scale that the alpha can be before splitting
		
		private var splitCountdown:int = splitTimer;
		
		public override function Initialize () {
			speed = 2;
			super.Initialize ();
			showName = "Split";
			score = 150;
		}
		
		public override function Update () {
			super.Update ();
			
			splitCountdown--;
			scaleX = 1 + Math.random () * (1 - (splitCountdown / splitTimer)) * maxSplitScale;
			scaleY = 1 + Math.random () * (1 - (splitCountdown / splitTimer)) * maxSplitScale;
			
			if (splitCountdown <= 0) {
				dead = true;
				dispatchEvent (new GameEvent (GameEvent.AlphaSplit));
			}
		}
	}
}