package Game {
	import flash.events.Event;
	
	public class ScoreGain extends Entity {
		private static const duration:int = 30;
		
		private var countdown:int = duration;
		
		public override function Update () {
			if (countdown > 0) {
				countdown--;
			} else {
				dispatchEvent (new GameEvent (GameEvent.ScoreGainDone));
			}
		}
		
		public function SetText (text:String) {
			txt.text = String (text);
		}
	}
}