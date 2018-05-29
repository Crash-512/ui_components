package smart.modern_gui.scroll
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import smart.modern_gui.MG_IUpdatable;
	import smart.modern_gui.base.MG_Container;
	import smart.modern_gui.base.MG_Sprite;
	import smart.modern_gui.constants.MG_Colors;
	import smart.modern_gui.signals.MG_Signal;
	import smart.modern_gui.utils.MG_Updater;
	
	internal class MG_ScrollBar extends MG_Container implements MG_IUpdatable
	{
		protected var _content:Sprite;
		protected var _btnScrollA:MG_ScrollButton;
		protected var _btnScrollB:MG_ScrollButton;
		
		protected var _bar:MG_Sprite;
		protected var _barPressed:Boolean;
		protected var _barSize:Number = 0.5;
		protected var _initMouse:Point;
		protected var _initPosition:Point;
		protected var _scrollSpeed:int = 25;
		protected var _scrollStep:int = 50;
		protected var _onScroll:MG_Signal;
		protected var _scrollPane:MG_ScrollPane;

		protected var _barColor:uint = _barNormalColor;
		protected var _barNormalColor:uint = MG_Colors.GRAY_MEDIUM_1;
		protected var _barPressedColor:uint = MG_Colors.GRAY_MEDIUM_3;
		
		public static const THICKNESS:int = 20;
		
		
		public function MG_ScrollBar(scrollPane:MG_ScrollPane, onScroll:MG_Signal)
		{
			super();
			
			_width = THICKNESS;
			_onScroll = onScroll;
			_scrollPane = scrollPane;
			_hasBackground = true;
			_backgroundColor = MG_Colors.GRAY_DARK_2;
			
			_initMouse = new Point();
			_initPosition = new Point();
			_btnScrollA = new MG_ScrollButton();
			_btnScrollB = new MG_ScrollButton();
			
			add(_btnScrollA);
			add(_btnScrollB);
			
			_bar = new MG_Sprite();
			_display.addChild(_bar);
			
			_bar.addEventListener(MouseEvent.MOUSE_DOWN, onPressBar);
			
			MG_Updater.add(this);
		}
		
		public function setValue(value:int):void 
		{
			
		}
		
		public function update():void 
		{
			
		}
		
		public function reset():void 
		{
			redraw();
		}
		
		override public function redraw():void
		{
			super.redraw();
			_btnScrollA.visible = true;
			_btnScrollB.visible = true;
		}
		
		private function onPressBar(event:MouseEvent):void
		{
			reset();
			_barPressed = true;
			_initMouse.setTo(mouseX, mouseY);
			_initPosition.setTo(_bar.x, _bar.y);
			_barColor = _barPressedColor;
			redraw();
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			_barPressed = false;
			_barColor = _barNormalColor;
			redraw();
			var stage:Stage = event.currentTarget as Stage;
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		
		// *** PROPERTIES *** //
		
		
		public function set content(value:Sprite):void
		{
			_content = value;
		}
		
		public function get content():Sprite
		{
			return _content;
		}
		
		public function set barSize(value:Number):void
		{
			_barSize = value;
			redraw();
		}
		
	}
}
