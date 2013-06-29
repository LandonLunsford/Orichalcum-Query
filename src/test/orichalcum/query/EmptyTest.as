package orichalcum.query  
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.strictlyEqualTo;

	public class EmptyTest 
	{
		private var $container:OrichalcumQuery = $(new Sprite);
		
		[Test]
		public function emptyOfEmptyIsEmpty():void
		{
			assertThat($([]).empty().length, equalTo(0));
		}
		
		[Test]
		public function emptyOfFullIsEmpty():void
		{
			$container.append(new Sprite).append(new Sprite);
			assertThat($container.children().length, equalTo(2));
			assertThat($container.empty().children().length, equalTo(0));
		}
		
	}

}