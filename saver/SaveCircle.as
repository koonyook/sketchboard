package saver
{
	import flash.display.MovieClip;
	import flash.utils.setTimeout;
	public class SaveCircle
	{
		private var win:MovieClip;
		public var list:Array;
		
		//for animation
		private var step:int;
		private var thisBoard:MovieClip,thisLabel:myLabel;
		
		public function SaveCircle(win:MovieClip)
		{
			this.win=win;
			list=new Array();
		}
		public function addPoint(nowX,nowY):void
		{
			list.push(new Array(nowX,nowY));
		}
		public function setXML(doc:XML)		//load from xml
		{
			var i:int=0;
			while(doc.point[i]!=undefined)
			{
				list.push(new Array(doc.point[i].@x,doc.point[i].@y));
				i++;
			}
		}
		public function toXML():XML
		{
			var doc:XML = new XML(<shape type="Circle"> </shape>);
			var i:int;
			for(i=0;i<list.length;i++)
				doc.appendChild(<point x={list[i][0]} y={list[i][1]} />);
			return doc;
		}
		public function animate():void
		{
			step=1;
			thisLabel=win.labelboard.addChild(new myLabel());
			thisLabel.x=list[0][0];
			thisLabel.y=list[0][1];
			thisLabel.num.text="";
			nextStep(1);
			//win.nextPlaying=setTimeout(doOneStep,win.delayTime);
		}
		private function doOneStep():void
		{
			var dx,dy,radius;
			if(step<list.length)
			{
				dx=(list[step][0]-list[0][0]);
				dy=(list[step][1]-list[0][1]);
				radius=Math.sqrt((dx*dx)+(dy*dy));
				thisLabel.num.text= Math.round(radius).toString();
				win.tmpboard.graphics.clear();
				win.tmpboard.graphics.lineStyle(1, 0x00FF00, 0.5);
				win.tmpboard.graphics.drawCircle(list[0][0],list[0][1],radius);
				win.tmpboard.graphics.drawCircle(list[0][0],list[0][1],1);
				//if(step==list.length-1)
				//	trace("animate,dx,dy->",dx,dy,"radius->",radius);
				step++;
				nextStep(1);
				//win.nextPlaying=setTimeout(doOneStep,win.delayTime);
			}
			else
			{				
				var pinX:int=list[0][0],pinY:int=list[0][1];
				thisBoard=win.board.addChild(new MovieClip());
				thisBoard.graphics.lineStyle(1);
				thisBoard.graphics.moveTo(pinX+4,pinY);
				thisBoard.graphics.lineTo(pinX-4,pinY);
				thisBoard.graphics.moveTo(pinX,pinY-4);
				thisBoard.graphics.lineTo(pinX,pinY+4);
				win.boardList.push(thisBoard);
				thisLabel.fading=true;
				setTimeout((win.root as MovieClip).fadeMCOut,win.delayLabel,thisLabel,"remove");
				nextStep(2);
				//win.nextPlaying=setTimeout(win.animateShape,win.delayTime);
			}
		}
		private function nextStep(place:int):void
		{
			var nextFunc:Function;
			if(place==1)
				nextFunc=this.doOneStep;
			else if(place==2)
				nextFunc=win.animateShape;
			
			if(win.nowPlaying && !win.nowPausing)
			{
				win.nextPlaying=setTimeout(nextFunc,win.delayTime);
			}
			else if(win.nowPlaying && win.nowPausing)
			{
				win.nextPlaying=setTimeout(win.pauseFunction,win.pauseTime,nextFunc);
			}
		}
	}
}