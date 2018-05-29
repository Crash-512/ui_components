package smart.gui.components.scroll 
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	
	import smart.gui.utils.SG_Math;
	import smart.gui.cursor.SG_CursorType;
	import smart.gui.cursor.SG_Mouse;
	import smart.tweener.SP_Tweener;
	
	public class SG_Scroller extends Sprite
	{
		public var smoothScroll:Number = 0.1;
		public var scrollSpeed:uint = 26;
		public var enableCursorResize:Boolean = true;
		
		private var _content:Sprite;
		private var cursor:Sprite;
		private var _autoHide:Boolean;
		private var enableShow:Boolean = true;
		private var isScrolling:Boolean;
		private var isOver:Boolean;
		private var manual:Boolean = true;
		private var nextPos:int;
		private var maskSprite:Shape;
		private var bar:Sprite;
		private var minPos:int;
		private var maxPos:int;
		private var delta:int;
		private var contentArea:int;

		private var scrollArea:int;
		private var vertical:Boolean;
		private var scrollPos:int;
		private var oldScrollPos:int;
		private var autoScroll:Boolean;
		
		private static const SCROLL_SIZE:int = 12;
		private static const SHOW_TIME:int = 12;
		private static const BAR_ALPHA:Number = 0.0;
		private static const DEFAULT_CURSOR_SIZE:int = 40;
		private static const HIDE_TIME:int = 10;
		
		
		public function SG_Scroller(content:Sprite, maskSprite:Shape, vertical:Boolean = true) 
		{
			_content = content;
			this.maskSprite = maskSprite;
			this.vertical = vertical;
			alpha = 0;
			
			if (content.parent) init();
			else				content.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event = null):void
		{
			if (_content.hasEventListener(Event.ADDED_TO_STAGE))
			{
				_content.removeEventListener(Event.ADDED_TO_STAGE, init);
			}
			maxPos = y;
			maskSprite.parent.addChild(this);
			
			if (vertical) 
			{
				cursor = new ScrollCursorV();
				cursor.height = DEFAULT_CURSOR_SIZE;
				y = maskSprite.y;
			}
			else
			{
				cursor = new ScrollCursorH();
				cursor.width = DEFAULT_CURSOR_SIZE;
				x = maskSprite.x;
			}
			
			bar = new Sprite();
			mouseEnabled = false;
			addChild(bar);
			addChild(cursor);
			
			bar.addEventListener(MouseEvent.MOUSE_DOWN, clickToBar);
			cursor.addEventListener(MouseEvent.MOUSE_DOWN, clickToCursor);
			_content.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
		}
		
		public function set content(sprite:Sprite):void 
		{
			if (_content != sprite)
			{
				_content.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
				_content = sprite;
				_content.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
			}
		}
		
		public function update(event:Event = null):void
		{
			var maskSize:int;
			var contentSize:int;
			
			if (vertical)
			{
				minPos = getMinPosV();
				maskSize = maskSprite.height;
				contentSize = _content.height;
				if (enableCursorResize) cursor.height = Math.round((maskSize/contentSize*maskSize));
				
				contentArea = Math.abs(minPos) + maxPos;
				scrollArea = (maskSize - cursor.height);
				redrawBar(SCROLL_SIZE, maskSize);
				
				x = maskSprite.x + (maskSprite.width - SCROLL_SIZE) - 1 + SCROLL_SIZE;
				
				if (contentArea != 0) cursor.y = Math.round(Math.abs((_content.y - maxPos)/contentArea) * scrollArea);
				
				if (cursor.y > scrollArea)
				{
					scrollTo(new Point(0, scrollArea));
					cursor.y = scrollArea;
				}
			}
			else
			{
				minPos = getMinPosH();
				maskSize = maskSprite.width;
				contentSize = _content.width;
				if (enableCursorResize) cursor.width = Math.round((maskSize/contentSize*maskSize));
				
				contentArea = Math.abs(minPos) + maxPos;
				scrollArea = (maskSize - cursor.width);
				redrawBar(maskSize, SCROLL_SIZE);
				
				y = maskSprite.y + (maskSprite.height) - 1;
				
				if (contentArea != 0) cursor.x = Math.round(Math.abs((_content.x - maxPos)/contentArea) * scrollArea);
				
				if (cursor.x > scrollArea)
				{
					scrollTo(new Point(scrollArea, 0));
					cursor.x = scrollArea;
				}
			}
			if (maskSize > contentSize)
			{
				if (enableShow)
				{
					enableShow = false;
					hideScroll(0);
					scrollTo(new Point());
				}
			}
			else if (!enableShow)
			{
				enableShow = true;
				if (isOver) showScroll();
			}
		}
		
		public function reset():void 
		{
			scrollTo(new Point(), false);
		}
		
		private function showScroll():void
		{
			SP_Tweener.remove(this);
			SP_Tweener.addTween(this, {alpha:1}, {time:SHOW_TIME});
		}
		
		private function hideScroll(delay:int):void
		{
			if (alpha != 1) delay = 0;
			
			SP_Tweener.remove(this);
			SP_Tweener.addTween(this, {alpha:0}, {time:SHOW_TIME, delay:delay});
		}
		
		public function scrollUp():void
		{
			scrollPos += scrollSpeed;
			if (scrollPos > 0) scrollPos = 0;
			
			if (scrollPos != 0) scrollPos -= scrollPos % scrollSpeed;
			
			if ((vertical && _content.y != scrollPos) || (!vertical && _content.x != scrollPos)) startScroll();
			manual = false;
		}
		
		public function scrollDown():void
		{
			var minScrollPos:int = 0;
			
			if (vertical)	minScrollPos = getMinPosV();
			else			minScrollPos = getMinPosH();
			
			if (minScrollPos < -minScrollPos)
			{
				scrollPos -= scrollSpeed;
				if (scrollPos < minScrollPos) scrollPos = minScrollPos;
			}
			
			if (scrollPos != minScrollPos) scrollPos -= scrollPos % scrollSpeed;
			
			if ((vertical && _content.y != scrollPos) || (!vertical && _content.x != scrollPos)) startScroll();
			manual = false;
		}
		
		private function mouseWheel(event:MouseEvent):void 
		{
			if (event.delta < 0)	scrollDown();
			else					scrollUp();
		}
		
		public function scrollTo(point:Point, smooth:Boolean = true):void
		{
			var rect:Rectangle = maskSprite.getRect(_content);
			
			point = _content.globalToLocal(point);
			rect.bottom -= 2;
			
			if (!rect.containsPoint(point))
			{
				scrollPos = -point.y + maskSprite.height/2;
				
				var minPos:int = getMinScrollPos();
				
				if (scrollPos < minPos) scrollPos = minPos;
				if (scrollPos > 0)		scrollPos = 0;
				
				if (smooth)
				{
					manual = false;
					startScroll();
					
					var event:SG_ScrollEvent = new SG_ScrollEvent(SG_ScrollEvent.START_SCROLL);
					dispatchEvent(event);
					autoScroll = true;
				}
				else
				{
					var value:Number;
					
					if (vertical)
					{
						value = scrollPos;
						
						if (scrollPos < _content.y)	_content.y = Math.floor(value);
						else						_content.y = Math.ceil(value);
					}
					else
					{
						value = scrollPos;
						
						if (scrollPos < _content.x)	_content.x = Math.floor(value);
						else						_content.x = Math.ceil(value);
					}
				}
			}
		}
		
		private function startScroll():void
		{
			if (!hasEventListener(Event.ENTER_FRAME)) addEventListener(Event.ENTER_FRAME, scrolling);
		}
		
		private function scrolling(event:Event):void
		{
			var value:Number;
			
			if (vertical)
			{
				value = SG_Math.smoothMove(_content.y, scrollPos, smoothScroll, false);
				
				if (scrollPos < _content.y)	_content.y = Math.floor(value);
				else						_content.y = Math.ceil(value);
				
				if (_content.y == scrollPos) stopScroll();
			}
			else
			{
				value = SG_Math.smoothMove(_content.x, scrollPos, smoothScroll, false);
				
				if (scrollPos < _content.x)	_content.x = Math.floor(value);
				else						_content.x = Math.ceil(value);
				
				if (_content.x == scrollPos) stopScroll();
			}
			if (!manual) update();
		}
		
		private function stopScroll():void
		{
			if (autoScroll)
			{
				var event:SG_ScrollEvent = new SG_ScrollEvent(SG_ScrollEvent.STOP_SCROLL);
				dispatchEvent(event);
				autoScroll = false;
			}
			
			removeEventListener(Event.ENTER_FRAME, scrolling);
		}
		
		private function clickToBar(event:MouseEvent):void 
		{
			if (vertical)	delta = cursor.height/2;
			else			delta = cursor.width/2;
			startManualScroll();
		}
		
		internal function startHandScroll(event:MouseEvent):void 
		{
			if (vertical)	delta = mouseY;
			else			delta = mouseX;

			oldScrollPos = scrollPos;

			SG_Mouse.setCursor(SG_CursorType.HAND);
			
			stage.addEventListener(MouseEvent.MIDDLE_MOUSE_UP, stopHandScroll);
			stage.addEventListener(Event.MOUSE_LEAVE, stopHandScroll);
			stage.addEventListener(Event.ENTER_FRAME, handScroll);
			update();
			
			isScrolling = true;
		}
		
		private function handScroll(event:Event):void
		{
			var contentPos:int = (vertical) ? _content.y : _content.x;
			var mousePos:int = (vertical) ? mouseY : mouseX;
			var newScrollPos:int = oldScrollPos + (mousePos - delta);

			if (newScrollPos < minPos) newScrollPos = minPos;
			if (newScrollPos > maxPos) newScrollPos = maxPos;

			scrollPos = newScrollPos;
			if (contentPos != scrollPos) startScroll();
		}
		
		private function stopHandScroll(event:Event):void
		{
			SG_Mouse.setCursor(SG_CursorType.ARROW);
			stage.removeEventListener(MouseEvent.MIDDLE_MOUSE_UP, stopHandScroll);
			stage.removeEventListener(Event.MOUSE_LEAVE, stopHandScroll);
			stage.removeEventListener(Event.ENTER_FRAME, handScroll);
			isScrolling = false;

			if (!isOver) hideScroll(SHOW_TIME);
		}
		
		private function clickToCursor(event:Event):void
		{
			if (vertical)	delta = mouseY - cursor.y;
			else			delta = mouseX - cursor.x;
			startManualScroll();
		}
		
		private function startManualScroll():void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, stopManualScroll);
			stage.addEventListener(Event.ENTER_FRAME, manualScroll);
			update();
			manual = true;
			isScrolling = true;
		}
		
		private function manualScroll(event:Event):void
		{
			if (vertical)
			{
				cursor.y = Math.round(mouseY - delta);
				if (cursor.y < 0)			cursor.y = 0;
				if (cursor.y > scrollArea)	cursor.y = scrollArea;
				
				scrollPos = -Math.abs(cursor.y/scrollArea) * contentArea + maxPos;
				if (_content.y != scrollPos) startScroll();
			}
			else
			{
				cursor.x = Math.round(mouseX - delta);
				if (cursor.x < 0)			cursor.x = 0;
				if (cursor.x > scrollArea)	cursor.x = scrollArea;
				
				scrollPos = -Math.abs(cursor.x/scrollArea) * contentArea + maxPos;
				if (_content.x != scrollPos) startScroll();
			}
		}
		
		private function stopManualScroll(event:MouseEvent):void
		{
			var stage:Stage = event.currentTarget as Stage;
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopManualScroll);
			stage.removeEventListener(Event.ENTER_FRAME, manualScroll);
			isScrolling = false;
			
			if (!isOver) hideScroll(SHOW_TIME);
		}
		
		private function getMinScrollPos():int
		{
			if (vertical)	return getMinPosV();
			else			return getMinPosH();
		}
		
		private function getMinPosV():int
		{
			var value:int = maxPos + (maskSprite.height - _content.height);
			if (value > maxPos) value %= maxPos;
			return value;
		}
		
		private function getMinPosH():int
		{
			var value:int = maxPos + (maskSprite.width - _content.width);
			if (value > maxPos) value %= maxPos;
			return value;
		}
		
		private function redrawBar(barWidth:int, barHeight:int):void
		{
			bar.graphics.clear();
			bar.graphics.beginFill(0, BAR_ALPHA);
			bar.graphics.drawRect(0, 0, barWidth, barHeight);
			bar.graphics.endFill();
		}
		
		private function overContent(event:Event):void
		{
			isOver = true;
			if (enableShow) showScroll();
		}
		
		private function outContent(event:Event = null):void
		{
			if (enableShow && !isScrolling) hideScroll(HIDE_TIME);
			isOver = false;
		}
		
		public function set autoHide(value:Boolean):void
		{
			_autoHide = value;
			
			if (value)
			{
				alpha = 0;
				parent.addEventListener(MouseEvent.MOUSE_OVER, overContent);
				parent.addEventListener(MouseEvent.MOUSE_OUT, outContent);
			}
			else
			{
				alpha = 1;
				
				if (hasEventListener(MouseEvent.MOUSE_OVER))
				{
					parent.removeEventListener(MouseEvent.MOUSE_OVER, overContent);
					parent.removeEventListener(MouseEvent.MOUSE_OUT, outContent);
				}
			}
		}
		
		public function get autoHide():Boolean
		{
			return _autoHide;
		}
		
	}
}