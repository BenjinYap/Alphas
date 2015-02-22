package Game {
	import flash.geom.*;
	import Screener.*;
	
	public final class GameData {
		public static var soundOn:Boolean = true;
		public static var musicOn:Boolean = true;
		
		public static var score:Number = 0;
		
		public static function Reset () {
			score = 0;
		}
	}
}