package Game.Abilities {
	import Game.Ability;
	import Game.AbilityType;
	
	public class MultikillAbility extends Ability {
		
		public function MultikillAbility () {
			type = AbilityType.Multikill;
			maxLevel = 10;
			startValue = 1;
			valueIncrement = 1;
			cooldown = 30;
			super ();
		}
	}
}