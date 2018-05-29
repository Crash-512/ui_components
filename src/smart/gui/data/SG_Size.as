package smart.gui.data 
{
	public class SG_Size 
	{
		public var width:Number;
		public var height:Number;

		public static const LARGE:String = "large";
		public static const MEDIUM:String = "medium";
		public static const SMALL:String = "small";
		
		
		public function SG_Size(width:Number = 0, height:Number = 0) 
		{
			this.width = width;
			this.height = height;
		}
		
		public function clone():SG_Size 
		{
			return new SG_Size(width, height);
		}
		
		public function toString():String
		{
			return "width:" + width + ", height:" + height;
		}
		
	}
}