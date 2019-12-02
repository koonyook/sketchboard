package tools
{
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import saver.SaveEreaser;
	public class Ereaser
	{
		public var win:MovieClip;
		public function Ereaser(win:MovieClip)
		{
			this.win=win;
			win.touch.visible=false;
			win.background.addEventListener(MouseEvent.MOUSE_DOWN,initEreaser);
			win.board.addEventListener(MouseEvent.MOUSE_DOWN,initEreaser);
			win.grid.addEventListener(MouseEvent.MOUSE_DOWN,initEreaser);
		}

		private function initEreaser(event:MouseEvent):void
		{
			var i=win.boardList.indexOf(event.target);
			if(i>=0)
			{
				win.board.removeChild(win.boardList[i]);
				delete win.boardList[i];
				win.boardList.splice(i,1);
				var save=new SaveEreaser(win);
				save.setLayer(i);
				win.history.push(save);
			}
			win.board.addEventListener(MouseEvent.MOUSE_OVER,drawEreaser);
			win.addEventListener(MouseEvent.MOUSE_UP,upendEreaser);
			win.addEventListener(MouseEvent.MOUSE_OUT,outendEreaser);	//cannot easy use
		}
		private function drawEreaser(event:MouseEvent):void
		{
			var i=win.boardList.indexOf(event.target);
			if(i>=0)
			{
				win.board.removeChild(win.boardList[i]);
				delete win.boardList[i];
				win.boardList.splice(i,1);
				var save=new SaveEreaser(win);
				save.setLayer(i);
				win.history.push(save);
			}
		}
		private function upendEreaser(event:MouseEvent):void
		{
			win.board.removeEventListener(MouseEvent.MOUSE_OVER,drawEreaser);
			win.removeEventListener(MouseEvent.MOUSE_UP,upendEreaser);
			win.removeEventListener(MouseEvent.MOUSE_OUT,outendEreaser);		//cannot easy use
		}
		private function outendEreaser(event:MouseEvent):void
		{
			if(event.stageX<=0 || event.stageX>=1024 || event.stageY<=0 || event.stageY>=768)	//must set dynamic
			{
				win.board.removeEventListener(MouseEvent.MOUSE_OVER,drawEreaser);
				win.removeEventListener(MouseEvent.MOUSE_UP,upendEreaser);
				win.removeEventListener(MouseEvent.MOUSE_OUT,outendEreaser);		//cannot easy use
			}
		}
		public function shutdown():void
		{
			win.touch.visible=true;
			win.background.removeEventListener(MouseEvent.MOUSE_DOWN,initEreaser);
			win.board.removeEventListener(MouseEvent.MOUSE_DOWN,initEreaser);
			win.grid.removeEventListener(MouseEvent.MOUSE_DOWN,initEreaser);
			delete this;
		}
	}
}


