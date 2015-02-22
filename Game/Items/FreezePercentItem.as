package Game.Items {
	import Game.Item;
	import Game.Abilities.FreezeAbility;
	
	public class FreezePercentItem extends Item {
		
		public function FreezePercentItem () {
			gameName = "Improved Freeze";
			desc = "Freezes @% of all alphas";
			isOneTime = false;
			nextDesc = "Next Level: Increases to @%";
			cost = 2;
			abilityLink = FreezeAbility;
		}
	}
}