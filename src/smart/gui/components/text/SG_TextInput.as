package smart.gui.components.text
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextFieldAutoSize;
	import flash.ui.Keyboard;

	import smart.gui.components.SG_ComponentType;
	import smart.gui.constants.SG_SkinType;
	import smart.gui.constants.SG_ValueType;

	public class SG_TextInput extends SG_TextLabel
	{
		protected var _inputType:String;
		private var isActive:Boolean;
		private var isNumbers:Boolean;
		private var isNegative:Boolean;
		private var isFloat:Boolean;
		private var _maxChars:uint;
		private static const DEFAULT_WIDTH:Number = 100;
		private static const DEFAULT_HEIGHT:Number = 24;

		
		public function SG_TextInput(text:String = "", inputType:String = SG_TextInputType.STRING)
		{
			super(text, SG_TextStyle.textInput_medium);
			this.inputType = inputType;
			this.text = text;
			initComponents();
			if (text != "") checkValueAfter();

			type = SG_ComponentType.TEXT_INPUT;
			valueType = SG_ValueType.STRING;
		}
		
		override public function setSize(width:uint, height:uint = 0):void
		{
			this.width = width;
			this.height = height;
		}
		
		override protected function redrawSkin():void
		{
			super.redrawSkin();
			color = _skin.textColor;
		}
		
		override protected function update():void
		{
			textField.setTextFormat(textFormat);
			textField.defaultTextFormat = textFormat;

			if (!isActive && textField.text == "") setDefaultValue();
		}
		
		public function selectAll():void
		{
			if (stage) stage.focus = textField;
			textField.setSelection(0, length)
		}
		
		protected function initComponents():void
		{
			_skinType = SG_SkinType.TEXT_INPUT;
			redrawSkin();
			_componentSkin.height = DEFAULT_HEIGHT;
			width = DEFAULT_WIDTH;

			textField.textColor = _skin.textColor;
			textField.width = _componentSkin.width - 4;
			textField.autoSize = TextFieldAutoSize.NONE;
			updateTextField();
			enableReduction = false;
			enableInput = true;

			textField.addEventListener(MouseEvent.MOUSE_DOWN, activate);
			textField.addEventListener(FocusEvent.FOCUS_IN, activate);
			textField.addEventListener(FocusEvent.FOCUS_OUT, deactivate);
			textField.addEventListener(Event.CHANGE, changeText);
			textField.addEventListener(TextEvent.TEXT_INPUT, inputEvent);
			textField.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
		}
		
		protected function updateTextField():void
		{
			textField.x = 4;
			textField.y = Math.floor(_componentSkin.height - textField.height) / 2;
		}
		
		protected function checkValueAfter(event:Boolean = true):void
		{
			if (isNumbers)
			{
				var value:Number = parseFloat(textField.text);
				if (!isNaN(value))    textField.text = String(value);
				else                textField.text = "0";
			}
			_text = textField.text;

			if (event) dispatchValue(text);
		}
		
		private function setDefaultValue():void
		{
			if (inputType == SG_TextInputType.STRING)
			{
				textField.text = _defaultMessage;
				textField.alpha = 0.7;
			}
			else
			{
				textField.text = "0";
				checkValueAfter();
			}
			_text = textField.text;
		}
		
		protected function keyDown(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.ENTER)
			{
				checkValueAfter();
				textField.setSelection(0, textField.length);
				dispatchValue(_text);
			}
		}
		
		private function inputEvent(event:TextEvent):void
		{
			var index:int = textField.caretIndex;
			var text:String = textField.text;
			var symbol:String = event.text;
			var first:String = text.charAt(0);

			if (isNumbers && symbol == "0")
			{
				if (first == "0" && (index == 0 || index == 1))            event.preventDefault();
				else if (index == 0 && (text.length != 0 && first != "."))    event.preventDefault();
			}
			if (isNegative && symbol == "-")
			{
				if (first == "-" || index != 0) event.preventDefault();
			}
			if (isFloat && symbol == ".")
			{
				if (index == 0 || text.indexOf(".") != -1) event.preventDefault();
			}
		}
		
		protected function changeText(event:Event):void
		{
			_text = textField.text;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function activate(event:Event):void
		{
			isActive = true;
			if (editable && textField.text == _defaultMessage) text = "";
		}
		
		private function deactivate(event:Event = null):void
		{
			isActive = false;
			if (textField.text != _defaultMessage) checkValueAfter();
			update();
		}
		

		// *** PROPERTIES *** //

		
		override public function set text(value:String):void
		{
			_text = value;
			
			textField.text = value;
			updateWidth();
			checkValueAfter(false);
			update();
		}
		
		override public function set enabled(value:Boolean):void
		{
			_enabled = value;
			mouseEnabled = value;
			mouseChildren = value;

			if (_enabled) textField.alpha = 1;
			else          textField.alpha = 0.5;
		}
		
		override public function set width(value:Number):void
		{
			_width = value - 4;
			
			if (_componentSkin)
			{
				_componentSkin.width = value;
				textField.width = _componentSkin.width - 4;
			}
		}
		
		override public function get width():Number
		{
			return _componentSkin.width;
		}
		
		public function set editable(value:Boolean):void
		{
			textField.selectable = value;
			textField.mouseEnabled = value;
		}
		
		public function get editable():Boolean
		{
			return textField.selectable;
		}
		
		public function set inputType(value:String):void
		{
			isFloat = false;
			isNegative = false;
			isNumbers = false;

			_inputType = value;
			textField.restrict = SG_TextInputType.getRestrict(value);

			if (inputType == SG_TextInputType.FLOAT || inputType == SG_TextInputType.UFLOAT)    isFloat = true;
			if (inputType == SG_TextInputType.INT || inputType == SG_TextInputType.FLOAT)        isNegative = true;
			
			textField.maxChars = _maxChars;

			if (inputType != SG_TextInputType.STRING) isNumbers = true;

			checkValueAfter(false);
		}
		
		public function get inputType():String
		{
			return _inputType;
		}
		
		public function set defaultMessage(value:String):void
		{
			if (textField.text == _defaultMessage) textField.text = "";
			_defaultMessage = value;
			update();
		}
		
		public function get defaultMessage():String
		{
			return _defaultMessage;
		}
		
		public function set maxChars(value:uint):void
		{
			_maxChars = value;
			textField.maxChars = _maxChars;
		}
		
		public function get maxChars():uint
		{
			return _maxChars;
		}
		
		private function get length():int
		{
			return textField.length;
		}
		
	}

}