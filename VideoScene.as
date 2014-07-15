package 
{
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class VideoScene extends BaseScene
	{
		public var videoplayer:VideoPlayer;
		private var _fadeTimer:Timer;
		private var _debugDialog:TextField;
		
		private var _curScene:String;
		private var _isOpeningSceneCanInteractive:Boolean = false;
		private var _openingCheckTimer:Timer;
	    private var _hasResponse:Boolean = false;
		
		private var _delayInterval:int;
		private var _startTime:Number = 0;
		private var _counter:int = 0;
		private var _delayTimer:Timer = new Timer(100,20) ;
		private var _isCanInteractive:Boolean = false;
		 
		//数组定义
		private var _paramArray:Array = new Array();
		private var _headArray:Vector.<Array>;
		private var _videoplayerControlArray:Vector.<Array>;
		
        //常量定义
		private static const ROW_COUNT:int = 10;
		private static const COLUMN_COUNT:int = 20;
		private static const ROW_BEGINNING:uint = 960;
		private static const ROW_ENDING:uint = 1920;
		private static const COL_BEGINNING:uint = 0;
		private static const COL_ENDING:uint = 300;
		private static const ROW_STEP:Number = (ROW_ENDING - ROW_BEGINNING) / COLUMN_COUNT;
		private static const COL_STEP:Number = (COL_ENDING - COL_BEGINNING) / ROW_COUNT;
		
		public function VideoScene(director:FerrisWheelDirector)
		{
			super(director);
		}

		override public function initScene(sceneName:String):void
		{
			_fadeTimer = new Timer(10,200);
			director.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeydown);
			createVideoPlayer(sceneName);
		}
		
		override public function leaveScene(sceneName:String):void{
			director.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeydown);
			this.releaseSth();
		}

		public function createVideoPlayer(sceneName:String):void
		{
			if (videoplayer == null)
			{
				videoplayer = new VideoPlayer();
				addChild(videoplayer);
				videoplayer.x = 0;
				videoplayer.y = 0;
			}
			addUrl();
			
		}
		
		public function addUrl():void{
			
		}

		private function onKeydown(event:KeyboardEvent):void
		{
			if (! videoplayer)
			{
				return;
			}

			try
			{
				if (event.keyCode == Keyboard.LEFT)
				{
					trace("left");
					videoplayer.seekVideo(VideoState.SEEK_BACK);
					videoplayer.fadeIn();
					_fadeTimer.reset();
					_fadeTimer.start();
					_fadeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onFadeTimerComplete);
				}
				else if (event.keyCode == Keyboard.RIGHT)
				{
					trace("right");
					videoplayer.seekVideo(VideoState.SEEK_FRONT);
					videoplayer.fadeIn();
					_fadeTimer.reset();
					_fadeTimer.start();
					_fadeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onFadeTimerComplete);
				}
				else if (event.keyCode == Keyboard.SPACE)
				{
					trace("space");
					videoplayer.changeVideoState();
				}
				else if (event.keyCode == Keyboard.UP)
				{
					director.goIntoScene(CurrentScene.OPENING_SCENE);
				}
			}
			catch (e:Error)
			{
				trace(e.message);
			}
		}

		private function onFadeTimerComplete(event:TimerEvent):void
		{
			if (videoplayer)
			{
				videoplayer.fadeOut();
				_fadeTimer.stop();
				_fadeTimer.removeEventListener(TimerEvent.TIMER, onFadeTimerComplete);
			}
		}


		public function releaseSth():void
		{
			if (videoplayer){
				if (this.contains(videoplayer)){
					this.removeChild(videoplayer);
					videoplayer = null;
				}
			}
			_fadeTimer = null;
		}
		
		
	}

}