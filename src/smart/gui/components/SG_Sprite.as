package smart.gui.components
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class SG_Sprite extends Sprite
	{
		protected var container:Sprite;
		protected var center:SG_CenterPoint;
		protected var _centerPoint:String = SG_CenterPoint.NULL;
		protected var _lockMouse:Boolean;
		
		  
		public function SG_Sprite()
		{
			container = new Sprite();
			center = new SG_CenterPoint(_centerPoint);
			super.addChild(container);
		}
		
		public function destroy():void 
		{
			// TODO сложный дестрой
			if (contains(container)) removeChild(container);
			while (container.numChildren != 0) container.removeChildAt(0);
		}
		
		public function removeAll():void 
		{
			while (numChildren != 0) removeChildAt(0);
		}
		
		public function setPosition(x:int = 0, y:int = 0):void 
		{
			this.x = x; 
			this.y = y; 
		}
		
		public function setScale(scale:Number):void
		{
			scaleX = scale;
			scaleY = scale;
		}
		
		public function setSize(width:int, height:int):void
		{
			this.width = width;
			this.height = height;
		}
		
		public function set centerPoint(value:String):void
		{
			_centerPoint = value;
			center.centerPoint = _centerPoint;
			updateCenter();
		}
		
		public function updateCenter():void
		{
			var rect:Rectangle = container.getRect(container);
			
			container.x = 0;
			container.y = 0;

			if (_centerPoint != SG_CenterPoint.NULL)
			{
				if (center == null) center = new SG_CenterPoint(_centerPoint);
				else                center.centerPoint = _centerPoint;
				
				if (center.bottom)     container.y = -rect.bottom;
				else if (center.top)   container.y = -rect.top;
				else                   container.y = -rect.y - rect.height/2;

				if (center.left)       container.x = -rect.left;
				else if (center.right) container.x = -rect.right;
				else                   container.x = -rect.x - rect.width/2;

				container.x = Math.round(container.x);
				container.y = Math.round(container.y);
			}
		}
		
		public function set lockMouse(value:Boolean):void
		{
			_lockMouse = value;
			container.mouseEnabled = !_lockMouse;
			container.mouseChildren = !_lockMouse;
		}
		
		public function get mouseXY():Point
		{
			return new Point(mouseX, mouseY);
		}
		
		public function get position():Point 
		{
			 return new Point(x, y);
		}
		
		public function get centerPoint():String
		{
			return _centerPoint;
		}
		
		public function get lockMouse():Boolean
		{
			return _lockMouse;
		}
		
	}
}
