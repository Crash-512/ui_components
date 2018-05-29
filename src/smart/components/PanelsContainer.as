package smart.components
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.Font;
	
	import smart.gui.components.SG_Button;
	import smart.gui.signals.SG_Signal;
	import smart.gui.scroll.MG_ScrollPane;
	
	public class PanelsContainer extends Sprite
	{
		private var _panels:Vector.<Panel>;
		private var _layout:Layout;
		private var _scroller:MG_ScrollPane;
		private var _onChangeUiState:SG_Signal;
		private var _onContentScrolled:SG_Signal;
		
		public function PanelsContainer(height:int = 900)
		{
			Font.registerFont(FontPtSans);
			Font.registerFont(FontPtSansBold);
			
			_panels = new <Panel>[];
			_layout = new Layout();
			
			_scroller = new MG_ScrollPane(_layout);
			_scroller.width = 310;
			_scroller.height = height;
			addChild(_scroller.display);
			
			initPanels();
			updatePanels();
			
			_scroller.redraw();
			_scroller.onScrolled.add(onScrolled);
			
			_onChangeUiState = new SG_Signal();
			_onContentScrolled = new SG_Signal();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onScrolled():void
		{
			_onContentScrolled.emit(scrollPosition);
		}
		
		private function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.addEventListener(Event.RESIZE, onResize);
		}
		
		private function onResize(event:Event):void
		{
			_scroller.height = stage.stageHeight;
		}
		
		public function setObject(object:Object):void
		{
			for each (var panel:Panel in _panels)
			{
				panel.setObject(object);
			}
		}
		
		protected function initPanels():void
		{
		}
		
		protected function createPanel(name:String):Panel
		{
			return addPanel(new Panel(name));
		}
		
		protected function addPanel(panel:Panel):Panel
		{
			panel.setLayout(_layout);
			panel.onClick.add(onPanelClick);
			panel.onPressButton.add(onPressButton);
			panel.init();
			panel.postInit();
			_layout.addChild(panel);
			_panels.push(panel);
			return panel;
		}
		
		protected function onPressButton(button:SG_Button):void
		{
		
		}
		
		private function onClickPanel(panel:Panel):void 
		{
			_scroller.redraw();
			
			if (panel.maximized)
			{
				var scrollY:int = _layout.scrollRect.y;
				var delta:int = _scroller.height - (panel.y  - scrollY + panel.height);
				
				if (delta < 0) 
				{
					_scroller.setScrollY(scrollY - delta);
				}
			}
		}
		
		private function onPanelClick():void
		{
			_onChangeUiState.emit();
			_layout.update();
		}
		
		private function updatePanels():void
		{
			for each (var panel:Panel in _panels)
			{
				panel.updateSize();
				panel.onClick.add(onClickPanel);
			}
			_layout.update();
		}
		
		public function get panels():Vector.<Panel>
		{
			return _panels;
		}
		
		public function get onChangeUiState():SG_Signal
		{
			return _onChangeUiState;
		}
		
		public function set scrollPosition(value:int):void
		{
			_scroller.setScrollY(value);
		}
		
		public function get scrollPosition():int
		{
			return _layout.scrollRect.y;
		}
		
		public function get onContentScrolled():SG_Signal
		{
			return _onContentScrolled;
		}
	}
}
