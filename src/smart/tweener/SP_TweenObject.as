/* 
 * Класс TweenObject хранит в себе ссылку на объект, над которым выполняются
 * преобразования, и список всех преобразований, хранящихся в экземплярах
 * класса Tween. Один TweenObject может содержать в себе несколько Tween'ов с
 * разными параметрами. Например: один твин для масштабирования (width, height),
 * другой - для изменения координат (x, y). Экземпляры класса Tween, находящиеся
 * в TweenObject, могут работать независимодруг отдруга. Их можно создавать,
 * удалять или ставить на паузу. Экземпляры этого класса связаны двумерным списком.
 */
package smart.tweener 
{
	public class SP_TweenObject 
	{
		public var removable:Boolean;
		public var paused:Boolean;
		public var source:Object;
		public var tweenList:SP_Tween;
		public var next:SP_TweenObject;
		public var prev:SP_TweenObject;
		
		
		public function SP_TweenObject(source:Object) 
		{
			this.source = source;
		}
		
		internal function removeMatchOptions(object:SP_TweenObject, tweenOptions:Object):void
		{
			var tween:SP_Tween = object.tweenList;
			var newOptions:Vector.<String> = new Vector.<String>();
			var parameter:String;
			var tweensForRemove:Array = [];
			var paramsForRemove:Array;
			var match:Boolean;
			var counter:int;

			// Создаём список новых параметров
			for (parameter in tweenOptions) newOptions.push(parameter);
			//trace(SE_FrameCounter.timeStamp, "removeMatchOptions()", object.source, tween);
			// Проверяем твины объекта на совпадение параметров
			while (tween)
			{
				match = false;
				counter = 0;
				paramsForRemove = [];
				//trace("tween:", tween);
				// Перебираются параметры твина
				for (parameter in tween.tweenOptions)
				{
					match = false;

					for (var i:int = 0; i < newOptions.length; i++)
					{
						if (parameter == newOptions[i])
						{
							// Совпадения параметра найдено, заносится в массив для удаления
							match = true;
							paramsForRemove.push(parameter);
							break;
						}
					}
					if (!match) counter++;
				}
				if (counter != 0) // Количество параметров без совпадений
				{
					// Удаляем из твина совпавшие параметры
					for (var j:int = 0; j < paramsForRemove.length; j++)
					{
						parameter = paramsForRemove[j];
						tween.removeParameter(parameter);
					}
				}
				else if (paramsForRemove.length != 0) 
				{
					// Если в твине не осталось параметров, заносим в массив для удаления
					tweensForRemove.push(tween);
				}

				tween = tween.next;
			}
			// Удаляем твины без параметров
			for (var k:int = 0; k < tweensForRemove.length; k++)
			{
				tween = tweensForRemove[k];
				remove(tween);
			}
		}
		
		public function add(tween:SP_Tween):void
		{
			// Добавляем новый твин в двусвязный список
			if (tweenList)
			{
				tween.next = tweenList;
				tweenList.prev = tween;
			}
			tweenList = tween;
			removable = false;
		}
		
		public function remove(tween:SP_Tween):void
		{
			// Удаляем твин из двусвязного списка
			if (tween.prev) tween.prev.next = tween.next;
			if (tween.next) tween.next.prev = tween.prev;
			if (tween == tweenList) tweenList = tween.next;
			
			// Устанавливаем флаг на удаление
			if (!tweenList) removable = true;
		}
		
		public function removeAll():void
		{
			var tween:SP_Tween = tweenList;
			var removedTween:SP_Tween;
			
			while (tween)
			{
				removedTween = tween;
				tween = tween.next;
				if (!removedTween.priority) remove(removedTween);
			}
		}
		
		public function destroy():void
		{
			var tween:SP_Tween;
			
			// Прогоняем двусвязный список
			while (tweenList)
			{
				// Уничтожаем все твины объекта
				tween = tweenList;
				tweenList = tweenList.next;
				tween.destroy();
			}
		}
		
	}
}