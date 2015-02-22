package Game.Abilities {
	import Game.Ability;
	import Game.AbilityType;
	
	public class ExplosionAbility extends Ability {
		
		public function ExplosionAbility () {
			type = AbilityType.Explosion;
			maxLevel = 10;
			startValue = 1;
			valueIncrement = 1;
			cooldown = 300;
			super ();
		}
	}
}