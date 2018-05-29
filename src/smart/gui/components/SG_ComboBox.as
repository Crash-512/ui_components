package smart.gui.components
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	
	import smart.gui.components.SG_ComponentType;
	import smart.gui.components.SG_DynamicComponent;
	import smart.gui.components.SG_Button;
	import smart.gui.components.SG_ButtonType;
	import smart.gui.components.SG_Icon;
	import smart.gui.components.SG_IconType;
	import smart.gui.components.SG_List;
	import smart.gui.components.SG_ListEvent;
	import smart.gui.components.SG_ListItem;
	import smart.gui.components.SG_TextLabel;
	import smart.gui.components.SG_TextStyle;
	import smart.gui.constants.SG_SkinType;
	import smart.gui.constants.SG_ValueType;
	import smart.gui.skin.SG_GUISkin;
	
	public class SG_ComboBox extends SG_DynamicComponent
	{
		public var dropdownCount:int = 5;
		public var selectedItem:SG_ListItem;
		public var list:SG_List;
		public var parentContainer:Sprite;
		
		private var _dropUpSide:Boolean;
		private var defaultText:String;
		private var button:SG_Button;
		
		protected var lockEvent:Boolean;
		protected var label:SG_TextLabel;
		protected var locked:Boolean;
		
		private static const SHADOW_FILTER:DropShadowFilter = new DropShadowFilter(4, 90, 0, 0.15, 12, 12);
		
		public function SG_ComboBox(defaultText:String = "Select Item", items:Vector.<String> = null) 
		{
			this.defaultText = defaultText;
			_skinType = SG_SkinType.TEXT_INPUT;
			init();
			if (items) setItemsFromArray(items);
			
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
			for each (var label:String in items) list.addItem(label);
			list.refresh();
			list.resetSelection();
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
			
			style = SG_TextStyle.comboBox_medium.clone();
			button.setSize(18, 24);
			_componentSkin.height = 24;
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
			list.componentSkin.filters = [SHADOW_FILTER];
			list.width = width;

			// Label
			label = new SG_TextLabel(defaultText);
			label.x = 5;
			label.alpha = 0.5;
			label.color = _skin.textColor;
			addChild(label);
			
			_componentSkin.width = 106;
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
		}
		
		private function outBox(event:MouseEvent):void 
		{
			button.mouseOut();
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
			list = new SG_List();
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
			
			if (dropdownCount <= len)	list.height = dropdownCount * 20 + 1;
			else						list.height = len * 20 + 1;
		}
		
		private function showList():void 
		{
			var len:int = list.rootFolder.length;
			
			if (len == 0) return;
			
			lockEvent = true;
			stage.addEventListener(MouseEvent.CLICK, hideList);
			
			var listHeight:int;
			
			if (dropdownCount <= len)	listHeight = dropdownCount * 20 + 2;
			else						listHeight = len * 20 + 2;
			
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
			list.height = listHeight;
			
			if (parentContainer) parentContainer.addChild(list);
			else                 stage.addChild(list);
		}
		
		private function hideList(event:Event = null):void 
		{
			if (list.visible && !lockEvent && !locked)
			{
				list.lockList();
				list.stage.removeEventListener(MouseEvent.CLICK, hideList);
				list.visible = false;
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
		
		override public function set enabled(value:Boolean):void
		{
			_enabled = value;
			button.enabled = value;
			label.enabled = value;
			mouseEnabled = value;
			mouseChildren = value;
		}
		
		public function set selectedIndex(index:int):void
		{
			if (index >= 0 && index < list.length)
			{
				var item:SG_ListItem = list.selectItemAt(index, false);
				selectItem(item);
			}
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
		
		override public function get width():Number 
		{
			return _componentSkin.width + button.width;
		}
		
		public function get value():String
		{
			if (selectedItem) return selectedItem.text;
			return null;
		}
		
	}
}