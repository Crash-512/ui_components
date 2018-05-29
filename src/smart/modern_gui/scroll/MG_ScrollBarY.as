package smart.modern_gui.scroll
{
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import smart.gui.signals.SG_Signal;
	
	import smart.modern_gui.buttons.MG_Button;
	import smart.modern_gui.signals.MG_Signal;
	import smart.modern_gui.utils.MG_Utils;
	
	public class MG_ScrollBarY extends MG_ScrollBar
	{
		private var _btnScrollUp:MG_ScrollButton;
		private var _btnScrollDown:MG_ScrollButton;
		private var _scrollUp:Boolean;
		private var _scrollDown:Boolean;
		private var _onScrolled:SG_Signal;
		
		private var _barMinY:int;
		private var _barMaxY:int;
		private var _nextY:int;
		
		  
		public function MG_ScrollBarY(scrollPane:MG_ScrollPane, onScroll:MG_Signal)
		{
			super(scrollPane, onScroll);
			
			_nextY = -1;
			_autoWidth = false;
			_width = THICKNESS;
			_barMinY = THICKNESS;
			
			_onScrolled = new SG_Signal();
			_btnScrollUp = _btnScrollA;
			_btnScrollDown = _btnScrollB;
			
			_btnScrollUp.setMode(MG_ScrollButtonMode.UP);
			_btnScrollDown.setMode(MG_ScrollButtonMode.DOWN);
			
			_btnScrollUp.onMouseDown.add(onPressScrollUp);
			_btnScrollDown.onMouseDown.add(onPressScrollDown);
			
			_bar.y = _barMinY;
		}
		
		private function onPressScrollUp(button:MG_Button):void
		{
			_scrollUp = true;
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onPressScrollDown(button:MG_Button):void
		{
			_scrollDown = true;
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		override protected function onMouseUp(event:MouseEvent):void
		{
			super.onMouseUp(event);
			_scrollUp = false;
			_scrollDown = false;
			_onScrolled.emit();
		}
		
		override public function setValue(value:int):void 
		{
			contentY = value >= 0 ? value : 0;
		}
		
		public function wheelUp():void 
		{
			if (_nextY == -1) _nextY = contentY;

			_nextY -= _scrollStep;
			
			if (_nextY < 0) _nextY = 0;
		}
		
		public function wheelDown():void 
		{
			var scrollRect:Rectangle = _content.scrollRect;
			var maxY:int = _content.height - scrollRect.height;
			
			if (_nextY == -1) _nextY = scrollRect.y;
			
			_nextY += _scrollStep;
			
			if (_nextY > maxY) _nextY = maxY;
		}
		
		override public function reset():void 
		{
			super.reset();
			_nextY = -1;
			_scrollDown = false;
			_scrollUp = false;
		}
		
		override public function update():void 
		{
			var y:int;
			
			if (_barPressed)
			{
				y = _initPosition.y + (mouseY - _initMouse.y);
				_bar.y = y < _barMinY ? _barMinY : y > _barMaxY ? _barMaxY : y;
				setContentToBar();
			}
			else if (_scrollDown)
			{
				y = _bar.y + _scrollSpeed;
				_bar.y = y > _barMaxY ? _barMaxY : y;
				setContentToBar();
			}
			else if (_scrollUp)
			{
				y = _bar.y - _scrollSpeed;
				_bar.y = y < _barMinY ? _barMinY : y;
				setContentToBar();
			}
			else
			{
				y = contentY;
				
				if (_nextY >= 0 && y != _nextY)
				{
					y = _nextY;
					if (y == _nextY)
					{
						_nextY = -1;
					}
					contentY = y;
					setBarToContent();
				}
			}
		}
		
		private function setBarToContent():void
		{
			var k:Number = contentY/(_content.height - scrollHeight);
					
			_bar.y = _barMinY + (_barMaxY - _barMinY) * k;
		}
		
		private function setContentToBar():void
		{
			var k:Number = (_bar.y - _barMinY)/(_barMaxY - _barMinY);
			var maxY:int = _content.height - scrollHeight;
			
			contentY = maxY * k;
		}
		
		override public function redraw():void
		{
			super.redraw();
			_bar.clearCanvas();
			
			if (_content) 
			{
				if (scrollHeight < _content.height)
				{
					redrawScrollBar();
				}
				else
				{
					redrawScrollBar();
					contentY = 0;
				}
			}
			else _display.clearCanvas();
		}
		
		private function redrawScrollBar():void
		{
			var buttonHeight:int = THICKNESS;
			var barHeight:int = (_height - buttonHeight * 2) * _barSize;
			var minHeight:int = _height/10;
			
			if (barHeight < minHeight) barHeight = minHeight;
			
			_barMaxY = (_height - barHeight) - buttonHeight;
			
			_bar.drawRect(_barColor, _width, barHeight);
			_btnScrollDown.y = _height - buttonHeight;
			
			var contentMaxY:int = _content.height - scrollHeight;
			
			if (contentY > contentMaxY)
			{
				contentY = contentMaxY;
			}
			setBarToContent();
		}
		
		
		// *** PROPERTIES *** //
		
		
		
		override public function get width():int
		{
			return (_barSize != 0) ? _width : 0;
		}
		
		private function set contentY(value:int):void 
		{
			var rect:Rectangle = _content.scrollRect;
			
			if (rect.y != value)
			{
				rect.y = value;
				_content.scrollRect = rect;
				_onScroll.dispatch(_scrollPane);
			}
		}
		
		private function get contentY():int 
		{
			return _content.scrollRect.y;
		}
		
		private function get scrollHeight():int 
		{
			return _content.scrollRect.height;
		}
		
		public function get onScrolled():SG_Signal
		{
			return _onScrolled;
		}
	}
}
