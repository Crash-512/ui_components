package smart.gui.components 
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	public class SG_CenterPoint 
	{
		private var _centerPoint:String;
		
		public var left:Boolean;
		public var right:Boolean;
		public var top:Boolean;
		public var bottom:Boolean;
		public var center:Boolean;
		
		public static const NULL:String = "null";
		public static const CENTER:String = "center";
		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";
		public static const TOP:String = "top";
		public static const BOTTOM:String = "bottom";
		public static const TOP_LEFT:String = "topLeft";
		public static const TOP_RIGHT:String = "topRight";
		public static const BOTTOM_LEFT:String = "bottomLeft";
		public static const BOTTOM_RIGHT:String = "bottomRight";
		
		
		public function SG_CenterPoint(centerPoint:String) 
		{
			this.centerPoint = centerPoint;	
		}
		
		public function set centerPoint(value:String):void 
		{
			_centerPoint = value;

			left = false;
			right = false;
			top = false;
			bottom = false;
			center = false;

			switch (_centerPoint)
			{
				case CENTER: center = true; break;
				case LEFT:   left = true;   break;
				case RIGHT:  right = true;  break;
				case TOP:    top = true;    break;
				case BOTTOM: bottom = true; break;

				case TOP_LEFT:     top = true;    left = true;  break;
				case TOP_RIGHT:    top = true;    right = true; break;
				case BOTTOM_LEFT:  bottom = true; left = true;  break;
				case BOTTOM_RIGHT: bottom = true; right = true; break;
			}
		}
		
		public function updateCenter(sprite:DisplayObject, rect:Rectangle = null):void 
		{
			if (!rect) rect = sprite.getRect(sprite);
			
			sprite.x = 0;
			sprite.y = 0;
			
			if (_centerPoint != NULL)
			{
				if (bottom)     sprite.y = -rect.bottom;
				else if (top)   sprite.y = -rect.top;
				else            sprite.y = -rect.y - rect.height/2;
				
				if (left)       sprite.x = -rect.left;
				else if (right) sprite.x = -rect.right;
				else            sprite.x = -rect.x - rect.width/2;
				
				sprite.x = Math.round(sprite.x);
				sprite.y = Math.round(sprite.y);
			}
		}
		
		public function get centerPoint():String
		{
			return _centerPoint;
		}
		
		
		// *** STATIC *** //
		
		
		public static function updateCenter(sprite:DisplayObject, centerPoint:String, rect:Rectangle = null):void
		{
			new SG_CenterPoint(centerPoint).updateCenter(sprite, rect);
		}
		
	}
}