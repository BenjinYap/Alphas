package Game.Items {
	import Game.Item;
	import Game.Abilities.SlowAbility;
	
	public class SlowItem extends Item {
		
		public function SlowItem () {
			gameName = "Slow";
			desc = "Periodically slows some of the alphas for a few seconds";
			isOneTime = true;
			cost = 1;
			abilityLink = SlowAbility;
		}
	}
}