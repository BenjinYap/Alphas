package Game.Items {
	import Game.Item;
	import Game.Abilities.FreezeAbility;
	
	public class FreezeItem extends Item {
		
		public function FreezeItem () {
			gameName = "Freeze";
			desc = "Periodically freezes some of the alphas in place for a few seconds";
			isOneTime = true;
			cost = 2;
			abilityLink = FreezeAbility;
		}
	}
}