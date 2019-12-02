package tools
{
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	
	public class Move
	{
		public var win:MovieClip;
		
		public function Move(win:MovieClip)
		{
			this.win=win;
			win.touch.visible=false;
			win.instrument.wakeup();
		}
		public function shutdown():void
		{
			win.touch.visible=true;
			win.instrument.sleep();
			delete this;
		}		
	}
}