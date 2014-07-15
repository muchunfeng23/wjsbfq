package  {
	/*
	 *  FerrisWheel
	 *  Created by WJS on 14-4-21
	 *  Copyrigt (c) 2014 . All rights reserved
	 */

	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.external.ExternalInterface;
	import flash.utils.Timer;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.events.TimerEvent;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	public class FerrisWheel extends MovieClip {
		
		//变量声明
		private var _curScene:String;
		private var _isOpeningSceneCanInteractive:Boolean = false;
		private var _openingCheckTimer:Timer;
	    private var _hasResponse:Boolean = false;
	    private var videoplayer:VideoPlayer;
		private var _fadeTimer:Timer = new Timer(10,200);
		private var _debugDialog:TextField;
		private var _delayInterval:int;
		private var _startTime:Number = 0;
		private var _counter:int = 0;
		private var _delayTimer:Timer = new Timer(100,20);
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
		 
		 
		 
		public function FerrisWheel() {
			ExternalInterface.addCallback("iCall", iCall);
			delayCallInteractive();
			createSquare(ROW_COUNT,COLUMN_COUNT);
			initArray();
			this.tabEnabled = false;
			this.tabChildren = false;
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeydown);
			
			startBtn.addEventListener(MouseEvent.CLICK, onStart);
			singBtn.addEventListener(MouseEvent.CLICK, onSing);
			followBtn.addEventListener(MouseEvent.CLICK, onFollow);
			magicBtn.addEventListener(MouseEvent.CLICK, onMagic);
			playBtn.addEventListener(MouseEvent.CLICK, onPlay);
		}
		
		private function onStart(event:MouseEvent):void
		{
			curScene = CurrentScene.LET_US_START_SCENE;  
			createPlayer();
			videoplayer.videoURL = VideoURL.LET_US_START_SCENE_VIDEO_URL;
		}
		
		private function onSing(event:MouseEvent):void
		{
			curScene = CurrentScene.LET_US_SING_SCENE;
			createPlayer();
			videoplayer.videoURL = VideoURL.LET_US_SING_SCENE_VIDEO_URL;
		}
		
		private function onFollow(event:MouseEvent):void
		{
			curScene = CurrentScene.FOLLOW_ME_SCENE;
			createPlayer();
			videoplayer.videoURL = VideoURL.FOLLOW_ME_SCENE_VIDEO_URL;
		}
		
		private function onMagic(event:MouseEvent):void
		{
			curScene = CurrentScene.IT_IS_MAGIC_SCENE;
			createPlayer();
			videoplayer.videoURL = VideoURL.IT_IS_MAGIC_SCENE_VIDEO_URL;
		}
		
		private function onPlay(event:MouseEvent):void
		{
			
		}
		
		private function onKeydown(event:KeyboardEvent):void
		{
			if (!videoplayer)
			return;
			
			try
			{
				if (event.keyCode == Keyboard.LEFT){
				videoplayer.seekVideo(VideoState.SEEK_BACK);
				videoplayer.fadeIn();
				//_fadeTimer.reset();
				//_fadeTimer.start();
				//_fadeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onFadeTimerComplete);
			    }else if (event.keyCode == Keyboard.RIGHT){
				videoplayer.seekVideo(VideoState.SEEK_FRONT);
				videoplayer.fadeIn();
				//_fadeTimer.reset();
				//_fadeTimer.start();
				//_fadeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onFadeTimerComplete);
			    }else if (event.keyCode == Keyboard.SPACE){
				videoplayer.changeVideoState();
			    }else if (event.keyCode == Keyboard.UP){
				removeVideoPlayer();
			    }
			}
			catch (e:Error)
			{
				trace (e.message);
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
		
		private function removeVideoPlayer():void
		{
			if (videoplayer){
				if (this.contains(videoplayer)){
					this.removeChild(videoplayer);
					videoplayer = null;
					
					_isOpeningSceneCanInteractive = true;
					curScene = CurrentScene.OPENING_SCENE;
					
					/*if (_delayTimer.running)
					{
						_delayTimer.reset();
						_delayTimer.start();
						_delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onDelayTimer);
					}
					else
					{
						_delayTimer.start();
						_delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onDelayTimer);
					}*/
				}
			}
		}
		
		
		
		private function onDelayTimer(event:TimerEvent):void
		{
			_delayTimer.stop();
			_delayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onDelayTimer); 
			_isOpeningSceneCanInteractive = true;
			curScene = CurrentScene.OPENING_SCENE;
		}
		
		private function createPlayer():void
		{
			if (videoplayer == null){
				videoplayer = new VideoPlayer();
				addChild(videoplayer);
				videoplayer.x = 0;
				videoplayer.y = 0;
				
				_debugDialog = new TextField();
				_debugDialog.defaultTextFormat = new TextFormat("微软雅黑",20,0x00FF00,true);
				_debugDialog.x = 0;
				_debugDialog.y = 0;
				_debugDialog.width = 960;
				_debugDialog.height = 300;
				_debugDialog.border = true;
				_debugDialog.wordWrap = true;
				_debugDialog.background = true;
				_debugDialog.backgroundColor = 0x000000;
			    _debugDialog.borderColor = 0xFF0000;
				videoplayer.addChild(_debugDialog);
			}
		}
		
		private function initArray():void
		{
			_headArray = new Vector.<Array>(5);
            _headArray[0] = new Array([1,2],[2,2],[3,2],[1,3],[2,3],[3,3]);
			_headArray[1] = new Array([5,3],[6,3],[5,4],[6,4],[5,5],[6,5]);
			_headArray[2] = new Array([8,1],[9,1],[10,1],[8,2],[9,2],[10,2]);
			_headArray[3] = new Array([12,3],[13,3],[14,3],[12,4],[13,4],[14,4]);
			_headArray[4] = new Array([16,2],[17,2],[18,2],[16,3],[17,3],[18,3]);
			
			_videoplayerControlArray = new Vector.<Array>(3);
			_videoplayerControlArray[0] = new Array([0,0],[1,0],[0,1],[1,1],[0,2],[1,2]);
			_videoplayerControlArray[1] = new Array([9,0],[10,0],[9,1],[10,1],[9,2],[10,2]);
			_videoplayerControlArray[2] = new Array([18,0],[19,0],[18,1],[19,1],[18,2],[19,2]);
		}
		
		private function createSquare(rows:uint, columns:uint):void{
			var rowArray:Vector.<Sprite> = new Vector.<Sprite>(rows);
			var colArray:Vector.<Sprite> = new Vector.<Sprite>(columns);
			
			for (var i:int=0; i<=rows; i++){
				rowArray[i] = new Sprite();
				rowArray[i].graphics.lineStyle(1,0x000000,0.5);
				rowArray[i].graphics.moveTo(FerrisWheel.ROW_BEGINNING, FerrisWheel.COL_BEGINNING + (FerrisWheel.COL_STEP * i));
				rowArray[i].graphics.lineTo(FerrisWheel.ROW_ENDING, FerrisWheel.COL_BEGINNING + (FerrisWheel.COL_STEP * i));
				rowArray[i].graphics.endFill();
				addChild(rowArray[i]);
			}
			
			for (var j:int=0; j<=columns; j++){
				colArray[j] = new Sprite();
				colArray[j].graphics.lineStyle(1,0x000000,0.5);
				colArray[j].graphics.moveTo(FerrisWheel.ROW_BEGINNING + (FerrisWheel.ROW_STEP * j), FerrisWheel.COL_BEGINNING);
				colArray[j].graphics.lineTo(FerrisWheel.ROW_BEGINNING + (FerrisWheel.ROW_STEP * j), FerrisWheel.COL_ENDING);
				colArray[j].graphics.endFill();
				addChild(colArray[j]);
			}
		}
		
		
		private function delayCallInteractive():void{
			_openingCheckTimer = new Timer(1000,5);
			_openingCheckTimer.start();
			_openingCheckTimer.addEventListener(TimerEvent.TIMER_COMPLETE, openingCheckTimerTickHandler);
		}
		
		private function openingCheckTimerTickHandler(event:TimerEvent):void{
			_isOpeningSceneCanInteractive = true;
			curScene = CurrentScene.OPENING_SCENE;
			_openingCheckTimer.stop();
			_openingCheckTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, openingCheckTimerTickHandler);
		}
		
		public function iCall(param:String):void{
		
		    if (_debugDialog)
			{
				_debugDialog.text = String(_isOpeningSceneCanInteractive);
			}
		
			_paramArray = param.split("|");			
			var targetLength:uint = _paramArray.length;
			var sourceLength1:uint;
			var sourceLength2:uint;
			
			if (this._isOpeningSceneCanInteractive)
			{
				if (curScene == CurrentScene.OPENING_SCENE)
				{
				    headSceneInteractiveHandler(_paramArray, targetLength, sourceLength1,sourceLength2); 
			    }
				else 
				{
				    if (videoplayer)
					{
					    if (videoplayer.isCanInteractive)
						{
						    //videoplayerInteractiveHandler(_paramArray, targetLength, sourceLength1,sourceLength2);
					    }
				    }
			     }
			}
		}
		
		private function sort(param:Array):Array
		{
			var _sourceArray:Array = param;
			var _destArray:Array = [];
			var interArray:Array = [];
			var minArray:Array = [];
			for (var i:int=0; i<_sourceArray.length; i++){
				minArray = _sourceArray[i];
				for (var j:int=0; j<_sourceArray.length; j++){
					interArray = _sourceArray[j];
					if (minArray[1] >= interArray[1])
						minArray = interArray;
				}
				_destArray.push(minArray);
				_sourceArray.splice(_sourceArray.indexOf(minArray),1);
				i = -1;
			}
			return _destArray;
		}
		
		private function videoplayerInteractiveHandler(paramArray:Array, targetLength:uint, sourceLength1:uint, sourceLength2:uint):void
		{
			sourceLength1 = _videoplayerControlArray.length;
			for (var i:int=0; i<targetLength; i++)
			{
				for (var j:int=0; j<sourceLength1; j++)
				{
					sourceLength2 = _videoplayerControlArray[j].length;
					for (var k:int=0; k<sourceLength2; k++)
					{
						if (paramArray[i] == _videoplayerControlArray[j][k])
						{
							if (j == 0)
								videoplayer.seekVideo(VideoState.SEEK_BACK);
							else if (j == 1)
								videoplayer.changeVideoState();
							else if (j == 2)
								videoplayer.seekVideo(VideoState.SEEK_FRONT);
						}
					}
				}
			}
		}
		
		private function headSceneInteractiveHandler(paramArray:Array, targetLength:uint, sourceLength1:uint, sourceLength2:uint):void{
			sourceLength1 = _headArray.length;
			for (var i:int=0; i<targetLength; i++){
				for (var j:int=0; j<sourceLength1; j++){
					sourceLength2 = _headArray[j].length;
					for (var k:int=0; k<sourceLength2; k++){
						if (paramArray[i] == _headArray[j][k]){
							if (j == 0){
								curScene = CurrentScene.LET_US_START_SCENE;
								createPlayer();
								videoplayer.videoURL = VideoURL.LET_US_START_SCENE_VIDEO_URL;
								this._isOpeningSceneCanInteractive = false;
							}else if (j == 1){
								curScene = CurrentScene.LET_US_SING_SCENE;
								createPlayer();
								videoplayer.videoURL = VideoURL.LET_US_SING_SCENE_VIDEO_URL;
								this._isOpeningSceneCanInteractive = false;
							}else if (j == 2){
								curScene = CurrentScene.FOLLOW_ME_SCENE;
								createPlayer();
								videoplayer.videoURL = VideoURL.FOLLOW_ME_SCENE_VIDEO_URL;
								this._isOpeningSceneCanInteractive = false;
							}else if (j==3){
								curScene = CurrentScene.IT_IS_MAGIC_SCENE;
								createPlayer();
								videoplayer.videoURL = VideoURL.IT_IS_MAGIC_SCENE_VIDEO_URL;
								this._isOpeningSceneCanInteractive = false;
							}else if (j==4){
								
							}
							return;
						}
					}
				}
			}
		}
		
		/* 互动的过程中可能会改变当前场景到另一个场景 */
		private function get curScene():String{
			return _curScene;
		}
		
		private function set curScene(scene:String):void{
			_curScene = scene;
		}
	}
}
