package smart.gui.skin
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import smart.gui.skin.SG_ComponentTexture;
	
	internal class SG_ComponentGrid
	{
		public var frames:Vector.<SG_ComponentTexture>;
		public var width:uint;
		public var height:uint;
		
		private var sourceFrame:SG_ComponentTexture;
		
		  
		public function SG_ComponentGrid(frame:SG_ComponentTexture, width:uint, height:uint)
		{
			sourceFrame = frame;
			this.width = width;
			this.height = height;
			init();
		}
		
		private function init():void
		{
			var rect:Rectangle = new Rectangle(width, height, sourceFrame.rect.width - width*2, sourceFrame.rect.height - height*2);

			frames = new Vector.<SG_ComponentTexture>(9, true);
			frames[0] = createFrame(width, height, new Point(0, 0));
			frames[1] = createFrame(rect.width, height, new Point(rect.x, 0));
			frames[2] = createFrame(width, height, new Point(rect.right, 0));
			
			frames[3] = createFrame(width, rect.height, new Point(0, rect.y));
			frames[4] = createFrame(rect.width, rect.height, new Point(rect.x, rect.y));
			frames[5] = createFrame(width, rect.height, new Point(rect.right, rect.y));
			
			frames[6] = createFrame(width, height, new Point(0, rect.bottom));
			frames[7] = createFrame(rect.width, height, new Point(rect.x, rect.bottom));
			frames[8] = createFrame(width, height, new Point(rect.right, rect.bottom));
		}
		
		private function createFrame(width:uint, height:uint, destPoint:Point):SG_ComponentTexture 
		{
			var rect:Rectangle = new Rectangle(destPoint.x, destPoint.y, width, height);
			var bitmapData:BitmapData = new BitmapData(width, height, true, 0x00000000);
			bitmapData.copyPixels(sourceFrame.bitmapData, rect, new Point());
			
			var frame:SG_ComponentTexture = new SG_ComponentTexture(bitmapData, rect);
			
			return frame;
		}
		
	}
}
