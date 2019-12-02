package saver
{
	import flash.display.MovieClip;
	import flash.utils.setTimeout;
	public class SaveAngle
	{
		private var win:MovieClip;
		private var list:Array;
		
		//for animation
		private var step:int;
		
		public function SaveAngle(win:MovieClip)
		{
			this.win=win;
			list=new Array();
		}
		public function addAngle(angle):void
		{
			list.push(angle);
		}
		public function setXML(doc:XML):void		//load from xml
		{
			var i:int=0;
			while(doc.angle[i]!=undefined)
			{
				list.push(doc.angle[i].@value);
				i++;
			}
		}
		public function toXML():XML
		{
			var doc:XML = new XML(<shape type="Angle"> </shape>);
			var i:int;
			for(i=0;i<list.length;i++)
				doc.appendChild(<angle value={list[i]} />);
			return doc;
		}
		
		public function animate():void
		{
				win.instrument.half.blueLine.rotation=list[0];
				win.instrument.half.halfItem.moom.text=Math.round(list[0]).toString();
				step=1;
				nextStep(1);
				//win.nextPlaying=setTimeout(doOneStep,win.delayTime);
		}
		private function doOneStep():void
		{
			if(step<list.length)
			{
				win.instrument.half.blueLine.rotation=list[step];
				win.instrument.half.halfItem.moom.text=Math.round(90.0-list[step]).toString();
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
