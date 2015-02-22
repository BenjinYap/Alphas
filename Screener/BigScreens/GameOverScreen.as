package Screener.BigScreens {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.net.*;
	import Game.*;
	import Screener.*;
	
	public final class GameOverScreen extends BaseScreen {
		private var numScoresToShow:int = 14;

		private var scoreBoxes:Array = [];
		private var phoneRank:int;
		
		private var allTimeScores:Array;
		private var todayScores:Array;
		private var phoneScores:Array;
		
		private var score:int;
		
		private var mouseDownTargets:Array;
		
		public override function Initialize (arg:Object = null) {
			txtMode.text = arg.mode;
			txtScore.text = arg.score.toString ();
			txtAccuracy.text = int ((arg.accuracy * 100)).toString () + "%";
			score = int (arg.score * arg.accuracy);
			txtFinalScore.text = score.toString ();
			
			/*txtInput.restrict = "a-zA-Z0-9_";
			txtInput.border = true;
			txtInput.borderColor = 0x996600;
			removeChild (txtHighScoresStatus);
			removeChild (txtPhoneStatus);*/
			
			mouseDownTargets = [bttMenu, bttEndless, bttHardcore, bttTimed];
			
			for (var i = 0; i < mouseDownTargets.length; i++) {
				mouseDownTargets [i].addEventListener (MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
			}
			
			/*for (var i:int = 0; i < numScoresToShow; i++) {
				var scoreBox:MovieClip = new mcScoreBox ();
				scoreBoxes.push (scoreBox);
				scoreBox.x = 25;
				scoreBox.y = 50 + i * 22;
				addChild (scoreBox);
			}
			
			txtScore.text = GameData.score.toString ();
			txtAllTimeRank.text = "-";
			txtTodayRank.text = "-";
			txtPhoneRank.text = "-";
			
			txtAllTime.alpha = 0.5;
			txtToday.alpha = 0.5;
			txtPhone.alpha = 0.5;

			Main.highScores.addEventListener (HighScoreEvent.AllTimeReceived, onAllTimeReceived, false, 0, true);
			Main.highScores.addEventListener (HighScoreEvent.TodayReceived, onTodayReceived, false, 0, true);
			Main.highScores.addEventListener (HighScoreEvent.PhoneReceived, onPhoneReceived, false, 0, true);
			Main.highScores.Refresh ();
			
			var date:Date = new Date ();
			var hourOffset:int = date.timezoneOffset / 60;
			var hour:int = date.hours - date.hoursUTC;
			hour = (hour < 0) ? hour + 24 : hour;
			var hourString:String;
			
			if (hour == 0) {
				hourString = "12 AM";
			} else if (hour < 12) {
				hourString = hour.toString () + " AM";
			} else if (hour == 12) {
				hourString = "12 PM";
			} else {
				hourString = (hour - 12).toString () + " PM";
			}
			
			txtTimezone.text = "Since " + hourString + " local";
			txtTimezone.visible = false;*/
		}
		
		public override function PrepareToDie () {
			for (var i = 0; i < mouseDownTargets.length; i++) {
				mouseDownTargets [i].removeEventListener (MouseEvent.MOUSE_DOWN, onMouseDown);
			}
		}

		private function onAllTimeReceived (e:HighScoreEvent) {
			Main.highScores.removeEventListener (HighScoreEvent.AllTimeReceived, onAllTimeReceived);
			
			allTimeBar.stop ();
			removeChild (allTimeBar);
			
			allTimeScores = e.data;
			var allTimeRank:int = Main.highScores.GetRankFromScores (allTimeScores, GameData.score);
			txtAllTimeRank.text = GetRankString (allTimeRank);
			
			txtAllTime.alpha = 1;
			txtAllTime.addEventListener (MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
			txtAllTime.dispatchEvent (new MouseEvent (MouseEvent.MOUSE_DOWN));
		}
		
		private function onTodayReceived (e:HighScoreEvent) {
			Main.highScores.removeEventListener (HighScoreEvent.TodayReceived, onTodayReceived);
			
			todayBar.stop ();
			removeChild (todayBar);
			
			todayScores = e.data;
			var todayRank:int = Main.highScores.GetRankFromScores (todayScores, GameData.score);
			txtTodayRank.text = GetRankString (todayRank);
			
			txtToday.alpha = 1;
			txtToday.addEventListener (MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
			txtToday.dispatchEvent (new MouseEvent (MouseEvent.MOUSE_DOWN));
		}
		
		private function onPhoneReceived (e:HighScoreEvent) {
			Main.highScores.removeEventListener (HighScoreEvent.PhoneReceived, onPhoneReceived);
			
			phoneBar.stop ();
			removeChild (phoneBar);
			
			phoneScores = e.data;
			var phoneRank:int = Main.highScores.GetRankFromScores (phoneScores, GameData.score);
			txtPhoneRank.text = GetRankString (phoneRank);
			
			txtPhone.alpha = 1;
			txtPhone.addEventListener (MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
			txtPhone.dispatchEvent (new MouseEvent (MouseEvent.MOUSE_DOWN));
		}
		
		private function ShowScores (scoreArray:Array) {
			txtAllTime.textColor = 0xFFFFFF;
			txtToday.textColor = 0xFFFFFF;
			txtPhone.textColor = 0xFFFFFF;
			
			if (scoreArray == allTimeScores) {
				txtAllTime.textColor = 0x996600;
				txtTimezone.visible = false;
			} else if (scoreArray == todayScores) {
				txtToday.textColor = 0x996600;
				txtTimezone.visible = true;
			} else if (scoreArray == phoneScores) {
				txtPhone.textColor = 0x996600;
				txtTimezone.visible = false;
			}
			
			for (var i:int = 0; i < scoreBoxes.length; i++) {
				if (i < scoreArray.length) {
					scoreBoxes [i].txtName.text = scoreArray [i].name;
					scoreBoxes [i].txtScore.text = scoreArray [i].score;
				} else {
					scoreBoxes [i].txtName.text = "";
					scoreBoxes [i].txtScore.text = "";
				}
			}
			
			if (scoreArray.length == 0) {
				var tf:TextFormat = scoreBoxes [0].txtName.getTextFormat ();
				tf.align = TextFormatAlign.CENTER;
				scoreBoxes [0].txtName.text = "No scores in this category";
				scoreBoxes [0].txtName.setTextFormat (tf);
			} else {
				var tf:TextFormat = scoreBoxes [0].txtName.getTextFormat ();
				tf.align = TextFormatAlign.LEFT;
				scoreBoxes [0].txtName.setTextFormat (tf);
			}
		}
		
		private function GetRankString (rank:Number):String {
			var rankString:String;
			var lastDigit:Number = rank % (Math.pow (10, rank.toString ().length));
				
			if (lastDigit == 1) {
				rankString = rank.toString () + "st";
			} else if (lastDigit == 2) {
				rankString = rank.toString () + "nd";
			} else if (lastDigit == 3) {
				rankString = rank.toString () + "rd";
			} else {
				rankString = rank.toString () + "th";
			}
			
			return rankString;
		}

		private function Submit () {
			if (txtInput.text.length > 0) {
				txtInput.type = TextFieldType.DYNAMIC;
				txtInput.selectable = false;
				txtHighScoresStatus.text = "Submitting!";
				addChild (txtHighScoresStatus);
				removeChild (bttSubmit);
				
				var vars:URLVariables = new URLVariables();
				vars.api_key = HighScores.apiKey;
				vars.game_id = HighScores.gameID;
				vars.response = "XML"
				vars.username = txtInput.text;
				vars.score = GameData.score.toString ();
				
				var req:URLRequest = new URLRequest ("https://www.scoreoid.com/api/createScore");
				req.data = vars;
				req.method = URLRequestMethod.POST;
				
				var loader:URLLoader = new URLLoader ();
				loader.dataFormat = URLLoaderDataFormat.TEXT;
				loader.addEventListener (Event.COMPLETE, onSubmitComplete, false, 0, true);
				loader.load (req);
				
				var so:SharedObject = SharedObject.getLocal ("lightrunner");
				
				if (so.size == 0) {
					so.data.scores = [];
				}
				
				so.data.scores.push ({name:txtInput.text, score:GameData.score});
				so.close ();
				
				txtHighScoresStatus.text = "Submitting to high scores!";
				addChild (txtHighScoresStatus);
				txtPhoneStatus.text = "Submitted to your device!";
				addChild (txtPhoneStatus);
			}
		}
		
		private function onSubmitComplete (e:Event) {
			e.currentTarget.removeEventListener (Event.COMPLETE, onSubmitComplete);
			
			if (e.target.data.indexOf ("The score has been saved") != -1) {
				txtHighScoresStatus.text = "Submitted to high scores!";
			} else {
				txtHighScoresStatus.text = "Couldn't submit to high scores!";
			}
		}
		
		private function onMouseDown (e:MouseEvent) {
			if (e.currentTarget == txtAllTime) {
				ShowScores (allTimeScores);
			} else if (e.currentTarget == txtToday) {
				ShowScores (todayScores);
			} else if (e.currentTarget == txtPhone) {
				ShowScores (phoneScores);
			} else if (e.currentTarget == bttSubmit) {
				//Submit ();
			} else if (e.currentTarget == bttMenu) {
				screenMgr.NewBigScreen (ScreenType.Menu);
			} else if (e.currentTarget == bttEndless) {
				screenMgr.NewBigScreen (ScreenType.Game, {mode:GameMode.Endless});
			} else if (e.currentTarget == bttTimed) {
				screenMgr.NewBigScreen (ScreenType.Game, {mode:GameMode.Timed});
			} else if (e.currentTarget == bttHardcore) {
				screenMgr.NewBigScreen (ScreenType.Game, {mode:GameMode.Hardcore});
			}
		}
	}
}