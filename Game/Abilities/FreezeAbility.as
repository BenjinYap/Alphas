package Game.Abilities {
	import Game.Ability;
	import Game.AbilityType;
	
	public class FreezeAbility extends Ability {
		public static const duration:int = 210;
		
		public function FreezeAbility () {
			type = AbilityType.Freeze;
			maxLevel = 5;
			startValue = 5;
			valueIncrement = 5;
			cooldown = 450;
			super ();
		}
	}
}