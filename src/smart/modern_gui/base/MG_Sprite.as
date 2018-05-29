package smart.modern_gui.base
{
	import flash.display.Sprite;
	
	import smart.modern_gui.base.MG_Component;
	
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
		
		public function drawRectShift(color:uint, width:int, height:int, shift:int):void 
		{
			graphics.beginFill(color);
			graphics.drawRect(shift, shift, width - shift*2, height - shift*2);
			graphics.endFill();
		}
		
		public function drawRoundRect(color:uint, width:int, height:int, radius:Number, x:int = 0, y:int = 0):void 
		{
			if (width > height && radius > height)	radius = height;
			if (width < height && radius > width)	radius = width;
			
			graphics.beginFill(color);
			graphics.drawRoundRect(x, y, width, height, radius);
			graphics.endFill();
		}
		
		public function setPosition(x:int, y:int):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function drawCircle(color:uint, radius:int, x:int = 0, y:int = 0):void
		{
			graphics.beginFill(color);
			graphics.drawCircle(x, y, radius);
			graphics.endFill();
		}
		
		
		// *** PROPERTIES *** //
		
		
		public function get component():MG_Component
		{
			return _component;
		}
		
	}
}
