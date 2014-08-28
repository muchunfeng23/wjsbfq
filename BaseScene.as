package 
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.display.Sprite;
	import flash.display.Loader;
	
	public class BaseScene extends MovieClip
	{
		public var director:FerrisWheelDirector;
		//测试用的数据
		private var _debugDialog:TextField;
		private var ds:Sprite;

		public function BaseScene(director1:FerrisWheelDirector)
		{
			_debugDialog = new TextField();
			_debugDialog.defaultTextFormat = new TextFormat("微软雅黑",20,0x00FF00,true);
			this.director = director1;
		}

		//进入这个场景的一些操作，包括内存清空处理，初始化操作
		public function initScene(sceneName:String):void
		{

		}

		public function leaveScene(sceneName:String):void
		{
			
		}

		//摄像头捕捉动作
		public function cameraCatch(param:String):void
		{

		}

		//每个Scene的按键操作
		public function keyPressed():void
		{

		}

		//每个场景的逻辑处理
		public function logic():void
		{

		}



		//debug
		//增加一个测试面板，测试iCall坐标
		public function addTestScene():void
		{
			/*
			createSquare(10,20);
			
			_debugDialog.x = 0;
			_debugDialog.y = 0;
			_debugDialog.width = 500;
			_debugDialog.height = 100;
			_debugDialog.border = true;
			_debugDialog.wordWrap = true;
			_debugDialog.background = true;
			_debugDialog.backgroundColor = 0x000000;
			_debugDialog.borderColor = 0xFF0000;
			this.addChild(_debugDialog);
			*/
		}
		
		public function addMask(loader1:Loader):void
		{
			addChild(loader1);
		}
		
		public function setTestValue(testValue:String):void{
			_debugDialog.text = testValue;
		}
		
		public function drawRect(param:String):void{
			if(ds != null){
				this.removeChild(ds);
				ds = null;
				ds = new Sprite();
			}else{
				ds = new Sprite();
			}
			var rowBeginning:Number = 960;
			var rowEnding:Number = 1920;
			var colBeginning:Number = 0;
			var colEnding:Number = 300;
			var _paramArray:Array = param.split("|");
			if(_paramArray == null){
				return;
			}
			for each (var xystr:String in _paramArray){
				var xyInt:Array = xystr.split(",");
				ds.graphics.beginFill(0x23456);
				//x,y|x,y   x:row 行  y:column 列
				ds.graphics.drawRect(rowBeginning + 48 * xyInt[0],30 * xyInt[1],48,30);
				ds.graphics.endFill();
			}
			this.addChild(ds);
		}
		
		private function createSquare(rows:uint, columns:uint):void{
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
		}

	}

}