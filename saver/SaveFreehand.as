package saver
{
	import flash.display.MovieClip;
	import flash.utils.setTimeout;
	public class SaveFreehand
	{
		private var win:MovieClip;
		private var list:Array;
		private var color;
		private var size:int;
		
		//for animation
		private var step:int;
		private var thisBoard:MovieClip;
		
		public function SaveFreehand(win:MovieClip)
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
		public function setXML(doc:XML):void		//load from xml
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
			var doc:XML = new XML(<shape type="Freehand" color={color} size={size}> </shape>);
			var i:int;
			for(i=0;i<list.length;i++)
				doc.appendChild(<point x={list[i][0]} y={list[i][1]} />);
			return doc;
		}
		
		public function animate():void
		{
				thisBoard=win.board.addChild(new MovieClip());
				win.boardList.push(thisBoard);
				thisBoard.graphics.lineStyle(size, color);
				thisBoard.graphics.moveTo(list[0][0],list[0][1]);
				if(list.length==1)
				{
					thisBoard.graphics.beginFill(color);
					thisBoard.graphics.drawCircle(list[0][0],list[0][1],size/4);
					thisBoard.graphics.endFill();
					//win.nextPlaying=setTimeout(win.animateShape,win.delayTime);
					nextStep(2);
				}
				else
				{
					step=1;
					//win.nextPlaying=setTimeout(doOneStep,win.delayTime);
					nextStep(1);
				}
		}
		private function doOneStep():void
		{
			if(step<list.length)
			{
				thisBoard.graphics.lineTo(list[step][0],list[step][1]);
				step++;
				//win.nextPlaying=setTimeout(doOneStep,win.delayTime);
				nextStep(1);
			}
			else
			{
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
