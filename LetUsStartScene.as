package  {
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	public class LetUsStartScene extends VideoScene{

		public function LetUsStartScene(director:FerrisWheelDirector) {
			super(director);
		}
		
		override public function addUrl():void{
			super.videoplayer.videoURL = VideoURL.LET_US_START_SCENE_VIDEO_URL;
		}
		
	}
	
}
