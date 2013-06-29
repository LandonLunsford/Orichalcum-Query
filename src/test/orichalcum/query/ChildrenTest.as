package orichalcum.query
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.strictlyEqualTo;

	public class ChildrenTest 
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
		public function testContentsNotIncludedByType():void
		{
			assertThat($(new Sprite).children(Sprite).length, equalTo(0));
		}
		
		[Test]
		public function testContentsNotIncludedByName():void
		{
			assertThat($(_root).children(ROOT_NAME).length, equalTo(0));
		}
		
		[Test]
		public function testDescendantsNotIncluded():void
		{
			assertThat($(_root).children(Shape).length, equalTo(0));
		}
		
		[Test]
		public function testChildrenByClass():void
		{
			assertThat($(_root).children(Sprite)[0], strictlyEqualTo(_child));
		}
		
		[Test]
		public function testChildrenByName():void
		{
			assertThat($(_root).find(CHILD_NAME)[0], strictlyEqualTo(_child));
		}
		
	}

}