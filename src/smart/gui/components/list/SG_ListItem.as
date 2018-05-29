package smart.gui.components.list 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	import smart.tweener.SP_Tween;
	import smart.tweener.SP_Tweener;

	import smart.gui.components.list.history.SG_ListAction;
	import smart.gui.components.text.SG_TextRestrict;
	import smart.gui.skin.SG_GUISkin;

	public class SG_ListItem extends Sprite
	{
		public var id:int;
		public var rootFolder:String;
		public var enableRenaming:Boolean = true;
		public var enableDragging:Boolean = true;
		public var enableRemove:Boolean = true;
		public var label:SG_ListLabel;
		public var isFolder:Boolean;
		public var isRoot:Boolean;
		public var isEmpty:Boolean;
		public var lock:Boolean;
		public var container:Sprite;
		public var prev:SG_ListItem;
		public var next:SG_ListItem;
		public var data:Object;

		protected var _enabled:Boolean = true;
		protected var _folder:SG_ListFolder;
		protected var _name:String;
		protected var _width:int = 180;
		protected var _height:int = 26;
		protected var _depth:int = -1;
		protected var _highlight:Boolean;
		protected var _selected:Boolean;
		protected var size:int = 0;
		protected var icon:MovieClip;
		protected var preset:SG_ListPreset;
		protected var iconPos:int;
		protected var labelPos:int;
		protected var background:Sprite;
		protected var labelMarginRight:int = 14;
		protected var labelMargin:int;

		protected var _list:SG_List;
		protected var action:SG_ListAction;
		
		internal var alphaTween:SP_Tween;
		internal var fastRefresh:Boolean;

		
		public function SG_ListItem(text:String = null, list:SG_List = null, sizePreset:SG_ListPreset = null, icon:MovieClip = null)
		{
			_list = list;
			preset = sizePreset;

			if (text) initItem(text, size, icon);
		}
		
		public function destroy(full:Boolean = false):void
		{

		}
		
		public function setSkin(skin:SG_GUISkin):void 
		{
			redraw();
			if (label) label.color = skin.textColor;
		}
		
		private function initItem(text:String, size:int, icon:MovieClip):void
		{
			this.size = size;
			this.name = text;
			
			container = new Sprite();
			addChild(container);
			
			updateBackground();
			redraw();
			height = preset.itemHeight;
			
			label = new SG_ListLabel(text, preset.textStyle);
			label.restrict = SG_TextRestrict.ALL;
			label.enableReduction = true;
			labelMargin = Math.ceil((background.height - label.height)/2);
			label.y = labelMargin;
			addChild(label);
			
			if (_list) label.color = _list.skin.textColor;
			if (icon)  setIcon(icon);
			
			refreshDepth();
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

				if (_list.style.enableSeparators)
				{
					background.graphics.beginFill(_list.style.separatorColor);
					background.graphics.drawRect(0, 0, _width, 1);
					background.graphics.endFill();
				}
			}
		}
		
		public function clone():SG_ListItem
		{
			var item:SG_ListItem = new SG_ListItem(name, list, preset, cloneIcon());
			cloneSettings(item);
			return item;
		}
		
		protected function cloneSettings(item:SG_ListItem):void
		{
			item.enableRenaming = enableRenaming;
			item.enableDragging = enableDragging;
			item.enableRemove = enableRemove;
			item.isFolder = isFolder;
			item.isRoot = isRoot;
			item.isEmpty = isEmpty;
			item.id = id;
			item.data = data;

			item.rootFolder = rootFolder;
		}
		
		protected function cloneIcon():MovieClip
		{
			if (icon)
			{
				var className:String = getQualifiedClassName(icon);
				var iconClass:Class = getDefinitionByName(className) as Class;
				return new iconClass();
			}
			else return null;
		}
		
		public function getXML():XML
		{
			var itemXML:XML = <item name={name} />;
			return itemXML;
		}
		
		public function remove(destroy:Boolean = true):void 
		{
			if (folder)	folder.removeItem(this, destroy);
		}
		
		public function getPosition():Point
		{
			return new Point(x, y);
		}
		
		public function rename(selectAll:Boolean = false):void
		{
			if (!lock && enableRenaming)
			{
				if (isFolder && !_list.enableRenameFolders) return;
				if (!isFolder && !_list.enableRenameItems)	return;
				
				lock = true;
				
				var listEvent:SG_ListEvent = new SG_ListEvent(SG_ListEvent.START_RENAMING);
				listEvent.item = this;
				_list.dispatchEvent(listEvent);
				
				if (stage)
				{
					action = new SG_ListAction(this, SG_ListAction.RENAME);
					label.textField.backgroundColor = _list.style.itemColor;
					label.rename(selectAll);
					label.addEventListener(SG_ListEvent.STOP_RENAMING, stopRenaming);
				}
				else addEventListener(Event.ADDED_TO_STAGE, renameAfterAdded);
			}
		}
		
		private function stopRenaming(event:Event):void
		{
			if (label.text == "") label.text = "Новый элемент";

			lock = false;
			label.removeEventListener(SG_ListEvent.STOP_RENAMING, stopRenaming);

			var listEvent:SG_ListEvent = new SG_ListEvent(SG_ListEvent.STOP_RENAMING);
			listEvent.item = this;
			_list.dispatchEvent(listEvent);
			_list.saveHistory(action); // RENAME

			updateLabelWidth();
		}
		
		protected function setIcon(icon:MovieClip, mouseEnabled:Boolean = false):void
		{
			this.icon = icon;

			if (icon.height > preset.iconSize)
			{
				icon.height = preset.iconSize;
				icon.scaleX = icon.scaleY;
			}
			if (icon.width > preset.iconSize)
			{
				icon.width = preset.iconSize;
				icon.scaleY = icon.scaleX;
			}
			icon.mouseChildren = mouseEnabled;
			icon.mouseEnabled = mouseEnabled;
			icon.x = preset.iconMargin;
			icon.y = preset.iconMargin;
			container.addChild(icon);

			labelMargin /= 2;
			labelMargin += preset.iconMargin + preset.iconSize;
		}
		
		protected function refreshDepth():void
		{
			var margin:int = _depth * preset.depthMargin;

			iconPos = preset.iconMargin + margin;
			labelPos = labelMargin + margin;

			if (icon)
			{
				SP_Tweener.remove(icon);
				icon.x = iconPos;
			}
			SP_Tweener.remove(label);
			label.x = labelPos;
			updateLabelWidth();
		}
		
		private function addEvents():void
		{
			background.doubleClickEnabled = true;
			container.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			container.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			container.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			container.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, rightMouseDown);
			background.addEventListener(MouseEvent.DOUBLE_CLICK, doubleClick);
		}
		
		protected function removeEvents():void
		{
			container.removeEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			container.removeEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			container.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			container.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, rightMouseDown);
			background.removeEventListener(MouseEvent.DOUBLE_CLICK, doubleClick);
		}
		
		private function renameAfterAdded(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, renameAfterAdded);
			rename(true);
		}
		
		public function showItem():void
		{
			alpha = 0;
			SP_Tweener.addTween(this,  {alpha:1}, {time:12, priority:true, delay:8});
		}
		
		internal function updateSize():void
		{
			width = _list.width;
			updateLabelWidth();
		}
		
		protected function mouseOver(event:MouseEvent):void 
		{
			if (!selected && _list.enableHighlight)	highlight = true;
		}
		
		protected function mouseOut(event:MouseEvent):void 
		{
			if (!selected && _list.enableHighlight) highlight = false;
		}
		
		protected function mouseDown(event:MouseEvent):void 
		{
			_list.selectItem(this, true);
		}
		
		private function rightMouseDown(event:MouseEvent):void
		{
			_list.selectItem(this, false);
		}
		
		protected function updateLabelWidth():void
		{
			if (label) label.width = _width - labelPos - labelMarginRight;
		}
		
		private function doubleClick(event:MouseEvent):void
		{
			if (!_list.waiting) rename();
		}
		
		override public function toString():String
		{
			return name;
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
			
			if (_list.enableHighlight) highlight = _selected;
		}
		
		public function set depth(value:int):void
		{
			_depth = value;
			refreshDepth();
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
		
		public function get depth():int
		{
			return _depth;
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
		
		public function get folderID():int
		{
			if (folder) return folder.id;
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