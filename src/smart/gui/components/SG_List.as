package smart.gui.components
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import smart.gui.constants.SG_SkinType;
	import smart.gui.skin.SG_GUISkin;
	
	public class SG_List extends SG_Component
	{
		protected var container:Sprite;
		protected var _rootFolder:SG_ListFolder;
		protected var _defaultMessage:SG_TextLabel;
		protected var scroller:SG_Scroller;
		protected var content:Sprite;
		
		public var isComboBox:Boolean;
		public var listMask:Shape;
		public var selectedItem:SG_ListItem;
		public var style:SG_ListStyle;
		public var currentFolder:SG_ListFolder;
		
		public function SG_List()
		{
			_skinType = SG_SkinType.LIST;
			redrawSkin();
			initList();
			type = SG_ComponentType.LIST;
		}
		
		override public function setSkin(skin:SG_GUISkin):void
		{
			super.setSkin(skin);
			rootFolder.setSkin(skin);
		}
		
		private function initList():void
		{
			// Sprites
			container = new Sprite();
			content = new Sprite();
			listMask = new Shape();

			addChild(container);
			container.addChild(_componentSkin);
			container.addChild(content);
			container.addChild(listMask);
			content.mask = listMask;
			
			// Root folder
			initRootFolder();
			content.addChild(_rootFolder);
			_rootFolder.name = "root";
			_rootFolder.x = 1;
			_rootFolder.width = _width;
			currentFolder = _rootFolder;
			
			// Scroll Pane
			scroller = new SG_Scroller(_rootFolder, listMask);
			scroller.enableCursorResize = false;

			// Controllers
			style = new SG_ListStyle(this);

			// Events
			addEventListener(Event.ADDED_TO_STAGE, init);
			_componentSkin.addEventListener(MouseEvent.CLICK, resetSelection);
		}
		
		protected function initRootFolder():void
		{
			_rootFolder = new SG_ListFolder(null, this);
		}
		
		private function init(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			updateScroll();
			stage.stageFocusRect = false;
		}
		
		public function getItemsList(withClosed:Boolean = true, withFolders:Boolean = true, withItems:Boolean = true):Array
		{
			return rootFolder.getItemsList(withClosed, withFolders, withItems);
		}
		
		public function refresh():void
		{
			var items:Array = getItemsList(false, true, false);
			var folder:SG_ListFolder;
			
			for (var i:int = items.length-1; i>=0; i--)
			{
				folder = items[i];
				folder.refresh();
			}
		}
		
		public function resetScroll():void
		{
			scroller.reset();
		}
		
		public function set rootFolder(folder:SG_ListFolder):void
		{
			if (_rootFolder != folder || !content.contains(folder))
			{
				if (_rootFolder && content.contains(_rootFolder)) content.removeChild(_rootFolder);
				
				_rootFolder = folder;
				_rootFolder.list = this;
				content.addChild(_rootFolder);
				_rootFolder.width = _width;
				resetSelection();
				scroller.content = _rootFolder;
			}
		}
		
		public function resetSelection(event:MouseEvent = null):void
		{
			if (event) return;
			
			if (selectedItem) 
			{
				selectedItem.selected = false;
				selectedItem = null;
			}
			currentFolder = _rootFolder;
		}
		
		public function lockList(timeout:Boolean = false):void
		{
			_rootFolder.mouseEnabled = false;
			_rootFolder.mouseChildren = false;
		}
		
		public function unlockList():void
		{
			_rootFolder.mouseEnabled = true;
			_rootFolder.mouseChildren = true;
		}
		
		public function updateScroll():void
		{
			if (stage) scroller.update();
		}
		
		internal function setCurrentFolder(item:SG_ListItem):void
		{
			if (item.isFolder && (item as SG_ListFolder).opened)
			{
				currentFolder = selectedItem as SG_ListFolder;
			}
			else if (selectedItem) currentFolder = selectedItem.folder;
			
			if (!currentFolder) currentFolder = _rootFolder;
		}
		
		public function selectItemAt(index:int, event:Boolean = true):SG_ListItem
		{
			var item:SG_ListItem = getItemAt(index);
			if (item) selectItem(item, false, event);
			return item;
		}
		
		public function selectItem(item:SG_ListItem, dragItem:Boolean = false, event:Boolean = true):void
		{
			if (!selectedItem || selectedItem != item)
			{
				if (selectedItem) selectedItem.selected = false;
				selectedItem = item;
				selectedItem.selected = true;
				setCurrentFolder(selectedItem);
			}
			if (event) 
			{
				dispatchEvent(new SG_ListEvent(SG_ListEvent.SELECT_ITEM));
			}
		}
		
		public function addItem(label:String):SG_ListItem
		{
			return currentFolder.addItem(label);
		}
		
		public function getItemAt(index:uint):SG_ListItem
		{
			return _rootFolder.getItemAt(index);
		}
		
		override public function getRect(sprite:DisplayObject):Rectangle
		{
			return _componentSkin.getRect(sprite);
		}
		
		override public function setSize(width:uint, height:uint = 0):void 
		{
			this.width = width;
			this.height = height;
		}
		
		public function getItemByName(name:String, subFolders:Boolean = true):SG_ListItem 
		{
			return rootFolder.getItemByName(name, subFolders);
		}

		// *** PROPERTIES *** //
		
		override public function set width(value:Number):void
		{
			_width = value;
			_componentSkin.width = value;
			style.redrawList();
			_rootFolder.width = value;
			updateScroll();
		}
		
		override public function set height(value:Number):void
		{
			_height = value;
			_componentSkin.height = value;
			style.redrawList();
			if (!isComboBox) updateScroll();
		}
		
		public function get length():int
		{
			return _rootFolder.length;
		}
		
		override public function get width():Number
		{
			return _componentSkin.width;
		}
		
		override public function get height():Number
		{
			return _componentSkin.height;
		}
		
		public function get rootFolder():SG_ListFolder
		{
			return _rootFolder;
		}
	}
}