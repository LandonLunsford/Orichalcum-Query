package orichalcum.query  
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	
	public class NextAllTest 
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
		public function nextAllOfParentlessEmptySetIsEmpty():void
		{
			assertThat($(new Sprite).nextAll().length, equalTo(0));
		}
		
		[Test]
		public function  nextAllOfLastIsEmpty():void
		{
			assertThat($(_child3).nextAll().length, equalTo(0));
		}
		
		[Test]
		public function  nextAllOfFirstIsAll():void
		{
			assertThat($(_child1).nextAll().toArray(), equalTo([_child2, _child3]));
		}
		
		[Test]
		public function filterOutSome():void
		{
			assertThat($(_child1).nextAll(Shape).toArray(), equalTo([_child2]));
		}
		
		[Test]
		public function filterOutAll():void
		{
			assertThat($(_child1).nextAll(Point).length, equalTo(0));
		}
		
		[Test]
		public function filterInAll():void
		{
			assertThat($(_child1).nextAll().toArray(), equalTo([_child2, _child3]));
		}
		
		
	}

}