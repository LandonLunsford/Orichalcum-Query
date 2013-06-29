package orichalcum.query  
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;

	public class NotTest 
	{
		
		private var a:DisplayObject = new Sprite;
		private var b:DisplayObject = new Shape;
		private var c:DisplayObject = new Bitmap;
		private var $all:OrichalcumQuery = $([a, b, c]);
		
		[Test]
		public function filterEmptyIsEmpty():void
		{
			assertThat($([]).not(Point).length, equalTo(0));
		}
		
		[Test]
		public function filterOutFirst():void
		{
			assertThat($all.not(Sprite).toArray(), equalTo([b,c]));
		}
		
		[Test]
		public function filterOutSecond():void
		{
			assertThat($all.not(Shape).toArray(), equalTo([a,c]));
		}
		
		[Test]
		public function filterOutLast():void
		{
			assertThat($all.not(Bitmap).toArray(), equalTo([a,b]));
		}
		
		[Test]
		public function filterInAll():void
		{
			assertThat($all.not(Point).toArray(), equalTo($all.toArray()));
		}
		
		[Test]
		public function filterOutAll():void
		{
			assertThat($all.not(DisplayObject).length, equalTo(0));
		}
		
	}

}