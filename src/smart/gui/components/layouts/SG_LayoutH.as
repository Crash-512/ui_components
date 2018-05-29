package smart.gui.components.layouts 
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import smart.gui.constants.SG_Align;
	
	public class SG_LayoutH extends SG_Layout
	{
		
		public function SG_LayoutH(spacing:int = 10, alignV:String = SG_Align.NONE, centerPoint:String = "null")
		{
			super(spacing, alignV, centerPoint);
		}
		
		override public function update(event:Event = null):void 
		{
			if (event && !autoUpdate) return;
			
			var nextPos:int = 0;
			var maxSize:int = 0;
			var objects:Array = getObjects();
			var rect:Rectangle;
			
			for each (var object:DisplayObject in objects)
			{	
				if (object.visible)
				{
					if (useRectAlign)
					{
						object.x = 0;
						rect = object.getRect(content);
						object.x = -rect.x + nextPos;
					} 
					else object.x = nextPos;
					
					nextPos += object.width + _spacing;
					if (object.height > maxSize) maxSize = object.height;
				}
			}
			if (enableAlign) for each (object in objects)
			{
				if (object.visible)
				{
					if (_align != SG_Align.NONE)
					{
						object.y = 0;
						rect = object.getRect(content);
						object.y = -rect.y;
					}
					switch (_align)
					{
						case SG_Align.ZERO:	    object.y = 0;								break;
						case SG_Align.BOTTOM:	object.y += (maxSize - object.height);		break;
						case SG_Align.CENTER:	object.y += (maxSize - object.height)/2;	break;
					}
					object.x = Math.round(object.x);
					object.y = Math.round(object.y);
				}	
			}
			super.update(event);
		}
		
		override public function get width():Number
		{
			var object:DisplayObject;
			var objects:Array = getObjects();
			var width:Number = 0;
			
			while (objects.length != 0)
			{
				object = objects.pop();
				width += object.width;
				if (objects.length != 0) width += _spacing;
			}
			return width;
		}
		
		override public function get height():Number
		{
			var objects:Array = getObjects();
			var height:Number = Number.MIN_VALUE;
			
			for each (var object:DisplayObject in objects)
			{
				if (object.height > height) height = object.height;
			}
			return height;
		}
		
	}

}