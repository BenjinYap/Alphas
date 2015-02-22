package Game {
	import flash.display.MovieClip;
	import flash.events.*;
	
	public class Item extends MovieClip {
		public var gameName:String;
		public var desc:String;
		public var isOneTime:Boolean;
		public var nextDesc:String;
		public var cost:int;
		public var abilityLink:Class;
		
		public function Initialize () {
			
		}
		
		public function PrepareToDie () {
			
		}
	}
}