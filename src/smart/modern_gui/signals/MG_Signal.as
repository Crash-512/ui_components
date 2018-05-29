package smart.modern_gui.signals
{
	import flash.utils.Dictionary;
	
	import smart.modern_gui.base.MG_Component;
	
	public class MG_Signal
	{
		private var listeners:MG_ListenerList;
		private var dictionary:Dictionary;
		
		  
		public function MG_Signal()
		{
			super();
			init();
		}
		
		private function init():void
		{
			listeners = new MG_ListenerList();
			dictionary = new Dictionary(true);
		}
		
		public function dispose():void 
		{
			clear();
			pool.push(this);
		}
		
		public function clear():void 
		{
			listeners.removeAll();
			
			for (var callback:Function in dictionary)
			{
				delete dictionary[callback];
			}
		}
		
		[Inline] final public function has(callback:Function):Boolean 
		{
			return (dictionary[callback] != null);
		}
		
		public function add(callback:Function, once:Boolean = false):void 
		{
			if (callback && !has(callback))
			{
				var listener:MG_Listener = MG_Listener.create(callback, once);
				listeners.add(listener);
				
				dictionary[callback] = listener;
			}
		}
		
		public function addOnce(callback:Function):void
		{
			if (callback && !has(callback))
			{
				var listener:MG_Listener = MG_Listener.create(callback, true);
				listeners.add(listener);
				
				dictionary[callback] = listener;
			}
		}
		
		public function remove(callback:Function):void
		{
			if (callback && has(callback))
			{
				var listener:MG_Listener = dictionary[callback];
				listeners.remove(listener);
				listener.dispose();
				
				delete dictionary[callback];
			}
		}
		
		public function dispatch(...args):void 
		{
			var pointer:MG_Listener = listeners.firstItem;
			var item:MG_Listener;
			
			while (pointer)
			{
				item = pointer;
				pointer = pointer.next;
				
				var len:int = item.callback.length;
				args = args.slice(0, len);
				item.callback.apply(null, args);
				
				if (item.once) remove(item.callback);
			}
		}
		
		
		// *** STATIC *** //
		
		
		
		private static var pool:Vector.<MG_Signal> = new <MG_Signal>[];
		
		
		public static function create():MG_Signal
		{
			return (pool.length != 0) ? pool.pop() : new MG_Signal(); 
		}
		
	}
}
