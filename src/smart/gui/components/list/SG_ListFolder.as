package smart.gui.components.list 
{
	import flash.display.Sprite;
	
	import smart.gui.skin.SG_GUISkin;
	
	public class SG_ListFolder extends SG_ListItem
	{
		private var separator:Sprite;
		
		protected var _opened:Boolean;
		
		public var lastItem:SG_ListItem;
		public var firstItem:SG_ListItem;
		internal var content:Sprite;
		
		
		public function SG_ListFolder(text:String = null, list:SG_List = null)
		{
			isFolder = true;
			super(text, list);

			if (!text)
			{
				// Root Folder
				content = new Sprite();
				addChild(content);
				_opened = true;
				isRoot = true;
				rootFolder = name;
			}
			else initFolder();
		}
		
		private function initFolder():void
		{
			content = new Sprite();
			content.y = background.height;
		}
		
		internal override function updateBackground():void
		{
			var item:SG_ListItem = firstItem;

			while (item)
			{
				item.updateBackground();
				item = item.next;
			}

			if (background && container.contains(background)) container.removeChild(background);

			background = new Sprite();
			container.addChildAt(background, 0);
		}
		
		internal override function redraw():void
		{
			var item:SG_ListItem = firstItem;

			while (item)
			{
				item.redraw();
				item = item.next;
			}
			if (background)
			{
				background.graphics.clear();
				
				if (highlight)  background.graphics.beginFill(_list.style.highlightColor);
				else            background.graphics.beginFill(_list.style.itemColor);
				
				background.graphics.drawRect(0, 0, _width, _height);
				background.graphics.endFill();
			}
		}
		
		override public function setSkin(skin:SG_GUISkin):void
		{
			super.setSkin(skin);

			var item:SG_ListItem = firstItem;

			while (item)
			{
				item.setSkin(skin);
				item = item.next;
			}
		}
		
		internal override function updateSize():void
		{
			var item:SG_ListItem = firstItem;

			while (item)
			{
				item.updateSize();
				item = item.next;
			}
			background.width = _list.width;
		}
		
		public function getItemsList(withClosed:Boolean = true, withFolders:Boolean = true, withItems:Boolean = true):Array 
		{
			var folder:SG_ListFolder = this;
			var item:SG_ListItem = this;
			var items:Array = [];
			
			while (true)
			{
				if (!item || item.isEmpty)
				{
					item = folder.next;
					folder = folder.folder;
					if (!item)	break;
					else		continue;
				}
				else if (item.isFolder)
				{
					folder = item as SG_ListFolder;
					
					if (folder != this) return items;
					
					if (withFolders) items.push(folder);
					
					if (folder.opened || withClosed) 
					{
						item = folder.firstItem;
						continue;
					}
					else folder = folder.folder;
				}
				else if (withItems) items.push(item);
				
				item = item.next;
			}
			return items;
		}
		
		public function addItem(label:String):SG_ListItem
		{
			var item:SG_ListItem = createItem(label);
			item.width = _width;
			item.rootFolder = rootFolder;
			
			insertToEnd(item);
			_list.updateScroll();
			
			var event:SG_ListEvent = new SG_ListEvent(SG_ListEvent.ADD_ITEM);
			event.item = item;
			_list.dispatchEvent(event);
			
			return item;
		}
		
		protected function createItem(label:String):SG_ListItem
		{
			var item:SG_ListItem = new _list.itemClass(label, _list);
			return item;
		}
		
		public function getItemAt(index:uint):SG_ListItem
		{
			if (index < length)
			{
				var item:SG_ListItem = content.getChildAt(index) as SG_ListItem;
				return item;
			}
			return null;
		}
		
		public function getItemByName(name:String, subFolders:Boolean = true):SG_ListItem 
		{
			var item:SG_ListItem = firstItem;
			var folder:SG_ListFolder;
			var result:SG_ListItem;
			
			while (item)
			{
				if (item.isFolder)
				{
					folder = item as SG_ListFolder;
					if (subFolders) result = folder.getItemByName(name, true);
					if (result) return result;
				}
				else if (item.name == name)	return item;
				
				item = item.next;
			}
			return null;
		}
		
		public function insertToEnd(item:SG_ListItem):void
		{
			addToList(item);
			
			item.list = _list;
			item.width = _list.width;
			item.folder = this; 
			item.updateSize();
			
			_list.dispatchEvent(new SG_ListEvent(SG_ListEvent.REFRESH));
		}
		
		public function addToList(item:SG_ListItem):void
		{
			if (lastItem) 
			{
				lastItem.next = item;
				item.prev = lastItem;
				lastItem = item;
			}
			if (!firstItem) 
			{
				firstItem = item;
				lastItem = item;
			}
			content.addChild(item);
		}
		
		public function refresh():void
		{
			var item:SG_ListItem = firstItem;
			var nextY:int = 0;
			
			while (item)
			{	
				item.y = nextY;
				nextY += item.height;
				item = item.next;
			}
		}

		// *** PROPERTIES *** //
		
		override public function set width(value:Number):void
		{
			_width = value;
			
			if (!isRoot) 
			{
				updateLabelWidth();
				redraw();
			}
			
			var item:SG_ListItem = firstItem;
			
			while (item)
			{
				item.width = value;
				item = item.next;
			}
		}
		
		override public function set list(value:SG_List):void 
		{
			_list = value;
			
			var item:SG_ListItem = firstItem;
			
			while (item)
			{
				item.list = value;
				item = item.next;
			}
		}
		
		public function get opened():Boolean 
		{
			return _opened;
		}
		
		public function get length():int
		{
			var count:int = 0;
			var item:SG_ListItem = firstItem;
			
			while (item)
			{
				count++;
				item = item.next;
			}
			return count;
		}
		
		override public function get height():Number
		{
			if (_opened)	
			{
				if (!isRoot)	return background.height + contentHeight;
				else			return contentHeight;
			}
			return background.height;
		}
		
		private function get contentHeight():int
		{
			var value:int = 0;
			var item:SG_ListItem = firstItem;
			
			while (item)
			{
				if (item.visible) value += item.height;
				item = item.next;
			}
			return value;
		}
	}
}