package saver
{
	import flash.display.MovieClip;
	import flash.utils.setTimeout;
	public class SaveMove
	{
		private var win:MovieClip;
		private var list:Array;
		private var tool:String;
		
		//for animation
		private var step:int;
		private var thisTool:Object;
		
		public function SaveMove(win:MovieClip)
		{
			this.win=win;
			list=new Array();
		}
		public function setTool(tool:String)
		{
			this.tool=tool;
			this.thisTool=win.getTool(tool);
		}
		public function addPoint(nowX:int,nowY:int):void
		{
			list.push(new Array(nowX,nowY));
		}
		public function setXML(doc:XML):void		//load from xml
		{
			tool=doc.@tool;
			this.thisTool=win.getTool(tool);
			var i:int=0;
			while(doc.point[i]!=undefined)
			{
				list.push(new Array(doc.point[i].@x,doc.point[i].@y));
				i++;
			}
		}
		public function toXML():XML
		{
			var doc:XML = new XML(<shape type="Move" tool={tool}> </shape>);
			var i:int;
			for(i=0;i<list.length;i++)
				doc.appendChild(<point x={list[i][0]} y={list[i][1]} />);
			return doc;
		}
		
		public function animate():void
		{
				thisTool.x=list[0][0];
				thisTool.y=list[0][1];
				step=1;
				nextStep(1);
				//win.nextPlaying=setTimeout(doOneStep,win.delayTime);
		}
		private function doOneStep():void
		{
			if(step<list.length)
			{
				thisTool.x=list[step][0];
				thisTool.y=list[step][1];
				step++;
				nextStep(1);
				//win.nextPlaying=setTimeout(doOneStep,win.delayTime);
			}
			else
			{
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
