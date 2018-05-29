package smart.gui.signals
{
	internal class SG_Listener
	{
		public var callback:Function;
		public var once:Boolean;
		
		public var next:SG_Listener;
		public var prev:SG_Listener;
		
		  
		public function SG_Listener()
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
		
		private static const pool:Vector.<SG_Listener> = new <SG_Listener>[];
		
		
		public static function create(callback:Function, once:Boolean = false):SG_Listener
		{
			var instance:SG_Listener = (pool.length != 0) ? pool.pop() : new SG_Listener();
			instance.constructor(callback, once);
			return instance;
		}
		
	}
}
