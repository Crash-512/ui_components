package smart.gui.components.combobox 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	
	import smart.gui.components.SG_CenterPoint;
	
	import smart.gui.components.SG_ComponentType;
	
	import smart.gui.components.SG_DynamicComponent;
	import smart.gui.components.buttons.SG_Button;
	import smart.gui.components.buttons.SG_ButtonType;
	
	import smart.gui.components.icons.SG_Icon;
	import smart.gui.components.icons.SG_IconType;
	import smart.gui.components.list.SG_List;
	import smart.gui.components.list.SG_ListEvent;
	import smart.gui.components.list.SG_ListItem;
	import smart.gui.components.text.SG_TextLabel;
	import smart.gui.components.text.SG_TextStyle;
	import smart.gui.constants.SG_SkinType;
	import smart.gui.constants.SG_ValueType;
	import smart.gui.data.SG_Size;
	import smart.gui.data.SP_DataProvider;
	import smart.gui.skin.SG_GUISkin;
	import smart.tweener.SP_Easing;
	import smart.tweener.SP_Tweener;
	
	public class SG_ComboBox extends SG_DynamicComponent
	{
		public var dropdownCount:int = 5;
		public var selectedItem:SG_ListItem;
		public var list:SG_List;
		public var parentContainer:Sprite;
		
		private var _dropUpSide:Boolean;
		private var _size:String;
		private var defaultText:String;
		private var button:SG_Button;
		
		protected var lockEvent:Boolean;
		protected var label:SG_TextLabel;
		protected var locked:Boolean;
		
		private static const COLOR_TIME:int = 4;
		private static const DROP_TIME:int = 5;
		
		private static const SHADOW_FILTER:DropShadowFilter = new DropShadowFilter(4, 90, 0, 0.15, 12, 12);
		
		
		public function SG_ComboBox(defaultText:String = "Select Item", items:Vector.<String> = null) 
		{
			this.defaultText = defaultText;
			_skinType = SG_SkinType.TEXT_INPUT;
			_size = SG_Size.MEDIUM;
			init();
			if (items) setItemsFromArray(items);
			
			// TODO при скроле мышкой убирать alpha = 0.5
			type = SG_ComponentType.COMBO_BOX;
			valueType = SG_ValueType.STRING;
		}
		
		override public function setSkin(skin:SG_GUISkin):void
		{
			super.setSkin(skin);
			button.setSkin(skin);
			list.setSkin(skin);
			list.componentSkin.filters = [SHADOW_FILTER];
			updateSize();
			_componentSkin.currentState = 1;
		}
		
		public function setItemsFromArray(items:Vector.<String>):void
		{
			for each (var label:String in items) list.addItem(label, null, false);
			list.refresh();
			list.resetSelection();
		}
		
		public function addItem(name:String, data:Object = null):SG_ListItem
		{
			var item:SG_ListItem = list.addItem(name, null, false);
			item.data = data;
			list.refresh();
			list.resetSelection();
			return item;
		}
		
		public function selectItem(item:SG_ListItem):void
		{
			label.text = item.text;
			label.alpha = 1;
			selectedItem = item;
			list.selectItem(item, false, false)
		}
		
		public function selectItemByName(name:String):void
		{
			if (name != null)
			{
				var listItem:SG_ListItem = list.getItemByName(name);

				if (listItem) selectItem(listItem);
				else          setDefaultMessage();
			}
			else setDefaultMessage();
		}
		
		private function updateSize():void
		{
			var style:SG_TextStyle;
			
			// TODO переделать
			switch (_size)
			{
				case SG_Size.SMALL:   
				{
					style = SG_TextStyle.comboBox_small.clone();
					button.setSize(18, 22);
					_componentSkin.height = 22;
					break;
				}
				case SG_Size.MEDIUM:  
				{
					style = SG_TextStyle.comboBox_medium.clone();
					button.setSize(18, 24);
					_componentSkin.height = 24;
					break;
				}
				case SG_Size.LARGE:   
				{
					style = SG_TextStyle.comboBox_large.clone();
					button.setSize(27, 32);
					_componentSkin.height = 32;
					break;
				}
			}
			style.color = _skin.textColor;
			label.style = style;
			label.y = Math.floor((_componentSkin.height - label.height)/2);
		}
		
		private function init():void
		{
			button = new SG_Button("", new SG_Icon(SG_IconType.DROP), SG_ButtonType.RIGHT);
			button.enableEvents(false);
			addChild(button);

			redrawSkin();
			_componentSkin.currentState = 1;

			initList();
			list.isComboBox = true;
			list.style.upCorners = false;
			list.enableDragAndDrop = true;
			list.componentSkin.filters = [SHADOW_FILTER];
			list.width = width;

			// Label
			label = new SG_TextLabel(defaultText);
			label.x = 5;
			label.alpha = 0.5;
			label.color = _skin.textColor;
			addChild(label);
			
			switch (_size)
			{
				case SG_Size.SMALL:     _componentSkin.width = 80;  break;
				case SG_Size.MEDIUM:    _componentSkin.width = 106; break;
				case SG_Size.LARGE:     _componentSkin.width = 130; break;
			}
			updateSize();

			// Events
			addEventListener(MouseEvent.MOUSE_OVER, overBox);
			addEventListener(MouseEvent.MOUSE_OUT, outBox);
			addEventListener(MouseEvent.MOUSE_DOWN, dropList);
			addEventListener(MouseEvent.MOUSE_WHEEL, scrollBox);
			list.addEventListener(SG_ListEvent.SELECT_ITEM, changeItem);
			refresh();
		}
		
		private function overBox(event:MouseEvent):void 
		{
			button.mouseOver();
			//SP_Tweener.addTween(_componentSkin, {color:SG_ColorFilters.GREEN}, {time:COLOR_TIME}, SP_Tweener.COLOR);
		}
		
		private function outBox(event:MouseEvent):void 
		{
			button.mouseOut();
			//SP_Tweener.addTween(_componentSkin, {color:SG_ColorFilters.RESET_FILTER}, {time:COLOR_TIME}, SP_Tweener.COLOR);
		}
		
		protected function scrollBox(event:MouseEvent):void 
		{
			var newIndex:int = selectedIndex;
			
			if (event.delta > 0) newIndex--;
			else				 newIndex++;
			
			if (newIndex < 0)            newIndex = 0;
			if (newIndex >= list.length) newIndex = list.length - 1;
			
			if (selectedIndex != newIndex)
			{
				selectedIndex = newIndex;
				dispatchEvent(new Event(Event.CHANGE));
				dispatchValue(value);
			}
		}
		
		protected function initList():void 
		{
			list = new SG_List(1);
			list.setDefaultIcons(null, null);
			list.visible = false;
		}
		
		private function dropList(event:MouseEvent):void 
		{
			button.mouseDown();
			updateListSize();
			if (list.visible)	hideList();
			else				showList();
			
			event.stopPropagation();
			event.stopImmediatePropagation();
		}
		
		protected function updateListSize():void 
		{
			var len:int = list.rootFolder.length;
			
			if (dropdownCount <= len)	list.height = dropdownCount * list.preset.itemHeight + 1;
			else						list.height = len * list.preset.itemHeight + 1;
		}
		
		private function showList():void 
		{
			var len:int = list.rootFolder.length;
			
			if (len == 0) return;
			
			lockEvent = true;
			stage.addEventListener(MouseEvent.CLICK, hideList);
			
			var listHeight:int;
			
			if (dropdownCount <= len)	listHeight = dropdownCount * list.preset.itemHeight + 2;
			else						listHeight = len * list.preset.itemHeight + 2;
			
			var listPos:Point;
			
			if (_dropUpSide)	listPos = new Point(0, 0);
			else				listPos = new Point(0, _componentSkin.height);

			listPos = localToGlobal(listPos);
			if (parentContainer) listPos = parentContainer.globalToLocal(listPos);
			
			list.x = listPos.x;
			list.y = listPos.y;
			list.resetScroll();
			list.visible = true;
			list.unlockList();
			list.height = 12;
			SP_Tweener.addTween(list, {height:listHeight}, {time:DROP_TIME, ease:SP_Easing.sineOut, onComplete:list.updateScroll});
			
			if (parentContainer) parentContainer.addChild(list);
			else                 stage.addChild(list);
		}
		
		private function hideList(event:Event = null):void 
		{
			if (list.visible && !lockEvent && !locked)
			{
				list.lockList();
				list.stage.removeEventListener(MouseEvent.CLICK, hideList);
				SP_Tweener.addTween(list, {height:12}, {time:DROP_TIME, removeChild:true, invisible:true, ease:SP_Easing.sineOut, onComplete:list.updateScroll});
			}
			lockEvent = false;
		}
		
		private function changeItem(event:Event):void 
		{
			selectItem(list.selectedItem);
			dispatchEvent(new Event(Event.CHANGE));
			dispatchValue(list.selectedItem.name);
		}
		
		public function setDefaultMessage():void
		{
			selectedItem = null;
			list.resetSelection();
			label.text = defaultText;
			label.alpha = 0.5;
		}
		
		private function refresh():void
		{
			button.x = _componentSkin.width;
		}
		

		// *** PROPERTIES *** //

		
		override public function set width(value:Number):void
		{
			_componentSkin.width = value - button.width;
			list.width = value;
			refresh();
		}
		
		override public function set height(value:Number):void
		{
			button.height = value;
			label.y = int(value - label.height)/2 - 1;
			super.height = value;
		}
		
		public function set text(value:String):void
		{
			label.text = value;
			label.alpha = 1;
		}
		
		public function set dropUpSide(value:Boolean):void 
		{
			_dropUpSide = value;
			
			if (_dropUpSide) list.centerPoint = SG_CenterPoint.BOTTOM_LEFT;
			else             list.centerPoint = SG_CenterPoint.TOP_LEFT;
			
			list.style.upCorners = value;
			list.style.downCorners = !value;
		}
		
		override public function set enabled(value:Boolean):void
		{
			_enabled = value;
			button.enabled = value;
			label.enabled = value;
			mouseEnabled = value;
			mouseChildren = value;
		}
		
		public function set dataProvider(data:SP_DataProvider):void 
		{
			list.dataProvider = data;
			enabled = true;
			setDefaultMessage();
		}
		
		public function set selectedIndex(index:int):void
		{
			if (index >= 0 && index < list.length)
			{
				var item:SG_ListItem = list.selectItemAt(index, false);
				selectItem(item);
			}
		}
		
		public function set size(value:String):void
		{
			_size = value;
			updateSize();
		}
		
		public function set value(name:String):void
		{
			selectItemByName(name);
		}
		
		public function get text():String
		{
			return label.text;
		}
		
		public function get length():int
		{
			return list.length;
		}
		
		public function get selectedIndex():int
		{
			if (selectedItem)	return selectedItem.childIndex;
			else				return -1;
		}
		
		public function get items():Array
		{
			var items:Array = [];
			var item:SG_ListItem = list.rootFolder.firstItem;
			
			while (item)
			{
				items.push(item);
				item = item.next;
			}
			return items;
		}
		
		public function get dropUpSide():Boolean 
		{
			return _dropUpSide;
		}
		
		public function get dataProvider():SP_DataProvider 
		{
			// TODO ComboBox DataProvider
			return null;
		}
		
		override public function get width():Number 
		{
			return _componentSkin.width + button.width;
		}
		
		public function get size():String
		{
			return _size;
		}
		
		public function get value():String
		{
			if (selectedItem) return selectedItem.text;
			return null;
		}
		
	}
}