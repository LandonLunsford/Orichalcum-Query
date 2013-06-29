package orichalcum.query  
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.strictlyEqualTo;
	
	public class FindTest 
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
			assertThat($(new Sprite).find(Sprite).length, equalTo(0));
			assertThat($(_root).find(ROOT_NAME).length, equalTo(0));
		}
		
		[Test]
		public function testFindAbsentByClass():void
		{
			assertThat($(new Sprite).find(Shape).length, equalTo(0));
		}
		
		[Test]
		public function testFindAbsentByName():void
		{
			assertThat($(new Sprite).find('name').length, equalTo(0));
		}
		
		[Test]
		public function testFindChildByClass():void
		{
			assertThat($(_root).find(Sprite)[0], strictlyEqualTo(_child));
		}
		
		[Test]
		public function testFindChildByName():void
		{
			assertThat($(_root).find(CHILD_NAME)[0], strictlyEqualTo(_child));
		}
		
		[Test]
		public function testFindDescendantByClass():void
		{
			assertThat($(_root).find(Shape)[0], strictlyEqualTo(_descendant));
		}
		
		[Test]
		public function testFindDescendantByName():void
		{
			assertThat($(_root).find(DESCENDANT_NAME)[0], strictlyEqualTo(_descendant));
		}
		
		[Test]
		public function testFindDescendantsByClass():void
		{
			assertThat($(_root).find(DisplayObject).length, equalTo(2));
		}
		
		[Test]
		public function testFindNothingReturnsNothing():void
		{
			assertThat($(_root).find().length, equalTo(0));
		}
		
	}

}