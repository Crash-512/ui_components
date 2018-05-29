package smart.gui.scroll
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import smart.gui.base.MG_ResizableComponent;
	import smart.gui.signals.SG_Signal;
	
	public class MG_ScrollPane extends MG_ResizableComponent
	{
		private var _content:Sprite;
		private var _scrollBar:MG_ScrollBar;
		private var _onScroll:SG_Signal;
		private var _onScrolled:SG_Signal;
		
		private static const DEFAULT_SIZE:int = 100;
		
		public function MG_ScrollPane(content:Sprite)
		{
			super();
			
			_width = DEFAULT_SIZE;
			_height = DEFAULT_SIZE;
			
			_onScroll = new SG_Signal();
			_onScrolled = new SG_Signal();
			_scrollBar = new MG_ScrollBar(this, _onScroll);
			_scrollBar.onScrolled.add(onContentScrolled);
			
			addChild(_scrollBar);
			
			_content = content;
			_content.scrollRect = new Rectangle();
			_display.addChildAt(_content, 0);
			
			_scrollBar.content = _content;
			
			redraw();
			
			_content.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_display.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}
		
		private function onContentScrolled():void
		{
			_onScrolled.emit();
		}
		
		private var _initDragY:int = 0; 
		private var _initContentY:int = 0; 
		
		private function onMouseDown(event:MouseEvent):void
		{
			_initDragY = mouseY;
			_initContentY = _content.scrollRect.y;
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(Event.MOUSE_LEAVE, onMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseUp(event:Event):void
		{
			stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.removeEventListener(Event.MOUSE_LEAVE, onMouseUp);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_onScrolled.emit();
		}
		
		private function onEnterFrame(event:Event):void
		{
			if (int(mouseY) != _initDragY)
			{
				setScrollY(_initContentY - (mouseY - _initDragY));
			}
		}
		
		private function onMouseWheel(event:MouseEvent):void
		{
			event.delta > 0 ? _scrollBar.wheelUp() : _scrollBar.wheelDown();
		}
		
		public function reset():void
		{
			var rect:Rectangle = _content.scrollRect;
			rect.x = 0;
			rect.y = 0;
			_content.scrollRect = rect;
			redraw();
			_scrollBar.reset();
		}
		
		override public function redraw():void
		{
			super.redraw();
			
			if (_content)
			{
				if (_content.height > _height)
				{
					_scrollBar.barSize = _height/_content.height;
				}
				else _scrollBar.barSize = 1;
				
				var scrollRect:Rectangle = _content.scrollRect;
				scrollRect.width = _width - _scrollBar.width;
				scrollRect.height = _height;
				
				_content.scrollRect = scrollRect;
			}
			_scrollBar.x = _width - _scrollBar.width;
			_scrollBar.height = _height;
		}
		
		public function setScrollY(value:int):void 
		{
			_scrollBar.setValue(value);
			redraw();
		}
		
		public function get content():Sprite
		{
			return _content;
		}
		
		public function get onScrolled():SG_Signal
		{
			return _onScrolled;
		}
	}
}
