package Game.Entities.Animations {
	import Game.Entities.Animation;
	import Game.Abilities.FreezeAbility;
	
	public class FrozenAnimation extends Animation {
		
		public function FrozenAnimation () {
			isLooping = true;
			duration = FreezeAbility.duration;
			super ();
		}
	}
}