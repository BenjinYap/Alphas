package Game.Entities.Animations {
	import Game.Entities.Animation;
	import Game.Abilities.SlowAbility;
	
	public class SlowedAnimation extends Animation {
		
		public function SlowedAnimation () {
			isLooping = true;
			duration = SlowAbility.duration;
			super ();
		}
	}
}