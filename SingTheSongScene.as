package  {
	
	public class SingTheSongScene extends VideoScene{

		public function SingTheSongScene(director:FerrisWheelDirector) {
			super(director);
		}

		override public function addUrl():void{
			trace("hello sing the song");
			super.videoplayer.videoURL = VideoURL.LET_US_SING_SCENE_VIDEO_URL;
		}
	}
	
}
