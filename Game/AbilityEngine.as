package Game {
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	
	//handles ability cooldown and usage
	public class AbilityEngine extends EventDispatcher {

		private var abilities:Array;
		
		public function SetAbilities (Abilities:Array) {
			abilities = Abilities;
		}
		
		public function Update () {
			var numAbilities:int = abilities.length;
			
			for (var i:int = 0; i < numAbilities; i++) {
				var ability:Ability = abilities [i];
				
				if (ability.level > 0) {
					if (ability.countdown > 0) {
						ability.countdown--;
					} else if (ability.countdown == 0) {
						ability.countdown = ability.cooldown;
						dispatchEvent (new GameEvent (GameEvent.AbilityRecharge, {ability:ability}));
					}
				}
			}
		}
	}
}