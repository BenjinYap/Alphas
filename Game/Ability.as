package Game {
	
	public class Ability {
		public var type:String;
		
		public var level:int = 0;
		public var maxLevel:int;
		
		public var startValue:int;
		public var valueIncrement:int;
		public var value:int;
		
		public var active:Boolean;
		public var cooldown:int;
		public var countdown:int;
		
		public function Ability () {
			active = false;
			countdown = cooldown;
		}
		
		public function UpdateValue () {
			value = startValue + (level - 1) * valueIncrement;
		}
	}
}