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
	
	public class PrevAllTest 
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
		public function prevAllOfParentlessEmptySetIsEmpty():void
		{
			assertThat($(new Sprite).prevAll().length, equalTo(0));
		}
		
		[Test]
		public function  prevAllOfFirstIsEmpty():void
		{
			assertThat($(_child1).prevAll().length, equalTo(0));
		}
		
		[Test]
		public function  prevAllOfLastIsAll():void
		{
			assertThat($(_child3).prevAll().toArray(), equalTo([_child1, _child2]));
		}
		
		[Test]
		public function filterOutSome():void
		{
			assertThat($(_child3).prevAll(Shape).toArray(), equalTo([_child2]));
		}
		
		[Test]
		public function filterOutAll():void
		{
			assertThat($(_child3).prevAll(Point).length, equalTo(0));
		}
		
		[Test]
		public function filterInAll():void
		{
			assertThat($(_child3).prevAll().toArray(), equalTo([_child1, _child2]));
		}
		
		
	}

}