package Game.Items {
	import Game.Item;
	import Game.Abilities.ExplosionAbility;
	
	public class ExplosionCountItem extends Item {
		
		public function ExplosionCountItem () {
			gameName = "Improved Explosion";
			desc = "Causes the next @ alphas to explode";
			isOneTime = false;
			nextDesc = "Next Level: Increases to @ alphas";
			cost = 4;
			abilityLink = ExplosionAbility;
		}
	}
}