package smart.tweener
{
	import flash.display.Shape;
	import flash.events.Event;
	
	public class SP_Tweener extends SP_TweenerBase
	{
		private var enabled:Boolean = false;
		private var autoUpdate:Boolean;
		private var controller:Shape  = new Shape();

		private static var tweener:SP_Tweener = new SP_Tweener(true);

		public function SP_Tweener(autoUpdate:Boolean = false)
		{
			paused = true;
			this.autoUpdate = autoUpdate;
		}
		
		override public function destroy():void
		{
			controller = null;
			this.stopTweener();
			super.destroy();
		}
		
		override public function update(event:Event = null):void
		{
			super.update(event);
		}
		
		override public function addTween(source:Object, tweenOptions:Object, timeOptions:Object, mode:int = 1):SP_Tween
		{
			var tween:SP_Tween = super.addTween(source, tweenOptions, timeOptions, mode);
			if (autoUpdate && !enabled) startController();  // Запускаем контроллер, если он не запущен
			return tween;	// Возвращаем созданный твин
		}
		
		override protected function removeTweenObject(object:SP_TweenObject):void
		{
			super.removeTweenObject(object);

			// Отключение контроллера, если нет текущих твин-объектов
			if (!objectList)
			{
				if (completeCallback != null) applyCompleteCallback();
				enabled = false;
				stopTweener();
			}
		}
		
		private function startController():void
		{
			startTweener();
			enabled = true;
		}
		
		public function stopTweener():void
		{
			if (autoUpdate)
			{
				controller.removeEventListener(Event.ENTER_FRAME, update);
				paused = true;
			}
		}
		
		public function startTweener():void
		{
			if (autoUpdate && paused)
			{
				controller.addEventListener(Event.ENTER_FRAME, update, false, 10);
				paused = false;
			}
		}
		
		override public function get isEmpty():Boolean
		{
			return (!objectList);
		}

		// *** STATIC *** //
		
		public static function addTween(source:Object, tweenOptions:Object, timeOptions:Object, mode:int = 1):SP_Tween
		{
			return tweener.addTween(source, tweenOptions, timeOptions, mode);
		}
		
		public static function remove(source:Object):void
		{
			tweener.remove(source);
		}
		
		public static function removeAll():void
		{
			tweener.clear();
		}
		
		public static function stopTweener():void
		{
			tweener.stopTweener();
		}
		
		public static function startTweener():void
		{
			tweener.startTweener();
		}
	}
}