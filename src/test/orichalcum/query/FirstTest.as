package orichalcum.query  
{
	import flash.display.Shape;
	import org.hamcrest.assertThat;
	
	public class FirstTest 
	{
		[Test]
		public function testEmpty():void
		{
			assertThat($().first().length == 0);
		}
		
		[Test]
		public function testLengthOne():void
		{
			assertThat($([new Shape, new Shape]).first().length == 1);
		}
		
		[Test]
		public function testFirstIsFirst():void
		{
			const first:Shape = new Shape;
			assertThat($(first).first()[0] === first);
			assertThat($([first, new Shape]).first()[0] === first);
		}
		
	}

}