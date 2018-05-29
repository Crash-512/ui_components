package smart.gui.cursor 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.ui.MouseCursorData;

	public class SG_Mouse 
	{
		public static var mouseIsDown:Boolean;
		
		private static var prevCursor:String = MouseCursor.ARROW;
		
		private static const CURSOR_SIZE:int = 32;

		
		public static function initEvents(stage:Stage):void
		{
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}
		
		private static function mouseDown(event:MouseEvent):void
		{
			mouseIsDown = true;
		}
		
		private static function mouseUp(event:MouseEvent):void
		{
			mouseIsDown = false;
		}
		
		public static function setCursor(cursor:String):void
		{
			if (Mouse.supportsNativeCursor && Mouse.cursor != cursor)
			{
				try
				{
					Mouse.cursor = cursor;
				}
				catch (e:*) 
				{
					Mouse.cursor = MouseCursor.ARROW;
				}
			}
		}
		
		public static function saveCursor():void
		{
			prevCursor = Mouse.cursor;
		}
		
		public static function loadCursor():void
		{
			Mouse.cursor = prevCursor;
		}
		
		public static function isArrow():Boolean
		{
			return Mouse.cursor == SG_CursorType.ARROW;
		}
		
		public static function get currentCursor():String
		{
			return Mouse.cursor;
		}
		
		public static function registerCursor(sprite:Sprite, name:String):void
		{
			var rect:Rectangle = sprite.getRect(sprite);
			var bitmapData:BitmapData = new BitmapData(CURSOR_SIZE, CURSOR_SIZE, true, 0x00000000);
			var matrix:Matrix = new Matrix(1, 0, 0, 1, -rect.x, -rect.y);
			bitmapData.draw(sprite, matrix);
			registerCursorFromBitmap(bitmapData, rect, name);
		}
		
		public static function registerCursorFromBitmap(bitmapData:BitmapData, rect:Rectangle, name:String):void
		{
			var cursorFrames:Vector.<BitmapData> = new Vector.<BitmapData>(1, true);
			cursorFrames[0] = bitmapData;

			var hotSpot:Point = new Point();
			hotSpot.x = Math.round(-rect.x);
			hotSpot.y = Math.round(-rect.y);

			var cursorData:MouseCursorData = new MouseCursorData();
			cursorData.hotSpot = hotSpot;
			cursorData.data = cursorFrames;
			
			Mouse.registerCursor(name, cursorData);
		}
		
		public static function get cursor():String
		{
			return Mouse.cursor;
		}
		
	}

}