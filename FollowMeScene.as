package  {
	
	public class FollowMeScene extends VideoScene{

		public function FollowMeScene(director:FerrisWheelDirector) {
			super(director);
		}

		override public function addUrl():void{
			trace("hello sing the song");
			super.videoplayer.videoURL = VideoURL.FOLLOW_ME_SCENE_VIDEO_URL;
		}
	}
	
}
