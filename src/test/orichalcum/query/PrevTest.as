package orichalcum.query  
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.strictlyEqualTo;
	
	public class PrevTest 
	{
		
		static private var _parent:DisplayObjectContainer;
		static private var _child1:Sprite;
		static private var _child2:Shape;
		static private var _child3:Bitmap;
		
		
		[BeforeClass]
		static public function setup():void
		{
			_parent = new Sprite;
			_child1 = new Sprite;
			_child2 = new Shape;
			_child3 = new Bitmap;
			_parent.addChild(_child1);
			_parent.addChild(_child2);
			_parent.addChild(_child3);
		}
		
		[AfterClass]
		static public function teardown():void
		{
			_parent = null;
			_child1 = null;
			_child2 = null;
			_child3 = null;
		}
		
		[Test]
		public function prevOfParentlessEmptySetIsEmpty():void
		{
			assertThat($(new Sprite).prev().length, equalTo(0));
		}
		
		[Test]
		public function prevOfFirstIsEmpty():void
		{
			assertThat($(_child1).prev().length, equalTo(0));
		}
		
		[Test]
		public function prevOfSecondIsFirst():void
		{
			assertThat($(_child2).prev()[0], strictlyEqualTo(_child1));
		}
		
		[Test]
		public function prevOfChildWithParentReturnsOneSibling():void
		{
			assertThat($(_child2).prev().length, equalTo(1));
		}
		
		[Test]
		public function prevOfSetReturnsSetWithoutLast():void
		{
			var $rest:OrichalcumQuery = $(_parent).children().prev();
			assertThat($rest.length, equalTo(2));
			assertThat($rest[0], strictlyEqualTo(_child1));
			assertThat($rest[1], strictlyEqualTo(_child2));
		}
		
		[Test]
		public function classFilterOfSibling():void
		{
			assertThat($(_child3).prev(Shape)[0], strictlyEqualTo(_child2));
			assertThat($(_child3).prev(Sprite).length, equalTo(0));
		}
		
		[Test]
		public function classFilterOfSet():void
		{
			const $children:OrichalcumQuery = $(_parent).children();
			assertThat($children.prev(Bitmap).length, equalTo(0));
			assertThat($children.prev(DisplayObject).length, equalTo(2));
			assertThat($children.prev(Bitmap).length, equalTo(0));
			assertThat($children.prev(Shape)[0], strictlyEqualTo(_child2));
			assertThat($children.prev(Sprite)[0], strictlyEqualTo(_child1));
		}
		
	}

}