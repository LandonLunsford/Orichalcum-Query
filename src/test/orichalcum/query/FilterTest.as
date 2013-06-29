package orichalcum.query  
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;

	public class FilterTest 
	{
		
		private var a:DisplayObject = new Sprite;
		private var b:DisplayObject = new Shape;
		private var c:DisplayObject = new Bitmap;
		private var $all:OrichalcumQuery = $([a, b, c]);
		
		[Test]
		public function filterEmptyIsEmpty():void
		{
			assertThat($([]).are(DisplayObject).length, equalTo(0));
		}
		
		[Test]
		public function filterInFirst():void
		{
			assertThat($all.are(Sprite).toArray(), equalTo([a]));
		}
		
		[Test]
		public function filterInSecond():void
		{
			assertThat($all.are(Shape).toArray(), equalTo([b]));
		}
		
		[Test]
		public function filterInLast():void
		{
			assertThat($all.are(Bitmap).toArray(), equalTo([c]));
		}
		
		[Test]
		public function filterInAll():void
		{
			assertThat($all.are(DisplayObject).toArray(), equalTo($all.toArray()));
		}
		
		[Test]
		public function filterOutAll():void
		{
			assertThat($all.are(Point).length, equalTo(0));
		}
		
	}

}