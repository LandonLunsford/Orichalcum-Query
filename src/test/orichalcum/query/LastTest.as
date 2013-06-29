package orichalcum.query  
{
	import flash.display.Shape;
	import org.hamcrest.assertThat;
	
	public class LastTest 
	{
		[Test]
		public function testEmpty():void
		{
			assertThat($().last().length == 0);
		}
		
		[Test]
		public function testLengthOne():void
		{
			assertThat($([new Shape, new Shape]).last().length == 1);
		}
		
		[Test]
		public function testLastIsLast():void
		{
			const last:Shape = new Shape;
			assertThat($(last).last()[0] === last);
			assertThat($([new Shape, last]).last()[0] === last);
		}
		
	}

}