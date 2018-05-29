package smart.gui.base
{
	import flash.display.Stage;
	import flash.events.MouseEvent;
	
	import smart.gui.signals.SG_Signal;
	
	public class MG_Button extends MG_ResizableComponent
	{
		protected var _highlighted:Boolean;
		protected var _pressed:Boolean;
		
		protected var _normalColor:uint;
		protected var _overColor:uint;
		protected var _pressedColor:uint;
		protected var _disabledColor:uint;
		
		private var _onMouseDown:SG_Signal;
		
		public function MG_Button(width:int = 0, height:int = 0)
		{
			super();
			
			if (width != 0)	 _autoWidth = false;
			if (height != 0) _autoHeight = false;
			
			_enabled = true;
			_normalColor = 0x009686;
			_disabledColor = 0x595959;
			
			_overColor = 0x19af95;
			_pressedColor = 0x008c7c;
			
			setSize(width, height);
			
			_onMouseDown = SG_Signal.create();
			
			_display.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			_display.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			_display.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
		}
		
		override public function redraw():void
		{
			super.redraw();
			
			var color:uint;
			
			if (_enabled)
			{
				if (_pressed)			color = _pressedColor;
				else if (_highlighted)	color = _overColor;
				else					color = _normalColor;
			}
			else color = _disabledColor;
			
			_display.drawRect(color, _width, _height);
		}
		
		private function mouseDownHandler(event:MouseEvent = null):void
		{
			if (!_enabled) return;
			_pressed = true;
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			redraw();
			_onMouseDown.emit(this);
		}
		
		private function mouseUpHandler(event:MouseEvent):void
		{
			var stage:Stage = event.currentTarget as Stage;
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			_pressed = false;
			redraw();
		}
		
		private function mouseOverHandler(event:MouseEvent = null):void
		{
			if (!_enabled) return;
			_highlighted = true;
			redraw();
		}
		
		private function mouseOutHandler(event:MouseEvent = null):void
		{
			if (!_enabled) return;
			_highlighted = false;
			redraw();
		}
		
		public function get onMouseDown():SG_Signal
		{
			return _onMouseDown;
		}
	}
}
