package smart.gui.components.controllers 
{
	import flash.display.*;
	import flash.events.*;
	import smart.gui.components.SG_Component;
	import smart.gui.components.SG_ComponentType;
	import smart.gui.components.SG_DynamicComponent;
	import smart.gui.constants.*;
	import smart.gui.skin.SG_ComponentSkin;

	public class SG_Slider extends SG_DynamicComponent
	{
		private var _value:Number;
		private var _minValue:Number;
		private var _maxValue:Number;
		private var _tickInterval:Number;
		private var _snapInterval:Number;
		private var _defaultValue:Number;
		
		private var minPos:int;
		private var ticks:Sprite;
		private var bar:SG_ComponentSkin;
		private var activeBar:SG_ComponentSkin;
		private var picker:SG_ComponentSkin;
		private var barMask:Sprite;
		private var pickerSprite:Sprite;
		private var components:Array;
		
		private static const DEFAULT_WIDTH:int = 100;
		private static const TICK_SIZE:int = 3;
		
		
		public function SG_Slider(minValue:Number = 0, maxValue:Number = 10, tickInterval:Number = 5, snapInterval:Number = 1) 
		{
			_minValue = minValue;
			_maxValue = maxValue;
			_tickInterval = tickInterval;
			_snapInterval = snapInterval;
			
			init();

			type = SG_ComponentType.SLIDER;
			valueType = SG_ValueType.NUMBER;
			
			_defaultValue = value;
		}
		
		override public function clone():SG_DynamicComponent
		{
			return new SG_Slider(_minValue, _maxValue, _tickInterval, _snapInterval);
		}
		
		private function init():void
		{
			ticks = new Sprite();
			ticks.y = -6;
			addChild(ticks);

			pickerSprite = new Sprite();
			barMask = new Sprite();
			redrawSkin();
			
			minPos = bar.height/2;
			pickerSprite.x = minPos;
			pickerSprite.y = minPos;
			
			addEventListener(MouseEvent.MOUSE_WHEEL, scrollSlider);
			pickerSprite.addEventListener(MouseEvent.MOUSE_DOWN, pressCircle);
			bar.addEventListener(MouseEvent.MOUSE_DOWN, pressCircle);
			addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, resetToDefault);
			addEventListener(MouseEvent.MIDDLE_MOUSE_UP, resetToDefault);
			
			value = 0;
			updateValue();
		}
		
		private function resetToDefault(event:MouseEvent):void
		{
			if (_minValue > _defaultValue)		value = _minValue;
			else if (_maxValue < _defaultValue)	value = _maxValue;
			else								value = _defaultValue;
			
			dispatchEvent(new Event(Event.CHANGE));
			dispatchValue(_value);
		}
		
		override protected function redrawSkin():void
		{
			if (components)
			{
				for each (var component:SG_ComponentSkin in components)
				{
					if (component.parent) component.parent.removeChild(component);
				}
			}
			bar = _skin.getComponentSkin(SG_SkinType.SLIDER);
			bar.width = (_width == 0) ? DEFAULT_WIDTH : _width;
			addChild(bar);

			activeBar = _skin.getComponentSkin(SG_SkinType.SLIDER);
			activeBar.currentState = 1;
			activeBar.mouseEnabled = false;
			activeBar.width = bar.width;
			addChild(activeBar);

			picker = _skin.getComponentSkin(SG_SkinType.PICKER);
			pickerSprite.addChild(picker);
			addChild(pickerSprite);
			
			components = [bar, activeBar, picker];
			redrawMask();
			redrawTicks();
		}
		
		private function redrawMask():void
		{
			var g:Graphics = barMask.graphics;
			g.beginFill(0);
			g.drawRect(0, 0, activeBar.width, activeBar.height);
			g.endFill();
			activeBar.mask = barMask;
			addChild(barMask);
		}
		
		private function scrollSlider(event:MouseEvent):void 
		{
			var interval:Number = (event.shiftKey) ? _tickInterval : _snapInterval;
			
			if (event.delta > 0)	value += interval;
			else					value -= interval;
			dispatchEvent(new Event(Event.CHANGE));
			dispatchValue(_value);
			
			event.stopImmediatePropagation();
			event.stopPropagation();
		}
		
		private function redrawTicks():void 
		{
			var g:Graphics = ticks.graphics;
			g.clear();
			
			var tickCount:int = Math.floor(totalValue/_tickInterval);
			var tickWidth:int = Math.round(barWidth/tickCount);
			var nextX:int = minPos-1;
			
			for (var i:int=0; i<=tickCount; i++)
			{
				g.beginFill(0, 0.2);
				g.drawRect(nextX, 0, 2, TICK_SIZE);
				g.endFill();
				
				nextX += tickWidth;
			}
		}
		
		private function moveCircle(event:Event):void 
		{
			var nextValue:Number = (mouseX - zeroPosition)/tickSize;
			if (_minValue > 0) nextValue += _minValue;
			value = nextValue;
			dispatchEvent(new Event(Event.CHANGE));
			dispatchValue(_value);
		}
		
		private function pressCircle(event:MouseEvent):void 
		{
			picker.currentState = 1;
			picker.addEventListener(Event.ENTER_FRAME, moveCircle);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			stage.addEventListener(Event.MOUSE_LEAVE, mouseUp);
			
			event.stopImmediatePropagation();
			event.stopPropagation();
		}		
		
		private function mouseUp(event:Event):void 
		{
			picker.currentState = 0;
			picker.removeEventListener(Event.ENTER_FRAME, moveCircle);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			stage.removeEventListener(Event.MOUSE_LEAVE, mouseUp);
		}
		
		private function updateValue():void
		{
			value = _value;
		}
		
		
		// *** PROPERTIES *** //
		
		
		public function set value(value:Number):void
		{
			if (isNaN(value)) value = 0;
			
			value = Math.round(value/_snapInterval)*_snapInterval;
			
			if (value < minValue)	value = minValue;
			if (value > maxValue)	value = maxValue;
			
			pickerSprite.x = (minPos + barWidth * (value - minValue)/totalValue);
			barMask.width = pickerSprite.x;
			
			_value = value;
		}
		
		override public function set enabled(value:Boolean):void
		{
			_enabled = value;
			
			if (_enabled)
			{
				activeBar.filters = [];
				bar.filters = [];
				picker.filters = [];
				mouseEnabled = true;
				mouseChildren = true;
			}
			else
			{
				activeBar.filters = [SG_Filters.DISABLED];
				bar.filters = [SG_Filters.DISABLED];
				picker.filters = [SG_Filters.DISABLED];
				mouseEnabled = false;
				mouseChildren = false;
			}
		}
		
		override public function set width(width:Number):void
		{
			_width = width;
			bar.width = width;
			activeBar.width = width;
			redrawMask();
			redrawTicks();
			updateValue();
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		public function set minValue(value:Number):void 
		{
			_minValue = value;
			updateValue();
			redrawTicks();
		}
		
		public function set maxValue(value:Number):void 
		{
			_maxValue = value;
			updateValue();
			redrawTicks();
		}
		
		public function set tickInterval(value:Number):void 
		{
			_tickInterval = value;
			redrawTicks();
		}
		
		public function set snapInterval(value:Number):void 
		{
			_snapInterval = value;
			updateValue();
		}
		
		public function set defaultValue(value:Number):void
		{
			if (value < _minValue)		_defaultValue = _minValue;
			else if (value > _maxValue)	_defaultValue = _maxValue;
			else						_defaultValue = value;
		}
		
		private function get barWidth():Number
		{
			return activeBar.width - minPos*2;
		}
		
		private function get tickSize():Number
		{
			return barWidth/totalValue;
		}
		
		private function get zeroPosition():Number
		{
			if (_minValue < 0)	return (minPos + barWidth * Math.abs(_minValue/totalValue));
			else				return minPos;
		}
		
		private function get totalValue():Number
		{
			return Math.abs(maxValue - minValue);
		}
		
		public function get value():Number
		{
			return _value;
		}
		
		public function get minValue():Number 
		{
			return _minValue;
		}
		
		public function get maxValue():Number 
		{
			return _maxValue;
		}
		
		public function get tickInterval():Number 
		{
			return _tickInterval;
		}
		
		public function get snapInterval():Number 
		{
			return _snapInterval;
		}
		
		override public function get enabled():Boolean 
		{
			return _enabled;
		}
		
		public function get defaultValue():Number
		{
			return _defaultValue;
		}
		
	}

}