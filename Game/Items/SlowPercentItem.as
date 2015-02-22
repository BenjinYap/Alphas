package Game.Items {
	import Game.Item;
	import Game.Abilities.SlowAbility;
	
	public class SlowPercentItem extends Item {
		
		public function SlowPercentItem () {
			gameName = "Improved Slow";
			desc = "Slows @% of all alphas";
			isOneTime = false;
			nextDesc = "Next Level: Increases to @%";
			cost = 1;
			abilityLink = SlowAbility;
		}
	}
}