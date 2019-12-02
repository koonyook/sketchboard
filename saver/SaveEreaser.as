package saver
{
	import flash.display.MovieClip;
	import flash.utils.setTimeout;
	public class SaveEreaser
	{
		private var win:MovieClip;
		
		private var layer:int;
		
		public function SaveEreaser(win:MovieClip)
		{
			this.win=win;
		}
		public function setLayer(layer)
		{
			this.layer=layer;
		}
		public function setXML(doc:XML)		//load from xml
		{
			layer=doc.@layer;
		}
		public function toXML():XML
		{
			var doc:XML = new XML(<shape type="Ereaser" layer={layer}> </shape>);
			return doc;
		}

		public function animate():void
		{
			nextStep(1);
		}
		public function doOneStep():void
		{
			if(layer>=0 )
			{
				if(win.boardList[layer]!=undefined)
				{
				
					win.board.removeChild(win.boardList[layer]);
					delete win.boardList[layer];
					win.boardList.splice(layer,1);
				}
				else
				{
					trace(">>errer erease at layer "+layer+","+win.boardList[layer]);
				}
			}
			else
			{
				win.tmpboard.graphics.clear();
			}
			nextStep(2);
			//win.nextPlaying=setTimeout(win.animateShape,win.delayTime);
		}
		private function nextStep(place:int):void
		{
			var nextFunc:Function = win.animateShape;
			var timeUse=win.delayTime;
			if(place==1)
			{
				nextFunc=this.doOneStep;
				//trace(timeUse,win.delayMultiply);
				timeUse*=win.delayMultiply;
			}
			else if(place==2)
			{
				nextFunc=win.animateShape;
			}
			if(win.nowPlaying && !win.nowPausing)
			{
				win.nextPlaying=setTimeout(nextFunc,timeUse);
			}
			else if(win.nowPlaying && win.nowPausing)
			{
				win.nextPlaying=setTimeout(win.pauseFunction,win.pauseTime,nextFunc);
			}
		}
	}
}