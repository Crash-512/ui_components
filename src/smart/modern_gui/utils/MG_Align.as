package smart.modern_gui.utils
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import smart.modern_gui.constants.MG_AlignH;
	import smart.modern_gui.constants.MG_AlignV;
	
	public class MG_Align
	{
		
		[Inline] public static function centerByWidth(sprite:DisplayObject, width:int, useRect:Boolean = false):void
		{
			if (useRect)
			{
				var rect:Rectangle = sprite.getRect(sprite);
				sprite.x = -rect.x + int((width - rect.width) / 2);
			}
			else
			{
				sprite.x = int((width - sprite.width) / 2);
			}
		}
		
		[Inline] public static function centerByHeight(sprite:DisplayObject, height:int, useRect:Boolean = false):void
		{
			if (useRect)
			{
				var rect:Rectangle = sprite.getRect(sprite);
				sprite.y = -rect.y + int((height - rect.height) / 2);
			}
			else
			{
				sprite.y = int((height - sprite.height) / 2);
			}
		}
		
		[Inline] public static function centerBySize(sprite:DisplayObject, width:int, height:int, useRect:Boolean = false):void
		{
			if (useRect)
			{
				var rect:Rectangle = sprite.getRect(sprite);
				sprite.x = -rect.x + int((width - rect.width) / 2);
				sprite.y = -rect.y + int((height - rect.height) / 2);
			}
			else
			{
				sprite.x = int((width - sprite.width) / 2);
				sprite.y = int((height - sprite.height) / 2);
			}
		}
		
		[Inline] public static function alignByWidth(sprite:DisplayObject, alignH:MG_AlignH, width:int, useRect:Boolean = false):void
		{
			if (useRect)
			{
				var rect:Rectangle = sprite.getRect(sprite);
				
				switch (alignH)
				{
					case MG_AlignH.LEFT:	sprite.x = -rect.x;								break;
					case MG_AlignH.RIGHT:	sprite.x = width - rect.right;					break;
					case MG_AlignH.CENTER:	sprite.x = -rect.x + (width - rect.width)/2;	break;
				}
			}
			else
			{
				switch (alignH)
				{
					case MG_AlignH.LEFT:	sprite.x = 0;							break;
					case MG_AlignH.RIGHT:	sprite.x = width;						break;
					case MG_AlignH.CENTER:	sprite.x = (width - sprite.width)/2;	break;
				}
			}
			sprite.x = Math.round(sprite.x);
		}
		
		[Inline] public static function alignByHeight(sprite:DisplayObject, alignV:MG_AlignV, height:int, useRect:Boolean = false):void
		{
			if (useRect)
			{
				var rect:Rectangle = sprite.getRect(sprite);
				
				switch (alignV)
				{
					case MG_AlignV.TOP:		sprite.y = -rect.y;								break;
					case MG_AlignV.BOTTOM:	sprite.y = height - rect.bottom;				break;
					case MG_AlignV.CENTER:	sprite.y = -rect.y + (height - rect.height)/2;	break;
				}
			}
			else
			{
				switch (alignV)
				{
					case MG_AlignV.TOP:		sprite.y = 0;							break;
					case MG_AlignV.BOTTOM:	sprite.y = height;						break;
					case MG_AlignV.CENTER:	sprite.y = (height - sprite.height)/2;	break;
				}
			}
			sprite.y = Math.round(sprite.y);
		}
		
		[Inline] public static function alignBySize(sprite:DisplayObject, alignH:MG_AlignH, alignV:MG_AlignV, width:int, height:int, useRect:Boolean = false):void
		{
			alignByWidth(sprite, alignH, width, useRect);
			alignByHeight(sprite, alignV, height, useRect);
		}
		
	}
}
