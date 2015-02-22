package {
	import flash.display.*;
	import flash.media.*;
	import flash.utils.*;
	import flash.events.*;
	import Game.*;
	
	public class SoundManager {
		public static var musicOn:Boolean = false;
		public static var soundOn:Boolean = false;
		
		public static var channel:SoundChannel;
		public static var isMusicPlaying:Boolean = false;
		
		private static var typeClasses:Array = [sndType1, sndType2];
		
		public static function PlayType () {
			if (soundOn) {
				new typeClasses [Math.floor (Math.random () * typeClasses.length)] ().play ();
			}
		}
		
		public static function PlayExplosion () {
			if (soundOn) {
				new sndExplosion ().play ();
			}
		}
		
		public static function PlayFreeze () {
			if (soundOn) {
				new sndFreeze ().play ();
			}
		}
		
		public static function PlayFreezeBreak () {
			//new sndFreezeBreak ().play ();
		}
		
		public static function PlayMusic () {
			if (isMusicPlaying == false) {
				channel = new sndMusic ().play ();
				channel.addEventListener (Event.SOUND_COMPLETE, onMusicComplete, false, 0, true);
				isMusicPlaying = true;
				
				if (musicOn == false) {
					MuteMusic ();
				}
			}
		}
		
		private static function onMusicComplete (e:Event) {
			channel.removeEventListener (Event.SOUND_COMPLETE, onMusicComplete);
			channel = new sndMusic ().play ();
			channel.addEventListener (Event.SOUND_COMPLETE, onMusicComplete, false, 0, true);
			
			if (musicOn == false) {
				MuteMusic ();
			}
		}
		
		public static function MuteMusic () {
			var st:SoundTransform = new SoundTransform (0);
			channel.soundTransform = st;
		}
		
		public static function UnmuteMusic () {
			var st:SoundTransform = new SoundTransform (1);
			channel.soundTransform = st;
		}
		
		public static function StopMusic () {
			channel.stop ();
			channel.removeEventListener (Event.SOUND_COMPLETE, onMusicComplete);
			isMusicPlaying = false;
		}
	}
}