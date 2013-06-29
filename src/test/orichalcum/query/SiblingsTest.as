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
	
	public class SiblingsTest 
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
		public function siblingsOfParentlessElementIsEmpty():void
		{
			assertThat($(new Sprite).siblings().length, equalTo(0));
		}
		
		[Test]
		public function siblingsOfSiblinglessElementIsEmpty():void
		{
			assertThat($(new Sprite).appendTo($(new Sprite)).siblings().length, equalTo(0));
		}
		
		[Test]
		public function testFilterOut():void
		{
			assertThat($(_child1).siblings(DisplayObjectContainer).length, equalTo(0));
		}
		
		[Test]
		public function testFilterIn():void
		{
			assertThat($(_child1).siblings(Bitmap)[0], strictlyEqualTo(_child3));
		}
		
	}

}