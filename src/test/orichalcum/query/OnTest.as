package orichalcum.query  
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.isTrue;
	import org.hamcrest.object.strictlyEqualTo;

	public class OnTest 
	{
		private const CHANGE_EVENT:Event = new Event(Event.CHANGE);
		private var _root:DisplayObjectContainer;
		private var _child:DisplayObject;
		private var $root:OrichalcumQuery;
		private var $child:OrichalcumQuery;
		private var _called:Boolean;
		
		
		[Before]
		public function setup():void
		{
			_root = new Sprite;
			_child = new Sprite;
			$root = $(_root);
			$child = $(_child);
			_root.addChild(_child);
		}
		
		[After]
		public function teardown():void
		{
			_root = null;
			_child = null;
			_called = false;
		}
		
		/**
		 * Unable to catch this but I know it exists
		 */
		[Ignore]
		[Test(expects = "TypeError")]
		public function testErrorOnEventTypeMistmatch():void
		{
			const handler:Function = function(mouseEvent:MouseEvent):void { _called = true; };
			$(new Sprite).on(Event.CHANGE, handler).trigger(CHANGE_EVENT);
			assertThat(_called, isTrue());
		}
		
		[Test]
		public function testHandlerContext():void
		{
			const context:Sprite = new Sprite;
			const handler:Function = function():void { assertThat(context, strictlyEqualTo(this)); };
			$(context).on(Event.CHANGE, handler).trigger(CHANGE_EVENT);
		}
		
		[Test]
		public function testNoFireOnWrongEventType():void
		{
			const _this:Object = this;
			const handler:Function = function():void { _called = true; };
			$(new Sprite).on(Event.ACTIVATE, handler).trigger(CHANGE_EVENT);
			assertThat(_called, isFalse());
		}
		
		[Test]
		public function testNoBindOnNullHandler():void
		{
			assertThat($(new Sprite).on(Event.ACTIVATE, null)[0].hasEventListener(Event.ACTIVATE), isFalse());
		}
		
		[Test]
		public function testHandleOnEvent():void
		{
			const handler:Function = function(event:Event):void { _called = true; };
			$(new Sprite).on(Event.CHANGE, handler).trigger(CHANGE_EVENT);
			assertThat(_called, isTrue());
		}
		
		[Test]
		public function testZeroArgumentHandler():void
		{
			const handler:Function = function():void { _called = true; };
			$(new Sprite).on(Event.CHANGE, handler).trigger(CHANGE_EVENT);
			assertThat(_called, isTrue());
		}
		
		[Test]
		public function testOneArgumentHandler():void
		{
			const handler:Function = function(event:Event):void { _called = true; };
			$(new Sprite).on(Event.CHANGE, handler).trigger(CHANGE_EVENT);
			assertThat(_called, isTrue());
		}
		
		[Test]
		public function testCustomArgumentHandler():void
		{
			const _arg0:Object = {};
			const _arg1:Object = {};
			const handler:Function = function(arg0:Object, arg1:Object):void {
				assertThat(_arg0, strictlyEqualTo(arg0));
				assertThat(_arg1, strictlyEqualTo(arg1));
			};
			$(new Sprite).on(Event.CHANGE, [_arg0, _arg1], handler).trigger(CHANGE_EVENT);
		}
		
		[Test]
		public function testFilterIn():void
		{
			const handler:Function = function(event:Event):void { _called = true; };
			$(new Sprite).on(Event.CHANGE, Sprite, handler).trigger(CHANGE_EVENT);
			assertThat(_called, isTrue());
		}
		
		[Test]
		public function testFilterOut():void
		{
			const handler:Function = function(event:Event):void { _called = true; };
			$(new Sprite).on(Event.CHANGE, Shape, handler).trigger(CHANGE_EVENT);
			assertThat(_called, isFalse());
		}
		
		[Test]
		public function testEventListenerAddedToEach():void
		{
			$([new Sprite, new Sprite, new Sprite])
				.on(MouseEvent.CLICK, function():void { })
				.ea(function(dispatcher:IEventDispatcher, index:int):void {
					assertThat(dispatcher.hasEventListener(MouseEvent.CLICK), isTrue());
				});
		}
		
		[Test]
		public function testBindMultiple():void
		{
			var subject:DisplayObject = $(new Sprite).on({
				activate: function():void {}
				,deactivate: function():void {}
			})[0];
			
			assertThat(subject.hasEventListener(Event.ACTIVATE), isTrue());
			assertThat(subject.hasEventListener(Event.DEACTIVATE), isTrue());
		}
		
		[Test]
		public function testNamespaceBinding():void
		{
			var subject:DisplayObject = $(new Sprite).on('click.namespace', function():void {})[0];
			assertThat(subject.hasEventListener(MouseEvent.CLICK), isTrue());
		}
		
		[Test]
		public function testEventDelegation():void
		{
			$root.on(MouseEvent.CLICK, $child, function():void { _called = true; } );
			$child.trigger(new MouseEvent(MouseEvent.CLICK));
			assertThat(_called, isTrue());
		}
		
	}

}