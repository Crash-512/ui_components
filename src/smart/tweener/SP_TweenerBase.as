package smart.tweener
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	internal class SP_TweenerBase extends EventDispatcher
	{
		internal var paused:Boolean;
		
		protected var _fastMode:Boolean;
		protected var removeAfterCall:Boolean;
		protected var completeCallback:Function;
		protected var dictonary:Dictionary;
		protected var objectList:SP_TweenObject;

		private static const NULL_OBJECT:Object = {};

		  
		public function SP_TweenerBase()
		{
			super();
			constructor();
		}
		
		internal function constructor():void
		{
			dictonary = new Dictionary(true);
			paused = false;
		}
		
		public function destroy():void
		{
			this.clear();
			completeCallback = null;
			removeAfterCall = false;
			dictonary = null;
		}
		
		public function addCompleteCallback(callback:Function, removeAfterCall:Boolean = true):void
		{
			this.removeAfterCall = removeAfterCall;
			completeCallback = callback;
		}
		
		[Inline] protected final function applyCompleteCallback():void
		{
			var callback:Function = completeCallback;
			if (removeAfterCall) completeCallback = null;
			callback.apply();
			callback = null;
		}
		
		public function update(event:Event = null):void
		{
			var object:SP_TweenObject = objectList;
			var tween:SP_Tween;
			
			// Прогоняем двусвязный список твин-объектов
			while (object)
			{
				if (!object.paused)
				{
					// Прогоняем двусвязный список твинов
					tween = object.tweenList;

					while (tween)
					{
						if (!tween.paused)
						{
							if (tween.delay == 0)
							{
								if (tween.reverseMode)
								{
									if (tween.frame > 0) tween.frame--;
								}
								else
								{
									if (tween.frame < tween.time) tween.frame++;
								}
								tween.update();
							}
							else
							{
								tween.delay--;
								if (tween.delay == 0) tween.recalc = true;
							}
						}
						tween = tween.next;
					}
				}
				// Удаление твин-объекта, если все твины выполнены
				if (object.removable)
				{
					var objectForRemove:SP_TweenObject = object;
					object = object.next;
					removeTweenObject(objectForRemove);
				}
				else object = object.next;
			}
			if (_fastMode && event) update();
		}
		
		[Inline] final private function getObjectBySource(source:Object):SP_TweenObject
		{
			var object:SP_TweenObject;

			if (!dictonary[source])
			{
				object = new SP_TweenObject(source);
				dictonary[source] = object;
				addTweenObject(object);
			}
			else object = dictonary[source];

			return object;
		}
		
		public function getTween(source:Object, tweenOptions:Object, timeOptions:Object, mode:int = 1):SP_Tween
		{
			var object:SP_TweenObject = getObjectBySource(source);
			var tween:SP_Tween = new SP_Tween(object, tweenOptions, timeOptions, mode);
			return tween;
		}
		
		public function addTween(source:Object, tweenOptions:Object, timeOptions:Object, mode:int = 1):SP_Tween
		{
			var object:SP_TweenObject;

			if (dictonary[source])
			{
				object = dictonary[source];

				if (timeOptions.delay <= 0)
				{
					// Если нет дилэя, удаляем совпадения в твинах
					object.removeMatchOptions(object, tweenOptions);
					// TODO сделать флаг "replace"
				}
			}
			var tween:SP_Tween = getTween(source, tweenOptions, timeOptions, mode);
			
			object = getObjectBySource(source);
			object.add(tween);	// Добавляем твин к твин-объекту

			return tween;	// Возвращаем созданный твин
		}
		
		[Inline] final private function addTweenObject(object:SP_TweenObject):void
		{
			// Добавляем твин-объект в двусвязный список
			if (objectList)
			{
				object.next = objectList;
				objectList.prev = object;
			}
			objectList = object;
		}
		
		protected function removeTweenObject(object:SP_TweenObject):void
		{
			// Удаляем объект из двусвязного списка
			if (object.prev) object.prev.next = object.next;
			if (object.next) object.next.prev = object.prev;
			if (object == objectList) objectList = object.next;

			// Уничтожаем объект
			object.destroy();
			if (dictonary) delete dictonary[object.source];
			object = null;
		}
		
		public function clear():void
		{
			var tweenObject:SP_TweenObject = objectList;
			// Удаляем все твин-объекты
			while (tweenObject)
			{
				tweenObject.removeAll();
				if (!tweenObject.tweenList) removeTweenObject(tweenObject);
				tweenObject = tweenObject.next;
			}
			objectList = null
		}
		
		public function addEnterFrame(time:Number, updateFunction:Function, functionVars:Array = null):SP_Tween
		{
			var enterFrameTween:SP_Tween = addTween({}, {}, {time:time, onUpdate:updateFunction, onUpdateVars:functionVars});
			return enterFrameTween;
		}
		
		public function addTimeout(time:Number, completeFunction:Function, functionVars:Array = null):SP_Tween
		{
			var timeoutTween:SP_Tween = addTween({}, {}, {time:time, onComplete:completeFunction, onCompleteVars:functionVars});
			return timeoutTween;
		}
		
		public function addTimeoutFrom(source:Object, time:Number, completeFunction:Function, functionVars:Array = null):SP_Tween
		{
			var timeoutTween:SP_Tween = addTween(source, {}, {time:time, onComplete:completeFunction, onCompleteVars:functionVars});
			return timeoutTween;
		}
		
		public function remove(source:Object, tweenOptions:Object = null):void
		{
			if (dictonary[source] != undefined)
			{
				var object:SP_TweenObject = dictonary[source];
				
				if (tweenOptions) object.removeMatchOptions(object, tweenOptions);
				else              object.removeAll();
				
				if (!object.tweenList) removeTweenObject(object);
			}
		}
		
		public function pause(source:Object):void
		{
			if (dictonary[source])
			{
				var object:SP_TweenObject = dictonary[source];
				object.paused = true;
			}
		}
		
		public function play(source:Object, playAllTweens:Boolean = false):void
		{
			if (dictonary[source])
			{
				var object:SP_TweenObject = dictonary[source];
				object.paused = false;

				if (playAllTweens)
				{
					// Прогоняем двусвязный список твинов
					var tween:SP_Tween = object.tweenList;

					while (tween)
					{
						tween.paused = false;
						tween = tween.next;
					}
				}
			}
		}
		
		public function pauseAll():void
		{
			var object:SP_TweenObject = objectList;

			while (object)
			{
				object.paused = true;
				object = object.next;
			}
		}
		
		public function playAll():void
		{
			var object:SP_TweenObject = objectList;

			while (object)
			{
				object.paused = false;
				object = object.next;
			}
		}
		
		public function rewind(source:Object):void
		{
			if (dictonary[source])
			{
				var object:SP_TweenObject = dictonary[source];

				// Прогоняем двусвязный список твинов
				var tween:SP_Tween = object.tweenList;

				while (tween)
				{
					tween.frame = 0;
					tween = tween.next;
				}
			}
		}
		
		public function getTweenObject(source:Object):SP_TweenObject
		{
			if (dictonary[source]) return dictonary[source];
			return null;
		}
		
		public function get fastMode():Boolean
		{
			return _fastMode;
		}
		
		public function set fastMode(value:Boolean):void
		{
			_fastMode = value;
		}
		
		public function get isEmpty():Boolean 
		{
			return !objectList;
		}
		
	}
}
