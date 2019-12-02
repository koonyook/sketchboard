package saver
{
	import flash.display.MovieClip;
	import flash.utils.setTimeout;
	import fl.motion.Color; 
	public class SaveBackground
	{
		private var win:MovieClip;
		private var color;
		
		//for animation
		public function SaveBackground(win:MovieClip)
		{
			this.win=win;
		}
		public function setColor(color)
		{
			this.color=color;
		}
		public function setXML(doc:XML):void		//load from xml
		{
			color=doc.@color;
		}
		public function toXML():XML
		{
			var doc:XML = new XML(<shape type="Background" color={color}> </shape>);
			return doc;
		}
		public function animate():void
		{
			nextStep(1);
		}
		public function doOneStep():void
		{
			var c:Color=new Color();   
			c.setTint(color, 1.0);    
			win.background.transform.colorTransform=c;
			win.optionBar.backgroundColorPicker.selectedColor=color;
			win.optionBar.preview.background.transform.colorTransform=c;
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
