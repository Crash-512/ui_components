package smart.modern_gui.data
{
	import flash.geom.Rectangle;
	
	public class MG_Size
	{
		public var width:int;
		public var height:int;
		
		  
		public function MG_Size(width:int, height:int)
		{
			this.width = width;
			this.height = height;
		}
		
		public function getRect():Rectangle 
		{
			return new Rectangle(0, 0, width, height);
		}
		
	}
}
