package Screener.ModalScreens {
	import flash.display.*;
	import flash.events.*;
	import Screener.*;
	
	public class ConfirmScreen extends BaseScreen {
		private var mouseDownTargets:Array;
		
		public override function Initialize (arg:Object = null) {
			mouseDownTargets = [bttYes, bttNo];
			
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
			if (e.currentTarget == bttYes) {
				screenMgr.RemoveModalScreen ({message:"quit"});
			} else if (e.currentTarget == bttNo) {
				screenMgr.RemoveModalScreen ();
			}
		}
	}
}