package smart.gui.components
{
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import smart.gui.constants.SG_Align;
	
	public class SG_TextLabel extends SG_DynamicComponent
	{
		public var enableReduction:Boolean;
		public var enableBackReduction:Boolean;
		public var textField:TextField;
		
		protected var _defaultMessage:String = " ";
		protected var _maxWidth:uint;
		protected var _style:SG_TextStyle;
		protected var _font:String;
		protected var _bold:Boolean;
		protected var _color:uint;
		protected var _text:String;
		protected var _align:String = "left";
		protected var textFormat:TextFormat;
		
		
		public function SG_TextLabel(text:String = " ", style:SG_TextStyle = null, align:String = SG_Align.LEFT)
		{
			init(text, style);
			if (!style) this.align = align;
			
			type = SG_ComponentType.TEXT_LABEL;
		}
		
		protected function init(text:String, style:SG_TextStyle):void 
		{
			if (!style) style = SG_TextStyle.label_medium;
			
			textField = new TextField();
			textField.embedFonts = true;
			textField.selectable = false;
			textField.multiline = false;
			//textField.border = true;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.antiAliasType = AntiAliasType.ADVANCED;
			
			mouseChildren = false;
			mouseEnabled = false;
			
			this.style = style;
			this.text = text;
			
			addChild(textField);
			align = style.align;
		}
		
		protected function update():void 
		{
			textField.setTextFormat(textFormat);
			textField.defaultTextFormat = textFormat;
		}
		
		protected function updateWidth():void 
		{
			if (_width != 0)
			{
				if (enableReduction) reduction(_width);
				if (enableBackReduction) backReduction(_width);
				textField.width = _width;
				textField.autoSize = TextFieldAutoSize.NONE;
			}
			else if (_maxWidth != 0)
			{
				reduction(maxWidth);
				textField.autoSize = TextFieldAutoSize.NONE;
			}
			else textField.autoSize = TextFieldAutoSize.LEFT;
		}
		
		protected function backReduction(targetWidth:int):void
		{
			textField.text = _text;
			textField.autoSize = TextFieldAutoSize.LEFT;
			
			if (textField.width > targetWidth)
			{
				var length:int = _text.length-1;
				var symbol:int = 0;
				
				while (textField.width > targetWidth && length >= 1)
				{
					textField.text = "..." + _text.substring(symbol, _text.length);
					length--;
					symbol++;
				}
			}
		}
		
		protected function reduction(targetWidth:uint):void 
		{
			textField.text = _text;
			textField.autoSize = TextFieldAutoSize.LEFT;

			if (textField.width > targetWidth)
			{
				var length:int = _text.length-1;

				while (textField.width > targetWidth && length >= 1)
				{
					textField.text = _text.substr(0, length) + "...";
					length--;
				}
			}
		}
		

		// *** PROPERTIES *** //

		
		public function set text(value:String):void
		{
			if (value != null)
			{
				_text = value;
				textField.alpha = 1;
				textField.text = value;
				width = _width;
				update();
			}
		}
		
		override public function set width(value:Number):void 
		{
			_width = value;
			updateWidth();
		}
		
		override public function set height(value:Number):void 
		{
			textField.height = value;
		}
		
		public function set color(value:uint):void 
		{
			_color = value;
			textFormat.color = _color;
			update();
		}
		
		public function set bold(value:Boolean):void 
		{
			_bold = value;
			textFormat.bold = _bold;
			update();
		}
		
		public function set font(value:String):void 
		{
			_font = value;
			textFormat.font = _font;
			update();
		}
		
		public function set align(value:String):void 
		{
			_align = value;
			textFormat.align = _align;
			update();
		}
		
		public function set multiline(value:Boolean):void
		{
			textField.multiline = value;
			textField.wordWrap = value;
		}
		
		public function set leading(value:int):void 
		{
			textFormat.leading = value;
			update();
		}
		
		public function set enableInput(value:Boolean):void 
		{
			if (value)
			{
				textField.type = TextFieldType.INPUT;
				textField.selectable = true;
				mouseChildren = true;
				mouseEnabled = true;
			}
			else
			{
				textField.type = TextFieldType.DYNAMIC;
				textField.selectable = false;
				mouseChildren = false;
				mouseEnabled = false;
			}
		}
		
		public function set restrict(value:String):void
		{
			textField.restrict = value;
		}
		
		public function set style(value:SG_TextStyle):void 
		{
			_style = value;
			
			textFormat = new TextFormat(_style.font, _style.size, _style.color, _style.bold);
			textFormat.align = _style.align;
			update();
		}
		
		override public function set enabled(value:Boolean):void
		{
			_enabled = value;
			if (_enabled)	alpha = 1;
			else			alpha = 0.5;
		}
		
		public function set maxWidth(value:uint):void
		{
			_maxWidth = value;
			updateWidth();
		}
		
		public function get text():String
		{
			if (_text != _defaultMessage)	return _text;
			else							return null;
		}
		
		override public function get width():Number 
		{
			if (_width != 0) return _width;
			return textField.width;
		}
		
		public function get color():uint 
		{
			return _color;
		}
		
		public function get bold():Boolean 
		{
			return _bold;
		}
		
		public function get font():String 
		{
			return _font;
		}
		
		public function get align():String 
		{
			return _align;
		}
		
		public function get multiline():Boolean 
		{
			return textField.multiline;
		}
		
		public function get restrict():String
		{
			return textField.restrict;
		}
		
		public function get style():SG_TextStyle 
		{
			return _style;
		}
		
		public function get maxWidth():uint
		{
			return _maxWidth;
		}
		
	}

}