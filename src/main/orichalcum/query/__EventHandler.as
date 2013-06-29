package orichalcum.query
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	internal class __EventHandler 
	{
		private var _eventId:String;
		private var _eventType:String;
		private var _displayObject:DisplayObject;
		private var _handler:Function;
		private var _selector:*;
		private var _matcher:Function;
		private var _arguments:Array;
		
		public function __EventHandler(
			eventId:String,
			eventType:String,
			displayObject:DisplayObject,
			handler:Function,
			matcher:Function,
			selector:* = null,
			args:Array = null) 
		{
			_eventId = eventId;
			_eventType = eventType;
			_displayObject = displayObject;
			_handler = handler;
			_selector = selector;
			_matcher = matcher;
			_arguments = args;
		}
		
		public function bind():void
		{
			_displayObject.addEventListener(_eventType, handle);
		}
		
		public function unbind():void
		{
			_displayObject.removeEventListener(_eventType, handle);
		}
		
		public function matches(selector:* = null, handler:Function = null):Boolean
		{
			return (selector == null || selector == _selector)
				&& (handler == null || handler == _handler);
		}
		
		public function triggerHandler(args:Array):void 
		{
			_handler.apply(_displayObject, args || _arguments);
		}
		
		public function handle(event:Event):*
		{
			if (_matcher(event.target))
				return callHandler(event);
		}
		
		public function callHandler(event:Event):*
		{
			if (_arguments)
				return _handler.apply(_displayObject, _arguments);
					
			if (_handler.length == 0)
				return _handler.call(_displayObject);
				
			if (_handler.length == 1)
				return _handler.call(_displayObject, event);
		}
		
	}

}