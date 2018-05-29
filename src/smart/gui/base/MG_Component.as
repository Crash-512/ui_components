package smart.gui.base
{
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	
	import smart.gui.signals.SG_Signal;
	
	public class MG_Component extends EventDispatcher
	{
		internal var newX:int;
		internal var newY:int;
		internal var container:MG_Container;
		internal var prev:MG_Component;
		internal var next:MG_Component;
		
		protected var _widthInPercent:uint;
		protected var _heightInPercent:uint;
		protected var _enabled:Boolean;
		
		protected var _display:MG_Sprite;
		protected var _lastChild:MG_Component;
		protected var _firstChild:MG_Component;
		protected var _hasChildren:Boolean;
		
		private var _onRedraw:SG_Signal;
		
		  
		public function MG_Component()
		{
			_enabled = true;
			_display = new MG_Sprite(this);
			_onRedraw = SG_Signal.create();
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
		
		internal function applyChanges():void
		{
			_display.x = newX;
			_display.y = newY;
		}
		
		public function redraw():void
		{
			_display.clearCanvas();
			_onRedraw.emit(this);
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
		
		public function get onRedraw():SG_Signal
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
