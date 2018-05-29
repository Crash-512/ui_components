package smart.tweener
{
	import flash.events.Event;
	
	public class SP_TweenPool extends SP_TweenerBase
	{
		internal var _tweener:SP_Tweener;
		internal var finished:Boolean;
		internal var next:SP_TweenPool;
		internal var prev:SP_TweenPool;

		  
		public function SP_TweenPool()
		{
			super();
		}
		
		override public function destroy():void 
		{
			if (_tweener)
			{
				_tweener.removePool(this);
				_tweener = null;
			}
			paused = true;
			next = null;
			prev = null;
			super.destroy();
			pool.push(this);
		}
		
		override public function addTween(source:Object, tweenOptions:Object, timeOptions:Object, mode:int = 1):SP_Tween
		{
			var tween:SP_Tween = super.addTween(source, tweenOptions, timeOptions, mode);
			paused = false;
			return tween;
		}
		
		override public function update(event:Event = null):void
		{
			super.update(event);
			
			if (!objectList) 
			{
				if (completeCallback != null) applyCompleteCallback();
				dispatchEvent(new SP_TweenerEvent(SP_TweenerEvent.ALL_TWEENS_FINISHED));
				paused = true;
			}
		}
		
		
		// *** PROPERTIES *** //
		
		
		public function get hasTweener():Boolean 
		{
			return _tweener != null;
		}
		
		[Inline] public function get tweener():SP_Tweener
		{
			return _tweener;
		}
		
		
		// *** STATIC *** //

		internal static var pool:Vector.<SP_TweenPool> = new Vector.<SP_TweenPool>();

		
		[Inline] public static function create():SP_TweenPool
		{
			var tweenPool:SP_TweenPool;

			if (pool.length != 0)
			{
				tweenPool = pool.pop();
				tweenPool.constructor();
			}
			else tweenPool = new SP_TweenPool(); 
			
			return tweenPool;
		}
		
	}
}
