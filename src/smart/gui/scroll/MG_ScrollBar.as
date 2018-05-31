package smart.gui.scroll
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import smart.gui.signals.SG_Signal;
	import smart.gui.base.MG_Button;
	import smart.gui.base.MG_Container;
	import smart.gui.base.MG_Sprite;
	import smart.gui.constants.MG_Colors;
	
	public class MG_ScrollBar extends MG_Container
	{
		protected var _content:Sprite;
		protected var _btnScrollA:MG_ScrollButton;
		protected var _btnScrollB:MG_ScrollButton;
		
		protected var _bar:MG_Sprite;
		protected var _barPressed:Boolean;
		protected var _barSize:Number = 0.5;
		protected var _initMouse:Point;
		protected var _initPosition:Point;
		protected var _scrollSpeed:int = 25;
		protected var _scrollStep:int = 50;
		protected var _onScroll:SG_Signal;
		protected var _scrollPane:MG_ScrollPane;

		protected var _barColor:uint = _barNormalColor;
		protected var _barNormalColor:uint = MG_Colors.GRAY_MEDIUM_1;
		protected var _barPressedColor:uint = MG_Colors.GRAY_MEDIUM_2;
		
		protected var _btnScrollUp:MG_ScrollButton;
		protected var _btnScrollDown:MG_ScrollButton;
		protected var _scrollUp:Boolean;
		protected var _scrollDown:Boolean;
		protected var _onScrolled:SG_Signal;
		protected var _barMinY:int;
		protected var _barMaxY:int;
		protected var _nextY:int;
		
		public static const THICKNESS:int = 20;
		
		
		public function MG_ScrollBar(scrollPane:MG_ScrollPane, onScroll:SG_Signal)
		{
			super();
			
			_width = THICKNESS;
			_onScroll = onScroll;
			_scrollPane = scrollPane;
			_hasBackground = true;
			_backgroundColor = MG_Colors.GRAY_DARK_1;
			
			_initMouse = new Point();
			_initPosition = new Point();
			_btnScrollA = new MG_ScrollButton();
			_btnScrollB = new MG_ScrollButton();
			
			add(_btnScrollA);
			add(_btnScrollB);
			
			_bar = new MG_Sprite();
			_display.addChild(_bar);
			
			_bar.addEventListener(MouseEvent.MOUSE_DOWN, onPressBar);
			_bar.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			_nextY = -1;
			_autoWidth = false;
			_width = THICKNESS;
			_barMinY = THICKNESS;
			
			_onScrolled = new SG_Signal();
			_btnScrollUp = _btnScrollA;
			_btnScrollDown = _btnScrollB;
			
			_btnScrollUp.setMode(MG_ScrollButton.UP);
			_btnScrollDown.setMode(MG_ScrollButton.DOWN);
			
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
		
		private function onEnterFrame(event:Event):void
		{
			update();
		}
		
		public function setValue(value:int):void
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
		
		public function update():void
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
		
		public function reset():void
		{
			redraw();
			_nextY = -1;
			_scrollDown = false;
			_scrollUp = false;
		}
		
		override public function redraw():void
		{
			super.redraw();
			_btnScrollA.visible = true;
			_btnScrollB.visible = true;
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
		
		private function onPressBar(event:MouseEvent):void
		{
			reset();
			_barPressed = true;
			_initMouse.setTo(mouseX, mouseY);
			_initPosition.setTo(_bar.x, _bar.y);
			_barColor = _barPressedColor;
			redraw();
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			_barPressed = false;
			_barColor = _barNormalColor;
			redraw();
			var stage:Stage = event.currentTarget as Stage;
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			_scrollUp = false;
			_scrollDown = false;
			_onScrolled.emit();
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
		
		public function set content(value:Sprite):void
		{
			_content = value;
		}
		
		public function get content():Sprite
		{
			return _content;
		}
		
		public function set barSize(value:Number):void
		{
			_barSize = value;
			redraw();
		}
		
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
				_onScroll.emit(_scrollPane);
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
