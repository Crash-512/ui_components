package smart.gui.signals
{
	import flash.utils.Dictionary;
	
	public class SG_Signal
	{
		private var listeners:SG_ListenerList;
		private var dictionary:Dictionary;
		
		  
		public function SG_Signal()
		{
			super();
			init();
		}
		
		private function init():void
		{
			listeners = new SG_ListenerList();
			dictionary = new Dictionary(true);
		}
		
		public function clear():void 
		{
			listeners.removeAll();
			dictionary = new Dictionary(true);
		}
		
		public function dispose():void 
		{
			listeners.removeAll();
			dictionary = new Dictionary();
			pool.push(this);
		}
		
		[Inline] final public function has(callback:Function):Boolean 
		{
			return (dictionary[callback] != null);
		}
		
		public function add(callback:Function, once:Boolean = false):void 
		{
			if (!has(callback))
			{
				var listener:SG_Listener = SG_Listener.create(callback, once);
				listeners.add(listener);
				
				dictionary[callback] = listener;
			}
		}
		
		public function addOnce(callback:Function):void
		{
			if (!has(callback))
			{
				var listener:SG_Listener = SG_Listener.create(callback, true);
				listeners.add(listener);
				
				dictionary[callback] = listener;
			}
		}
		
		public function remove(callback:Function):void
		{
			if (has(callback))
			{
				var listener:SG_Listener = dictionary[callback];
				listeners.remove(listener);
				listener.dispose();
				
				delete dictionary[callback];
			}
		}
		
		public function emit(...args):void
		{
			var pointer:SG_Listener = listeners.firstItem;
			var item:SG_Listener;
			
			while (pointer)
			{
				item = pointer;
				pointer = pointer.next;
				
				var len:int = item.callback.length;
				item.callback.apply(null, args.slice(0, len));
				
				if (item.once) remove(item.callback);
			}
		}
		
		[Inline] final public function dispatchArgs(args:Object):void 
		{
			var pointer:SG_Listener = listeners.firstItem;
			var item:SG_Listener;
			
			while (pointer)
			{
				item = pointer;
				pointer = pointer.next;
				item.callback(args);
				if (item.once) remove(item.callback);
			}
		}
		
		[Inline] final public function dispatchWithString(string:String):void
		{
			var pointer:SG_Listener = listeners.firstItem;
			var item:SG_Listener;
			
			while (pointer)
			{
				item = pointer;
				pointer = pointer.next;
				item.callback(string);
				if (item.once) remove(item.callback);
			}
		}
		
		
		// *** STATIC *** //
		
		
		
		private static var pool:Vector.<SG_Signal> = new <SG_Signal>[];
		
		
		public static function create():SG_Signal
		{
			return (pool.length != 0) ? pool.pop() : new SG_Signal(); 
		}
		
	}
}
