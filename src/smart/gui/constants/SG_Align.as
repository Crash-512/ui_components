package smart.gui.constants
{
	public class SG_Align
	{
		public static const NONE:String = "none";
		public static const ZERO:String = "zero";
		public static const CENTER:String = "center";
		public static const TOP:String = "top";
		public static const BOTTOM:String = "bottom";
		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";
		
		
		public static function isValidHorisontal(value:String):Boolean
		{
			return (value == NONE || value == ZERO || value == CENTER || value == LEFT || value == RIGHT);
		}
		
		public static function isValidVertical(value:String):Boolean
		{
			return (value == NONE || value == ZERO || value == CENTER || value == BOTTOM || value == CENTER);
		}
		
	}
}
