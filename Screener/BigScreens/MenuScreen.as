package Screener.BigScreens {
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import Screener.*;
	import Game.GameMode;
	
	public final class MenuScreen extends BaseScreen {
		private var mouseDownTargets:Array;
		
		public override function Initialize (arg:Object = null) {
			SoundManager.PlayMusic ();
			
			mouseDownTargets = [bttEndless, bttTimed, bttHardcore, bttCredits];
			
			for (var i:int = 0; i < mouseDownTargets.length; i++) {
				mouseDownTargets [i].addEventListener (MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
			}
		}

		public override function PrepareToDie () {
			for (var i:int = 0; i < mouseDownTargets.length; i++) {
				mouseDownTargets [i].removeEventListener (MouseEvent.MOUSE_DOWN, onMouseDown);
			}
		}
		
		private function onMouseDown (e:MouseEvent) {
			if (e.currentTarget == bttEndless) {
				screenMgr.NewBigScreen (ScreenType.Game, {mode:GameMode.Endless});
			} else if (e.currentTarget == bttTimed) {
				screenMgr.NewBigScreen (ScreenType.Game, {mode:GameMode.Timed});
			} else if (e.currentTarget == bttHardcore) {
				screenMgr.NewBigScreen (ScreenType.Game, {mode:GameMode.Hardcore});
			} else if (e.currentTarget == bttCredits) {
				screenMgr.AddModalScreen (ScreenType.Credits);
			}
		}
	}
}