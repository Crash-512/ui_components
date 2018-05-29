package smart.modern_gui.buttons
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	
	import smart.modern_gui.base.MG_ResizableComponent;
	import smart.modern_gui.constants.MG_AlignH;
	import smart.modern_gui.constants.MG_AlignV;
	import smart.modern_gui.constants.MG_Colors;
	import smart.modern_gui.mg_internal;
	import smart.modern_gui.signals.MG_Signal;
	import smart.modern_gui.utils.MG_Align;
	import smart.modern_gui.utils.MG_ColorUtils;
	
	use namespace mg_internal;

	public class MG_Button extends MG_ResizableComponent
	{
		private var _icon:DisplayObject;
		
		private var _useRectForAlign:Boolean;
		
		protected var _selected:Boolean;
		protected var _highlighted:Boolean;
		protected var _pressed:Boolean;
		
		protected var _normalColor:uint;
		protected var _overColor:uint;
		protected var _pressedColor:uint;
		protected var _selectedColor:uint;
		protected var _disabledColor:uint;
		
		private var _iconAlignH:MG_AlignH;
		private var _iconAlignV:MG_AlignV;
		
		private var _onMouseOver:MG_Signal;
		private var _onMouseOut:MG_Signal;
		private var _onMouseDown:MG_Signal;
		private var _onDoubleClick:MG_Signal;
		private var _onClick:MG_Signal;
		
		  
		public function MG_Button(width:int = 0, height:int = 0)
		{
			super();
			
			if (width != 0)	 _autoWidth = false;
			if (height != 0) _autoHeight = false;
			
			_enabled = true;
			_normalColor = MG_Colors.MINT;
			_disabledColor = MG_Colors.GRAY_BRIGHT_1;
			_selectedColor = MG_Colors.GRAY_MEDIUM_1;
			
			_overColor = MG_ColorUtils.offset(_normalColor, 25, 25, 15);
			_pressedColor = MG_ColorUtils.offset(_normalColor, -10, -10, -10);
			
			setSize(width, height);
			
			_onMouseOver = MG_Signal.create();
			_onMouseOut = MG_Signal.create();
			_onMouseDown = MG_Signal.create();
			_onDoubleClick = MG_Signal.create();
			_onClick = MG_Signal.create();
			
			_display.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			_display.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			_display.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			_display.addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		private function doubleClickHandler(event:MouseEvent):void
		{
			_onDoubleClick.dispatch(this);
		}
		
		public function setIcon(icon:DisplayObject, alignToCenter:Boolean = true, useRectForAlign:Boolean = false):void 
		{
			if (_icon && _display.contains(_icon))
			{
				_display.removeChild(_icon);
			}
			
			_iconAlignH = MG_AlignH.CENTER;
			_iconAlignV = MG_AlignV.CENTER;
			
			_useRectForAlign = useRectForAlign;
			_icon = icon;
			_display.addChild(icon);
			redraw();
			
			if (icon is Sprite)
			{
				Sprite(icon).mouseEnabled = false;
				Sprite(icon).mouseChildren = false;
			}
		}
		
		override public function redraw():void
		{
			super.redraw();
			
			var color:uint;
			
			if (_enabled)
			{
				if (_selected)			color = _selectedColor;
				else if (_pressed)		color = _pressedColor;
				else if (_highlighted)	color = _overColor;
				else					color = _normalColor;
			}
			else color = _disabledColor;
			
			_display.drawRect(color, _width, _height);
			
			if (_icon)
			{
				MG_Align.alignBySize(_icon, _iconAlignH, _iconAlignV, _width, _height, _useRectForAlign);
			}
		}
		
		public function setColor(color:uint):void 
		{
			_normalColor = color;
			_overColor = MG_ColorUtils.offset(_normalColor, 25, 25, 15);
			_pressedColor = MG_ColorUtils.offset(_normalColor, -10, -10, -10);
			redraw();
		}
		
		
		// *** EVENTS *** //
		
		
		mg_internal function mouseDownHandler(event:MouseEvent = null):void
		{
			if (!_enabled) return;
			_pressed = true;
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			redraw();
			_onMouseDown.dispatch(this);
		}
		
		private function mouseUpHandler(event:MouseEvent):void
		{
			var stage:Stage = event.currentTarget as Stage;
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			_pressed = false;
			redraw();
		}
		
		mg_internal function mouseOverHandler(event:MouseEvent = null):void
		{
			if (!_enabled) return;
			_highlighted = true;
			redraw();
			_onMouseOver.dispatch(this);
		}
		
		mg_internal function mouseOutHandler(event:MouseEvent = null):void
		{
			if (!_enabled) return;
			_highlighted = false;
			redraw();
			_onMouseOut.dispatch(this);
		}
		
		private function clickHandler(event:MouseEvent):void
		{
			if (!_enabled) return;
			_onClick.dispatch(this);
		}
		
		public function unlock():void 
		{
			enabled = true;
		}
		
		
		// *** PROPERTIES *** //
		
		
		public function set normalColor(value:uint):void
		{
			_normalColor = value;
			redraw();
		}
		
		public function get normalColor():uint
		{
			return _normalColor;
		}
		
		public function set overColor(value:uint):void
		{
			_overColor = value;
		}
		
		public function get overColor():uint
		{
			return _overColor;
		}
		
		public function set pressedColor(value:uint):void
		{
			_pressedColor = value;
		}
		
		public function get pressedColor():uint
		{
			return _pressedColor;
		}
		
		public function set selectedColor(value:uint):void
		{
			_selectedColor = value;
		}
		
		public function get selectedColor():uint
		{
			return _selectedColor;
		}
		
		public function set disabledColor(value:uint):void
		{
			_disabledColor = value;
		}
		
		public function get disabledColor():uint
		{
			return _disabledColor;
		}
		
		public function get icon():DisplayObject
		{
			return _icon;
		}
		
		public function set selected(value:Boolean):void
		{
			_selected = value;
			redraw();
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set iconAlignV(value:MG_AlignV):void
		{
			_iconAlignV = value;
			redraw();
		}
		
		public function get iconAlignV():MG_AlignV
		{
			return _iconAlignV;
		}
		
		public function set iconAlignH(value:MG_AlignH):void
		{
			_iconAlignH = value;
			redraw();
		}
		
		public function get iconAlignH():MG_AlignH
		{
			return _iconAlignH;
		}
		
		public function get onMouseOver():MG_Signal
		{
			return _onMouseOver;
		}
		
		public function get onMouseOut():MG_Signal
		{
			return _onMouseOut;
		}
		
		public function get onMouseDown():MG_Signal
		{
			return _onMouseDown;
		}
		
		public function get onDoubleClick():MG_Signal
		{
			if (!_display.hasEventListener(MouseEvent.DOUBLE_CLICK))
			{
				_display.mouseChildren = false;
				_display.doubleClickEnabled = true;
				_display.addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);
			}
			return _onDoubleClick;
		}
		
		public function get onClick():MG_Signal
		{
			return _onClick;
		}
		
	}
}
