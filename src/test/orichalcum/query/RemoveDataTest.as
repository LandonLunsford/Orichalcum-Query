package orichalcum.query  
{
	import flash.display.Sprite;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	
	public class RemoveDataTest 
	{
		
		private var $subject:OrichalcumQuery;
		
		
		[Before]
		public function setup():void
		{
			$subject = $(new Sprite).data({a:'a' ,b:'b'});
		}
		
		[After]
		public function teardown():void
		{
			$subject = null;
		}
		
		[Test]
		public function testRemoveData():void
		{
			$subject.removeData();
			assertThat($subject.data('a'), equalTo(undefined));
			assertThat($subject.data('b'), equalTo(undefined));
		}
		
		[Test]
		public function testRemoveDatum():void
		{
			$subject.removeData('a');
			assertThat($subject.data('a'), equalTo(undefined));
			assertThat($subject.data('b'), equalTo('b'));
		}
		
		[Test]
		public function testRemoveDatums():void
		{
			$subject.removeData('a','b');
			assertThat($subject.data('a'), equalTo(undefined));
			assertThat($subject.data('b'), equalTo(undefined));
		}
		
	}

}