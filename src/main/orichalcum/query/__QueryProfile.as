package orichalcum.query
{

	internal class __QueryProfile 
	{
		
		private var _data:Object;
		private var _eventHandlers:Object;
		
		public function get data():Object 
		{
			return _data ||= {};
		}
		
		public function set data(value:Object):void 
		{
			_data = value;
		}
		
		public function get eventHandlers():Object 
		{
			return _eventHandlers ||= {};
		}
		
		public function set eventHandlers(value:Object):void 
		{
			_eventHandlers = value;
		}
		
		public function getAllEventHandlersOfType(eventType:String):Array
		{
			return eventHandlers[eventType] ||= [];
		}
		
		public function removeAllEventHandlers():void
		{
			for (var eventId:String in _eventHandlers)
				removeAllEventHandlersOfType(eventId);
		}
		
		public function removeAllEventHandlersOfType(eventId:String):void
		{
			//trace('removing', eventId);
			const listeners:Array = eventHandlers[eventId];
			for each(var listener:__EventHandler in listeners)
			{
				//trace('itr', listener);
				listener.unbind();
			}
			listeners.length = 0;
			delete eventHandlers[eventId];
		}
		
		public function removeAllEventHandlersOfNamespace(eventNamespace:String):void
		{
			// should be "endsWith()"
			//if ((new RegExp('$' + eventNamespace)).test(eventId))
			for (var eventId:String in eventHandlers)
				eventId.indexOf(eventNamespace) >= 0 &&	removeAllEventHandlersOfType(eventId);
		}
		
		/**
		 * Main entry point
		 * @param	eventId
		 * @param	selector
		 * @param	handler
		 */
		public function removeEventHandler(eventId:String, selector:* = null, handler:Function = null):void
		{
			/* optimization */
			selector == null && handler == null
				? OrichalcumQuery.isEventTypeNamespace(eventId)
					? removeAllEventHandlersOfNamespace(eventId)
					: removeAllEventHandlersOfType(eventId)
				: OrichalcumQuery.isEventTypeNamespace(eventId)
					? removeEventHandlersOfNamespace(eventId, selector, handler)
					: removeEventHandlerOfType(eventId, selector, handler)
		}
		
		public function removeEventHandlersOfNamespace(eventNamespace:String, selector:* = null, handler:Function = null):void
		{
			for (var eventId:String in eventHandlers)
			{
				if (eventId.indexOf(eventNamespace) >= 0)
					removeEventHandlerOfType(eventId, selector, handler);
				
				var handlers:Array = eventHandlers[eventId]
				if (handlers && handlers.length == 0)
					delete eventHandlers[eventId];
			}
		}
		
		public function removeEventHandlerOfType(eventId:String, selector:* = null, handler:Function = null):void
		{
			const listeners:Array = getAllEventHandlersOfType(eventId);
			for (var i:int = listeners.length - 1; i >= 0; i--)
			{
				var listener:__EventHandler = listeners[i];
				if (listener.matches(selector, handler))
				{
					listeners.splice(i, 1);
					listener.unbind();
				}
			}
		}
		
		public function removeData():void
		{
			_data = {};
		}
		
		public function clear():void
		{
			removeData();
			removeAllEventHandlers();
		}
		
	}

}