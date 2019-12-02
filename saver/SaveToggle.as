package saver
{
	import flash.display.MovieClip;
	import flash.utils.setTimeout;
	public class SaveToggle
	{
		private var win:MovieClip;
		private var tool:String;
		private var appear:Boolean;
		
		public function SaveToggle(win:MovieClip)
		{
			this.win=win;
		}
		public function setTool(tool:String)
		{
			this.tool=tool;
			this.appear=appear;
		}
		public function setAppear(appear:Boolean)
		{
			this.appear=appear;
		}
		public function setXML(doc:XML)
		{
			tool=doc.@tool;
			if(doc.@appear=="true")
				appear=true;
			else
				appear=false;
		}
		public function toXML():XML
		{
			var doc:XML = new XML(<shape type="Toggle" tool={tool} appear={appear}> </shape>);
			return doc;
		}
		public function animate():void
		{
			nextStep(1);
		}
		public function doOneStep():void
		{
			var thisTool:MovieClip = win.getTool(tool);
			var thisButton:MovieClip = win.getToolButton(tool);			
			if(appear)
			{
				thisTool.visible=true;
				thisButton.gotoAndStop("Select");
			}
			else
			{
				thisTool.visible=false;
				thisButton.gotoAndStop("Normal");
			}
			nextStep(2);
			//win.nextPlaying=setTimeout(win.animateShape,win.delayTime);
		}
		
		private function nextStep(place:int):void
		{
			var nextFunc:Function;
			var timeUse=win.delayTime;
			if(place==1)
			{
				nextFunc=this.doOneStep;
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