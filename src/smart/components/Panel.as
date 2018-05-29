package smart.components
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import smart.gui.components.SG_Component;
	import smart.gui.components.SG_Button;
	import smart.gui.components.SG_ComboBox;
	import smart.gui.components.SG_Slider;
	import smart.gui.components.SG_Stepper;
	import smart.gui.components.SG_Layout;
	import smart.gui.components.SG_LayoutH;
	import smart.gui.components.SG_LayoutV;
	import smart.gui.components.SG_Switcher;
	import smart.gui.components.SG_TextLabel;
	import smart.gui.components.SG_TextStyle;
	import smart.gui.constants.SG_Align;
	import smart.gui.skin.SG_SkinType;
	import smart.gui.signals.SG_Signal;
	
	public class Panel extends SG_Component
	{
		protected var _components:Vector.<Component>;
		
		private var _maximized:Boolean = true;
		private var _layout:SG_LayoutV;
		private var _title:SG_Component;
		private var _panel:SG_Component;
		private var _fldTitle:SG_TextLabel;
		private var _parentLayout:Layout;
		private var _size:int;
		private var _onClick:SG_Signal;
		private var _onPressButton:SG_Signal;
		
		private static const TITLE_HEIGHT:int = 24;
		
		public function Panel(title:String):void
		{
			super();
			
			_onClick = new SG_Signal();
			_onPressButton = new SG_Signal();
			
			_panel = new SG_Component();
			_panel.skinType = SG_SkinType.PANEL;
			super.addChild(_panel);
			
			_title = new SG_Component();
			_title.skinType = SG_SkinType.PANEL_TITLE;
			super.addChild(_title);
			
			_fldTitle = new SG_TextLabel(title, SG_TextStyle.label_large, SG_Align.CENTER);
			_fldTitle.color = _skin.windowTextColor;
			_fldTitle.mouseEnabled = false;
			_title.addChild(_fldTitle);
			
			_components = new <Component>[];
			
			_layout = new SG_LayoutV(8, SG_Align.LEFT);
			super.addChild(_layout);
			
			_title.addEventListener(MouseEvent.MOUSE_DOWN, onPressTitle);
		}
		
		public function init():void
		{
		
		}
		
		public function postInit():void
		{
		
		}
		
		public function setLayout(panelsLayout:Layout):void
		{
			_parentLayout = panelsLayout;
			_size = panelsLayout.panelSize;
			_panel.setSize(_size, _size);
			_title.setSize(_size, TITLE_HEIGHT);
			_layout.setPosition(panelsLayout.paddingX, 35);
		}
		
		private function onPressTitle(event:MouseEvent):void
		{
			maximized = !_maximized;
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			return _layout.addChild(child);
		}
		
		public function setObject(object:Object):void
		{
			for each (var component:Component in _components)
			{
				component.setObject(object);
			}
		}
		
		public function addComponent(component:Component):void
		{
			_layout.addChild(component);
			_components.push(component);
		}
		
		public function addComboBox(id:String, name:String, items:Vector.<String>):SG_ComboBox
		{
			var component:ComboBox = new ComboBox(id, name, items, _parentLayout);
			addComponent(component);
			return component.comboBox;
		}
		
		public function addSwitcher(id:String, name:String, value:Boolean = false):SG_Switcher
		{
			var component:Switcher = new Switcher(id, name, value, _parentLayout);
			addComponent(component);
			return component.switcher;
		}
		
		public function addSlider(id:String, name:String, minValue:Number, maxValue:Number, defaultValue:Number, tickInterval:Number = 10, snapInterval:Number = 1):SG_Slider
		{
			var component:Slider = new Slider(id, name, _parentLayout, minValue, maxValue, defaultValue, tickInterval, snapInterval);
			addComponent(component);
			return component.slider;
		}
		
		public function addStepper(id:String, name:String, minValue:Number, maxValue:Number, defaultValue:Number, interval:Number = 1):SG_Stepper
		{
			var component:Stepper = new Stepper(id, name, _parentLayout, minValue, maxValue, defaultValue, interval);
			addComponent(component);
			return component.stepper;
		}
		
		public function addButton(name:String, size:int = -1, layout:SG_Layout = null):SG_Button
		{
			var button:SG_Button = new SG_Button(name);
			button.width = size < 0 ? _parentLayout.panelSize - _parentLayout.paddingX * 2 : size;
			layout = layout == null ? _layout : layout;
			layout.addChild(button);
			button.onMouseDown.add(buttonPressed);
			return button;
		}
		
		public function addTwoButtons(nameA:String, nameB:String, callbackA:Function = null, callbackB:Function = null):void
		{
			var size:int = (_parentLayout.panelSize - _parentLayout.paddingX * 3) / 2;
			var layout:SG_LayoutH = new SG_LayoutH(_parentLayout.paddingX);
			
			var buttonA:SG_Button = addButton(nameA, size, layout);
			var buttonB:SG_Button = addButton(nameB, size, layout);
			
			if (callbackA != null) buttonA.onMouseDown.add(callbackA);
			if (callbackB != null) buttonB.onMouseDown.add(callbackB);
			
			buttonA.onMouseDown.add(buttonPressed);
			buttonB.onMouseDown.add(buttonPressed);
			
			_layout.addChild(layout);
		}
		
		private function buttonPressed(button:SG_Button):void
		{
			_onPressButton.emit(button);
		}
		
		public function addSeparator():void 
		{
			var size:Number = _size - _parentLayout.paddingX * 2;
			var separator:Sprite = new Sprite();
			separator.graphics.beginFill(0, 0.1);
			separator.graphics.drawRect(0, 0, size, 2);
			separator.graphics.endFill();
			_layout.addChild(separator);
		}
		
		public function updateSize():void
		{
			setSize(_size, _layout.height + 46);
		}
		
		override public function setSize(width:uint, height:uint = 0):void
		{
			_panel.setSize(width, height);
			updateTitle();
		}
		
		private function updateTitle():void
		{
			_fldTitle.x = Math.round((width - _fldTitle.width)/2);
		}
		
		override public function get width():Number
		{
			return _title.width;
		}
		
		override public function get height():Number
		{
			return _maximized ? super.height : TITLE_HEIGHT;
		}
		
		public function get onClick():SG_Signal
		{
			return _onClick;
		}
		
		public function get maximized():Boolean
		{
			return _maximized;
		}
		
		public function set maximized(value:Boolean):void
		{
			if (_maximized != value)
			{
				_maximized = value;
				_layout.visible = value;
				_panel.visible = value;
				_onClick.emit(this);
			}
		}
		
		public function get layout():SG_LayoutV
		{
			return _layout;
		}
		
		public function get onPressButton():SG_Signal
		{
			return _onPressButton;
		}
	}
}
