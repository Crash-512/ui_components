package smart.modern_gui.base
{
	import smart.modern_gui.mg_internal;
	
	use namespace mg_internal;
	
	public class MG_ResizableComponent extends MG_Component
	{
		public var forceRedraw:Boolean;
		
		mg_internal var _newWidth:int;
		mg_internal var _newHeight:int;
		
		protected var _width:int;
		protected var _height:int;
		protected var _minWidth:int;
		protected var _minHeight:int;
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
		
		override mg_internal function applyChanges():void 
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
		
		public function setAutoSize(autoWidth:int, autoHeight:int):void 
		{
			_autoWidth = autoWidth;
			_autoHeight = autoHeight;
			resizeParentChildren();
			redraw();
		}
		
		[Inline] final protected function resizeParentChildren():void
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
		
		public function set autoWidth(value:Boolean):void
		{
			_autoWidth = value;
			resizeParentChildren();
		}
		
		public function get autoWidth():Boolean
		{
			return _autoWidth;
		}
		
		public function set autoHeight(value:Boolean):void
		{
			_autoHeight = value;
			resizeParentChildren();
		}
		
		public function get autoHeight():Boolean
		{
			return _autoHeight;
		}
		
		public function set widthInPercent(value:uint):void
		{
			_widthInPercent = Math.min(value, 100);
			resizeParentChildren();
		}
		
		public function get widthInPercent():uint
		{
			return _widthInPercent;
		}
		
		public function set heightInPercent(value:uint):void
		{
			_heightInPercent = Math.min(value, 100);
			resizeParentChildren();
		}
		
		public function get heightInPercent():uint
		{
			return _heightInPercent;
		}
		
		public function set minWidth(value:int):void
		{
			_minWidth = value;
			resizeParentChildren();
		}
		
		public function get minWidth():int
		{
			return _minWidth;
		}
		
		public function set minHeight(value:int):void
		{
			_minHeight = value;
			resizeParentChildren();
		}
		
		public function get minHeight():int
		{
			return _minHeight;
		}
		
		public function set maxWidth(value:int):void
		{
			_maxWidth = value;
			resizeParentChildren();
		}
		
		public function get maxWidth():int
		{
			return _maxWidth;
		}
		
		public function set maxHeight(value:int):void
		{
			_maxHeight = value;
			resizeParentChildren();
		}
		
		public function get maxHeight():int
		{
			return _maxHeight;
		}
		
		[Inline] final mg_internal function set newWidth(value:int):void
		{
			_newWidth = value > _maxWidth ? _maxWidth : (value < _minWidth ? _minWidth : value);
		}
		
		mg_internal function get newWidth():int
		{
			return _newWidth;
		}
		
		[Inline] final mg_internal function set newHeight(value:int):void
		{
			_newHeight = value > _maxHeight ? _maxHeight : (value < _minHeight ? _minHeight : value);
		}
		
		mg_internal function get newHeight():int
		{
			return _newHeight;
		}
		
		public function set backgroundColor(value:uint):void
		{
			_backgroundColor = value;
			_hasBackground = true;
			redraw();
		}
		
		public function get backgroundColor():uint
		{
			return _backgroundColor;
		}
		
	}
}
