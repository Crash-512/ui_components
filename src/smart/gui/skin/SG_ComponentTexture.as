package smart.gui.skin 
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	internal class SG_ComponentTexture 
	{
		public var bitmapData:BitmapData;
		public var rect:Rectangle;
		
		
		public function SG_ComponentTexture(bitmapData:BitmapData, frameRect:Rectangle) 
		{
			this.bitmapData = bitmapData;
			this.rect = frameRect;
		}
	}

}