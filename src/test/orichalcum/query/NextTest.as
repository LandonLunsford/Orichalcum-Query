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
	
	public class NextTest 
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
		public function nextOfParentlessEmptySetIsEmpty():void
		{
			assertThat($(new Sprite).next().length, equalTo(0));
		}
		
		[Test]
		public function nextOfLastIsEmpty():void
		{
			assertThat($(_child3).next().length, equalTo(0));
		}
		
		[Test]
		public function nextOfFirstIsSecond():void
		{
			assertThat($(_child1).next()[0], strictlyEqualTo(_child2));
		}
		
		[Test]
		public function nextOfChildWithParentReturnsOneSibling():void
		{
			assertThat($(_child1).next().length, equalTo(1));
		}
		
		[Test]
		public function nextOfSetReturnsSetWithoutFirst():void
		{
			var $rest:OrichalcumQuery = $(_parent).children().next();
			assertThat($rest.length, equalTo(2));
			assertThat($rest[0], strictlyEqualTo(_child2));
			assertThat($rest[1], strictlyEqualTo(_child3));
		}
		
		[Test]
		public function classFilterOfSibling():void
		{
			assertThat($(_child1).next(Shape)[0], strictlyEqualTo(_child2));
			assertThat($(_child1).next(Bitmap).length, equalTo(0));
		}
		
		[Test]
		public function classFilterOfSet():void
		{
			const $children:OrichalcumQuery = $(_parent).children();
			assertThat($children.next(DisplayObjectContainer).length, equalTo(0));
			assertThat($children.next(DisplayObject).length, equalTo(2));
			assertThat($children.next(Sprite).length, equalTo(0));
			assertThat($children.next(Shape)[0], strictlyEqualTo(_child2));
			assertThat($children.next(Bitmap)[0], strictlyEqualTo(_child3));
		}
		
	}

}