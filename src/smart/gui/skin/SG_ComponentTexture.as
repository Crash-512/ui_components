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
		
		public function destroy():void
		{
			if (bitmapData) bitmapData.dispose();
			bitmapData = null;
			rect = null;
		}
		
		public function clone():SG_ComponentTexture 
		{
			return new SG_ComponentTexture(bitmapData.clone(), rect.clone());
		}
		
	}

}