package smart.gui.components.list 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	import smart.gui.components.SG_CenterPoint;
	import smart.gui.components.SG_Component;
	import smart.gui.components.SG_ComponentType;
	import smart.gui.components.list.history.SG_ListAction;
	import smart.gui.components.scroll.SG_Scroller;
	import smart.gui.components.text.SG_TextLabel;
	import smart.gui.components.text.SG_TextStyle;
	import smart.gui.constants.SG_SkinType;
	import smart.gui.data.SP_DataProvider;
	import smart.gui.skin.SG_GUISkin;
	import smart.tweener.SP_Tween;
	import smart.tweener.SP_Tweener;
	
	public class SG_List extends SG_Component
	{
		protected var container:Sprite;
		protected var _rootFolder:SG_ListFolder;
		protected var _defaultMessage:SG_TextLabel;
		protected var _centerPoint:String = SG_CenterPoint.NULL;
		protected var expandTimeout:SP_Tween;
		
		protected var dragSystem:SG_ListDragSystem;
		protected var controller:SG_ListController;
		protected var scroller:SG_Scroller;
		
		public var itemClass:Class;
		public var folderClass:Class;
		public var folders:Object = {};
		public var items:Object = {};
		public var sortMode:int;
		public var isComboBox:Boolean;

		public var listMask:Shape;
		protected var content:Sprite;
		
		public var selectedItem:SG_ListItem;
		public var preset:SG_ListPreset;
		public var style:SG_ListStyle;
		public var currentFolder:SG_ListFolder;
		public var enableRemove:Boolean = true;
		public var enableResetSelection:Boolean = true;
		public var enableRenameItems:Boolean = true;	   // Разрешить переименовывание элементов
		public var enableRenameFolders:Boolean = true;	   // Разрешить переименовывание папок
		public var enableSubFolders:Boolean = true;		   // Разрешить вложенные папки
		public var enableHighlight:Boolean = true;		   // Подсветка элементов
		public var enableDragAndDrop:Boolean = true;	   // Разрешить перемещение
		public var enableDropToRoot:Boolean = true;		   // Перемещение элементов в корень
		public var enableDragOutside:Boolean = true;	   // Перемещение элементов в другой лист
		public var enableDropOutside:Boolean = true;	   // Перемещение элементов из другого листа
		public var enableKeyController:Boolean = true;	   // Управление листом с клавиатуры
		public var enableDragEvent:Boolean = true;
		
		internal var waiting:Boolean;
		
		public static const ITEM:String = "item";
		public static const FOLDER:String = "folder";

		
		public function SG_List(size:int = 1, defaultMessage:String = "", customPreset:SG_ListPreset = null) 
		{
			itemClass = SG_ListItem;
			folderClass = SG_ListFolder;
			
			if (customPreset)	preset = customPreset;
			else				preset = SG_ListPreset.PRESET[size];
			
			_skinType = SG_SkinType.LIST;
			redrawSkin();
			initList();
			initDefaultMessage(defaultMessage);
			addEventListener(SG_ListEvent.REFRESH, changeList);

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
			controller = new SG_ListController(this);
			dragSystem = new SG_ListDragSystem(this, _rootFolder, scroller);
			addChild(dragSystem);

			// Events
			addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(SG_ListEvent.START_RENAMING, controller.lock);
			addEventListener(SG_ListEvent.STOP_RENAMING, controller.unlock);
			_componentSkin.addEventListener(MouseEvent.CLICK, resetSelection);
		}
		
		private function updateCenterPoint():void
		{
			SG_CenterPoint.updateCenter(container, _centerPoint, _componentSkin.getRect(container));
		}
		
		protected function initRootFolder():void
		{
			_rootFolder = new SG_ListFolder(null, this, preset);
		}
		
		private function init(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			updateScroll();

			addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			stage.focus = this;
			stage.stageFocusRect = false;
		}
		
		public function focusOnItem(item:SG_ListItem):void 
		{
			var folder:SG_ListFolder = item.folder;
			
			do
			{
				folder.opened = true;
				folder = folder.folder;
			}
			while (folder && folder != rootFolder);
			
			refresh();
			selectItem(item);
			scrollTo(item);
		}
		
		public function sortList():void
		{
			
		}
		
		public function getItemsList(withClosed:Boolean = true, withFolders:Boolean = true, withItems:Boolean = true):Array 
		{
			return rootFolder.getItemsList(withClosed, withFolders, withItems);
		}
		
		public function getArray():Array
		{
			return _rootFolder.getArray();
		}
		
		public function refresh():void
		{
			var items:Array = getItemsList(false, true, false);
			var folder:SG_ListFolder;
			
			for (var i:int = items.length-1; i>=0; i--)
			{
				folder = items[i];
				folder.refresh(true);
			}
			if (expandTimeout)
			{
				expandTimeout.destroy();
				expandTimeout = null;
			}
			expandTimeout = SP_Tweener.addTimeout(SG_ListFolder.EXPAND_TIME, stopWaiting);
		}
		
		public function saveHistory(action:SG_ListAction):void
		{
			action.parseEndVars();
			
			if (action.correct)
			{
				var event:SG_ListEvent = new SG_ListEvent(SG_ListEvent.SAVE_HISTORY);
				event.action = action;
				dispatchEvent(event);
			}
		}
		
		private function initDefaultMessage(defaultMessage:String):void 
		{
			_defaultMessage = new SG_TextLabel(defaultMessage, SG_TextStyle.list_message);
			_defaultMessage.centerPoint = SG_CenterPoint.CENTER;
		}
		
		private function changeList(event:SG_ListEvent = null):void 
		{
			if (_rootFolder.length == 0)
			{
				_defaultMessage.x = Math.round(_componentSkin.width/2);
				_defaultMessage.y = Math.round(_componentSkin.height/2);
				addChild(_defaultMessage);
			}
			else if (_defaultMessage.parent) removeChild(_defaultMessage);
		}
		
		public function resetScroll():void
		{
			scroller.reset();
		}
		
		public function dropItem(item:SG_ListItem):void 
		{
			addDroppedItem(item);
		}
		
		protected function addDroppedItem(item:SG_ListItem):void
		{
			if (selectedItem) selectedItem.selected = false;
			
			selectedItem = item;
			selectedItem.selected = true;
			dragSystem.selectedItem = item;
			
			if (!dragSystem.dragTarget)
			{
				dragSystem._dragType = SG_ListDragSystem.PLUS;
				dragSystem.dragTarget = _rootFolder;
			}
			dragSystem.stopDragging();
		}
		
		public function stopDragOutside():void
		{
			dragSystem.dragTarget = null;
			dragSystem.stopDragging();
			dragSystem.selectedItem = null;
		}
		
		public function dragOutside(object:SG_ListItem):void 
		{
			if (!dragSystem.isDragging)
			{
				dragSystem.selectedItem = object;
				dragSystem.initDragging();
			}
			dragSystem.dragging();
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
				dragSystem.rootFolder = _rootFolder;
				scroller.content = _rootFolder;
			}
		}
		
		protected function keyDown(event:KeyboardEvent):void 
		{
			if (selectedItem && !controller.locked && enableKeyController)
			{
				switch (event.keyCode)
				{
					case Keyboard.LEFT:		controller.prevFolder(selectedItem);		break;
					case Keyboard.RIGHT:	controller.nextFolder(selectedItem);		break;
					case Keyboard.DELETE:	if (enableRemove) tryToRemoveItem();		break;
					case Keyboard.F2:		if (selectedItem) selectedItem.rename();    break;
					case Keyboard.UP:		
					{
						if (event.ctrlKey)  controller.moveUp(selectedItem);
						else                controller.selectPrevItem(selectedItem);
						break;
					}	
					case Keyboard.DOWN:
					{
						if (event.ctrlKey)  controller.moveDown(selectedItem);
						else                controller.selectNextItem(selectedItem);
						break;
					}	
					case Keyboard.ENTER:
					{
						if (!event.ctrlKey)
						{
							if (selectedItem && !selectedItem.lock)
							{
								event.stopImmediatePropagation();
								selectedItem.rename();
							}
						}
						break;
					}
				}
			}
		}
		
		public function tryToRemoveItem(event:Event = null):void
		{
			if (selectedItem) removeSelectedItem();
		}
		
		public function removeSelectedItem():void
		{
			var removedItem:SG_ListItem = selectedItem;
			
			if (selectedItem.prev)		selectItem(selectedItem.prev);
			else if (selectedItem.next)	selectItem(selectedItem.next);
			else						selectedItem = null;
			
			removeItem(removedItem);
		}
		
		public function removeItem(item:SG_ListItem):void
		{
			var action:SG_ListAction = new SG_ListAction(item, SG_ListAction.REMOVE);
			saveHistory(action); // REMOVE
			item.remove();
			refresh();
		}
		
		public function removeAll():void
		{
			items = {};
			folders = {};
			_rootFolder.destroy(true);
			resetScroll();
			changeList();
		}
		
		public function removeItemAt(index:uint):void
		{
			_rootFolder.removeItemAt(index);
		}
		
		public function resetSelection(event:MouseEvent = null):void 
		{
			if (event && !enableResetSelection) return;
			
			if (selectedItem) 
			{
				selectedItem.selected = false;
				selectedItem = null;
			}
			currentFolder = _rootFolder;
			dispatchEvent(new SG_ListEvent(SG_ListEvent.RESET_SELECTION));
		}
		/** ===== INTERNAL =============================================================== */
		public function lockList(timeout:Boolean = false):void
		{
			_rootFolder.mouseEnabled = false;
			_rootFolder.mouseChildren = false;
			
			if (timeout) SP_Tweener.addTimeout(SG_ListFolder.EXPAND_TIME, unlockList);
		}
		
		public function unlockList():void
		{
			_rootFolder.mouseEnabled = true;
			_rootFolder.mouseChildren = true;
		}
		
		public function updateScroll():void
		{
			if (stage) scroller.update();
			changeList();
		}
		
		internal function setCurrentFolder(item:SG_ListItem):void
		{
			var oldFolder:SG_ListFolder = currentFolder;
			
			if (item.isFolder && (item as SG_ListFolder).opened)
			{
				currentFolder = selectedItem as SG_ListFolder;
			}
			else if (selectedItem) currentFolder = selectedItem.folder;
			
			if (!currentFolder) currentFolder = _rootFolder;
			
			if (currentFolder != oldFolder) sortList();
		}
		/// ===== @PUBLIC ================================================================= //
		public function loadFromXML(xml:XML, targetFolder:SG_ListFolder = null):void
		{
			if (!targetFolder) targetFolder = _rootFolder;
			
			for each (var node:XML in xml.elements())
			{
				switch (node.name().toString())
				{
					case FOLDER:
					{
						var folder:SG_ListFolder = targetFolder.addFolder(node.@name);
						loadFromXML(node, folder);
						break;
					}
					case ITEM:
					{
						targetFolder.addItem(node.@name);
						break;
					}
				}
			}
		}
		
		public function getXML():XML
		{
			var xml:XML = <tasks></tasks>;
			var rootXML:XML = _rootFolder.getXML();
			for each (var node:XML in rootXML.elements()) xml.appendChild(node);
			return xml;
		}
		
		private function stopWaiting():void
		{
			waiting = false;
			updateScroll();
		}
		
		public function scrollTo(item:SG_ListItem, delay:int = 0):void
		{
			if (item.parent)
			{
				var point:Point = new Point(item.width/2, item.y);
				point = item.parent.localToGlobal(point);
				
				if (delay != 0)	SP_Tweener.addTimeout(delay, scroller.scrollTo, [point]);
				else			scroller.scrollTo(point);
			}
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
				var listEvent:SG_ListEvent = new SG_ListEvent(SG_ListEvent.SELECT_ITEM);
				listEvent.item = selectedItem;
				listEvent.manual = dragItem;
				dispatchEvent(listEvent);
			}
			
			if (dragItem && !item.lock)
			{
				if (enableDragAndDrop && selectedItem.enableDragging) dragSystem.startDragging(selectedItem);
			}
			
			if (!dragItem)	scrollTo(item);
			if (stage)		stage.focus = this;
		}
		
		public function setDefaultIcons(itemIcon:Class, folderIcon:Class):void
		{
			this.style.itemIcon = itemIcon;
			this.style.folderIcon = folderIcon;
		}
		
		public function addItem(label:String, icon:MovieClip = null, manual:Boolean = true):SG_ListItem
		{
			var item:SG_ListItem = currentFolder.addItem(label, icon, manual);
			var action:SG_ListAction = new SG_ListAction(item, SG_ListAction.CREATE);
			if (manual) saveHistory(action); // CREATE
			return item;
		}
		
		public function addFolder(label:String, icon:MovieClip = null, manual:Boolean = true):SG_ListFolder
		{
			var folder:SG_ListFolder = currentFolder.addFolder(label, icon, manual);
			var action:SG_ListAction = new SG_ListAction(folder, SG_ListAction.CREATE);
			if (manual) saveHistory(action); // CREATE
			return folder;
		}
		
		public function getItemAt(index:uint):SG_ListItem
		{
			return _rootFolder.getItemAt(index);
		}
		
		public function sortItemsBy(field:String, options:* = null, withFolders:Boolean = false):void
		{
			//saveHistory();
			_rootFolder.sortItemsBy(field, options, withFolders);
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
			updateCenterPoint();
		}
		
		public function set centerPoint(value:String):void 
		{
			_centerPoint = value;
			updateCenterPoint();
		}
		
		public function set defaultMessage(value:String):void 
		{
			_defaultMessage.text = value;
		}
		
		public function set dataProvider(data:SP_DataProvider):void 
		{
			var object:Object;
			var item:SG_ListItem;
			removeAll();
			
			for (var i:int=0; i<data.length; i++)
			{
				object = data.getItemAt(i);
				item = addItem(object.label, null, false);
				item.data = object.data;
			}
			rootFolder.refresh();
			resetSelection();
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
		
		public function get centerPoint():String 
		{
			return _centerPoint;
		}
		
		public function get defaultMessage():String 
		{
			return _defaultMessage.text;
		}
		
		public function get currentIndex():uint
		{
			if (selectedItem)	return selectedItem.childIndex;
			else				return 0;
		}
		
		public function get rootFolder():SG_ListFolder 
		{
			return _rootFolder;
		}
		
		public function get dataProvider():SP_DataProvider 
		{
			// TODO List DataProvider
			return null;
		}
		
	}
}