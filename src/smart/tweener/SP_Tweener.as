/*
 * Класс SP_Tweener - основной класс для управления всеми твинами.
 * Класс имеет методы создания, удаления, паузы и перемотки твинов.
 * При добавлении нового твина за объектом, над которым будут проводиться
 * преобразования, закрепляется экземпляр класса TweenObject, в котором,
 * в свою очередь, будут храниться экземпляры класса Tween, хранящие
 * списки преобразований.
 */
package smart.tweener
{
	import flash.display.Shape;
	import flash.events.Event;
	
	public class SP_Tweener extends SP_TweenerBase
	{
		private var enabled:Boolean = false;
		private var autoUpdate:Boolean;
		private var poolList:SP_TweenPool;
		private var controller:Shape  = new Shape();

		private static var tweener:SP_Tweener = new SP_Tweener(true);

		public static const BASIC:int = 1;
		public static const COLOR:int = 2;
		public static const SOUND:int = 3;
		
		
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
			// Прогоняем двусвязный список твин-пулов
			var pool:SP_TweenPool = poolList;
			
			while (pool)
			{
				if (!pool.paused) pool.update(event);
				pool = pool.next;
			}
			super.update(event);
		}
		
		public function addPool(pool:SP_TweenPool):void
		{
			if (pool._tweener != null) pool._tweener.removePool(pool);
			
			// Добавляем пул в двусвязный список
			if (poolList)
			{
				pool.next = poolList;
				poolList.prev = pool;
			}
			poolList = pool;
			pool._tweener = this;
	
			if (autoUpdate && !enabled) startController();
		}
		
		public function removePool(pool:SP_TweenPool, dispose:Boolean = false):void
		{
			if (pool._tweener != this) return;
			// Удаляем пул из двусвязного списка
			if (pool.prev) pool.prev.next = pool.next;
			if (pool.next) pool.next.prev = pool.prev;
			if (pool == poolList) poolList = pool.next;
			
			pool._tweener = null;
			pool.next = null;
			pool.prev = null;

			if (dispose) pool.destroy();
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
			if (!objectList && !poolList)
			{
				if (completeCallback != null) applyCompleteCallback();
				dispatchEvent(new SP_TweenerEvent(SP_TweenerEvent.ALL_TWEENS_FINISHED));
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
			return (!objectList && !poolList);
		}
		

		// *** STATIC *** //
		
		
		public static function addTween(source:Object, tweenOptions:Object, timeOptions:Object, mode:int = 1):SP_Tween
		{
			return tweener.addTween(source, tweenOptions, timeOptions, mode);
		}
		
		public static function getTween(source:Object, tweenOptions:Object, timeOptions:Object, mode:int = 1):SP_Tween
		{
			return tweener.getTween(source, tweenOptions, timeOptions, mode);
		}
		
		public static function addEnterFrame(time:Number, updateFunction:Function, functionVars:Array = null):SP_Tween
		{
			return tweener.addEnterFrame(time, updateFunction, functionVars);
		}
		
		public static function addTimeout(time:Number, completeFunction:Function, functionVars:Array = null):SP_Tween
		{
			return tweener.addTimeout(time, completeFunction, functionVars);
		}
		
		public static function addTimeoutFrom(source:Object, time:Number, completeFunction:Function, functionVars:Array = null):SP_Tween
		{
			return tweener.addTimeoutFrom(source, time, completeFunction, functionVars);
		}
		
		public static function remove(source:Object):void
		{
			tweener.remove(source);
		}
		
		public static function pause(source:Object):void
		{
			tweener.pause(source);
		}
		
		public static function play(source:Object, playAllTweens:Boolean = false):void
		{
			tweener.play(source, playAllTweens);
		}
		
		public static function pauseAll():void
		{
			tweener.pauseAll();
		}
		
		public static function playAll():void
		{
			tweener.playAll();
		}
		
		public static function rewind(source:Object):void
		{
			tweener.rewind(source);
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
		
		public static function getTweenObject(source:Object):SP_TweenObject
		{
			return tweener.getTweenObject(source);
		}
		
		public static function get fastMode():Boolean
		{
			return tweener.fastMode;
		}
		
		public static function set fastMode(value:Boolean):void
		{
			tweener.fastMode = value;
		}
		
	}
}