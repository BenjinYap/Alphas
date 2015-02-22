package Game.Items {
	import Game.Item;
	import Game.Abilities.MultikillAbility;
	
	public class MultikillItem extends Item {
		
		public function MultikillItem () {
			gameName = "Multi-kill";
			desc = "Periodically destroys multiple alphas of the same letter as the alpha you destroy";
			isOneTime = true;
			cost = 3;
			abilityLink = MultikillAbility;
		}
	}
}