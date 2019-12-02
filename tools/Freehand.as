package tools
{
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import saver.SaveFreehand;
	public class Freehand
	{
		public var win:MovieClip;
		public var isPoint:Boolean;
		public var thisBoard:MovieClip;
		public var save:SaveFreehand;
		
		public function Freehand(win:MovieClip)
		{
			this.win=win;
			win.touch.addEventListener(MouseEvent.MOUSE_DOWN,this.initFreehand);
		}
		
		private function initFreehand(event:MouseEvent):void
		{
			win.edited=true;
			isPoint=true;
			thisBoard=win.board.addChild(new MovieClip());
			win.boardList.push(thisBoard);
			thisBoard.graphics.lineStyle(win.currentLineSize, win.currentLineColor);
			thisBoard.graphics.moveTo(event.stageX,event.stageY);
			save = new SaveFreehand(win)
			save.setSize(win.currentLineSize);
			save.setColor(win.currentLineColor);
			save.addPoint(event.stageX,event.stageY);
			win.touch.addEventListener(MouseEvent.MOUSE_MOVE,drawFreehand);
			win.touch.addEventListener(MouseEvent.MOUSE_UP,endFreehand);
			win.touch.addEventListener(MouseEvent.MOUSE_OUT,endFreehand);
		}
		private function drawFreehand(event:flash.events.MouseEvent):void
		{
			isPoint=false;
			thisBoard.graphics.lineTo(event.stageX,event.stageY);
			save.addPoint(event.stageX,event.stageY);
		}
		private function endFreehand(event:MouseEvent):void
		{
			if(isPoint)
			{
				thisBoard.graphics.beginFill(win.currentLineColor);
				thisBoard.graphics.drawCircle(event.stageX,event.stageY,win.currentLineSize/4);
				thisBoard.graphics.endFill();
			}
			win.history.push(save);
			win.touch.removeEventListener(MouseEvent.MOUSE_MOVE,drawFreehand);
			win.touch.removeEventListener(MouseEvent.MOUSE_UP,endFreehand);
			win.touch.removeEventListener(MouseEvent.MOUSE_OUT,endFreehand);
		}
		public function shutdown():void
		{
			win.touch.removeEventListener(MouseEvent.MOUSE_DOWN,initFreehand);
			delete this;
		}
	}
}