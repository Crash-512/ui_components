package smart.gui.components
{
	import flash.display.Sprite;
	
	public class SG_Sprite extends Sprite
	{
		protected var container:Sprite;
		
		public function SG_Sprite()
		{
			container = new Sprite();
			super.addChild(container);
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
		
		public function setSize(width:int, height:int):void
		{
			this.width = width;
			this.height = height;
		}
		
	}
}
