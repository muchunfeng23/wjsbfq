package  {
	
	public class ItIsMagicScene extends VideoScene{

		public function ItIsMagicScene(director:FerrisWheelDirector) {
			super(director);
		}

		override public function addUrl():void{
			trace("hello sing the song");
			super.videoplayer.videoURL = VideoURL.IT_IS_MAGIC_SCENE_VIDEO_URL;
		}
	}
	
}
