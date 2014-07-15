package  {
	import flash.display.MovieClip;
	import flash.external.ExternalInterface;
	import flash.display.Stage;
	
	public class FerrisWheelDirector extends MovieClip{
		public var curScene:BaseScene;
		public var curSceneName:String;
		private var moduleSelect:BaseScene = new ModuleSelectScene(FerrisWheelDirector(this));
		private var letUsStartScene:BaseScene = new LetUsStartScene(FerrisWheelDirector(this));
		private var followMeScene:BaseScene = new FollowMeScene(FerrisWheelDirector(this));
		private var itIsMagic:BaseScene = new ItIsMagicScene(FerrisWheelDirector(this));
		private var singTheSong:BaseScene = new SingTheSongScene(FerrisWheelDirector(this));
		private var icallAskNum:int = 0;
		
		public function FerrisWheelDirector() {
			// constructor code
			ExternalInterface.addCallback("iCall", iCall);
 			this.goIntoScene(CurrentScene.OPENING_SCENE);
			
		}
		
		//这个是被互动软件回调，摄像头每感知到一次就调用一次
		public function iCall(param:String):void{
			  if(curScene != null){
			      curScene.setTestValue("" + icallAskNum + "               " + param);
				  curScene.drawRect(param);
			  }
			  if(icallAskNum++ < 5){
				  
			  }
			  
		}
		
		public function goIntoScene(sceneName:String):void{
			if(curScene != null){
				//在进入一个新的场景时，需要把旧的场景中的一些监听，一些东西清理掉
				curScene.leaveScene(curSceneName);
				stage.removeChild(curScene);
			}
			curSceneName = sceneName;
			switch(sceneName){
				case CurrentScene.OPENING_SCENE:
					curScene = moduleSelect;
					break;
				case CurrentScene.LET_US_START_SCENE:
					curScene = letUsStartScene;
					break;
				case CurrentScene.LET_US_SING_SCENE:
					curScene = singTheSong;
					break;
				case CurrentScene.FOLLOW_ME_SCENE:
					curScene = followMeScene;
					break;
				case CurrentScene.IT_IS_MAGIC_SCENE:
					curScene = itIsMagic;
					break;
			}
			curScene.initScene(sceneName);
			curScene.addTestScene();
			stage.addChild(curScene);
		}

	}
	
}
