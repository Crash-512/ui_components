/*
 * Класс Tween содержит в себе опции преобразования объекта,
 * а также текущий кадр преобразования, и ссылку на TweenObject.
 * Все экземпляры Tween связаны двусвязным списком внутри
 * родительского TweenObject.
 */
package smart.tweener 
{
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	public class SP_Tween 
	{
		// Настройки твина
		public var recalc:Boolean;
		public var ease:Function;
		public var reverseMode:Boolean;
		public var rounded:Boolean;
		public var paused:Boolean;
		public var repeat:Boolean;
		public var reverse:Boolean;
		public var repeatReverse:Boolean;
		public var invisible:Boolean;
		public var showAtStart:Boolean;
		public var removeChild:Boolean;
		public var priority:Boolean;
		
		// Callbacks
		public var onComplete:Function;
		public var onUpdate:Function;
		public var onBegin:Function;
		public var onReverse:Function;
		public var onReverseComplete:Function;
		public var onCompleteVars:Array;
		public var onUpdateVars:Array;
		public var onBeginVars:Array;
		public var onReverseVars:Array;
		public var onReverseCompleteVars:Array;
		
		// Списки опций
		public var mode:int;
		public var initList:SP_TweenOptions;
		public var endList:SP_TweenOptions;
		
		// Настройки времени
		public var delay:int = 0;
		public var frame:int;
		public var time:Number;
		
		// Родительский объект
		public var object:SP_TweenObject;
		public var tweenOptions:Object;
		
		// Указатели
		public var next:SP_Tween;
		public var prev:SP_Tween;
		
		
		public function SP_Tween(object:SP_TweenObject, tweenOptions:Object, timeOptions:Object, mode:int)
		{
			this.mode = mode;
			this.object = object;
			this.tweenOptions = tweenOptions;
			
			time = 2;
			ease = SP_Easing.linear;
			frame = 0;
			
			onCompleteVars = [];
			onUpdateVars = [];
			
			// Настройки времени
			for (var name:String in timeOptions)
			{
				if (name in this) this[name] = timeOptions[name];
			}
			if (delay == 0) recalcOptions();
			else			calcPreInitOptions();
		}
		
		public function destroy():void
		{
			ease = null;

			if (initList)
			{
				initList.list = null;
				initList = null;
			}
			if (endList)
			{
				endList.list = null;
				endList = null;
			}
			onComplete = null;
			onUpdate = null;
			onCompleteVars = null;
			onUpdateVars = null;

			if (object)
			{
				object.remove(this);
				object = null;
			}
		}
		
		internal function removeParameter(parameter:String):void 
		{
			if (parameter in tweenOptions) delete tweenOptions[parameter];

			if (endList)
			{
				var list:Array = endList.list;
				
				for (var i:int = 0; i < list.length; i++)
				{
					var name:String = list[i];
					
					if (name == parameter)
					{
						endList.list = list.splice(i+1);
						break;
					}
				}
			}
		}
		
		private function calcPreInitOptions():void 
		{
			var source:Object = object.source;
			var initName:String;
			
			for (var name:String in tweenOptions)
			{
				try
				{			
					if (name.substring(0,5) == "init_") 
					{
						initName = name.substring(5, name.length);
						source[initName] = tweenOptions[name];
						delete tweenOptions[name];
					}
				}
				catch(error:*) 
				{
					throw("Error: Переменная " + name + " не найдена в объекте " + source);
				}
			}
		}
		
		private function recalcOptions():void
		{
			var source:Object = object.source;
			
			// Создаём списки опций
			initList = new SP_TweenOptions();
			endList = new SP_TweenOptions();
			
			endList.parseEndOptions(tweenOptions, source);
			initList.parseInitOptions(endList.list, source);
		}
		
		[Inline] final public function nextFrame():void
		{
			if (reverseMode)
			{
				if (frame > 0)
				{
					frame--;
					update();
				}
			}
			else
			{
				if (frame < time)
				{
					frame++;
					update();
				}
			}
		}
		
		[Inline] final public function prevFrame():void
		{
			if (reverseMode)
			{
				if (frame < time)
				{
					frame++;
					update();
				}
			}
			else
			{
				if (frame > 0)
				{
					frame--;
					update();
				}
			}
		}
		
		public function delayTick():void
		{
			if (delay > 0)
			{
				delay--;
				if (delay == 0) paused = false;
			}
		}
		
		[Inline] final internal function update():void 
		{
			var value:Number;
			var sprite:DisplayObject;
			var params:Array;
			var source:Object = object.source;
			
			if (showAtStart && (frame == 1 || recalc))
			{
				if (source is DisplayObject)
				{
					sprite = source as DisplayObject;
					sprite.visible = true;
				}
				else source.visible = true;
			}
			
			// Пересчитать начальные параметры
			if (recalc)
			{
				recalcOptions();
				recalc = false;
				if (onBegin != null) onBegin.apply(null, onBeginVars);
			}
			
			// Преобразования из твина
			if (endList)
			for each (var name:String in endList.list)
			{
				// Список параметров для Ease-функции
				params = 
				[
					frame,			// Текущий кадр
					initList[name],	// Начальное значение
					endList[name],	// Конечное значение
					time			// Время преобразования
				];
				// Получение значения
				value = ease.apply(null, params);
				// Округление
				if (rounded) value = Math.round(value);
				
				// Применение значения
				if (!(source[name] is Boolean) || frame >= time) source[name] = value;
			}
			
			// onUpdate
			if (onUpdate != null) onUpdate.apply(null, onUpdateVars);
			
			// Окончание твина
			if (frame >= time)
			{
				// Реверс твина
				if (reverse)
				{
					if (onReverse != null) onReverse.apply(null, onReverseVars);
					reverseMode = !reverseMode;
				}
				// Повторение твина
				else if (repeat)
				{
					frame = 0;
				}
				else if (!paused) stopTween();
				// onComplete
				if (onComplete != null && frame != 0) onComplete.apply(null, onCompleteVars);
			}
			else if (frame == 0)
			{
				if (repeat)
				{
					// Повторить реверс
					reverseMode = false;
				}
				else if (reverse && reverseMode) 
				{
					//reverseMode = false;
					if (onReverseComplete != null) onReverseComplete.apply(null, onReverseCompleteVars);
					if (!paused) stopTween();
				}
			}
		}
		
		private function stopTween():void
		{
			var source:Object = object.source;
			var sprite:DisplayObject;
			
			// Сделать объект невидимым
			if (invisible)
			{
				if (source is DisplayObject)
				{
					sprite = source as DisplayObject;
					sprite.visible = false;
				}
				else source.visible = false;
			}
			// Удалить объект со сцены
			/*if (removeChild) 
			{
				if (source is SP_View)
				{
					// TODO нарушает инкапсуляцию
					(source as SP_View).removeFromParent();
				}
				else if (source is DisplayObject)
				{
					sprite = source as DisplayObject;
					if (sprite.parent) sprite.parent.removeChild(sprite);
				}
				else if (source is ST_Sprite)
				{
					(source as ST_DisplayObject).removeFromParent(true);
				}
			}*/
			// Удаление твина из списка
			object.remove(this);
		}
		
	}
}