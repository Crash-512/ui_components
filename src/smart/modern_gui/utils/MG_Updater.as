package smart.modern_gui.utils
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import smart.modern_gui.MG_IUpdatable;
	
	public class MG_Updater
	{
		private static var _callbacks:CallbackList;
		
		private static var counter:int = 0;
		private static var updater:Sprite = new Sprite();
		private static var objects:Dictionary = new Dictionary();
		
		  
		public static function add(object:MG_IUpdatable):void
		{
			if (objects[object] == null)
			{
				objects[object] = true;
				counter++;
			}
			if (!updater.hasEventListener(Event.ENTER_FRAME))
			{
				updater.addEventListener(Event.ENTER_FRAME, update);
			}
		}
		  
		public static function remove(object:MG_IUpdatable):void
		{
			if (objects[object] != null) 
			{
				counter--;
				delete objects[object];
			}
		}
		
		private static function update(event:Event):void
		{
			if (counter != 0)
			{
				for (var object:MG_IUpdatable in objects)
				{
					object.update();
				}
			}
			
			if (_callbacks)
			{
				var callback:Callback = _callbacks.firstItem;
				var nextCallback:Callback;
				
				while (callback)
				{
					nextCallback = callback.next;
					
					if (callback.delay > 0)
					{
						callback.delay--;
					}
					else if (callback.delay == 0)
					{
						callback.apply();
						_callbacks.remove(callback);
					}
					callback = nextCallback;
				}
			}
		}
		
		public static function delayedCall(callback:Function, delay:uint = 1, ...args):void 
		{
			if (!_callbacks) _callbacks = new CallbackList();
			
			_callbacks.add(Callback.create(callback, delay, args));
		}
		
	}
}

class Callback
{
	public var callback:Function;
	public var delay:uint;
	public var args:Array;
	
	public var next:Callback;
	public var prev:Callback;
	
	
	public function constructor(callback:Function, delay:uint, args:Array):void 
	{
		this.callback = callback;
		this.delay = delay;
		this.args = args;
	}
	
	public function apply():void 
	{
		(args.length > 0) ? callback.apply(this, args) : callback();
		dispose();
	}
	
	public function dispose():void 
	{
		callback = null;
		args = null;
		pool.push(this);
	}
	
	
	// *** STATIC *** //
	
	private static var pool:Vector.<Callback> = new <Callback>[];
	
	
	public static function create(callback:Function, delay:uint, ...rest):Callback
	{
		var instance:Callback = pool.length > 0 ? pool.pop() : new Callback();
		instance.constructor(callback, delay, rest[0]);
		return instance;
	}
	
}

class CallbackList
{
	public var firstItem:Callback;
	
	
	public function CallbackList() 
	{
		
	}
	  
	public function add(item:Callback):void 
	{
		if (firstItem)
		{
			firstItem.prev = item;
			item.next = firstItem;
		}
		firstItem = item;
	}
	
	public function remove(item:Callback):void 
	{
		if (item == firstItem) firstItem = firstItem.next;
		
		if (item.prev) item.prev.next = item.next;
		if (item.next) item.next.prev = item.prev;
		
		item.next = null;
		item.prev = null;
	}
	
	public function removeAll():void
	{
		var item:Callback;
		
		while (firstItem)
		{
			item = firstItem;
			firstItem = item.next;
			item.dispose();
		}
		firstItem = null;
	}
	
}