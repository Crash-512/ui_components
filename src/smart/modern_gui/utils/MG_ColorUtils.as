package smart.modern_gui.utils
{
	import flash.geom.ColorTransform;
	
	public class MG_ColorUtils
	{
		private static var _transform:ColorTransform = new ColorTransform();
		
		
		public static function offset(color:uint, red:int, green:int, blue:int):uint 
		{
			_transform.color = color;
			
			_transform.redOffset   += (red < 0)   ? max(red,   -_transform.redOffset)   : red;
			_transform.greenOffset += (green < 0) ? max(green, -_transform.greenOffset) : green;
			_transform.blueOffset  += (blue < 0)  ? max(blue,  -_transform.blueOffset)  : blue;
			
			return _transform.color;
		}
		
		private static function max(a:int, b:int):int 
		{
			return (a > b) ? a : b;
		}
		
	}
}
