package smart.modern_gui.signals
{
	internal class MG_Listener
	{
		public var callback:Function;
		public var once:Boolean;
		
		public var next:MG_Listener;
		public var prev:MG_Listener;
		
		  
		public function MG_Listener()
		{
			super();
		}
		
		public function constructor(callback:Function, once:Boolean = false):void 
		{
			this.callback = callback;
			this.once = once;
		}
		
		public function dispose():void
		{
			callback = null;
			once = false;
			next = null;
			prev = null;
			pool.push(this);
		}
		
		
		// *** STATIC *** //
		
		private static const pool:Vector.<MG_Listener> = new <MG_Listener>[];
		
		
		public static function create(callback:Function, once:Boolean = false):MG_Listener
		{
			var instance:MG_Listener = (pool.length != 0) ? pool.pop() : new MG_Listener();
			instance.constructor(callback, once);
			return instance;
		}
		
	}
}
