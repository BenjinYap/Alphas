package Game.Items {
	import Game.Item;
	import Game.Abilities.MultikillAbility;
	
	public class MultikillCountItem extends Item {
		
		public function MultikillCountItem () {
			gameName = "Improved Multi-kill";
			desc = "Destroys @ extra alphas of the same letter";
			isOneTime = false;
			nextDesc = "Next Level: Increases to @ extra alphas";
			cost = 3;
			abilityLink = MultikillAbility;
		}
	}
}