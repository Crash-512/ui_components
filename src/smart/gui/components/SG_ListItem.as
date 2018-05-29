package smart.gui.components
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import smart.gui.skin.SG_GUISkin;
	
	public class SG_ListItem extends Sprite
	{
		public var rootFolder:String;
		public var label:SG_TextLabel;
		public var isFolder:Boolean;
		public var isRoot:Boolean;
		public var container:Sprite;
		public var prev:SG_ListItem;
		public var next:SG_ListItem;

		protected var _enabled:Boolean = true;
		protected var _folder:SG_ListFolder;
		protected var _name:String;
		protected var _width:int = 180;
		protected var _height:int = 26;
		protected var _highlight:Boolean;
		protected var _selected:Boolean;
		protected var size:int = 0;
		protected var labelPos:int;
		protected var background:Sprite;
		protected var labelMarginRight:int = 14;
		protected var labelMargin:int;
		protected var _list:SG_List;
		
		public function SG_ListItem(text:String = null, list:SG_List = null)
		{
			_list = list;
			if (text) initItem(text, size);
		}
		
		public function setSkin(skin:SG_GUISkin):void
		{
			redraw();
			if (label) label.color = skin.textColor;
		}
		
		private function initItem(text:String, size:int):void
		{
			this.size = size;
			this.name = text;
			
			container = new Sprite();
			addChild(container);
			
			updateBackground();
			redraw();
			height = 20;
			
			label = new SG_TextLabel(text, SG_TextStyle.listItem);
			label.enableReduction = true;
			labelMargin = Math.ceil((background.height - label.height)/2);
			label.y = labelMargin;
			addChild(label);
			
			if (_list) label.color = _list.skin.textColor;
			
			addEvents();
		}
		
		internal function updateBackground():void
		{
			if (background && container.contains(background)) container.removeChild(background);

			background = new Sprite();
			container.addChildAt(background, 0);
		}
		
		internal function redraw():void
		{
			if (background)
			{
				background.graphics.clear();

				if (highlight)	background.graphics.beginFill(_list.style.highlightColor);
				else			background.graphics.beginFill(_list.style.itemColor);

				background.graphics.drawRect(0, 0, _width, _height);
				background.graphics.endFill();
			}
		}
		
		private function addEvents():void
		{
			background.doubleClickEnabled = true;
			container.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			container.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			container.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
		}
		
		protected function removeEvents():void
		{
			container.removeEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			container.removeEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			container.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
		}
		
		internal function updateSize():void
		{
			width = _list.width;
			updateLabelWidth();
		}
		
		protected function mouseOver(event:MouseEvent):void 
		{
			if (!selected)	highlight = true;
		}
		
		protected function mouseOut(event:MouseEvent):void 
		{
			if (!selected) highlight = false;
		}
		
		protected function mouseDown(event:MouseEvent):void 
		{
			_list.selectItem(this, true);
		}
		
		protected function updateLabelWidth():void
		{
			if (label) label.width = _width - labelPos - labelMarginRight;
		}
		
		// *** PROPERTIES *** //

		override public function set width(value:Number):void
		{
			_width = value;
			redraw();
			updateLabelWidth();
		}
		
		override public function set height(value:Number):void
		{
			_height = value;
			redraw();
		}
		
		public function set text(value:String):void
		{
			label.text = value;
		}
		
		public function set selected(value:Boolean):void 
		{
			_selected = value;
			highlight = _selected;
		}
		
		public function set highlight(value:Boolean):void
		{
			_highlight = value;
			redraw();
		}
		
		override public function set name(value:String):void
		{
			if (label) label.text = value;
			_name = value;
		}
		
		public function set folder(value:SG_ListFolder):void 
		{
			_folder = value;
		}
		
		public function set enabled(value:Boolean):void
		{
			if (_enabled && !value) removeEvents();
			if (!_enabled && value) addEvents();
			
			_enabled = value;
			label.alpha = (_enabled) ? 1 : 0.5;
		}
		
		public function set list(value:SG_List):void
		{
			_list = value;
		}
		
		override public function get width():Number
		{
			return background.width;
		}
		
		override public function get height():Number
		{
			return background.height;
		}
		
		public function get text():String
		{
			return label.text;
		}
		
		public function get selected():Boolean 
		{
			return _selected;
		}
		
		public function get highlight():Boolean
		{
			return _highlight;
		}
		
		override public function get name():String
		{
			if (label) return label.text;
			return _name;
		}
		
		public function get folder():SG_ListFolder 
		{
			return _folder;
		}
		
		public function get childIndex():int
		{
			if (parent) return parent.getChildIndex(this);
			return 0;
		}
		
		public function get list():SG_List
		{
			return _list;
		}
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
	}
}