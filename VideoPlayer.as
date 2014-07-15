package {
	
	/*
	 *  VideoPlayer
	 *  Created by WJS on 14-4-29
	 *  Copyrigt (c) 2014 . All rights reserved
	 */
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.AsyncErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.StatusEvent;
	import flash.geom.Point;
	
	
	public class VideoPlayer extends MovieClip {
	
		//变量声明
		private var _video:Video;
		private var _nc:NetConnection;
		private var _ns:NetStream;
		private var _videoURL:String;
		private var _client:Object;
		private var _videostate:String;
		private var _duration:Number;
		private var _seektime:Number;
		private var _seekOffset:uint;
		private var _curScene:String;
		private var _isCanInteractive:Boolean = false;
        private var _progressBar:ProgressBarMC;
		
		//常量声明
			
		public function VideoPlayer() {
			
			onAdded(null);
			
			/*if (stage)
				onAdded(null);
			else
				addEventListener(Event.ADDED_TO_STAGE, onAdded);*/
		}
		
		private function onAdded(event:Event=null):void{
			_client = new Object();
			_video = new Video(2880,300);
			addChild(_video);
			
			// 绘制基准表格
			//createSquare(10,20);
			_progressBar = new ProgressBarMC();
			_progressBar.x = 990;
			_progressBar.y = 260;
			_progressBar.frontBar.width = 30;
			_progressBar.frontBar.height = 30;
			_progressBar.buttonMode = true;
			_progressBar.visible = true;
			addChild(_progressBar);
			_progressBar.addEventListener(MouseEvent.CLICK, onProgressBarClick);
			addEventListener(Event.ENTER_FRAME, onEnter);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
		
		/*private function createSquare(rows:uint, columns:uint):void{
			var rowBeginning:Number = 960;
			var rowEnding:Number = 1920;
			var colBeginning:Number = 0;
			var colEnding:Number = 300;
			var rowStep = (rowEnding - rowBeginning) / columns;
			var colStep = (colEnding - colBeginning) / rows;
			var rowArray:Vector.<Sprite> = new Vector.<Sprite>(rows);
			var colArray:Vector.<Sprite> = new Vector.<Sprite>(columns);
			
			for (var i:int=0; i<=rows; i++){
				rowArray[i] = new Sprite();
				rowArray[i].graphics.lineStyle(1,0x000000,1);
				rowArray[i].graphics.moveTo(rowBeginning, colBeginning + (colStep * i));
				rowArray[i].graphics.lineTo(rowEnding, colBeginning + (colStep * i));
				rowArray[i].graphics.endFill();
				addChild(rowArray[i]);
			}
			
			for (var j:int=0; j<=columns; j++){
				colArray[j] = new Sprite();
				colArray[j].graphics.lineStyle(1,0x000000,1);
				colArray[j].graphics.moveTo(rowBeginning + (rowStep * j), colBeginning);
				colArray[j].graphics.lineTo(rowBeginning + (rowStep * j), colEnding);
				colArray[j].graphics.endFill();
				addChild(colArray[j]);
			}
		}*/
		
		protected function onProgressBarClick(event:MouseEvent):void
		{
			var point:Point = new Point(mouseX,mouseY);
			var posX:Number = _progressBar.globalToLocal(point).x;
			var rate:Number = posX / _progressBar.width;
			var time:Number = rate * _duration;
			seekPosition(time);
		}
		
		public function fadeIn():void
		{
			_progressBar.visible = true;
		}
		
		public function fadeOut():void
		{
			_progressBar.visible = false;
		}
		
		protected function seekPosition(time:Number):void
		{
			if (_ns){
				if (videostate == VideoState.VIDEO_STATE_PLAYING){
					_ns.seek(time);
				}
			}
		}
		
		protected function onEnter(event:Event):void
		{
			if (_ns){
				if (videostate == VideoState.VIDEO_STATE_PLAYING)
					_progressBar.frontBar.width = (_ns.time / _duration) * _progressBar.width;
				if (videostate == VideoState.VIDEO_STATE_PLAY_COMPLETE){
					_ns.play(videoURL);
					videostate = VideoState.VIDEO_STATE_PLAYING;
				}
			}
		}
		
		protected function connect():void{
			_nc = new NetConnection();
			_nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
			_nc.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_nc.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			_nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			_nc.connect(null);
		}
		
		protected function onAsyncError(event:AsyncErrorEvent):void{
			trace (event);
		}
		
		protected function onIOError(event:IOErrorEvent):void{
			trace (event);
		}
		
		protected function onSecurityError(event:SecurityErrorEvent):void{
			trace (event);
		}
		
		protected function onNetStatus(event:NetStatusEvent):void{
			var type:String = event.info["code"];
			trace (type);
			switch (type){
				case "NetConnection.Connect.Success":
				initNetStream();
				break;
				case "NetStream.Play.Start":
				this.videostate = VideoState.VIDEO_STATE_PLAYING;
				break;
				case "NetStream.Play.Stop":
				this.videostate = VideoState.VIDEO_STATE_STOPED;
				break;
				case "NetStream.Seek.Notify":
				break;
				default:
				break;
			}
		}
		
		protected function initNetStream():void{
		
			_ns = new NetStream(_nc);
			_ns.client = _client;
			_ns.bufferTime = 5;
			_ns.inBufferSeek = true;
			_client.onMetaData = onMetaData;
			_client.onPlayStatus = onStatus;
			_ns.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_ns.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			_ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
			_video.attachNetStream(_ns);
			_ns.play(videoURL);
		}
		
		public function seekVideo(method:String):void
		{
			if (_ns){
				if (videostate == VideoState.VIDEO_STATE_PLAYING){
					if (method == VideoState.SEEK_BACK){
						_seektime = _ns.time - _seekOffset; 
			            if (_seektime <= 0)
			             _seektime = 0;
			             _ns.seek(_seektime);
					}else if (method == VideoState.SEEK_FRONT){
						_seektime = _ns.time + _seekOffset; 
						if (_seektime >= _duration){
							_ns.resume();
			                videostate = VideoState.VIDEO_STATE_PLAYING;
							return;
						}
						_ns.seek(_seektime);
					}
				}
			}
		}
		
		public function onStatus(info:Object):void
		{
			switch (info.code){
				case "NetStream.Play.Complete":
					trace ("cartoon play complete now");
					this.videostate = VideoState.VIDEO_STATE_PLAY_COMPLETE;
					break;
				default:
					break;
			}
		}
		
		private function pauseVideo():void
		{
			if (_ns && videostate == VideoState.VIDEO_STATE_PLAYING){
				_ns.pause();
				this.videostate = VideoState.VIDEO_STATE_PAUSED;
			}
		}
		
        private function playVideo():void
		{
			if (_ns && videostate == VideoState.VIDEO_STATE_PAUSED){
				_ns.resume();
				this.videostate = VideoState.VIDEO_STATE_PLAYING;
			}
		}
		
		public function onMetaData(info:Object):void
		{
			_duration = info.duration;
			_seekOffset = Math.round(Math.ceil(_duration) / 50);
		}
		
		public function changeVideoState():void{
			if (videostate == VideoState.VIDEO_STATE_PLAYING)
				pauseVideo();
			else if (videostate == VideoState.VIDEO_STATE_PAUSED)
				playVideo();
		}
		
		
		public function get videoURL():String{
			return this._videoURL;
		}
		
		public function set videoURL(url:String):void{
			this._videoURL = url;
			connect();
		}
		
		public function get curScene():String{
		    return this._curScene;
		}
		
		public function set curScene(_scene:String):void{
			this._curScene = _scene;
		}
		
		public function get isCanInteractive():Boolean{
		    if (_ns){
				if (videostate == VideoState.VIDEO_STATE_PLAY_COMPLETE || videostate == VideoState.VIDEO_STATE_STOPED)
				    this._isCanInteractive = false;
				else
					this._isCanInteractive = true;
			}
			return this._isCanInteractive;
		}
	
		public function get videostate():String{
			return _videostate;
		}
		
		public function set videostate(val:String):void{
			this._videostate = val;
		}
		
		public function destroy(event:Event):void
		{
			if (_ns){
				_ns.pause();
				_ns.close();
				_ns.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
				_ns.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
				_ns.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
				_ns = null;
			}
			
			if (_nc){
				_nc.close();
				_nc.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			    _nc.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
				_nc = null;
			}
		}
	}
	
}
