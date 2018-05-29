package smart.gui.components.controllers 
{
	import flash.events.*;
	
	public class SG_CheckBox extends CheckBoxSprite
	{
		private var _checked:Boolean;
		private var _enabled:Boolean;
		
		
		public function SG_CheckBox()
		{
			check.visible = false;
			enabled = true;
			addEventListener(MouseEvent.MOUSE_OVER, overButton);
			addEventListener(MouseEvent.MOUSE_OUT, outButton);
			addEventListener(MouseEvent.MOUSE_DOWN, checkIt);
		}
		
		private function checkIt(event:MouseEvent):void
		{
			if (_enabled)
			{
				_checked = !_checked;
				check.visible = _checked;
				check.gotoAndPlay(1);
				
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		private function overButton(event:MouseEvent):void
		{
			if (_enabled) nextFrame();
		}
		
		private function outButton(event:MouseEvent):void
		{
			if (_enabled) prevFrame();
		}
		
		public function get checked():Boolean 
		{
			return _checked;
		}
		
		public function set checked(value:Boolean):void 
		{
			_checked = value;
			check.visible = _checked;
			check.gotoAndPlay(1);
		}
		
		override public function get enabled():Boolean 
		{
			return _enabled;
		}
		
		override public function set enabled(value:Boolean):void 
		{
			_enabled = value;
			
			if (_enabled)
			{
				mouseEnabled = true;
				mouseChildren = true;
			}
			else
			{
				mouseEnabled = false;
				mouseChildren = false;
			}
		}
		
	}
}