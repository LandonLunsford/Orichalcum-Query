package  
{
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.setTimeout;
	import llunsford.aquery.$;
	import llunsford.aquery.OrichalcumQuery;
	
	public class DemoA extends Sprite
	{
		
		public function DemoA() 
		{
			var tracer:Function = function(event:Event):void { trace(event) };
			
			const s2:Shape = new Shape;
			const s3:Bitmap = new Bitmap;
			const s:Sprite = new Sprite;
			s.graphics.beginFill(Math.random() * 0xffffff);
			s.graphics.drawCircle(0, 0, 100 + Math.random() * 100);
			s.graphics.endFill();
			s.x = stage.stageWidth * 0.5 - s.width * 0.5;
			s.y = stage.stageHeight * 0.5 - s.height * 0.5;
			
			$(stage).keydown(tracer);
			
			$(this)
				.append(s2)
				.prepend(s)
				.append(s3)
				.addedToStage(tracer);
			
			var $s:OrichalcumQuery = $(this).find(Sprite)
				.appendTo(this)
				.prependTo(this)
				.mouseover(tracer)
				.mouseout(tracer)
				.mousewheel(tracer)
				.keydown(tracer)
				.keyup(tracer)
				.one('click', tracer)
				//.hover(tracer, tracer)
				.off({mouseOver:tracer, mouseOut:tracer}, Sprite, tracer);
			
			//$(this).load('http://creativebits.org/files/500px-Apple_Computer_Logo.svg_.png');
			
			//setTimeout(function():void { $(root).toggle(false); }, 2000);
			//setTimeout(function():void { $(root).toggle(true); }, 3000);
		}
		
	}

}