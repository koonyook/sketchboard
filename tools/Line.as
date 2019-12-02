package tools
{
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.utils.setTimeout;
	import saver.SaveLine;
	public class Line
	{
		public var win:MovieClip,thisLabel:myLabel;
		private var startX,startY,endX,endY;
		private var save:SaveLine;
		
		public function Line(win:MovieClip):void
		{
			this.win=win;
			win.touch.addEventListener(MouseEvent.MOUSE_DOWN,initLine);
		}

		private function initLine(event:MouseEvent):void
		{
			endX=startX=event.stageX;
			endY=startY=event.stageY;
			save = new SaveLine(win);
			save.setSize(win.currentLineSize);
			save.setColor(win.currentLineColor);
			save.addPoint(event.stageX,event.stageY);
			win.touch.addEventListener(MouseEvent.MOUSE_MOVE,drawLine);
			win.touch.addEventListener(MouseEvent.MOUSE_UP,endLine);
			win.touch.addEventListener(MouseEvent.MOUSE_OUT,cancelLine);
			
			thisLabel=win.labelboard.addChild(new myLabel());
			thisLabel.num.text="";
		}
		private function drawLine(event:MouseEvent):void
		{
			win.tmpboard.graphics.clear();
			win.tmpboard.graphics.lineStyle(win.currentLineSize, win.currentLineColor);
			win.tmpboard.graphics.moveTo(startX,startY);
			win.tmpboard.graphics.lineTo(event.stageX,event.stageY);
			endX=event.stageX;
			endY=event.stageY;
			thisLabel.x=event.stageX;
			thisLabel.y=event.stageY-30;
			var dx=(event.stageX-startX);
			var dy=(event.stageY-startY);
			var radius=Math.sqrt((dx*dx)+(dy*dy));
			thisLabel.num.text= Math.round(radius).toString();
			save.addPoint(event.stageX,event.stageY);
		}
		private function endLine(event:MouseEvent):void
		{
			win.tmpboard.graphics.clear();
			setTimeout((win.root as MovieClip).fadeMCOut,win.delayLabel,thisLabel,"remove");
			if(endX!=startX || endY!=startY)
			{
				win.edited=true;
				var thisBoard=win.board.addChild(new MovieClip());
				win.boardList.push(thisBoard);
				thisBoard.graphics.lineStyle(win.currentLineSize, win.currentLineColor);
				thisBoard.graphics.moveTo(startX,startY);
				thisBoard.graphics.lineTo(endX,endY);
				win.history.push(save);
			}
			win.touch.removeEventListener(MouseEvent.MOUSE_MOVE,drawLine);
			win.touch.removeEventListener(MouseEvent.MOUSE_UP,endLine);
			win.touch.removeEventListener(MouseEvent.MOUSE_OUT,cancelLine);
		}
		private function cancelLine(event:MouseEvent):void
		{
			win.tmpboard.graphics.clear();
			win.labelboard.removeChild(thisLabel);
			win.touch.removeEventListener(MouseEvent.MOUSE_MOVE,drawLine);
			win.touch.removeEventListener(MouseEvent.MOUSE_UP,endLine);
			win.touch.removeEventListener(MouseEvent.MOUSE_OUT,cancelLine);
		}
		public function shutdown():void
		{
			win.touch.removeEventListener(MouseEvent.MOUSE_DOWN,initLine);
			delete this;
		}
	}
}
