package smart.gui.base
{
	public class MG_ResizableComponent extends MG_Component
	{
		public var forceRedraw:Boolean;
		
		protected var _newWidth:int;
		protected var _newHeight:int;
		
		protected var _width:int;
		protected var _height:int;
		protected var _maxWidth:int;
		protected var _maxHeight:int;
		protected var _autoWidth:Boolean;
		protected var _autoHeight:Boolean;
		
		protected var _hasBackground:Boolean;
		protected var _backgroundColor:uint;
		
		  
		public function MG_ResizableComponent()
		{
			super();
			_autoWidth = true;
			_autoHeight = true;
			_maxWidth = int.MAX_VALUE;
			_maxHeight = int.MAX_VALUE;
		}
		
		override public function redraw():void
		{
			super.redraw();
			
			if (_hasBackground)
			{
				_display.drawRect(_backgroundColor, width, height);
			}
		}
		
		override internal function applyChanges():void
		{
			super.applyChanges();
			
			if (forceRedraw || _width != _newWidth || _height != _newHeight)
			{
				_width = _newWidth;
				_height = _newHeight;
				redraw();
			}
			else 
			{
				_width = _newWidth;
				_height = _newHeight;
			}
		}
		
		public function setSize(width:int, height:int):void 
		{
			if (forceRedraw || _width != width || _height != height)
			{
				_width = _newWidth = width;
				_height = _newHeight = height;
				redraw();
			}
			else
			{
				_width = _newWidth = width;
				_height = _newHeight = height;	
			}
		}
		
		protected function resizeParentChildren():void
		{
			if (container) container.updateChildren();
		}
		
		// *** PROPERTIES *** //
		
		public function set width(value:int):void
		{
			_width = value;
			_newWidth = value;
			redraw();
		}
		
		override public function get width():int
		{
			return _width;
		}
		
		public function set height(value:int):void
		{
			_height = value;
			_newHeight = value;
			redraw();
		}
		
		override public function get height():int
		{
			return _height;
		}
	}
}
