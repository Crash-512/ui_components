package smart.gui.components.controllers 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import smart.gui.components.SG_ComponentType;
	import smart.gui.components.SG_DynamicComponent;
	import smart.gui.components.buttons.SG_Button;
	import smart.gui.components.buttons.SG_ButtonType;
	import smart.gui.components.icons.SG_Icon;
	import smart.gui.components.icons.SG_IconType;
	import smart.gui.components.text.SG_TextInput;
	import smart.gui.components.text.SG_TextInputType;
	import smart.gui.constants.SG_ValueType;
	import smart.gui.skin.SG_GUISkin;
	import smart.gui.utils.SG_Math;
	
	public class SG_Stepper extends SG_TextInput
	{
		public var hotUpdate:Boolean = true;
		
		private var _step:Number;
		private var _value:Number;
		private var _minValue:Number = Number.MIN_VALUE;
		private var _maxValue:Number = Number.MAX_VALUE;
		private var _defaultValue:Number = 0;
		
		private var _roundIndex:int = 0;
		private var btnReset:SG_Button;
		private var btnStep:SG_Button;
		private var initY:Number;
		private var initValue:Number;
		private var shiftMode:Boolean;
		private var undefinedMode:Boolean;
		
		private static const DEFAULT_WIDTH:Number = 55;
		private static const DEFAULT_HEIGHT:Number = 22;
		private static const SHIFT_INDEX:Number = 5;
		private static const PIXEL_STEP:int = 3;
		private static const BTN_SIZE:int = 20;
		
		public function SG_Stepper(value:Number = 0, step:Number = 1, minValue:Number = -999, maxValue:Number = 999) 
		{
			_defaultValue = value;
			_step = step;
			_value = value;
			_minValue = minValue;
			_maxValue = maxValue;
			
			_roundIndex = getNumbersAfterComma(step);
			
			super(SG_TextInputType.FLOAT, String(value));
			updateInputType();

			type = SG_ComponentType.STEPPER;
			valueType = SG_ValueType.NUMBER;
		}
		
		override public function clone():SG_DynamicComponent
		{
			return new SG_Stepper(_value, _step, _minValue, _maxValue);
		}
		
		override public function setSkin(skin:SG_GUISkin):void
		{
			super.setSkin(skin);
			btnStep.setSkin(skin);
		}
		
		private function updateInputType():void
		{
			if (step < 1)
			{
				if (minValue < 0)	inputType = SG_TextInputType.FLOAT;
				else				inputType = SG_TextInputType.UFLOAT;
			}
			else
			{
				if (minValue < 0)	inputType = SG_TextInputType.INT;
				else				inputType = SG_TextInputType.UINT;		
			}
		}
		
		override protected function initComponents():void 
		{
			btnReset = new SG_Button("", new SG_Icon(SG_IconType.CROSS), SG_ButtonType.LEFT);
			btnReset.width = BTN_SIZE;
			addChild(btnReset);
			
			btnStep = new SG_Button("", new SG_Icon(SG_IconType.STEPPER), SG_ButtonType.RIGHT);
			btnStep.width = BTN_SIZE;
			addChild(btnStep);
			
			btnReset.onMouseDown.add(onPressReset);
			btnStep.onMouseDown.add(onPressStep);
			btnStep.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, resetToDefault);
			addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, resetToDefault);
			addEventListener(MouseEvent.MOUSE_WHEEL, scrollValue);
			
			super.initComponents();
			
			width = DEFAULT_WIDTH;
			height = DEFAULT_HEIGHT;
		}
		
		override protected function changeText(event:Event):void
		{
			super.changeText(event);
			checkValueAfter(false);
			dispatchValue(value);
		}
		
		private function onPressReset():void
		{
			resetToDefault();
		}
		
		override public function set height(value:Number):void
		{
			_componentSkin.height = value;
			btnStep.height = DEFAULT_HEIGHT;
			btnReset.height = DEFAULT_HEIGHT;
			updateTextField();
		}
		
		protected function scrollValue(event:MouseEvent):void 
		{
			if (_enabled)
			{
				var scrollStep:Number = step;
				if (event.shiftKey) scrollStep *= SHIFT_INDEX;
				
				if (event.delta > 0)	setNewValue(value + scrollStep);
				else					setNewValue(value - scrollStep);
				
				dispatchEvent(new Event(Event.CHANGE));
				dispatchValue(_value);
				
				event.stopImmediatePropagation();
				event.stopPropagation();
			}
		}
		
		override protected function redrawSkin():void 
		{
			super.redrawSkin();
			_componentSkin.currentState = 3;
		}
		
		private function resetToDefault(event:MouseEvent = null):void
		{
			if (_minValue > _defaultValue)		value = _minValue;
			else if (_maxValue < _defaultValue)	value = _maxValue;
			else								value = _defaultValue;
			setNewValue(value);
			dispatchEvent(new Event(Event.CHANGE));
			dispatchValue(_value);
		}
		
		private function onPressStep():void
		{
			initY = mouseY;
			initValue = _value;
			
			stage.addEventListener(MouseEvent.MOUSE_UP, releaseButton);
			stage.addEventListener(Event.MOUSE_LEAVE, releaseButton);
			stage.addEventListener(Event.ENTER_FRAME, changeValue);
		}
		
		private function releaseButton(event:Event):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, releaseButton);
			stage.removeEventListener(Event.MOUSE_LEAVE, releaseButton);
			stage.removeEventListener(Event.ENTER_FRAME, changeValue);

			if (_value == initValue)
			{
				if (btnStep.mouseY < height/2)	setNewValue(_value + _step);
				else                   			setNewValue(_value - _step);
			}
			dispatchValue(_value);
		}
		
		private function changeValue(event:Event):void 
		{
			var step:Number = (shiftMode) ? _step * SHIFT_INDEX : _step;
			var newValue:Number = initValue + Math.floor((initY - mouseY)/PIXEL_STEP) * step;
			
			if (_value != newValue)
			{
				setNewValue(newValue);
				if (hotUpdate) dispatchValue(_value, true);
			}
		}
		
		override protected function checkValueAfter(event:Boolean = true):void 
		{
			if (!undefinedMode)
			{
				super.checkValueAfter(event);
				var newValue:Number = parseFloat(textField.text);
				setNewValue(newValue);
			}
		}
		
		private function setNewValue(newValue:Number, event:Boolean = true):void
		{
			if (newValue < _minValue) newValue = _minValue;
			if (newValue > _maxValue) newValue = _maxValue;
			
			value = SG_Math.roundTo(newValue, roundIndex);
			if (event) dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function getNumbersAfterComma(value:Number):int
		{
			var string:String = String(value);
			var index:int = string.indexOf(".") + 1;
			
			if (index != 0)
			{
				string = string.substring(index, string.length);
				return string.length;
			}
			else return 0;
		}
		
		// *** PROPERTIES *** //
		
		override public function set enabled(value:Boolean):void 
		{
			_enabled = value;
			btnStep.enabled = _enabled;
			textField.mouseEnabled = _enabled;
			
			if (_enabled)	textField.alpha = 1;
			else			textField.alpha = 0.4;
		}
		
		public function set value(value:Number):void
		{
			if (value < _minValue) value = _minValue;
			if (value > _maxValue) value = _maxValue;
			
			if (undefinedMode)
			{
				undefinedMode = false;
				_value = _defaultValue;
			}
			else _value = value;
			
			var string:String = String(value);
			var numbers:int = getNumbersAfterComma(value);
			
			if (_roundIndex != 0 && numbers == 0) string += ".";
			
			while (numbers < _roundIndex) 
			{
				string += "0";
				numbers++;
			}				
			textField.text = string;
		}
		
		override public function set width(value:Number):void
		{
			_componentSkin.width = value - btnStep.width - btnReset.width;
			textField.width = _componentSkin.width;
			textField.x = btnReset.width + 2;
			_componentSkin.x = btnReset.width;
			btnStep.x = _componentSkin.width + btnReset.width;
		}
		
		public function set defaultValue(value:Number):void 
		{
			if (value < _minValue)		_defaultValue = _minValue;
			else if (value > _maxValue)	_defaultValue = _maxValue;
			else						_defaultValue = value;
		}
		
		public function get value():Number
		{
			return _value;
		}
		
		override public function get width():Number
		{
			return _componentSkin.width + btnStep.width + btnReset.width;
		}
		
		public function get minValue():Number 
		{
			return _minValue;
		}
		
		public function get maxValue():Number 
		{
			return _maxValue;
		}
		
		public function get step():Number 
		{
			return _step;
		}
		
		public function get roundIndex():int
		{
			return _roundIndex;
		}
		
	}
}