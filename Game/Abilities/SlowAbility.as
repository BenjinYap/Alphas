package Game.Abilities {
	import Game.Ability;
	import Game.AbilityType;
	
	public class SlowAbility extends Ability {
		public static const slowFactor:Number = 0.5;
		public static const duration:int = 150;
		
		public function SlowAbility () {
			type = AbilityType.Slow;
			maxLevel = 10;
			startValue = 5;
			valueIncrement = 5;
			cooldown = 300;
			super ();
		}
	}
}