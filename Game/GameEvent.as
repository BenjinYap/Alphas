package Game {
	import flash.events.Event;
	
	public final class GameEvent extends Event {
		public static const AlphaOffStage:String = "a";
		public static const AlphaSplit:String = "b";
		
		public static const SlowRecharge:String = "c";
		public static const FreezeRecharge:String = "e";
		public static const ExplosionRecharge:String = "g";
		public static const MultikillRecharge:String = "i";
		
		public static const ScoreGainDone:String = "j";
		public static const AnimationDone:String = "k";
		public static const AlphaUnfreeze:String = "l";
		
		public static const AbilityRecharge:String = "d";
		
		public var data:* = null;
		
		public function GameEvent (type:String, Data:* = null) {
			data = Data;
			super (type);
		}
	}
}