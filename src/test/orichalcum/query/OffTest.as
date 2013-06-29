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

	public class OffTest 
	{
		private var _handler:Function = function(...args):void { trace(args); };
		private var _dispatcher:DisplayObjectContainer;
		private var $dispatcher:OrichalcumQuery;
		
		[Before]
		public function setup():void
		{
			_dispatcher = new Sprite;
			$dispatcher = $(_dispatcher);
		}
		
		[After]
		public function teardown():void
		{
			_dispatcher = null;
			$dispatcher.off();
			$dispatcher = null;
		}
		
		[Test]
		public function testRemoveAllEventListeners():void
		{
			$dispatcher.on( { activate:_handler, deactivate:_handler, click:_handler } ).off();
			assertThat(_dispatcher.hasEventListener(Event.ACTIVATE), isFalse());
			assertThat(_dispatcher.hasEventListener(Event.DEACTIVATE), isFalse());
			assertThat(_dispatcher.hasEventListener(MouseEvent.CLICK), isFalse());
		}
		
		[Test]
		public function testRemoveEventListenerList():void
		{
			$dispatcher.on( { activate:_handler, deactivate:_handler, click:_handler } ).off('activate,deactivate');
			assertThat(_dispatcher.hasEventListener(Event.ACTIVATE), isFalse());
			assertThat(_dispatcher.hasEventListener(Event.DEACTIVATE), isFalse());
			assertThat(_dispatcher.hasEventListener(MouseEvent.CLICK), isTrue());
		}
		
		[Test]
		public function testRemoveNamespacedEventListener():void
		{
			const eventId:String = 'init.namespace';
			$dispatcher.on(eventId, _handler);
			assertThat(_dispatcher.hasEventListener(Event.INIT), isTrue());
			$dispatcher.off(eventId);
			assertThat(_dispatcher.hasEventListener(Event.INIT), isFalse());
		}
		
		[Test]
		public function testRemoveAllEventListenersInNamespace():void
		{
			const ns:String = '.namespace';
			const e1:String = Event.CANCEL + ns;
			const e2:String = Event.COPY + ns;
			$dispatcher.on({ e1:_handler, e2:_handler, 'change':_handler});
			$dispatcher.off(ns);
			assertThat(_dispatcher.hasEventListener(Event.CANCEL), isFalse());
			assertThat(_dispatcher.hasEventListener(Event.COPY), isFalse());
			assertThat(_dispatcher.hasEventListener(Event.CHANGE), isTrue());
		}
		
		[Test]
		public function testSelectorMatching():void
		{
			const eventType:String = Event.CHANGE;
			$dispatcher.on(eventType, Sprite, _handler);
			$dispatcher.off(eventType, Shape, _handler);
			assertThat(_dispatcher.hasEventListener(eventType), isTrue());
			$dispatcher.off(eventType, Sprite, _handler);
			assertThat(_dispatcher.hasEventListener(eventType), isFalse());
		}
		
		[Test]
		public function testHandlerMatching():void
		{
			const eventType:String = Event.CHANGE;
			$dispatcher.on(eventType, _handler);
			$dispatcher.off(eventType, function():void{});
			assertThat(_dispatcher.hasEventListener(eventType), isTrue());
			$dispatcher.off(eventType, _handler);
			assertThat(_dispatcher.hasEventListener(eventType), isFalse());
		}
		
		[Test]
		public function testSelectorAndHandlerMatching():void
		{
			const eventType:String = Event.CHANGE;
			$dispatcher.on(eventType, Sprite, _handler);
			$dispatcher.off(eventType, Shape, _handler);
			assertThat(_dispatcher.hasEventListener(eventType), isTrue());
			$dispatcher.off(eventType, Sprite, function():void{});
			assertThat(_dispatcher.hasEventListener(eventType), isTrue());
			$dispatcher.off(eventType, Sprite, _handler);
			assertThat(_dispatcher.hasEventListener(eventType), isFalse());
		}
	}

}