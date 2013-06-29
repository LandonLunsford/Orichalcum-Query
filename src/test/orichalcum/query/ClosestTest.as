package orichalcum.query  
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.strictlyEqualTo;
	
	public class ClosestTest 
	{
		private const ROOT_NAME:String = 'root';
		private const CHILD_NAME:String = 'child';
		private const DESCENDANT_NAME:String = 'descendant';
		
		private var _root:DisplayObjectContainer;
		private var _child:Sprite;
		private var _descendant:Shape;
		
		
		[Before]
		public function setup():void
		{
			_root = new Sprite;
			_child = new Sprite;
			_descendant = new Shape;
			_root.addChild(_child);
			_child.addChild(_descendant);
			_root.name = ROOT_NAME;
			_child.name = CHILD_NAME;
			_descendant.name = DESCENDANT_NAME;
		}
		
		[After]
		public function teardown():void
		{
			_root = null;
			_child = null;
			_descendant = null;
		}
		
		[Test]
		public function testContentsNotIncluded():void
		{
			assertThat($(new Sprite).closest(Sprite).length, equalTo(0));
			assertThat($(_descendant).closest(DESCENDANT_NAME).length, equalTo(0));
		}
		
		[Test]
		public function testClosestAbsentByClass():void
		{
			assertThat($(new Sprite).closest(Shape).length, equalTo(0));
		}
		
		[Test]
		public function testClosestAbsentByName():void
		{
			assertThat($(new Sprite).closest('name').length, equalTo(0));
		}
		
		[Test]
		public function testClosestTakesFirstMatch():void
		{
			assertThat($(_descendant).closest(Sprite).length, equalTo(1));
		}
		
		[Test]
		public function testClosestAncestorByClass():void
		{
			assertThat($(_descendant).closest(Sprite)[0], strictlyEqualTo(_child));
		}
		
		[Test]
		public function testClosestAncestorByName():void
		{
			assertThat($(_descendant).closest(ROOT_NAME)[0], strictlyEqualTo(_root));
		}
		
	}

}