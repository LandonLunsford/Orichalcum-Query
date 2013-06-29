package orichalcum.query  
{
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import org.hamcrest.assertThat;
	import org.hamcrest.core.isA;
	import org.hamcrest.object.equalTo;
	
	public class EqTest 
	{
		[Test]
		public function testEmpty():void
		{
			assertThat($().eq(0).length, equalTo(0));
		}
		
		[Test]
		public function testFirst():void
		{
			assertThat($([new Sprite, new Shape, new Bitmap]).eq(0)[0], isA(Sprite));
		}
		
		[Test]
		public function testFirstViaLoop():void
		{
			assertThat($([new Sprite, new Shape, new Bitmap]).eq(-3)[0], isA(Sprite));
		}
		
		[Test]
		public function testMiddle():void
		{
			assertThat($([new Sprite, new Shape, new Bitmap]).eq(1)[0], isA(Shape));
		}
		
		[Test]
		public function testMiddleViaLoop():void
		{
			assertThat($([new Sprite, new Shape, new Bitmap]).eq(-2)[0], isA(Shape));
		}
		
		[Test]
		public function testLast():void
		{
			assertThat($([new Sprite, new Shape, new Bitmap]).eq(2)[0], isA(Bitmap));
		}
		
		[Test]
		public function testLastViaLoop():void
		{
			assertThat($([new Sprite, new Shape, new Bitmap]).eq(-1)[0], isA(Bitmap));
		}
		
		[Test]
		public function testIndexTooHigh():void
		{
			assertThat($([new Sprite, new Shape, new Bitmap]).eq(3).length, equalTo(0));
		}
		
		[Test]
		public function testIndexTooLow():void
		{
			assertThat($([new Sprite, new Shape, new Bitmap]).eq(-4).length, equalTo(0));
		}
	}

}