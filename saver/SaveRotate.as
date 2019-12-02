package saver
{
	import flash.display.MovieClip;
	import flash.utils.setTimeout;
	public class SaveRotate
	{
		private var win:MovieClip;
		private var list:Array;
		private var tool:String;
		
		//for animation
		private var step:int;
		private var thisTool:Object;
		
		public function SaveRotate(win:MovieClip)
		{
			this.win=win;
			list=new Array();
		}
		public function setTool(tool:String)
		{
			this.tool=tool;
			this.thisTool=win.getTool(tool);
		}
		public function addAngle(angle):void
		{
			list.push(angle);
		}
		public function setXML(doc:XML):void		//load from xml
		{
			tool=doc.@tool;
			this.thisTool=win.getTool(tool);
			var i:int=0;
			while(doc.angle[i]!=undefined)
			{
				list.push(doc.angle[i].@value);
				i++;
			}
		}
		public function toXML():XML
		{
			var doc:XML = new XML(<shape type="Rotate" tool={tool}> </shape>);
			var i:int;
			for(i=0;i<list.length;i++)
				doc.appendChild(<angle value={list[i]} />);
			return doc;
		}
		
		public function animate():void
		{
				thisTool.rotation=list[0];
				step=1;
				nextStep(1);
				//win.nextPlaying=setTimeout(doOneStep,win.delayTime);
		}
		private function doOneStep():void
		{
			if(step<list.length)
			{
				thisTool.rotation=list[step];
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
