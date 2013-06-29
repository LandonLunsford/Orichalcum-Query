package orichalcum.query
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import org.hamcrest.assertThat;

	public class ArgumentTest 
	{
		
		[Test]
		public function testNothing():void
		{
			assertThat($().length == 0);
		}
		
		[Test]
		public function testNull():void
		{
			assertThat($(null).length == 0);
		}
		
		[Test]
		public function testUndefined():void
		{
			assertThat($(undefined).length == 0);
		}
		
		[Test]
		public function testTrue():void
		{
			assertThat($(true).length == 0);
		}
		
		[Test]
		public function testFalse():void
		{
			assertThat($(false).length == 0);
		}
		
		[Test]
		public function testInt():void
		{
			assertThat($(int(99)).length == 0);
		}
		
		[Test]
		public function testUint():void
		{
			assertThat($(uint(99)).length == 0);
		}
		
		[Test]
		public function testNumber():void
		{
			assertThat($(Number(99)).length == 0);
		}
		
		[Test]
		public function testString():void
		{
			assertThat($('string').length == 0);
		}
		
		[Test]
		public function testObject():void
		{
			assertThat($({}).length == 0);
		}
		
		[Test]
		public function testClass():void
		{
			assertThat($(Class).length == 0);
		}
		
		[Test]
		public function testFunction():void
		{
			assertThat($(Function).length == 0);
		}
		
		[Test]
		public function testEmptyArray():void
		{
			assertThat($([]).length == 0);
		}
		
		[Test]
		public function testEmptyVector():void
		{
			assertThat($(new Vector.<DisplayObject>).length == 0);
		}
		
		[Test]
		public function testDisplayObject():void
		{
			assertThat($(new Shape).length == 1);
		}
		
		[Test]
		public function testArrayOfDisplayObjects():void
		{
			assertThat($([new Shape, new Shape, new Shape]).length == 3);
		}
		
		[Test]
		public function testVectorOfDisplayObjects():void
		{
			assertThat($(new <DisplayObject>[new Shape, new Shape, new Shape]).length == 3);
		}
		
		[Test]
		public function testArrayWithNull():void
		{
			assertThat($([null]).length == 0);
		}
		
		[Test]
		public function testVectorWithNull():void
		{
			assertThat($(new <DisplayObject>[null]).length == 0);
		}
		
	}

}