package saver
{
	import flash.display.MovieClip;
	import flash.utils.setTimeout;
	public class SaveLine
	{
		private var win:MovieClip,thisLabel:myLabel;
		
		private var list:Array;
		private var color;
		private var size:int;
		
		//for animation
		private var step:int;
		
		public function SaveLine(win:MovieClip)
		{
			this.win=win;
			list=new Array();
		}
		public function setColor(color)
		{
			this.color=color;
		}
		public function setSize(size)
		{
			this.size=size;
		}
		public function addPoint(nowX,nowY):void
		{
			list.push(new Array(nowX,nowY));
		}
		public function setXML(doc:XML)		//load from xml
		{
			color=doc.@color;
			size=doc.@size;
			var i:int=0;
			while(doc.point[i]!=undefined)
			{
				list.push(new Array(doc.point[i].@x,doc.point[i].@y));
				i++;
			}
		}
		public function toXML():XML
		{
			var doc:XML = new XML(<shape type="Line" color={color} size={size}> </shape>);
			var i:int;
			for(i=0;i<list.length;i++)
				doc.appendChild(<point x={list[i][0]} y={list[i][1]} />);
			return doc;
		}
		public function animate():void
		{
			step=1;
			thisLabel=win.labelboard.addChild(new myLabel());
			thisLabel.num.text=""
			//win.nextPlaying=setTimeout(doOneStep,win.delayTime);
			nextStep(1);
		}
		private function doOneStep():void
		{
			var dx,dy,radius;
			if(step<list.length-1)
			{
				win.tmpboard.graphics.clear();
				win.tmpboard.graphics.lineStyle(size, color);
				win.tmpboard.graphics.moveTo(list[0][0],list[0][1]);
				win.tmpboard.graphics.lineTo(list[step  ][0],list[step  ][1]);
				
				thisLabel.x=list[step][0];
				thisLabel.y=list[step][1]-30;
				dx=(list[step][0]-list[0][0]);
				dy=(list[step][1]-list[0][1]);
				radius=Math.sqrt((dx*dx)+(dy*dy));
				thisLabel.num.text= Math.round(radius).toString();
				
				step++;
				//win.nextPlaying=setTimeout(doOneStep,win.delayTime);
				nextStep(1);
			}
			else if(step==list.length-1)
			{
				var thisBoard:MovieClip = win.board.addChild(new MovieClip());
				dx=(list[step][0]-list[0][0]);
				dy=(list[step][1]-list[0][1]);
				radius=Math.sqrt((dx*dx)+(dy*dy));
				thisLabel.num.text= Math.round(radius).toString();
				win.tmpboard.graphics.clear();
				win.boardList.push(thisBoard);
				thisBoard.graphics.lineStyle(size, color);
				thisBoard.graphics.moveTo(list[0][0],list[0][1]);
				thisBoard.graphics.lineTo(list[step  ][0],list[step  ][1]);
				thisLabel.fading=true;
				setTimeout((win.root as MovieClip).fadeMCOut,win.delayLabel,thisLabel,"remove");
				//win.nextPlaying=setTimeout(win.animateShape,win.delayTime);
				nextStep(2);
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