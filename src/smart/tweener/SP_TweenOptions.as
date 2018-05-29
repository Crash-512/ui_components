package smart.tweener
{
	import flash.geom.ColorTransform;
	
	internal dynamic class SP_TweenOptions 
	{
		// Список параметров
		public var list:Array;
		private var initList:Object;
		
		// Масштабирование
		public var scaleX:Number;
		public var scaleY:Number;
		public var scaleZ:Number;
		public var init_scaleX:Number;
		public var init_scaleY:Number;
		public var init_scaleZ:Number;
		
		// Координаты
		public var x:int;
		public var y:int;
		public var z:int;
		public var init_x:int;
		public var init_y:int;
		public var init_z:int;
		
		// Поворот
		public var rotation:Number;
		public var rotationX:Number;
		public var rotationY:Number;
		public var rotationZ:Number;
		public var init_rotation:Number;
		public var init_rotationX:Number;
		public var init_rotationY:Number;
		public var init_rotationZ:Number;
		
		// Размеры
		public var width:int;
		public var height:int;
		public var init_width:int;
		public var init_height:int;
		
		// Прозрачность
		public var alpha:Number;
		public var init_alpha:Number;
		public var visible:Boolean;
		
		// Звук
		public var volume:Number;
		public var pan:Number;
		public var init_volume:Number;
		public var init_pan:Number;
		
		// Цвет
		public var redMultiplier:Number;
		public var greenMultiplier:Number;
		public var blueMultiplier:Number;
		public var redOffset:Number;
		public var greenOffset:Number;
		public var blueOffset:Number;
		
		// Фильтры
		
		// Bitmap-Фильтры
		
		
		public function SP_TweenOptions() 
		{
			list = [];
			initList = {};
		}
		
		public function parseEndOptions(options:Object, source:Object):void
		{
			var initName:String;
			
			for (var name:String in options)
			{
				try
				{
					if (name == "color")
					{
						var color:ColorTransform = options[name];
						var sourceColor:ColorTransform = source as ColorTransform;

						if (color.redMultiplier != sourceColor.redMultiplier)
						{
							redMultiplier = color.redMultiplier - sourceColor.redMultiplier;
							list.push("redMultiplier");
						}
						if (color.greenMultiplier != sourceColor.greenMultiplier)
						{
							greenMultiplier = color.greenMultiplier - sourceColor.greenMultiplier;
							list.push("greenMultiplier");
						}
						if (color.blueMultiplier != sourceColor.blueMultiplier)
						{
							blueMultiplier = color.blueMultiplier - sourceColor.blueMultiplier;
							list.push("blueMultiplier");
						}
						if (color.redOffset != sourceColor.redOffset)
						{
							redOffset = color.redOffset - sourceColor.redOffset;
							list.push("redOffset");
						}
						if (color.greenOffset != sourceColor.greenOffset)
						{
							greenOffset = color.greenOffset - sourceColor.greenOffset;
							list.push("greenOffset");
						}
						if (color.blueOffset != sourceColor.blueOffset)
						{
							blueOffset = color.blueOffset - sourceColor.blueOffset;
							list.push("blueOffset");
						}
					}
					/*else if (name == "scale")
					{
						scaleX = options[name];
						scaleY = options[name];
						list.push("scaleX");
						list.push("scaleY");
					}*/
					else
					{
						if (name.substring(0,5) == "init_")
						{
							initName = name.substring(5, name.length);
							
							/*if (initName == "scale")
							{
								source.scaleX = options.scaleX;
								source.scaleY = options.scaleY;
								
								scaleX = options.scaleX - source.scaleX;
								scaleY = options.scaleY - source.scaleY;
							}
							else
							{*/
								source[initName] = options[name];
								
								if (initName in initList)
								{
									this[initName] = options[initName] - source[initName];
								}
							//}
						}
						else
						{
							list.push(name);
							initList[name] = true;
							this[name] = options[name] - source[name];
						}
					}
					initName = null;
				}
				catch(error:*) 
				{
					throw("Error: Переменная " + name + " не найдена в объекте " + source);
				}
			}
		}
		
		private function addName(name:String, source:Object, options:Object):void
		{
			
		}
		
		public function parseInitOptions(list:Array, source:Object):void
		{
			this.list = list;
			
			for each (var name:String in list)
			{
				if (name in source) 
				{
					this[name] = source[name];
				}
			}
		}
		
	}

}