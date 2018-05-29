package smart.gui.base
{
	import flash.display.Sprite;
	
	import smart.gui.base.MG_Component;
	
	public class MG_Sprite extends Sprite
	{
		private var _component:MG_Component;
		
		public function MG_Sprite(component:MG_Component = null)
		{
			_component = component;
			super();
		}
		
		public function clearCanvas():void 
		{
			graphics.clear();
		}
		
		public function drawRect(color:uint, width:Number, height:Number, x:Number = 0, y:Number = 0, alpha:Number = 1):void 
		{
			graphics.beginFill(color, alpha);
			graphics.drawRect(x, y, width, height);
			graphics.endFill();
		}
		
		public function setPosition(x:int, y:int):void
		{
			this.x = x;
			this.y = y;
		}
		
		// *** PROPERTIES *** //
		
		public function get component():MG_Component
		{
			return _component;
		}
		
	}
}
