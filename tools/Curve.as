package tools
{
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.utils.setTimeout;
	import saver.SaveCircle;
	import saver.SaveEreaser;
	import saver.SaveFreehand;
	
	public class Curve
	{
		public var win:MovieClip;
		public var thisBoard:MovieClip,thisLabel:myLabel;
		public var isPoint:Boolean;
		private var pinX,pinY;
		private var radius;
		private var currentState:int; //1 or 2
		private var save:Object;
		
		public function Curve(win:MovieClip)
		{
			this.win=win;
			win.touch.doubleClickEnabled=true;
			win.touch.addEventListener(MouseEvent.MOUSE_DOWN,pinCircle);
			currentState=1;
		}
		public function shutdown()
		{
			win.touch.doubleClickEnabled=false;
			if(currentState==1)
			{
				win.touch.removeEventListener(MouseEvent.MOUSE_DOWN,pinCircle);
			}
			else if(currentState==2)
			{
				win.touch.removeEventListener(MouseEvent.MOUSE_DOWN,initCurve);
				win.touch.removeEventListener(MouseEvent.DOUBLE_CLICK,removeCircle);
				win.tmpboard.graphics.clear();
				
				save=new SaveEreaser(win);
				save.setLayer(-1);
				win.history.push(save);
			}
			
			delete this;
		}
		private function pinCircle(event:MouseEvent):void
		{
			radius=0;
			save = new SaveCircle(win);
			save.addPoint(event.stageX,event.stageY);
			pinX=event.stageX;
			pinY=event.stageY;
			win.touch.addEventListener(MouseEvent.MOUSE_MOVE,dragRadius);
			win.touch.addEventListener(MouseEvent.MOUSE_UP,selectRadius);
			win.touch.addEventListener(MouseEvent.MOUSE_OUT,cancelRadius);
			thisLabel=win.labelboard.addChild(new myLabel());
			thisLabel.x=pinX;
			thisLabel.y=pinY;
			thisLabel.num.text=""
		}
		private function dragRadius(event:MouseEvent):void
		{
			save.addPoint(event.stageX,event.stageY);
			var dx=(event.stageX-pinX);
			var dy=(event.stageY-pinY);
			radius=Math.sqrt((dx*dx)+(dy*dy));
			win.tmpboard.graphics.clear();
			win.tmpboard.graphics.lineStyle(1, 0x00FF00, 0.5);
			win.tmpboard.graphics.drawCircle(pinX,pinY,radius);
			win.tmpboard.graphics.drawCircle(pinX,pinY,1);
			thisLabel.num.text= Math.round(radius).toString();
		}
		private function cancelRadius(event:MouseEvent):void
		{
			win.tmpboard.graphics.clear();
			win.labelboard.removeChild(thisLabel);
			win.touch.removeEventListener(MouseEvent.MOUSE_MOVE,dragRadius);
			win.touch.removeEventListener(MouseEvent.MOUSE_UP,selectRadius);
			win.touch.removeEventListener(MouseEvent.MOUSE_OUT,cancelRadius);
		}
		private function selectRadius(event:MouseEvent):void
		{
			var dx=(event.stageX-pinX);
			var dy=(event.stageY-pinY);
			radius=Math.sqrt((dx*dx)+(dy*dy));
			
			win.touch.removeEventListener(MouseEvent.MOUSE_MOVE,dragRadius);
			win.touch.removeEventListener(MouseEvent.MOUSE_UP,selectRadius);
			win.touch.removeEventListener(MouseEvent.MOUSE_OUT,cancelRadius);
			if(radius>0)
			{
				win.edited=true;
				win.history.push(save);
				//trace(1,event.stageX,pinX,event.stageY,pinY);
				//trace(2,save.list[save.list.length-1][0],save.list[0][0],save.list[save.list.length-1][1],save.list[0][1]);
				//trace("dx,dy->",dx,dy,"radius->",radius);
				win.touch.removeEventListener(MouseEvent.MOUSE_DOWN,pinCircle);
				
				thisBoard=win.board.addChild(new MovieClip());
				thisBoard.graphics.lineStyle(1);
				thisBoard.graphics.moveTo(pinX-4,pinY);
				thisBoard.graphics.lineTo(pinX+4,pinY);
				thisBoard.graphics.moveTo(pinX,pinY-4);
				thisBoard.graphics.lineTo(pinX,pinY+4);
				win.boardList.push(thisBoard);

				win.touch.addEventListener(MouseEvent.MOUSE_DOWN,initCurve);
				win.touch.addEventListener(MouseEvent.DOUBLE_CLICK,removeCircle);
				
				currentState=2;
			}
			else
			{
				save=null;
			}
			setTimeout((win.root as MovieClip).fadeMCOut,win.delayLabel,thisLabel,"remove");
		}
		private function removeCircle(event:MouseEvent):void
		{
			win.tmpboard.graphics.clear();
			win.touch.removeEventListener(MouseEvent.MOUSE_DOWN,initCurve);
			win.touch.removeEventListener(MouseEvent.DOUBLE_CLICK,removeCircle);
			win.touch.addEventListener(MouseEvent.MOUSE_DOWN,pinCircle);
			currentState=1;
		
			save=new SaveEreaser(win);
			save.setLayer(-1);
			win.history.push(save);
		}
		var angle,nowX,nowY;   //,lastAngle
		private function initCurve(event:MouseEvent):void
		{
			isPoint=true;
			angle=Math.atan2(event.stageY-pinY,event.stageX-pinX);
			nowX=pinX+radius*Math.cos(angle);
			nowY=pinY+radius*Math.sin(angle);
			
			thisBoard=win.board.addChild(new MovieClip());
			win.boardList.push(thisBoard);
			thisBoard.graphics.lineStyle(win.currentLineSize, win.currentLineColor);
			thisBoard.graphics.moveTo(nowX,nowY);
			
			save = new SaveFreehand(win);
			save.setSize(win.currentLineSize);
			save.setColor(win.currentLineColor);
			save.addPoint(nowX,nowY);
			
			win.touch.addEventListener(MouseEvent.MOUSE_MOVE,drawCurve);
			win.touch.addEventListener(MouseEvent.MOUSE_UP,endCurve);
			win.touch.addEventListener(MouseEvent.MOUSE_OUT,endCurve);
		}
		private function drawCurve(event:MouseEvent):void
		{
			isPoint=false;
			//lastAngle=angle;
			angle=Math.atan2(event.stageY-pinY,event.stageX-pinX);
			nowX=pinX+radius*Math.cos(angle);
			nowY=pinY+radius*Math.sin(angle);
			thisBoard.graphics.lineTo(nowX,nowY);
			save.addPoint(nowX,nowY);
			//trace(angle);
			/*
			var startRad,endRad,diff;
			if(Math.abs(angle-lastAngle)<=Math.PI)
			{
				if(angle-lastAngle>0)
					diff=-0.02;
				else
					diff=0.02;
				startRad=lastAngle+diff;
				endRad=angle;
				
				for(angle=startRad;angle<endRad;angle+=diff)
				{
					nowX=pinX+radius*Math.cos(angle);
					nowY=pinY+radius*Math.sin(angle);
					thisBoard.graphics.lineTo(nowX,nowY);
					save.addPoint(nowX,nowY);
				}
			}
			else
			{
				if(angle>0)
					diff=0.02;
				else
					diff=-0.02;
				startRad=lastAngle+diff;
				endRad=angle;
				for(angle=startRad;Math.abs(angle)<Math.PI;angle+=diff)
				{
					nowX=pinX+radius*Math.cos(angle);
					nowY=pinY+radius*Math.sin(angle);
					thisBoard.graphics.lineTo(nowX,nowY);
					save.addPoint(nowX,nowY);
				}
				for(angle=-(Math.abs(diff)/diff)*Math.PI;Math.abs(angle)>Math.abs(endRad);angle+=diff)
				{
					nowX=pinX+radius*Math.cos(angle);
					nowY=pinY+radius*Math.sin(angle);
					thisBoard.graphics.lineTo(nowX,nowY);
					save.addPoint(nowX,nowY);
				}
			}
			*/
		}
		private function endCurve(event:MouseEvent):void
		{
			if(isPoint)
			{
				var angle=Math.atan2(event.stageY-pinY,event.stageX-pinX);
				var nowX=pinX+radius*Math.cos(angle);
				var nowY=pinY+radius*Math.sin(angle);
				thisBoard.graphics.beginFill(win.currentLineColor);
				thisBoard.graphics.drawCircle(nowX,nowY,win.currentLineSize/4);
				thisBoard.graphics.endFill();
			}
			win.history.push(save);
			win.touch.removeEventListener(MouseEvent.MOUSE_MOVE,drawCurve);
			win.touch.removeEventListener(MouseEvent.MOUSE_UP,endCurve);
			win.touch.removeEventListener(MouseEvent.MOUSE_OUT,endCurve);
		}
	}
}