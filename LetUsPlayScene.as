package 
{
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.display.SimpleButton;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	public class LetUsPlayScene extends BaseScene
	{
		private var loader1:Loader;
		private var url1:URLRequest;

		public function LetUsPlayScene(director1:FerrisWheelDirector)
		{
			// constructor code
			super(director1);
		}

		override public function initScene(sceneName:String):void
		{
			loader1 =new Loader();
			url1 = new URLRequest("Game.swf");
			director.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeydown);
			loader1.load(url1);
			addChild(loader1);
		}

		override public function leaveScene(curSceneName:String):void
		{
			loader1.unloadAndStop(true);
			removeChild(loader1);
			loader1 = null;
			url1 = null;
		}

		private function onKeydown(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.UP)
			{
				director.goIntoScene(CurrentScene.OPENING_SCENE);
			}
		}

	}

}