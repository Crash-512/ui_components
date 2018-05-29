package smart.gui.components.list 
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;

	import smart.tweener.SP_Tweener;
	import smart.gui.cursor.*;
	import smart.gui.components.list.history.*;
	import smart.gui.components.scroll.*;

	internal class SG_ListDragSystem extends Sprite
	{
		public var isDragging:Boolean;
		public var selectedItem:SG_ListItem;
		public var dragTarget:SG_ListItem;
		public var _dragType:int = -1;
		public var rootFolder:SG_ListFolder;
		
		private var list:SG_List;
		private var scrollPane:SG_Scroller;
		
		private var initDrag:Point;
		private var dragIcon:Sprite;
		private var lock:Boolean;
		private var insertBefore:Boolean;
		private var dropOutside:Boolean;
		private var outsideTarget:SG_List;
		private var removeFlag:Boolean;
		private var initFolder:SG_ListFolder;
		private var initPosition:int;
		
		private static const ICON_TIME:int = 15;
		private static const DRAG_EDGE:int = 10;
		private static const SCROLL_DELAY:int = 20;
		private var action:SG_ListAction;
		
		public static const LINE_CENTER:int = 0;
		public static const LINE_UP:int = 1;
		public static const LINE_DOWN:int = 2;
		public static const PLUS:int = 3;
		public static const REMOVE:int = 4;
		
		
		public function SG_ListDragSystem(list:SG_List, rootFolder:SG_ListFolder, scrollPane:SG_Scroller) 
		{
			dragIcon = new Sprite();
			dragIcon.alpha = 0;
			dragIcon.mouseEnabled = false;
			dragIcon.mouseChildren = false;
			
			this.list = list;
			this.rootFolder = rootFolder;
			this.scrollPane = scrollPane;
			
			scrollPane.addEventListener(SG_ScrollEvent.START_SCROLL, lockDragging);
			scrollPane.addEventListener(SG_ScrollEvent.STOP_SCROLL, unlockDragging);
		}
		
		public function startDragging(selectedItem:SG_ListItem):void
		{
			action = null;
			this.selectedItem = selectedItem;
			
			initDrag = new Point(mouseX, mouseY);
			addEventListener(Event.ENTER_FRAME, dragging);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDragging);
		}
		
		public function stopDragging(event:MouseEvent = null):void 
		{
			SG_Mouse.setCursor(SG_CursorType.ARROW);
			removeEventListener(Event.ENTER_FRAME, dragging);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragging);
			
			if (isDragging)
			{
				isDragging = false;
				rootFolder.mouseEnabled = true;
				rootFolder.mouseChildren = true;
				
				SP_Tweener.addTween(dragIcon, {alpha:0}, {time:ICON_TIME, removeChild:true});
				
				if (dragTarget && !dropOutside)
				{
					if (dragTarget != selectedItem)
					{
						selectedItem.fastRefresh = true;
						
						if (dragTarget.isFolder)
						{
							if (_dragType == PLUS)	placeToFolder();
							else					placeToItem();
						}
						else placeToItem();
					}
				}
				if (selectedItem.isFolder) 
				{
					var folder:SG_ListFolder = selectedItem as SG_ListFolder;
					folder.updateDepth();
				}
				if (dropOutside) 
				{
					outsideTarget.dropItem(selectedItem);
					outsideTarget = null;
				}
				else if (outsideTarget)
				{
					outsideTarget.stopDragOutside();
					outsideTarget = null;
				}
				
				var listEvent:SG_ListEvent = new SG_ListEvent(SG_ListEvent.STOP_DRAG);
				
				if (selectedItem.folder != initFolder || selectedItem.childIndex != initPosition)
				{
					if (initFolder.list == selectedItem.folder.list) 
					{
						list.saveHistory(action); // MOVING
					}
					list.refresh();
					list.scrollTo(selectedItem, SCROLL_DELAY);
					list.setCurrentFolder(selectedItem);
					
					listEvent.item = selectedItem;
				}
				else action = null;
				
				if (removeFlag)	list.removeItem(selectedItem);
				list.dispatchEvent(listEvent);
			}
		}
		
		private function placeToItem():void
		{
			var folder:SG_ListFolder = dragTarget.folder;
			
			if (insertBefore)	
			{
				folder.insertToEnd(selectedItem, false);
				list.lockList(true);
				list.refresh();
			}
			else if (dragTarget.prev != selectedItem)
			{
				folder.insertAfter(selectedItem, dragTarget);
				list.lockList(true);
				list.refresh();
			}
		}
		
		private function placeToFolder():void
		{
			var folder:SG_ListFolder = dragTarget as SG_ListFolder;
			
			if (selectedItem.folder != folder)
			{
				if (!selectedItem.isFolder)
				{
					folder.insertToEnd(selectedItem, false);
				}
				else folder.insertFolder(selectedItem as SG_ListFolder);
				
				list.lockList(true);
				if (!folder.opened)	folder.expand();
				list.refresh();
			}
		}
		
		public function initDragging():void 
		{
			initFolder = selectedItem.folder;
			initPosition = selectedItem.childIndex;
			action = new SG_ListAction(selectedItem, SG_ListAction.MOVING);
			
			isDragging = true;
			dragIcon.alpha = 0;
			dragIcon.visible = false;
			addChild(dragIcon);
			rootFolder.mouseEnabled = false;
			rootFolder.mouseChildren = false;
			dragTarget = null;
			SG_Mouse.setCursor(SG_CursorType.DRAG_ITEM);
			
			if (selectedItem.isFolder) 
			{
				var folder:SG_ListFolder = selectedItem as SG_ListFolder;
				if (folder.opened) folder.collapse();
			}
			
			var listEvent:SG_ListEvent = new SG_ListEvent(SG_ListEvent.START_DRAG);
			list.dispatchEvent(listEvent);
		}
		
		public function dragging(event:Event = null):void 
		{
			if (!isDragging) 
			{
				if (Math.abs(initDrag.y-mouseY) > DRAG_EDGE || Math.abs(initDrag.x-mouseX) > DRAG_EDGE)
				{
					initDragging();
					dragType = LINE_CENTER;
				}
			}
			else 
			{
				if (!lock)
				{
					var mouse:Point = new Point(list.mouseX, list.mouseY);
					var listRect:Rectangle = list.getRect(list);
					
					if (!listRect.containsPoint(mouse))
					{
						if (list.enableDragOutside)
						{
							if (getListUnderCursor())
							{
								dragIcon.visible = false;
								dropOutside = true;
								return;
							}
							else if (!list.enableDragEvent)
							{
								dropOutside = false;
								dragTarget = null;
								dragIcon.visible = false;
								return;
							}
						}
						else
						{
							SG_Mouse.setCursor(SG_CursorType.REMOVE_ITEM);
							removeFlag = true;
							return;
						}
						
					}
					SG_Mouse.setCursor(SG_CursorType.DRAG_ITEM);
					removeFlag = false;
					dropOutside = false;
					
					var item:SG_ListItem = itemUnderPoint(rootFolder);
					
					if (item && !item.lock) 
					{
						if (selectedItem.rootFolder != item.rootFolder) return;
						
						if (item.isFolder)	dragToFolder(item as SG_ListFolder);
						else				dragToItem(item);
					}
					if (dragTarget) setDragPoint();
					updateScroll();
				}
			}
		}
		
		private function dragToItem(item:SG_ListItem):void 
		{
			var itemY:int = item.parent.mouseY;
			
			if (!item.next && item.depth != 0 && itemY > item.y + list.preset.itemHeight)
			{
				if (selectedItem.isFolder)
				{
					// Во внешнюю папку
					dragType = LINE_CENTER;
					dragTarget = item.folder;
					insertBefore = true;
				}
				else if (item.folder.depth != 0 || list.enableDropToRoot)
				{
					// Во внешнюю папку или в корень
					dragType = LINE_DOWN;
					dragTarget = item.folder.folder;
					insertBefore = true;
				}
				return;
			}
			
			if (selectedItem.isFolder)
			{
				if (!list.enableSubFolders && item.depth > selectedItem.depth) return;
				
				dragType = LINE_CENTER;
				insertBefore = false;
				
				// Внутри папки
				while (item.prev)
				{
					if (item.prev.isFolder)
					{
						dragTarget = item;
						return;
					}
					item = item.prev;
				}
				dragTarget = item;
			}
			else 
			{		
				insertBefore = false;
				
				if (item.mouseY > list.preset.itemHeight/2)
				{
					if (!item.next)
					{
						dragTarget = item;
						insertBefore = true;
						dragType = LINE_UP;
					}
					else
					{
						dragTarget = item.next;
						dragType = LINE_CENTER;
					}
				}
				else 
				{
					dragTarget = item;
					dragType = LINE_CENTER;
				}
			}
		}
		
		private function dragToFolder(folder:SG_ListFolder):void 
		{
			var part:Number = list.preset.itemHeight/3;
			var itemY:int = folder.mouseY;
			
			/*if (selectedItem.folder == folder)
			{
				insertBefore = false;
				dragTarget = folder.firstItem;
				dragType = LINE_CENTER;
				return;
			}*/
			
			// Перемещаем папку
			if (selectedItem.isFolder)
			{
				if (!list.enableSubFolders && folder.depth != selectedItem.depth) return;
				
				if (itemY < part && selectedItem.rootFolder == folder.folder.rootFolder)
				{
					// Перед папкой
					dragType = LINE_CENTER;
					dragTarget = folder;
					insertBefore = false;
				}
				else if (itemY < part*2 && list.enableSubFolders)
				{
					// В папку
					dragType = PLUS;
					dragTarget = folder;
					insertBefore = false;
				}
				else
				{
					if (folder.opened && list.enableSubFolders)
					{
						// В папку
						dragType = LINE_CENTER;
						dragTarget = folder.getItemAt(0);
						insertBefore = false;
					}
					else 
					{
						// После папки
						dragType = LINE_CENTER;
						
						if (!folder.next)
						{
							dragTarget = folder;
							insertBefore = true;
						}
						else
						{
							dragTarget = folder.next;
							insertBefore = false;
						}
					}
				}
			}
			else // Перемещаем элемент
			{
				// В папку
				dragType = PLUS;
				dragTarget = folder;
				insertBefore = false;
				
				if ((!folder.next || !folder.next.isFolder) && !folder.opened && itemY > part*2)
				{
					if (folder.depth != 0 || list.enableDropToRoot)
					{
						// После папки или в корень
						dragType = LINE_CENTER;
						dragTarget = folder;
						insertBefore = true;
					}
				}
			}
		}
		
		private function getListUnderCursor():Boolean 
		{
			var mouse:Point = new Point(stage.mouseX, stage.mouseY);
			var objects:Array = stage.getObjectsUnderPoint(mouse);
			
			for each (var object:DisplayObject in objects)
			{
				do
				{
					if (object is SG_List && object != list) 
					{
						outsideTarget = object as SG_List;
						
						if (outsideTarget.enableDropOutside)
						{
							outsideTarget.dragOutside(selectedItem);
							return true;
						}
						else outsideTarget = null;
					}
					object = object.parent;
				}
				while (object)
			}
			return false;
		}
		
		private function setDragPoint():void
		{
			var point:Point = dragTarget.getPosition();
			point = dragTarget.parent.localToGlobal(point);
			point = globalToLocal(point);
			
			if (insertBefore)		point.y += dragTarget.height;
			if (_dragType == PLUS)	point.y += list.preset.itemHeight/2;
			
			dragIcon.y = point.y;
		}
		
		private function updateScroll():void
		{
			var upEdge:int = list.preset.itemHeight/2;
			var downEdge:int = list.height - upEdge;
			
			if (dragIcon.y <= upEdge)			scrollPane.scrollUp();
			else if (dragIcon.y >= downEdge)	scrollPane.scrollDown();
			
			if (dragIcon.y > list.height || dragIcon.y < 0) 
			{
				dragIcon.visible = false;
			}
			else if (!dragIcon.visible)
			{
				dragIcon.visible = true;
				SP_Tweener.addTween(dragIcon, {alpha:1}, {time:ICON_TIME});
			}
		}
		
		private function itemUnderPoint(target:SG_ListFolder):SG_ListItem
		{
			var oldItem:SG_ListItem;
			var item:SG_ListItem;
			var posY:int = target.content.mouseY;
			
			for (var i:int = 0; i < target.content.numChildren; i++) 
			{
				item = target.content.getChildAt(i) as SG_ListItem;
				
				if (posY < item.y)
				{
					item = oldItem;
					break;
				}
				oldItem = item;
			}
			
			if (item && item.isFolder)
			{
				var folder:SG_ListFolder = item as SG_ListFolder;
				if (folder.opened)	item = itemUnderPoint(folder);
				if (!item)			item = folder;
			}
			return item;
		}
		
		private function set dragType(value:int):void
		{
			if (_dragType != value)
			{
				while (dragIcon.numChildren != 0) dragIcon.removeChildAt(0);
				
				var separator:Sprite;
				
				switch (value)
				{
					case LINE_CENTER:		
					{
						separator = new Separator();
						separator.width = list.width;
						dragIcon.addChild(separator);		
						break;
					}
					case LINE_UP:		
					{
						separator = new SeparatorUp();
						separator.width = list.width;
						dragIcon.addChild(separator);		
						break;
					}
					case LINE_DOWN:		
					{
						separator = new SeparatorDown();
						separator.width = list.width;
						dragIcon.addChild(separator);		
						break;
					}
					case PLUS:		dragIcon.addChild(new IconAdd());		break;
					case REMOVE:	dragIcon.addChild(new IconRemove());	break;
				}
				_dragType = value;
			}
		}
		
		private function lockDragging(event:SG_ScrollEvent):void
		{
			lock = true;
		}
		
		private function unlockDragging(event:SG_ScrollEvent):void
		{
			lock = false;
		}
		
	}
}