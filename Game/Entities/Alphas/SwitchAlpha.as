package Game.Entities.Alphas {
	import Game.Entities.Alpha;
	
	public final class SwitchAlpha extends Alpha {
		private static const switchPeriod:int = 30;        //Frames that the alpha keeps switching alphabets
		private static const stayPeriod:int = 150;          //Frames that the alpha stays on one alphabet
		
		private var switching:Boolean = true;
		private var switchFrame:int = switchPeriod;
		private var stayFrame:int = 0;
		
		public override function Initialize () {
			speed = 2;
			super.Initialize ();
			showName = "Switch";
			score = 125;
		}
		
		public override function Update () {
			super.Update ();
			
			if (switching) {
				if (switchFrame > 0) {
					var alphabets:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
					txt.text = alphabets.charAt (Math.floor (Math.random () * alphabets.length));
					switchFrame--;
				} else {
					switching = false;
					stayFrame = stayPeriod;
				}
			} else {
				if (stayFrame > 0) {
					stayFrame--;
				} else {
					switching = true;
					switchFrame = switchPeriod;
				}
			}
		}
	}
}