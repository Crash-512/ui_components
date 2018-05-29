package smart.gui.components.scroll
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	import smart.gui.components.SG_Component;
	import smart.gui.constants.SG_CornersType;
	import smart.gui.constants.SG_SkinType;

	public class SG_ScrollPane extends SG_Component
	{
		private var _scroller:SG_Scroller;
		private var _cornersType:uint;
		private var vertical:Boolean;
		private var content:Sprite;
		private var container:Sprite;
		private var contentMask:Shape;
		
		  
		public function SG_ScrollPane(width:uint, height:uint, cornersType:uint = 0, vertical:Boolean = true)
		{
			this.vertical = vertical;
			_cornersType = cornersType;
			init();
			setSize(width, height);
		}
		
		private function init():void
		{
			_skinType = SG_SkinType.PANE;
			redrawSkin();
			_componentSkin.currentState = _cornersType;
			
			container = new Sprite();
			container.x = 1;
			container.y = 1;
			super.addChild(container);

			content = new Sprite();
			container.addChild(content);
			
			contentMask = new Shape();
			content.mask = contentMask;
			container.addChild(contentMask);
			
			_scroller = new SG_Scroller(content, contentMask, vertical);
			_scroller.enableCursorResize = false;
			_scroller.autoHide = true;

			container.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, _scroller.startHandScroll);
		}
		
		public function updateScroller():void 
		{
			_scroller.update();
		}
		
		protected function redrawMask():void
		{
			var canvas:Graphics = contentMask.graphics;
			var cornerSize:uint = 6;
			var topSize:Number = 0 ;
			var bottomSize:Number = 0;
			
			switch (_cornersType)
			{
				case SG_CornersType.TOP_AND_BOTTOM: 
				{
					topSize = cornerSize;
					bottomSize = cornerSize;
					break;
				}
				case SG_CornersType.ONLY_TOP:
				{
					topSize = cornerSize;
					break;
				}
				case SG_CornersType.ONLY_BOTTOM:
				{
					bottomSize = cornerSize;
					break;
				}
			}
			canvas.clear();
			canvas.beginFill(0x000000);
			canvas.drawRoundRectComplex(0, 0, width - 2, height - 2, topSize, topSize, bottomSize, bottomSize);
			canvas.endFill();
		}
		
		override public function setSize(width:uint, height:uint = 0):void
		{
			super.setSize(width, height);
			redrawMask();
			updateScroller();
		}
		
		public function set scrollSpeed(value:uint):void 
		{
			_scroller.scrollSpeed = value;
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			redrawMask();
			updateScroller();
		}
		
		override public function set height(value:Number):void
		{
			super.height = value;
			redrawMask();
			updateScroller();
		}
		
		public function set cornersType(value:uint):void
		{
			_cornersType = value;
			_componentSkin.currentState = _cornersType;
		}
		
		public function get scroller():SG_Scroller
		{
			return _scroller;
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			return content.addChild(child);
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			return content.addChildAt(child, index);
		}
		
		override public function getChildAt(index:int):DisplayObject
		{
			return content.getChildAt(index);
		}
		
		override public function getChildIndex(child:DisplayObject):int
		{
			return content.getChildIndex(child);
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			return content.removeChild(child);
		}
		
		override public function removeChildAt(index:int):DisplayObject
		{
			return content.removeChildAt(index);
		}
		
		public function get cornersType():uint
		{
			return _cornersType;
		}
		
	}
}
