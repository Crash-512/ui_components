package smart.gui.components.list 
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;

	import smart.tweener.*;
	import smart.gui.components.list.history.*;
	import smart.gui.data.*;
	import smart.gui.skin.SG_GUISkin;

	public class SG_ListFolder extends SG_ListItem
	{
		private var _hideArrow:Boolean = true;
		private var btnExpand:ExpandButton;
		private var folderMask:Sprite;
		private var separator:Sprite;
		private var emptyItem:SG_ListItem;
		private var expandTimeout:SP_Tween;
		
		protected var _opened:Boolean;
		
		public var lastItem:SG_ListItem;
		public var firstItem:SG_ListItem;
		internal var content:Sprite;
		
		private static const ICON_TIME:int = 12;
		public static const EXPAND_TIME:int = 30;

		
		public function SG_ListFolder(text:String = null, list:SG_List = null, sizePreset:SG_ListPreset = null, icon:MovieClip = null)
		{
			isFolder = true;
			super(text, list, sizePreset, icon);

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
		
		override public function destroy(full:Boolean = false):void
		{
			var items:Array = [];
			var item:SG_ListItem = firstItem;

			while (item)
			{
				items.push(item);
				item = item.next;
			}

			for each (item in items)
			{
				item.destroy(full);

				if (full)
				{
					item.folder = null;
					item.next = null;
					item.prev = null;
					content.removeChild(item);
				}
			}

			if (full)
			{
				firstItem = null;
				lastItem = null;
			}
		}
		
		private function initFolder():void
		{
			content = new Sprite();
			content.y = background.height;

			folderMask = new Sprite();
			folderMask.y = background.height;
			container.addChild(folderMask);
			content.mask = folderMask;

			btnExpand = new ExpandButton();
			btnExpand.width = preset.iconSize;
			btnExpand.height = preset.iconSize;
			btnExpand.x = 0;
			btnExpand.y = Math.round((background.height-btnExpand.height)/2);
			btnExpand.alpha = 0;
			btnExpand.visible = false;
			btnExpand.mouseEnabled = false;
			btnExpand.mouseChildren = false;
			container.addChild(btnExpand);
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

				if (_list.style.enableSeparators)
				{
					background.graphics.beginFill(_list.style.separatorColor);
					background.graphics.drawRect(0, 0, _width, 1);
					background.graphics.endFill();
				}

				if (_list.style.enableSeparators)
				{
					if (!separator)
					{
						separator = new Sprite();
						addChild(separator);
					}
					separator.graphics.clear();
					separator.graphics.beginFill(_list.style.separatorColor);
					separator.graphics.drawRect(0, 0, _width, 1);
					separator.graphics.endFill();
					separator.y = height;
				}
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
		
		internal function updateDepth():void
		{
			var item:SG_ListItem = firstItem;

			while (item)
			{
				item.depth = depth + 1;
				item = item.next;
			}
		}
		
		override public function clone():SG_ListItem
		{
			var folder:SG_ListFolder = new SG_ListFolder(name, list, preset, cloneIcon());
			cloneSettings(folder);
			
			var item:SG_ListItem = firstItem;
			
			while (item)
			{
				folder.insertToEnd(item.clone(), false, false);
				item = item.next;
			}
			folder.opened = _opened;
			folder.refresh();
			return folder;
		}
		
		public function getArray():Array
		{
			var array:Array = [];
			var item:SG_ListItem = firstItem;
			
			while (item)
			{
				array.push(item);
				item = item.next;
			}
			return array;
		}
		
		public function getItemsList(withClosed:Boolean = true, withFolders:Boolean = true, withItems:Boolean = true):Array 
		{
			var folder:SG_ListFolder = this;
			var depth:int = folder.depth;
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
					
					if (folder != this && folder.depth <= depth) return items;
					
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
		
		override public function toString():String
		{
			return "folder:" + name;
		}
		
		public function removeItem(item:SG_ListItem, destroy:Boolean):void
		{
			var event:SG_ListEvent = new SG_ListEvent(SG_ListEvent.REMOVE_ITEM);
			event.item = item;
			event.folder = item.folder;
			
			if (item == lastItem)	lastItem = lastItem.prev;
			if (item == firstItem)	firstItem = firstItem.next;
			
			if (item.prev) item.prev.next = item.next;
			if (item.next) item.next.prev = item.prev;
			
			item.next = null;
			item.prev = null;
			if (destroy) item.destroy();
			if (content.contains(item)) content.removeChild(item);
			if (background) redraw();
			addEmptyItem();
			
			_list.dispatchEvent(event);
			_list.dispatchEvent(new SG_ListEvent(SG_ListEvent.REFRESH));
		}
		
		public function removeItemAt(index:uint):void
		{
			if (index < length)
			{
				var item:SG_ListItem = content.getChildAt(index) as SG_ListItem;
				item.destroy();
				content.removeChild(item);
			}
		}
		
		private function removeEmptyItem():void
		{
			if (emptyItem && length > 1)
			{
				emptyItem.remove();
				emptyItem.destroy();
				emptyItem = null;
			}
		}
		
		override public function getXML():XML
		{
			var folderXML:XML = <folder name={name} opened={int(_opened)}/>;
			var item:SG_ListItem = firstItem;
			
			while (item)
			{
				if (!item.isEmpty) folderXML.appendChild(item.getXML());
				item = item.next;
			}
			return folderXML;
		}
		
		public function getPoint():Point
		{
			var point:Point = new Point(content.mouseX, content.mouseY);
			point = content.localToGlobal(point);
			
			return point;
		}
		
		protected function manualAdd(item:SG_ListItem):void
		{
			if (_list.selectedItem)
			{
				var index:int;
				var folder:SG_ListFolder;
				
				if (_list.selectedItem.isFolder) 
				{
					folder = _list.selectedItem as SG_ListFolder;
					
					if (item.isFolder)
					{
						if (!folder.opened)
						{
							index = folder.childIndex + 1;
							insertToIndex(item, index);
						}
						else insertToIndex(item, 0);
					}
					else insertFolder(item, true);
				}
				else
				{
					if (!item.isFolder)
					{
						index = _list.selectedItem.childIndex + 1;
						insertToIndex(item, index);
					}
					else insertFolder(item, true);
				}
			}
			else
			{
				if (item.isFolder)	insertFolder(item as SG_ListFolder, true);
				else				insertToEnd(item, true, true);
			}
			
			item.showItem();
			_list.scrollTo(item);
			_list.selectItem(item);
			_list.refresh();
			if (!item.folder.opened) item.folder.opened = true;
			item.rename(true);
		}
		
		public function addItem(label:String, icon:MovieClip = null, manual:Boolean = false):SG_ListItem
		{
			var item:SG_ListItem = createItem(label, icon);
			item.width = _width;
			item.rootFolder = rootFolder;
			
			if (manual) manualAdd(item);
			else		insertToEnd(item, manual, manual);
			_list.updateScroll();
			
			var event:SG_ListEvent = new SG_ListEvent(SG_ListEvent.ADD_ITEM);
			event.item = item;
			event.manual = manual;
			_list.dispatchEvent(event);
			
			return item;
		}
		
		public function addFolder(label:String, icon:MovieClip = null, manual:Boolean = false):SG_ListFolder
		{
			var folder:SG_ListFolder = createFolder(label, icon);
			folder.width = _width;
			folder.rootFolder = rootFolder;
			
			if (manual) manualAdd(folder);
			else		insertFolder(folder, manual);
			_list.updateScroll();
			
			var event:SG_ListEvent = new SG_ListEvent(SG_ListEvent.ADD_FOLDER);
			event.folder = folder;
			event.manual = manual;
			_list.dispatchEvent(event);
			
			return folder;
		}
		
		protected function createItem(label:String, _icon:MovieClip):SG_ListItem
		{
			var icon:MovieClip = getIcon(_icon, SG_List.ITEM);
			var item:SG_ListItem = new _list.itemClass(label, _list, preset, icon);
			return item;
		}
		
		protected function createFolder(label:String, _icon:MovieClip):SG_ListFolder
		{
			var icon:MovieClip = getIcon(_icon, SG_List.FOLDER);
			var folder:SG_ListFolder = new _list.folderClass(label, _list, preset, icon);
			return folder;
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
		
		public function getFolderByName(name:String, subFolders:Boolean = true):SG_ListFolder 
		{
			var item:SG_ListItem = firstItem;
			var folder:SG_ListFolder;
			var result:SG_ListFolder;
			
			while (item)
			{
				if (item.isFolder)
				{
					folder = item as SG_ListFolder;
					if (folder.name == name) return folder;
					if (subFolders) result = folder.getFolderByName(name, true);
					if (result) return result;
				}
				item = item.next;
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
		
		public function sortItemsBy(field:String, options:* = null, withFolders:Boolean = false):void
		{
			var arrays:Array = getArraysForSort();
			
			if (withFolders) arrays[0].sortOn(field, options);
			arrays[1].sortOn(field, options);
			
			refreshSortArrays(arrays);	
			for each (var folder:SG_ListFolder in arrays[0])	folder.sortItemsBy(field, options);
		}
		
		public function insertFolder(folder:SG_ListItem, refreshFolder:Boolean = false):void
		{
			var item:SG_ListItem;
			
			if (length != 0)
			{
				item = firstItem;
				
				while (item)
				{
					if (!item.isFolder)
					{
						insertAfter(folder, item, refreshFolder);
						return;
					}
					item = item.next;
				}
				insertToEnd(folder, refreshFolder, refreshFolder);
			}
			else insertToEnd(folder, refreshFolder, refreshFolder);
		}
		
		public function insertToIndex(item:SG_ListItem, index:int):void
		{
			item.fastRefresh = true;
			
			if (index < content.numChildren) 
			{
				var prevItem:SG_ListItem = content.getChildAt(index) as SG_ListItem;
				insertAfter(item, prevItem, false);
			}
			else insertToEnd(item, false, false);
			
			item.showItem();
			_list.refresh();
		}
		
		internal function insertAfter(item:SG_ListItem, nextItem:SG_ListItem, smooth:Boolean = true):void
		{
			item.remove(false);
			
			var prevItem:SG_ListItem = nextItem.prev;
			
			item.next = nextItem;
			item.prev = prevItem;
			nextItem.prev = item;
			
			if (prevItem)	prevItem.next = item;
			else			firstItem = item;
			
			var index:int = content.getChildIndex(nextItem);
			content.addChildAt(item, index);
			
			item.list = _list;
			item.folder = this;
			item.updateSize();
			item.depth = depth + 1;
			item.y = nextItem.y;
			
			if (smooth) item.showItem();
			removeEmptyItem();
			_list.dispatchEvent(new SG_ListEvent(SG_ListEvent.REFRESH));
		}
		
		public function insertToEnd(item:SG_ListItem, refreshFolder:Boolean = true, smooth:Boolean = true):void 
		{
			item.remove(false);
			addToList(item);
			
			item.list = _list;
			item.width = _list.width;
			item.folder = this; 
			item.updateSize();
			item.depth = depth + 1;
			
			if (refreshFolder)	refresh();	
			if (smooth)			item.showItem();
			_list.dispatchEvent(new SG_ListEvent(SG_ListEvent.REFRESH));
		}
		
		private function removeContent():void
		{
			if (contains(content)) removeChild(content);
		}
		/// ===== @PROTECTED ============================================================== //
		protected function refreshSortArrays(arrays:Array):void
		{
			var folders:Array = arrays[0];
			var items:Array = arrays[1];
			
			for each (var folder:SG_ListFolder in folders)	
			{
				folder.next = null;
				folder.prev = null;
				//folder.fastRefresh = true;
				addToList(folder);
			}
			for each (var item:SG_ListItem in items) 
			{
				item.next = null;
				item.prev = null;
				//item.fastRefresh = true;
				addToList(item);
			}
			_list.rootFolder.refresh();
		}
		
		protected function getArraysForSort():Array
		{
			var arrays:Array = [[],[]];
			var item:SG_ListItem = firstItem;
			
			while (item)
			{
				if (item.isFolder)		arrays[0].push(item);
				else if (!item.isEmpty)	arrays[1].push(item);
				item = item.next;
			}
			firstItem = null;
			lastItem = null;
			
			return arrays;
		}
		
		protected function getIcon(icon:MovieClip, type:String):MovieClip
		{
			if (!icon)
			{
				switch (type)
				{
					case SG_List.ITEM:	
					{
						if (_list.style.itemIcon)	return new _list.style.itemIcon() as MovieClip;
						break;
					}
					case SG_List.FOLDER:
					{
						if (_list.style.folderIcon)	return new _list.style.folderIcon() as MovieClip;
						break;
					}
				}
			}
			return icon;
		}
		
		override protected function mouseOver(event:MouseEvent):void 
		{
			if (!selected && _list.enableHighlight)	highlight = true;
			
			if (_opened)	btnExpand.arrow.rotation = 90;
			else			btnExpand.arrow.rotation = 0;
			
			if (hideArrow) 
			{
				btnExpand.x = depth * preset.depthMargin;
				btnExpand.visible = true;
				
				SP_Tweener.addTween(label, {x:labelPos + preset.depthMargin}, {time:preset.depthMargin, rounded:true});
				SP_Tweener.addTween(btnExpand, {alpha:1}, {delay:preset.depthMargin/2, time:preset.depthMargin/2});
				if (icon) SP_Tweener.addTween(icon, {x:iconPos + preset.depthMargin}, {time:preset.depthMargin, rounded:true});
			}
		}
		
		override protected function mouseOut(event:MouseEvent):void 
		{
			if (!selected && _list.enableHighlight) highlight = false;
			
			if (hideArrow) 
			{
				SP_Tweener.addTween(label, {x:labelPos}, {rounded:true, time:preset.depthMargin});
				SP_Tweener.addTween(btnExpand, {alpha:0}, {invisible:true, time:preset.depthMargin/2});
				if (icon) SP_Tweener.addTween(icon, {x:iconPos}, {rounded:true, time:preset.depthMargin});
			}
		}
		
		override protected function mouseDown(event:MouseEvent):void 
		{
			_list.selectItem(this, true);
			
			if (mouseX <= labelPos)
			{
				if (_opened)	collapse();
				else			expand();
			}
		}
		/// ===== @PRIVATE ================================================================ //
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
			removeEmptyItem();
			content.addChild(item);
		}
		
		private function addEmptyItem():void 
		{
			if (!isRoot && !emptyItem && _opened && length == 0)
			{
				emptyItem = new SG_ListEmptyItem(_list, preset);
				emptyItem.width = _width;
				emptyItem.depth = depth + 1;
				emptyItem.folder = this;
				addToList(emptyItem);
			}
		}
		
		private function smoothHide():void 
		{
			var item:SG_ListItem = lastItem;
			var delay:int = 0;
			var time:int = 4;
			var delayStep:int = (EXPAND_TIME/length)/1.3;
			
			while (item)
			{
				if (item.visible)
				{
					if (item.alphaTween) item.alphaTween.destroy();
					item.alphaTween = SP_Tweener.addTween(item, {alpha:0}, {time:time, priority:true,  delay:delay});
					delay += delayStep;
					if (time < 10) time++;
				}
				item = item.prev;
			}
		}
		
		public function smoothShow():void 
		{
			var item:SG_ListItem = firstItem;
			var delay:int = 0;
			var delayStep:int = (EXPAND_TIME/length)/1.2;
			
			while (item)
			{
				if (item.visible)
				{
					if (item.alphaTween) item.alphaTween.destroy();
					item.alphaTween = SP_Tweener.addTween(item, {init_alpha:0, alpha:1}, {time:10, priority:true,  delay:delay});
					delay += delayStep;
				}
				item = item.next;
			}
		}
		
		private function redrawMask(removeTween:Boolean = true, smooth:Boolean = false):void
		{
			if (removeTween) SP_Tweener.remove(folderMask);
			
			if (folderMask) 
			{
				var oldHeight:int = folderMask.height;
				var g:Graphics = folderMask.graphics;
				g.clear();
				g.beginFill(0x000000);
				g.drawRect(0,0, _width, contentHeight);
				g.endFill();
				folderMask.scaleY = 1;
				
				if (smooth)	SP_Tweener.addTween(folderMask, {init_height:oldHeight, height:contentHeight}, {time:EXPAND_TIME, ease:SP_Easing.quadOut});
			}
		}
		
		public function refresh(smooth:Boolean = false, withChilds:Boolean = false):void
		{
			var item:SG_ListItem = firstItem;
			var nextY:int = 0;
			var folder:SG_ListFolder;
			
			while (item)
			{	
				if (item.visible)
				{
					if (smooth)
					{
						if (item.fastRefresh)
						{
							item.y = nextY; 
							item.fastRefresh = false;
						}
						else SP_Tweener.addTween(item, {y:nextY}, {time:EXPAND_TIME, rounded:true, ease:SP_Easing.quadOut});
					}
					else item.y = nextY;
					
					if (item.visible) nextY += item.height;
				}
				if (withChilds && item.isFolder)
				{
					folder = item as SG_ListFolder;
					folder.refresh(smooth, withChilds);
				}
				item = item.next;
			}
			redrawMask(true, smooth);
			
			if (_opened && separator)
			{
				nextY = background.height + contentHeight;
				
				if (smooth)	SP_Tweener.addTween(separator, {y:nextY}, {time:EXPAND_TIME, rounded:true, ease:SP_Easing.quadOut});
				else		separator.y = nextY;
			}
		}
		
		internal function collapse(saveHistory:Boolean = true):void
		{	
			var action:SG_ListAction = new SG_ListAction(this, SG_ListAction.EXPAND, true);
			_opened = false;
			_list.setCurrentFolder(this);
			_list.refresh();
			if (saveHistory) _list.saveHistory(action);
			smoothHide();
			expandEvent();
			
			SP_Tweener.addTween(btnExpand.arrow, {rotation:0}, {time:ICON_TIME});
			SP_Tweener.addTween(folderMask, {init_scaleY:1, scaleY:0}, {time:EXPAND_TIME, ease:SP_Easing.quadOut});
			SP_Tweener.addTween(separator, {y:background.height}, {time:EXPAND_TIME, ease:SP_Easing.quadOut});
			expandTimeout = SP_Tweener.addTimeout(EXPAND_TIME, removeContent);
			if (icon) icon.prevFrame();
		}
		
		public function expand(smooth:Boolean = true, saveHistory:Boolean = true):void
		{
			var action:SG_ListAction = new SG_ListAction(this, SG_ListAction.EXPAND, true);
			_opened = true;
			_list.setCurrentFolder(this);
			
			addEmptyItem();
			addChild(content);
			refresh();
			
			if (saveHistory) _list.saveHistory(action);
			
			if (smooth)			
			{
				expandEvent();
				if (expandTimeout)
				{
					expandTimeout.destroy();
					expandTimeout = null;
				}
				SP_Tweener.addTween(btnExpand.arrow, {rotation:90}, {time:ICON_TIME});
				SP_Tweener.addTween(separator, {init_y:background.height, y:height}, {time:EXPAND_TIME, ease:SP_Easing.quadOut});
				SP_Tweener.addTween(folderMask, {init_scaleY:0, scaleY:1}, {time:EXPAND_TIME, ease:SP_Easing.quadOut});
				smoothShow();
				_list.refresh();
			}
			else
			{
				btnExpand.arrow.rotation = 90;
				separator.y = height;
				folderMask.height = contentHeight;
			}
			if (icon) icon.nextFrame();
			//list.saveHistory();
		}
		
		private function expandEvent():void
		{
			var event:SG_ListEvent = new SG_ListEvent(SG_ListEvent.EXPAND_FOLDER);
			event.item = this;
			_list.dispatchEvent(event);
		}
		

		// *** PROPERTIES *** //

		
		public function set opened(value:Boolean):void 
		{
			if (_opened && !value)	collapse(false);
			if (!_opened && value)	expand(true, false);
			
			_opened = value;
		}
		
		override public function set depth(value:int):void
		{
			_depth = value;
			updateDepth();
			refreshDepth();
		}
		
		override public function set width(value:Number):void
		{
			_width = value;
			
			if (!isRoot) 
			{
				updateLabelWidth();
				
				redraw();
				redrawMask(false);
			}
			
			var item:SG_ListItem = firstItem;
			
			while (item)
			{
				item.width = value;
				item = item.next;
			}
		}
		
		public function set hideArrow(value:Boolean):void
		{
			_hideArrow = value;
			
			if (value)
			{
				btnExpand.x = 0;
				btnExpand.y = Math.round((background.height-btnExpand.height)/2);
				btnExpand.visible = false;
				container.addChild(btnExpand);
			}
			else 
			{
				btnExpand.alpha = 1;
				btnExpand.visible = true;
				setIcon(btnExpand);
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
		
		public function get hideArrow():Boolean
		{
			return _hideArrow;
		}
		
		public function get dataProvider():SP_DataProvider
		{
			var data:SP_DataProvider = new SP_DataProvider();
			
			return data;
		}
		
		public function updateChilds():void
		{
			var item:SG_ListItem = firstItem;
			
			while (item)
			{
				item.list = list;
				content.addChild(item);
				item = item.next;
			}
		}
		
		public function set dataProvider(data:SP_DataProvider):void
		{
			
		}
		
	}
}