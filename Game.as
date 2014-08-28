package  {
	import flash.display.MovieClip;
	import flash.external.ExternalInterface;
	import flash.events.Event;
	import flash.display.Scene;
	
	public class Game extends MovieClip {
		public function Game() {
			
					ExternalInterface.addCallback("iCall", iCall);
		}
		
		 public function iCall(param:String):void
		{
			 var p:Array = param.split('|');
		     var pos:Array = new Array(new Array(50,50));
			
			for (var i:int = 0; i < p.length; i++)
		    {
			    if (pos[0] == (p[i] as Array))
				{
					if (this.currentScene.name == "questionScene")
					{
						doorClickHandler();
					    return;
					}
				}
		    }
	    }
	}
	
}
