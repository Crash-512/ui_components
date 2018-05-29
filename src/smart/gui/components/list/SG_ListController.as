package smart.gui.components.list 
{
	import flash.events.Event;
	
	internal class SG_ListController 
	{
		private var list:SG_List;
		public var locked:Boolean;
		
		
		public function SG_ListController(list:SG_List) 
		{
			this.list = list;
		}
		
		public function lock(event:Event):void 
		{
			locked = true;
		}
		
		public function unlock(event:Event):void 
		{
			locked = false;
		}
		
		internal function tryToSelect(item:SG_ListItem):Boolean
		{
			if (item && !item.isEmpty)
			{
				list.selectItem(item);
				return true;
			}
			return false;
		}
		
		internal function selectNextItem(item:SG_ListItem):void
		{
			var folder:SG_ListFolder;
			var nextItem:SG_ListItem;
			
			if (!item)
			{
				nextItem = list.rootFolder.firstItem;
				if (nextItem)
				{
					if (nextItem.visible)	tryToSelect(nextItem);
					else					selectNextItem(nextItem);
				}
				return;
			}
			if (item.isFolder && item.visible) 
			{
				folder = item as SG_ListFolder;
				nextItem = folder.firstItem;
				
				if (folder.opened && !nextItem.isEmpty) 
				{
					if (nextItem.visible)	list.selectItem(nextItem);
					else					selectNextItem(nextItem);
					return;
				}
			}
			nextItem = item.next;
			
			if (nextItem && !nextItem.isEmpty)
			{
				if (nextItem.visible)	list.selectItem(nextItem);
				else					selectNextItem(nextItem);
			}
			else
			{
				folder = item.folder;
				while (folder && !folder.next) folder = folder.folder;
				if (folder && folder.next) list.selectItem(folder.next);
			}
		}
		
		internal function selectPrevItem(item:SG_ListItem):void
		{
			var folder:SG_ListFolder;
			var prevItem:SG_ListItem = item.prev;
			
			if (prevItem)
			{
				if (prevItem.visible)
				{
					if (prevItem.isFolder) 
					{
						folder = prevItem as SG_ListFolder;
						if (folder.opened && !folder.lastItem.isEmpty) 
						{
							list.selectItem(folder.lastItem);
							return;
						}
					}
					tryToSelect(prevItem);
				}
				else selectPrevItem(prevItem);
			}
			else
			{
				folder = item.folder;
				
				if (folder && folder != list.rootFolder) list.selectItem(item.folder);
			}
		}
		
		internal function prevFolder(item:SG_ListItem):void 
		{
			if (!item)
			{
				tryToSelectFolder(list.rootFolder.firstItem);
			}
			else if (item.isFolder)
			{
				var folder:SG_ListFolder = item as SG_ListFolder;
				
				if (!folder.opened) 
				{
					var prevFolder:SG_ListFolder = folder.prev as SG_ListFolder;
					
					while (prevFolder)
					{					
						if (prevFolder && prevFolder.isFolder && prevFolder.opened)
						{
							list.selectItem(prevFolder);
							return;
						}
						prevFolder = prevFolder.prev as SG_ListFolder;
					}
					selectParentFolder(folder);
				}
				else folder.opened = false;
			}
			else selectParentFolder(item);
		}
		
		internal function nextFolder(item:SG_ListItem):void 
		{
			if (!item)
			{
				tryToSelectFolder(list.rootFolder.firstItem);
			}
			else if (item.isFolder)
			{
				var folder:SG_ListFolder = item as SG_ListFolder;
				
				if (folder.opened) 
				{
					if (!tryToSelectFolder(folder.firstItem))
					{
						if (!tryToSelectFolder(folder.next)) selectNextFolder(item);
					}
				}
				else folder.opened = true;
			}
			else selectNextFolder(item);
		}
		
		private function tryToSelectFolder(folder:SG_ListItem):Boolean
		{
			if (folder && folder.isFolder && folder.visible)
			{
				list.selectItem(folder);
				return true;
			}
			return false;
		}
		
		private function selectNextFolder(item:SG_ListItem):void
		{
			var folder:SG_ListFolder = item.folder;
			item = folder.next;
			
			// TODO исправить 
			while (item != null)
			{
				if (item.isFolder)
				{
					list.selectItem(item);
					return;
				}
				else 
				{
					selectNextFolder(item);
					return;
				}
				item = item.next;
			}
		}
		
		internal function selectParentFolder(item:SG_ListItem):SG_ListFolder
		{
			if (item.folder && item.folder != list.rootFolder)
			{
				list.selectItem(item.folder);
				return item.folder;
			}
			return null;
		}
		
		internal function moveUp(item:SG_ListItem):void
		{
			var folder:SG_ListFolder = item.folder;
			var prevItem:SG_ListItem = item.prev;

			if (prevItem && !prevItem.isFolder)
			{
				folder.insertAfter(item, prevItem, false);
				folder.refresh();
				list.dispatchEvent(new SG_ListEvent(SG_ListEvent.MOVE_ITEM));
			}
		}
		
		internal function moveDown(item:SG_ListItem):void
		{
			
			
			var folder:SG_ListFolder = item.folder;
			var nextItem:SG_ListItem = item.next;

			if (nextItem && !nextItem.isFolder)
			{
				folder.insertAfter(nextItem, item, false);
				folder.refresh();
				list.dispatchEvent(new SG_ListEvent(SG_ListEvent.MOVE_ITEM));
			}
		}
		
	}
}