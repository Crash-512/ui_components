package smart.modern_gui.base
{
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	
	import smart.modern_gui.base.MG_Sprite;
	import smart.modern_gui.mg_internal;
	import smart.modern_gui.signals.MG_Signal;
	import smart.modern_gui.skin.MG_BaseSkin;
	
	use namespace mg_internal;

	public class MG_Component extends EventDispatcher
	{
		mg_internal var newX:int;
		mg_internal var newY:int;
		mg_internal var container:MG_Container;
		mg_internal var prev:MG_Component;
		mg_internal var next:MG_Component;
		
		public var debug:Boolean;
		
		protected var _widthInPercent:uint;
		protected var _heightInPercent:uint;
		protected var _enabled:Boolean;
		
		protected var _skin:MG_BaseSkin;
		protected var _display:MG_Sprite;
		protected var _lastChild:MG_Component;
		protected var _firstChild:MG_Component;
		protected var _hasChildren:Boolean;
		
		private var _onRedraw:MG_Signal;
		
		  
		public function MG_Component()
		{
			_enabled = true;
			_display = new MG_Sprite(this);
			_onRedraw = MG_Signal.create();
		}
		
		protected function addChild(child:MG_Component):void
		{
			_display.addChild(child.display);
		}
		
		protected function removeChild(child:MG_Component):void
		{
			_display.removeChild(child.display);
		}
		
		protected function contains(child:MG_Component):Boolean
		{
			return _display.contains(child.display);
		}
		
		public function dispose():void 
		{
			
		}
		
		mg_internal function applyChanges():void 
		{
			_display.x = newX;
			_display.y = newY;
		}
		
		public function redraw():void
		{
			_display.clearCanvas();
			_onRedraw.dispatch(this);
		}
		
		public function setPosition(x:int, y:int):void 
		{
			_display.x = x;
			_display.y = y;
		}
		
		public function removeFromParent():void 
		{
			if (container) container.remove(this);
		}
		
		
		// *** PROPERTIES *** //
		
		
		public function get stage():Stage
		{
			return _display.stage;
		}
		
		public function get display():MG_Sprite
		{
			return _display;
		}
		
		public function set x(value:int):void
		{
			_display.x = value;
		}
		
		public function get x():int
		{
			return _display.x;
		}
		
		public function set y(value:int):void
		{
			_display.y = value;
		}
		
		public function get y():int
		{
			return _display.y;
		}
		
		public function set visible(value:Boolean):void
		{
			_display.visible = value;
		}
		
		public function get visible():Boolean
		{
			return _display.visible;
		}
		
		public function get parent():MG_Container
		{
			return container;
		}
		
		public function get width():int	
		{
			return _display.width;
		}
		
		public function get height():int	
		{
			return _display.height;
		}
		
		public function get mouseX():int
		{
			return _display.mouseX;
		}
		
		public function get mouseY():int
		{
			return _display.mouseY;
		}
		
		public function get onRedraw():MG_Signal
		{
			return _onRedraw;
		}
		
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			redraw();
		}
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
	}
}
