package Game.Items {
	import Game.Item;
	import Game.Abilities.ExplosionAbility;
	
	public class ExplosionItem extends Item {
		
		public function ExplosionItem () {
			gameName = "Explosion";
			desc = "Periodically causes the next number of destroyed by you to explode violently";
			isOneTime = true;
			cost = 4;
			abilityLink = ExplosionAbility;
		}
	}
}