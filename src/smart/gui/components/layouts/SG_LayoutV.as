package smart.gui.components.layouts 
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import smart.gui.constants.SG_Align;
	
	public class SG_LayoutV extends SG_Layout
	{
		
		public function SG_LayoutV(spacing:int = 10, alignH:String = SG_Align.NONE, centerPoint:String = "null")
		{
			super(spacing, alignH, centerPoint);
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
						object.y = 0;
						rect = object.getRect(content);
						object.y = -rect.y + nextPos;
					}
					else object.y = nextPos;
					
					nextPos += object.height + _spacing;
					if (object.width > maxSize) maxSize = object.width;
				}
			}
			if (enableAlign) for each (object in objects)
			{
				if (object.visible)
				{
					if (_align != SG_Align.NONE)
					{
						object.x = 0;
						rect = object.getRect(content);
						object.x = -rect.x;
					}
					switch (_align)
					{
						case SG_Align.ZERO:	    object.x = 0;							break;
						case SG_Align.RIGHT:	object.x += (maxSize - object.width);	break;
						case SG_Align.CENTER:	object.x += (maxSize - object.width)/2;	break;
					}
					object.x = Math.round(object.x);
					object.y = Math.round(object.y);
				}
			}
			super.update(event);
		}
		
		override public function get width():Number
		{
			var objects:Array = getObjects();
			var width:Number = Number.MIN_VALUE;
			
			for each (var object:DisplayObject in objects)
			{
				if (object.width > width) width = object.width;
			}
			return width + paddingH;
		}
		
		override public function get height():Number
		{
			var object:DisplayObject;
			var objects:Array = getObjects();
			var height:Number = 0;
			
			while (objects.length != 0)
			{
				object = objects.pop();
				height += object.height;
				if (objects.length != 0) height += _spacing;
			}
			return height + paddingV;
		}
		
	}

}