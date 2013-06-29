package orichalcum.query
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;

	/**
	 * Query API
	 * TODO
	 * off
	 * hover
	 * insertAfter
	 * insertBefore
	 * replaceAll
	 * replaceWith
	 * 
	 * NOTES
	 * bind/unbind & delegate/undelegate are supersceded by on/off, and are pointless thus removed
	 * 
	 */
	public dynamic class OrichalcumQuery extends Array
	{
		static internal const profiles:Dictionary = new Dictionary;
		static internal const VERSION:String = '1.0';
		static internal const UNDEFINED:Object = {};
		static internal const RETURN_TRUE:Function = function(...ags):Boolean { return true; };
		static internal const RETURN_FALSE:Function = function(...ags):Boolean { return false; };
		static internal const EVENT_TYPE_NAMESPACE_DELIMITER:String = '.';
		static internal const LIST_DELIMITER:String = ',';
		static public const noop:Function = function(...args):* { return undefined; };
		
		static internal function isEventTypeNamespace(value:String):Boolean
		{
			return value.indexOf(EVENT_TYPE_NAMESPACE_DELIMITER) == 0;
		}
		
		static internal function eventTypeOfEventId(eventId:String):String
		{
			const index:int = eventId.indexOf(EVENT_TYPE_NAMESPACE_DELIMITER);
			return index < 0 ? eventId : eventId.substring(0, index);
		}
		
		static internal function eventTargetMatcherOfSelector(selector:*):Function
		{
			return selector is String ? _nameMatcher(selector) : selector is Class ? _typeMatcher(selector) : RETURN_TRUE;
		}
		
		static internal function _typeMatcher(type:Class):Function
		{
			return function(child:DisplayObject):Boolean { return child is type; }; 
		}
		
		static internal function _propertyMatcher(name:String, value:*):Function
		{
			return function(child:DisplayObject):Boolean { return name in child && child[name] == value; };
		}
		
		static internal function _nameMatcher(name:String):Function
		{
			return _propertyMatcher('name', name);
		}
		
		static internal function _elementMatcher(element:DisplayObject):Function
		{
			return function(child:DisplayObject):Boolean { return child === element; };
		}
		
		static public function now():Number
		{
			return (new Date()).time;
		}
		
		static public function trim(string:String):String
		{
			return string.replace(/\s*/g, '');
		}
		
		static private function getProfile(displayObject:DisplayObject):__QueryProfile 
		{
			return profiles[displayObject] ||= new __QueryProfile;
		}
		
		static private function getData(displayObject:DisplayObject):Object
		{
			return getProfile(displayObject).data;
		}
		
		static private function getEventHandlers(displayObject:DisplayObject):Object
		{
			return getProfile(displayObject).eventHandlers;
		}
		
		static private function getEventHandlersOfType(displayObject:DisplayObject, eventId:String):Array
		{
			return getProfile(displayObject).getAllEventHandlersOfType(eventId);
		}
		
		static private function removeEventHandler(displayObject:DisplayObject, eventId:String, selector:*, handler:Function):void
		{
			return getProfile(displayObject).removeEventHandler(eventId, selector, handler);
		}
		
		static private function removeAllEventHandlers(displayObject:DisplayObject):void
		{
			return getProfile(displayObject).removeAllEventHandlers();
		}
		
		static private function removeEventHandlersOfType(displayObject:DisplayObject, eventType:String):void
		{
			return getProfile(displayObject).removeAllEventHandlersOfType(eventType);
		}
		
		static private function clearProfile(displayObject:DisplayObject):void
		{
			return getProfile(displayObject).clear();
		}
		
		static public function extend(...objects):Object
		{
			const extension:Object = {};
			for each(var object:Object in objects)
				for (var property:String in object)
					extension[property] = object[property];
			return extension;
		}
		
		static private function _extendEquals(...objects):Object
		{
			if (objects.length == 0)
				throw new ArgumentError;
				
			var extension:Object = objects[0]
			for (var i:int = 1; i < objects.length; i++)
			{
				var object:Object = objects[i];
				for (var property:String in object)
					extension[property] = object[property];
			}
			return extension;
		}
		
		public function OrichalcumQuery(argument:* = null)
		{
			if (argument is DisplayObject)
			{
				this[0] = argument;
			}
			else if (argument is Array || argument is Vector.<DisplayObject> || argument is OrichalcumQuery)
			{
				for each(var displayObject:DisplayObject in argument)
					displayObject && push(displayObject);
			}
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////
		// Internals
		/////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @deprecated Out of scope for release 1.0
		 * @throws IllegalOperationError
		 */
		public function get context():*
		{
			throw IllegalOperationError;
		}
		
		/**
		 * @deprecated Out of scope for release 1.0
		 * @throws IllegalOperationError
		 */
		public function get selector():*
		{
			throw IllegalOperationError;
		}
		
		/**
		 * The String version Key of the OrichalcumQuery in use
		 * @return OrichalcumQuery version
		 */
		public function get version():String
		{
			return VERSION;
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////
		// Ajax
		/////////////////////////////////////////////////////////////////////////////////////////////
		
		public function load(arg:*):OrichalcumQuery
		{
			if (length == 0)
				return this;
			
			if (arg is String)
				return _load(arg as String);
			
			if (arg is Object && 'url' in arg)
				return _load(arg.url
					,'complete' in arg ? arg.complete : null
					,'error' in arg ? arg.error : null
					,'progress' in arg ? arg.progress : null);
			
			return this;
		}
		
		private function _load(url:String, complete:Function = null, error:Function = null, progress:Function = null):OrichalcumQuery
		{
			const loader:Loader = new Loader;
			append(loader);
			complete != null && loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event:Event):void{ event.target.removeEventListener(event.type, arguments.callee); complete.length == 0 ? complete() : complete(event); });
			error != null && loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(event:IOErrorEvent):void {event.target.removeEventListener(event.type, arguments.callee); error.length == 0 ? error() : error(event); });
			progress != null && loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, function(event:ProgressEvent):void {event.target.removeEventListener(event.type, arguments.callee); progress.length == 0 ? progress() : progress(event); });
			loader.load(new URLRequest(url));
			return this;
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////
		// Dimensions
		/////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Get the current computed height for the first element in the set of matched elements or set the height of every matched element.
		 */
		public function width(...args):Number
		{
			return _dimension('width', args);
		}
		
		/**
		 * Get the current computed width for the first element in the set of matched elements or set the width of every matched element.
		 */
		public function height(...args):Number
		{
			return _dimension('height', args);
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////
		// Filtering
		// http://api.jquery.com/category/traversing/filtering/
		/////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Add elements to the set of matched elements.
		 * @param	selection
		 * @return
		 */
		public function add(selection:*):OrichalcumQuery
		{
			const sum:OrichalcumQuery = new OrichalcumQuery;
			for each(var displayObject:DisplayObject in this)
				sum.push(displayObject);
				
			if (selection is Array
			|| selection is Vector.<DisplayObject>
			|| selection is Vector.<DisplayObjectContainer>)
			{
				for each(displayObject in selection)
					displayObject && sum.push(displayObject);
			}
			else if (selection is DisplayObject)
			{
				sum.push(selection as DisplayObject);
			}
			return sum;
		}
		
		/**
		 * Reduce the set of matched elements to the first in the set.
		 * @return
		 */
		public function first():OrichalcumQuery
		{
			return length == 0 ? new OrichalcumQuery : new OrichalcumQuery(this[0]);
		}
		
		/**
		 * Reduce the set of matched elements to the final one in the set.
		 * @return
		 */
		public function last():OrichalcumQuery
		{
			return length == 0 ? new OrichalcumQuery : new OrichalcumQuery(this[length - 1]);
		}
		
		/**
		 * Reduce the set of matched elements to the one at the specified index.
		 * @param	index
		 * @return
		 */
		public function eq(index:int):OrichalcumQuery
		{
			return $(this[index >= 0 ? index : length + index]);
		}
		
		/**
		 * Reduce the set of matched elements to those that match the selector or pass the function’s test.
		 * @param	selector
		 * @return
		 */
		public function are(type:Class = null):OrichalcumQuery
		{
			if (type == null)
				return new OrichalcumQuery;
			
			const filtered:OrichalcumQuery = new OrichalcumQuery;
			for each(var displayObject:DisplayObject in this)
				displayObject is type && filtered.push(displayObject);
				
			return filtered;
		}
		
		/**
		 * Remove elements from the set of matched elements.
		 * @param	type
		 * @return
		 */
		public function not(type:Class = null):OrichalcumQuery
		{
			if (type == null)
				return new OrichalcumQuery;
			
			const filtered:OrichalcumQuery = new OrichalcumQuery;
			for each(var displayObject:DisplayObject in this)
				displayObject is type || filtered.push(displayObject);
				
			return filtered;
		}
		
		/**
		 * Reduce the set of matched elements to those that have a descendant that matches the selector or DOM element.
		 * @param	selector
		 * @return
		 */
		public function has(selector:*):OrichalcumQuery
		{
			if (selector == null)
				return new OrichalcumQuery;
				
			if (selector is String)
				return _has(_nameMatcher(selector as String));
			
			if (selector is Class)
				return _has(_typeMatcher(selector as Class));
			
			if (selector is DisplayObject)
				return _has(_elementMatcher(selector));
			
			if (selector is OrichalcumQuery && selector.length)
				return _has(_elementMatcher(selector[0]));
			
			return new OrichalcumQuery;
		}
		
		/**
		 * Search for a given element from among the matched elements
		 * @param	...args
		 * @return
		 */
		public function index(selector:* = null):int
		{
			if (length == 0)
				return -1;
			
			if (selector == null)
			{
				var child:DisplayObject = this[0];
				if (child.parent)
					return child.parent.getChildIndex(child);
			}
			
			if (selector is String)
				return _indexOf(_nameMatcher(selector as String));
				
			if (selector is Class)
				return _indexOf(_typeMatcher(selector as Class));
				
			if (selector is DisplayObject)
				return _indexOf(_elementMatcher(selector));
			
			if (selector is OrichalcumQuery && selector.length)
				return _indexOf(_elementMatcher(selector[0]));
				
			return -1;
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////
		// Traversal
		/////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Get the immediately following sibling of each element in the set of matched elements. If a selector is provided, it retrieves the next sibling only if it matches that selector.
		 * @param	selector
		 * @return
		 */
		public function next(selector:Class = null):OrichalcumQuery
		{
			if (selector == null)
				selector = DisplayObject;
			
			const selections:OrichalcumQuery = new OrichalcumQuery;
			for each(var child:DisplayObject in this)
			{
				var parent:DisplayObjectContainer = child.parent;
				if (parent)
				{
					var nextChildIndex:int = parent.getChildIndex(child) + 1;
					if (nextChildIndex < parent.numChildren)
					{
						var selection:DisplayObject  = parent.getChildAt(nextChildIndex);
						if (selection !== child && selection is selector)
							selections[selections.length] = selection;
					}
				}
			}
			return selections;
		}
		
		/**
		 * Get the immediately preceding sibling of each element in the set of matched elements, optionally filtered by a selector.
		 * @param	selector
		 * @return
		 */
		public function prev(selector:Class = null):OrichalcumQuery
		{
			if (selector == null)
				selector = DisplayObject;
			
			const selections:OrichalcumQuery = new OrichalcumQuery;
			for each(var child:DisplayObject in this)
			{
				var parent:DisplayObjectContainer = child.parent;
				if (parent)
				{
					var nextChildIndex:int = parent.getChildIndex(child) - 1;
					if (nextChildIndex >= 0)
					{
						var selection:DisplayObject  = parent.getChildAt(nextChildIndex);
						if (selection !== child && selection is selector)
							selections[selections.length] = selection;
					}
				}
			}
			return selections;
		}
		
		/**
		 * Get the siblings of each element in the set of matched elements, optionally filtered by a selector.
		 * @param	selector
		 * @return
		 */
		public function siblings(selector:Class = null):OrichalcumQuery
		{
			if (selector == null)
				selector = DisplayObject;
			
			const selections:OrichalcumQuery = new OrichalcumQuery;
			for each(var child:DisplayObject in this)
			{
				var parent:DisplayObjectContainer = child.parent;
				if (parent)
				{
					for (var i:int = 0; i < parent.numChildren; i++)
					{
						var selection:DisplayObject = parent.getChildAt(i);
						if (selection !== child && selection is selector)
							selections.push(selection);
					}
				}
			}
			return selections;
		}
		
		/**
		 * Get all following siblings of each element in the set of matched elements, optionally filtered by a selector.
		 * @param	selector
		 * @return
		 */
		public function nextAll(selector:Class = null):OrichalcumQuery
		{
			return _nextAll(selector || DisplayObject);
		}
		
		/**
		 * Get all preceding siblings of each element in the set of matched elements, optionally filtered by a selector.
		 * @param	selector
		 * @return
		 */
		public function prevAll(selector:Class = null):OrichalcumQuery
		{
			return _prevAll(selector || DisplayObject);
		}
		
		/**
		 * Get all following siblings of each element up to but not including the element matched by the selector, DOM node, or jQuery object passed.
		 * @param	selector
		 * @param	filter
		 * @return
		 */
		public function nextUntil(selector:*, filter:Class = null):OrichalcumQuery
		{
			if (selector == null)
				return new OrichalcumQuery;
			
			if (selector is String)
				return _nextUntil(filter || DisplayObject, _nameMatcher(selector as String));
				
			if (selector is Class)
				return _nextUntil(filter || DisplayObject, _typeMatcher(selector as Class));
				
			if (selector is DisplayObject)
				return _nextUntil(filter || DisplayObject, _elementMatcher(selector));
			
			if (selector is OrichalcumQuery && selector.length)
				return _nextUntil(filter || DisplayObject, _elementMatcher(selector[0]));
			
			return new OrichalcumQuery;
		}
		
		/**
		 * Get all preceding siblings of each element up to but not including the element matched by the selector, DOM node, or jQuery object.
		 * @param	selector
		 * @param	filter
		 * @return
		 */
		public function prevUntil(selector:*, filter:Class = null):OrichalcumQuery
		{
			if (selector == null)
				return new OrichalcumQuery;
			
			if (selector is String)
				return _prevUntil(filter || DisplayObject, _nameMatcher(selector as String));
				
			if (selector is Class)
				return _prevUntil(filter || DisplayObject, _typeMatcher(selector as Class));
				
			if (selector is DisplayObject)
				return _prevUntil(filter || DisplayObject, _elementMatcher(selector));
			
			if (selector is OrichalcumQuery && selector.length)
				return _prevUntil(filter || DisplayObject, _elementMatcher(selector[0]));
			
			return new OrichalcumQuery;
		}
		
		/**
		 * Get the children of each element in the set of matched elements, optionally filtered by a selector.
		 * @param	selector
		 * @return
		 */
		public function children(selector:* = null):OrichalcumQuery
		{
			if (selector == null)
				return _children(RETURN_TRUE);
				
			if (selector is String)
				return _children(_nameMatcher(selector as String));
			
			if (selector is Class)
				return _children(_typeMatcher(selector as Class));
				
			return new OrichalcumQuery;
		}
		
		/**
		 * Get the parent of each element in the current set of matched elements, optionally filtered by a selector.
		 * @param	selector
		 * @return
		 */
		public function parent(selector:* = null):OrichalcumQuery
		{
			if (selector == null)
				return _parent(RETURN_TRUE);
				
			if (selector is String)
				return _parent(_nameMatcher(selector as String));
			
			if (selector is Class)
				return _parent(_typeMatcher(selector as Class));
				
			return new OrichalcumQuery;
		}
		
		/**
		 * Get the ancestors of each element in the current set of matched elements, optionally filtered by a selector.
		 * @param	selector
		 * @return
		 */
		public function parents(selector:* = null):OrichalcumQuery
		{
			if (selector == null)
				return _parents(RETURN_TRUE);
				
			if (selector is String)
				return _parents(_nameMatcher(selector as String));
			
			if (selector is Class)
				return _parents(_typeMatcher(selector as Class));
				
			return new OrichalcumQuery;
		}
		
		/**
		 * Get the ancestors of each element in the current set of matched elements, up to but not including the element matched by the selector, DOM node, or jQuery object.
		 * @param	selector
		 * @param	filter
		 * @return
		 */
		public function parentsUntil(selector:*, filter:Class = null):OrichalcumQuery
		{
			if (selector == null)
				return _parentsUntil(filter || DisplayObject, RETURN_TRUE);
				
			if (selector is String)
				return _parentsUntil(filter || DisplayObject, _nameMatcher(selector as String));
			
			if (selector is Class)
				return _parentsUntil(filter || DisplayObject, _typeMatcher(selector as Class));
				
			return new OrichalcumQuery;
		}
		
		/**
		 * Get the descendants of each element in the current set of matched elements, filtered by a selector, jQuery object, or element.
		 * @param	selector
		 * @return
		 */
		public function find(selector:* = null):OrichalcumQuery
		{
			if (selector is String)
				return _find(_nameMatcher(selector as String));
			
			if (selector is Class)
				return _find(_typeMatcher(selector as Class));
			
			return new OrichalcumQuery;
		}
		
		/**
		 * For each element in the set, get the first element that matches the selector by testing the element itself and traversing up through its ancestors in the DOM tree.
		 * @param	selector
		 * @return
		 */
		public function closest(selector:* = null):OrichalcumQuery
		{
			if (selector == null)
				return _closest(RETURN_TRUE);
			
			if (selector is String)
				return _closest(_nameMatcher(selector as String));
				
			if (selector is Class)
				return _closest(_typeMatcher(selector as Class));
				
			return new OrichalcumQuery;
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////
		// Manipulation
		/////////////////////////////////////////////////////////////////////////////////////////////
		
		public function content(contents:* = null):OrichalcumQuery
		{
			if (contents == null)
				return children();
			
			var container:DisplayObjectContainer;
			if (length
				&& (container = this[0])
				&& (contents is OrichalcumQuery || contents is Array || contents is Vector.<DisplayObject>))
					for each (var child:DisplayObject in contents)
						container.addChild(child);
					
			return this;
		}
		
		public function append(arg:*):*
		{
			if (length == 0) return this;
			var appendee:DisplayObject = arg is OrichalcumQuery && arg.length ? arg[0] : arg as DisplayObject;
			if (appendee == null) return this;
			var container:DisplayObjectContainer = this[0];
			container && container.addChild(appendee);
			return this;
		}
		
		public function prepend(arg:*):*
		{
			if (length == 0) return this;
			var appendee:DisplayObject = (arg is OrichalcumQuery && arg.length ? arg[0] : arg) as DisplayObject;
			if (appendee == null) return this;
			var container:DisplayObjectContainer = this[0];
			container && container.addChildAt(appendee, 0);
			return this;
		}
		
		public function appendTo(arg:*):*
		{
			if (length == 0) return this;
			var container:DisplayObjectContainer = (arg is OrichalcumQuery && arg.length ? arg[0] : arg) as DisplayObjectContainer;
			if (container == null) return this;
			var appendee:DisplayObject = this[0];
			container.addChild(appendee);
			return this;
		}
		
		public function prependTo(arg:*):*
		{
			if (length == 0) return this;
			var container:DisplayObjectContainer = (arg is OrichalcumQuery && arg.length ? arg[0] : arg) as DisplayObjectContainer;
			if (container == null) return this;
			var appendee:DisplayObject = this[0];
			container.addChildAt(appendee, 0);
			return this;
		}
		
		/**
		 * Remove the set of matched elements from the DOM including their data and event listeners
		 * To remove the elements without removing data and events, use .detach() instead.
		 * 
		 * http://api.jquery.com/remove/
		 */
		public function remove(selector:Class = null):OrichalcumQuery
		{
			return _remove(selector || DisplayObject);
		}
		
		/**
		 * Remove the set of matched elements from the DOM.
		 * @param	selector
		 * @return
		 */
		public function detach(selector:Class = null):OrichalcumQuery
		{
			return _detach(selector || DisplayObject);
		}
		
		/**
		 * Remove all child nodes of the set of matched elements from the DOM.
		 * @return
		 */
		public function empty():OrichalcumQuery
		{
			for each(var parent:DisplayObjectContainer in this)
				if (parent) while (parent.numChildren) parent.removeChildAt(0);
			return this;
		}
		
		/**
		 * Wrap an HTML structure around each element in the set of matched elements.
		 * @param arg A selector, element, HTML string, or jQuery object specifying the structure to wrap around the matched elements. A callback function returning the HTML content or jQuery object to wrap around the matched elements. Receives the index position of the element in the set as an argument. Within the function, this refers to the current element in the set.
		 * @return
		 */
		public function wrap(arg:*):*
		{
			//if (arg == null)
			//
			//if (arg is Function)
			//
			//if (arg is Class)
			
			throw new IllegalOperationError;
		}
		
		/**
		 * Remove the parents of the set of matched elements from the DOM, leaving the matched elements in their place.
		 * @return
		 */
		public function unwrap():OrichalcumQuery
		{
			for each(var child:DisplayObject in this)
			{
				var parent:DisplayObjectContainer = child.parent;
				parent && parent.removeChild(child);
				var grandparent:DisplayObjectContainer = parent.parent;
				grandparent && grandparent.addChild(child);
			}
			return this;
		}
		
		/**
		 * Get the value of an attribute for the first element in the set of matched elements or set one or more attributes for every matched element.
		 * @param	...args
		 * @return
		 */
		public function attr(...args):*
		{
			if (length == 0 || args.length == 0)
				return this;
				
			var arg0:* = args[0];
			
			if (args.length == 2 && arg0 is String)
			{
				var arg1:* = args[1];
				for each(var child:DisplayObject in this)
					child[arg0] = arg1;
			}
			else if (args.length == 1)
			{
				if (arg0 is String)
				{
					child = this[0];
					return arg0 in child ? child[arg0] : undefined;
				}
				else if (arg0 is Object)
				{
					for each(child in this)
						for (var attribute:String in arg0) child[attribute] = arg0[attribute];
				}
			}
			return this;
		}
		
		public function data(...args):*
		{
			if (args.length == 0)
				return length ? getData(this[0]) : {};
			
			var arg0:* = args[0];
			
			if (args.length == 1)
			{
				if (arg0 is String)
					return getData(this[0])[arg0];
				
				if (arg0 is Object)
				{
					for each(var displayObject:DisplayObject in this)
						_extendEquals(getProfile(displayObject).data, arg0);
					return this;
				}
			}
			else if (arg0 is String)
			{
				for each(displayObject in this)
					getProfile(displayObject).data[arg0] = args[1];
			}
			return this;
		}
		
		public function removeData(...args):OrichalcumQuery
		{
			if (args.length)
			{
				for each(var displayObject:DisplayObject in this)
				{
					var data:Object = getData(displayObject);
					for each(var datumName:String in args)
						if (datumName != null)
							delete data[datumName];
				}
			}
			else
			{
				for each(displayObject in this)
					getProfile(displayObject).data = {};
			}
			return this;
		}	
		
		/////////////////////////////////////////////////////////////////////////////////////////////
		// Events
		/////////////////////////////////////////////////////////////////////////////////////////////
		
		public function one(event:String, ...args):OrichalcumQuery
		{
			return _on(event, args, 1);
		}
		
		public function on(events:Object, ...args):OrichalcumQuery
		{
			return _on(events, args);
		}
		
		public function triggerHandler(eventType:String, ...args):*
		{
			var firstReturnValue:* = UNDEFINED;
			for each(var displayObject:DisplayObject in this)
			{
				var handlers:Array = getEventHandlers(displayObject)[eventType];
				if (handlers && handlers.length)
				{
					var returnValue:* = handlers[0].triggerHandler(args);
					if (firstReturnValue === UNDEFINED)
						firstReturnValue = returnValue;
				}
			}
			return firstReturnValue === UNDEFINED ? UNDEFINED : firstReturnValue;
		}
		
		public function trigger(event:Event):OrichalcumQuery
		{
			for each(var displayObject:DisplayObject in this)
				displayObject.dispatchEvent(event);
			return this;
		}
		
		public function click(...args):OrichalcumQuery
		{
			return _bindOrTrigger(MouseEvent, MouseEvent.CLICK, args);
		}
		
		public function dblclick(...args):OrichalcumQuery
		{
			return _bindOrTrigger(MouseEvent, MouseEvent.DOUBLE_CLICK, args);
		}
		
		public function mousemove(...args):OrichalcumQuery
		{
			return _bindOrTrigger(MouseEvent, MouseEvent.MOUSE_MOVE, args);
		}
		
		public function mouseover(...args):OrichalcumQuery
		{
			return _bindOrTrigger(MouseEvent, MouseEvent.MOUSE_OVER, args);
		}
		
		public function mouseout(...args):OrichalcumQuery
		{
			return _bindOrTrigger(MouseEvent, MouseEvent.MOUSE_OUT, args);
		}
		
		public function mousewheel(...args):OrichalcumQuery
		{
			return _bindOrTrigger(MouseEvent, MouseEvent.MOUSE_WHEEL, args);
		}
		
		public function change(...args):OrichalcumQuery
		{
			return _bindOrTrigger(Event, Event.CHANGE, args);
		}
		
		public function focusIn(...args):OrichalcumQuery
		{
			return _bindOrTrigger(FocusEvent, FocusEvent.FOCUS_IN, args);
		}
		
		public function focusOut(...args):OrichalcumQuery
		{
			return _bindOrTrigger(FocusEvent, FocusEvent.FOCUS_OUT, args);
		}
		
		public function keydown(...args):OrichalcumQuery
		{
			return _bindOrTrigger(KeyboardEvent, KeyboardEvent.KEY_DOWN, args);
		}
		
		public function keyup(...args):OrichalcumQuery
		{
			return _bindOrTrigger(KeyboardEvent, KeyboardEvent.KEY_UP, args);
		}
		
		public function added(...args):OrichalcumQuery
		{
			return _bindOrTrigger(Event, Event.ADDED, args);
		}
		
		public function addedToStage(...args):OrichalcumQuery
		{
			return _bindOrTrigger(Event, Event.ADDED_TO_STAGE, args);
		}
		
		public function removed(...args):OrichalcumQuery
		{
			return _bindOrTrigger(Event, Event.REMOVED, args);
		}
		
		public function removedFromStage(...args):OrichalcumQuery
		{
			return _bindOrTrigger(Event, Event.REMOVED_FROM_STAGE, args);
		}
		
		public function enterFrame(...args):OrichalcumQuery
		{
			return _bindOrTrigger(Event, Event.ENTER_FRAME, args);
		}
		
		public function init(...args):OrichalcumQuery
		{
			return _bindOrTrigger(Event, Event.INIT, args);
		}
		
		public function activate(...args):OrichalcumQuery
		{
			return _bindOrTrigger(Event, Event.ACTIVATE, args);
		}
		
		public function deactivate(...args):OrichalcumQuery
		{
			return _bindOrTrigger(Event, Event.DEACTIVATE, args);
		}
		
		public function resize(...args):OrichalcumQuery
		{
			return _bindOrTrigger(Event, Event.RESIZE, args);
		}
		
		public function mouseleave(...args):OrichalcumQuery
		{
			return _bindOrTrigger(Event, Event.MOUSE_LEAVE, args);
		}
		
		public function hover(...args):OrichalcumQuery
		{
			if (args.length == 0)
				return this;
			
			const onHoverIn:Function = args[0];
			const onHoverOut:Function = args.length == 1 ? onHoverIn : args[1];
			
			if (onHoverIn == null || onHoverOut == null)
				return this;
			
			for each(var child:DisplayObject in this)
			{
				var eventId:String = MouseEvent.MOUSE_OVER;
				var eventHandler:__EventHandler = new __EventHandler(eventId, eventId, child, onHoverIn, RETURN_TRUE);
				eventHandler.bind();
				getEventHandlersOfType(child, eventId).push(eventHandler);
				
				eventId = MouseEvent.MOUSE_OUT;
				eventHandler = new __EventHandler(eventId, eventId, child, onHoverOut, RETURN_TRUE);
				eventHandler.bind();
				getEventHandlersOfType(child, eventId).push(eventHandler);
			}
			return this;
		}
		
		public function ea(closure:Function):OrichalcumQuery
		{
			var displayObject:DisplayObject;
			if (closure == null) return this;
			if (closure.length == 0) for each(displayObject in this) closure.call(displayObject);
			if (closure.length == 1) for each(displayObject in this) closure.call(displayObject, displayObject);
			if (closure.length == 2) for (var i:int = 0; i < length; i++){ displayObject = this[i]; closure.call(displayObject, displayObject, i); }
			return this;
		}
		
		/**
		 * Remove an event handler.
		 * @param	events One or more space-separated event types and optional namespaces, such as "click" or "keydown.myPlugin". Or an object in which the string keys represent one or more space-separated event types and optional namespaces, and the values represent a handler function to be called for the event(s).
		 * @param	selector A display object name or class which should match the one originally passed to .on() when attaching event handlers.
		 * @param	handler A handler function previously attached for the event(s), or the special value false.
		 * @return
		 */
		public function off(events:Object = null, selector:* = null, handler:Function = null):OrichalcumQuery
		{
			if (events is String)
			{
				_off(events as String, selector, handler);
			}
			else if (events is Object)
			{
				for (var eventId:String in events)
					_off(eventId, selector, events[eventId]);
			}
			else if (events == null && selector  == null && handler == null)
			{
				for each(var child:DisplayObject in this)
					removeAllEventHandlers(child);
			}
			return this;
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////
		// Utility
		/////////////////////////////////////////////////////////////////////////////////////////////
		
		public function toArray():Array
		{
			return concat();
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////
		// Offset
		/////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Get the current coordinates of the first element in the set of matched elements, relative to the offset parent.
		 */
		public function position():Point
		{
			return length ? new Point(this[0].x, this[0].y) : new Point;
		}
		
		/**
		 * Get the current coordinates of the first element, or set the coordinates of every element, in the set of matched elements, relative to the document.
		 * @param args
		 * @return
		 */
		public function offset(...args):*
		{
			if (args.length == 0)
			{
				var child:DisplayObject = this[0];
				return length ? child.localToGlobal(new Point(child.x, child.y)) : new Point;
			}
			
			var arg0:* = args[0];
			if (arg0 is Point)
			{
				for each(child in this)
				{
					child.x = arg0.x;
					child.y = arg0.y;
				}
			}
			else if (arg0 is Function)
			{
				for (var i:int = 0; i < length; i++)
				{
					child = this[i];
					var position:Point = arg0.call(child, i, new Point(child.x, child.y));
					if (position == null) continue;
					child.x = position.x;
					child.y = position.y;
				}
			}
			return this;
		}
		
		///////////////////////////////////////////// INTERNAL PROXIES //////////////////////////////////////////
		///////////////////////////////////////////// INTERNAL PROXIES //////////////////////////////////////////
		///////////////////////////////////////////// INTERNAL PROXIES //////////////////////////////////////////
		///////////////////////////////////////////// INTERNAL PROXIES //////////////////////////////////////////
		///////////////////////////////////////////// INTERNAL PROXIES //////////////////////////////////////////
		///////////////////////////////////////////// INTERNAL PROXIES //////////////////////////////////////////
		///////////////////////////////////////////// INTERNAL PROXIES //////////////////////////////////////////
		///////////////////////////////////////////// INTERNAL PROXIES //////////////////////////////////////////
		
		private function _dimension(dimensionName:String, args:Array):*
		{
			if (args.length == 0)
				return length ? this[0][dimensionName] : 0;
			
			var arg0:* = args[0];
			if (arg0 is Number)
			{
				for each(child in this)
					child.width = arg0;
			}
			else if (arg0 is Function)
			{
				for (var i:int = 0; i < length; i++)
				{
					var child:DisplayObject = this[0];
					arg0.call(child, i, child[dimensionName]);
				}
			}
			return this;
		}
		
		private function _indexOf(matcher:Function):int
		{
			for each(var parent:DisplayObjectContainer in this)
				if (parent)
					for (var i:int = 0; i < parent.numChildren; i++)
						if (matcher(parent.getChildAt(i))) // only difference is matcher
							return i;
			return -1;
		}
		
		private function _has(matcher:Function):OrichalcumQuery
		{
			const has:OrichalcumQuery = new OrichalcumQuery;
			for each(var container:DisplayObjectContainer in this)
				container && _hasRecurse(container, matcher) && has.push(container);
			return has;
		}
		
		private function _hasRecurse(container:DisplayObjectContainer, matcher:Function):Boolean
		{
			const numChildren:int = container.numChildren;
			for (var i:int = 0; i < numChildren; i++)
			{
				var child:DisplayObject = container.getChildAt(i);
				
				if (matcher(child))
					return true;
					
				if (child is DisplayObjectContainer)
					arguments.callee(child as DisplayObjectContainer, matcher);
			}
			return false;
		}
		
		private function _nextAll(selector:Class):OrichalcumQuery 
		{
			const selections:OrichalcumQuery = new OrichalcumQuery;
			for each(var child:DisplayObject in this)
			{
				var parent:DisplayObjectContainer = child.parent;
				if (parent)
				{
					for (var i:int = parent.getChildIndex(child) + 1; i < parent.numChildren; i++)
					{
						var selection:DisplayObject = parent.getChildAt(i);
						selection is selector && selections.push(selection);
					}
				}
			}
			return selections;
		}
		
		private function _prevAll(selector:Class):OrichalcumQuery 
		{
			const selections:OrichalcumQuery = new OrichalcumQuery;
			for each(var child:DisplayObject in this)
			{
				var parent:DisplayObjectContainer = child.parent;
				if (parent)
				{
					for (var i:int = parent.getChildIndex(child) - 1; i >= 0; i--)
					{
						var selection:DisplayObject = parent.getChildAt(i);
						selection is selector && selections.unshift(selection);
					}
				}
			}
			return selections;
		}
		
		private function _nextUntil(filter:Class, matcher:Function):OrichalcumQuery
		{
			const selections:OrichalcumQuery = new OrichalcumQuery;
			for each(var child:DisplayObject in this)
			{
				var parent:DisplayObjectContainer = child.parent;
				if (parent)
				{
					for (var i:int = parent.getChildIndex(child) + 1; i < parent.numChildren; i++)
					{
						var selection:DisplayObject = parent.getChildAt(i);
						if (matcher(selection)) return selections;
						selection is filter && selections.push(selection);
					}
				}
			}
			return selections;
		}
		
		private function _prevUntil(filter:Class, matcher:Function):OrichalcumQuery
		{
			const selections:OrichalcumQuery = new OrichalcumQuery;
			for each(var child:DisplayObject in this)
			{
				var parent:DisplayObjectContainer = child.parent;
				if (parent)
				{
					for (var i:int = parent.getChildIndex(child) - 1; i >= 0; i--)
					{
						var selection:DisplayObject = parent.getChildAt(i);
						if (matcher(selection)) return selections;
						selection is filter && selections.unshift(selection);
					}
				}
			}
			return selections;
		}
		
		private function _find(matcher:Function):OrichalcumQuery
		{
			const found:OrichalcumQuery = new OrichalcumQuery;
			for each(var container:DisplayObjectContainer in this)
				container && _findRecurse(found, container, matcher);
			return found;
		}
		
		private function _findRecurse(accumulator:OrichalcumQuery, container:DisplayObjectContainer, matcher:Function):void 
		{
			const numChildren:int = container.numChildren;
			for (var i:int = 0; i < numChildren; i++)
			{
				var child:DisplayObject = container.getChildAt(i);
				matcher(child) && accumulator.push(child);
				child is DisplayObjectContainer && arguments.callee(accumulator, child as DisplayObjectContainer, matcher);
			}
		}
		
		private function _closest(matcher:Function):OrichalcumQuery 
		{
			for each(var child:DisplayObject in this)
			{
				var parent:DisplayObject = child.parent;
				for (; parent; parent = parent.parent)
					if (matcher(parent))
						return new OrichalcumQuery(parent);
			}
			return new OrichalcumQuery;
		}
		
		private function _children(matcher:Function):OrichalcumQuery 
		{
			const children:OrichalcumQuery = new OrichalcumQuery;
			for each(var parent:DisplayObjectContainer in this)
			{
				if (parent == null) continue;
				for (var i:int = 0; i < parent.numChildren; i++)
				{
					var child:DisplayObject = parent.getChildAt(i);
					if (matcher(child))
						children[children.length] = child;
				}
			}
			return children;
		}
		
		private function _parent(matcher:Function):OrichalcumQuery
		{
			const parents:OrichalcumQuery = new OrichalcumQuery;
			for each(var child:DisplayObject in this)
			{
				var parent:DisplayObjectContainer = child.parent;
				parent && matcher(parent) && parents.push(parent);
			}
			return parents;
		}
		
		private function _parents(matcher:Function):OrichalcumQuery
		{
			const parents:OrichalcumQuery = new OrichalcumQuery;
			for each(var child:DisplayObject in this)
			{
				var parent:DisplayObject = child.parent;
				for (; parent; parent = parent.parent)
					matcher(parent) && parents.push(parent);
			}
			return parents;
		}
		
		private function _parentsUntil(filter:Class, matcher:Function):OrichalcumQuery
		{
			const parents:OrichalcumQuery = new OrichalcumQuery;
			for each(var child:DisplayObject in this)
			{
				var parent:DisplayObject = child.parent;
				if (matcher(parent)) return parents;
				for (; parent; parent = parent.parent)
					parent is filter && parents.push(parent);
			}
			return parents;
		}
		
		private function _remove(selector:Class):OrichalcumQuery
		{
			for each(var child:DisplayObject in this)
			{
				if (child is selector)
				{
					var parent:DisplayObjectContainer = child.parent;
					if (parent) parent.removeChild(child);
					clearProfile(child);
				}
			}
			return this;
		}
		
		private function _detach(selector:Class):OrichalcumQuery
		{
			for each(var child:DisplayObject in this)
			{
				if (child is selector)
				{
					var parent:DisplayObjectContainer = child.parent;
					if (parent) parent.removeChild(child);
				}
			}
			return this;
		}
		
		
		public function _bindOrTrigger(eventType:Class, eventId:String, args:Array):OrichalcumQuery
		{
			return args.length > 0
				? _onEvent(eventId, null, args.length > 1 ? args[1] : null, args[0])
				: trigger(new eventType(eventId));
		}
		
		/**
		 * Attach an event handler function for one or more events to the selected elements.
		 * @param	events One or more space-separated event types and optional namespaces, such as "click" or "keydown.myPlugin". Or an object in which the string keys represent one or more space-separated event types and optional namespaces, and the values represent a handler function to be called for the event(s).
		 * @param	...args
		 * 				selector:*
		 * 				params:Array
		 * 				handler:Function
		 * 				triggerLimit:int = 0
		 */
		public function _on(events:Object, args:Array, triggerLimit:int = 0):OrichalcumQuery
		{
			var selector:*, params:Array, handler:Function;
			
			switch (args.length){
				case 1:
					handler = args[0];
					break;
				case 2:
					args[0] is Array ? (params = args[0]) : (selector = args[0]);
					handler = args[1];
					break;
				case 3:
					selector = args[0];
					params = args[1];
					handler = args[2];
					break;
				case 4:
					selector = args[0];
					params = args[1];
					handler = args[2];
					triggerLimit = args[3];
					break;
			}
			
			if (events is String && handler != null)
			{
				_onEvent(events as String, selector, params, handler, triggerLimit);
			}
			else if (events is Object)
			{
				for (var eventId:String in events)
				{
					handler = events[eventId];
					handler != null && _onEvent(eventId, selector, params, handler, triggerLimit);
				}
			}
			return this;
		}
		
		private function _onEvent(eventId:String, selector:* = null, params:Array = null, handler:Function = null, triggerLimit:int = 0):OrichalcumQuery
		{
			var eventType:String = eventTypeOfEventId(eventId);
			var matcher:Function = eventTargetMatcherOfSelector(selector);
			for each(var child:DisplayObject in this)
			{
				var eventHandlers:Array = getEventHandlersOfType(child, eventId);
				if (triggerLimit == 1)
				{
					var handlerIndex:int = eventHandlers.length;
					var originalHandler:Function = handler;
					handler = function(...args):* {
						eventHandlers.splice(handlerIndex, 1);
						eventHandler.unbind();
						originalHandler.apply(this, args);
					};
				}
				var eventHandler:__EventHandler = new __EventHandler(eventId, eventType, child, handler, matcher, selector, params);
				eventHandlers.push(eventHandler);
				eventHandler.bind();
			}
			return this;
		}
		
		private function _off(events:String, selector:* = null, handler:Function = null):void 
		{
			if (handler == null && selector is Function)
			{
				handler = selector;
				selector = null;
			}
			if (events.lastIndexOf(LIST_DELIMITER) < 0)
			{
				for each(var child:DisplayObject in this)
					removeEventHandler(child, events, selector, handler);
			}
			else
			{
				for each(var eventId:String in OrichalcumQuery.trim(events).split(LIST_DELIMITER))
					for each(child in this)
						removeEventHandler(child, eventId, selector, handler);
			}
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////
		// Effects
		/////////////////////////////////////////////////////////////////////////////////////////////
		
		public function show():OrichalcumQuery
		{
			return toggle(true);
		}
		
		public function hide():OrichalcumQuery
		{
			return toggle(false);
		}
		
		public function toggle(...args):OrichalcumQuery
		{
			for each(var child:DisplayObject in this)
				child.visible = args.length ? args[0] : !child.visible;
			return this;
		}
		
		// TODO
		
		//public function hide(...args):OrichalcumQuery
		//{
			//switch(args.length) {
				//case 2: return _hide(args[0], args[1]);
				//case 1: return _hide(args.duration, args);
			//}
			//return _hide();
		//}
		//
		//private function _hide(duration:Number = 0, options:Object):OrichalcumQuery 
		//{
			//if (duration <= 0)
			//{
				//for each(var child:DisplayObject in this)
					//child.visible = false;
			//}
			//else
			//{
				// enable autoalpha plugin
				// TweenMax.allTo(this, duration, options);
			//}
			//return this;
		//}
		
	}

}