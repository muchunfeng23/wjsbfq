package  {
	import flash.events.MouseEvent;
	import flash.display.Stage;
	
	public class ModuleSelectScene extends BaseScene{
		
		private var mstage:Stage;
		
		public function ModuleSelectScene(director1:FerrisWheelDirector) {
			// constructor code
			super(director1);
		}
		
		override public function initScene(sceneName:String):void{
			trace("hi,modulescene init");
			director.startBtn.addEventListener(MouseEvent.CLICK, onStart);
			director.singBtn.addEventListener(MouseEvent.CLICK, onSing);
			director.followBtn.addEventListener(MouseEvent.CLICK, onFollow);
			director.magicBtn.addEventListener(MouseEvent.CLICK, onMagic);
			director.playBtn.addEventListener(MouseEvent.CLICK, onPlay);
		}
		
		override public function leaveScene(sceneName:String):void{
			director.startBtn.removeEventListener(MouseEvent.CLICK, onStart);
			director.singBtn.removeEventListener(MouseEvent.CLICK, onSing);
			director.followBtn.removeEventListener(MouseEvent.CLICK, onFollow);
			director.magicBtn.removeEventListener(MouseEvent.CLICK, onMagic);
			director.playBtn.removeEventListener(MouseEvent.CLICK, onPlay);
		}
		
		/**
		* 按键处理
		*/
		private function onStart(event:MouseEvent):void
		{
			super.director.goIntoScene(CurrentScene.LET_US_START_SCENE); 
		}
		
		private function onSing(event:MouseEvent):void
		{
			super.director.goIntoScene(CurrentScene.LET_US_SING_SCENE);
		}
		
		private function onFollow(event:MouseEvent):void
		{
			super.director.goIntoScene(CurrentScene.FOLLOW_ME_SCENE);
		}
		
		private function onMagic(event:MouseEvent):void
		{
			super.director.goIntoScene(CurrentScene.IT_IS_MAGIC_SCENE);
		}
		
		private function onPlay(event:MouseEvent):void
		{
			
		}

	}
	
}
