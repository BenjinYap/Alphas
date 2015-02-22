package Game.Entities.Alphas {
	import Game.Entities.Alpha;
	
	public final class NormalAlpha extends Alpha {
		
		public override function Initialize () {
			speed = 2;
			super.Initialize ();
			showName = "Normal";
			score = 50;
		}
	}
}