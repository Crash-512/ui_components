package smart.gui.constants
{
	import flash.geom.ColorTransform;

	public class SG_ColorFilters
	{
		public static const BLUE:ColorTransform = new ColorTransform(1,1,1,1,-20,0,20);
		public static const GREEN:ColorTransform = new ColorTransform(1,1,1,1,-10,0,-25);
		public static const RED:ColorTransform = new ColorTransform(1,1,1,1,30,-130,-250);
		public static const DARK_BLUE:ColorTransform = new ColorTransform(1,1,1,1,-70,-20,30);
		public static const ICON_BLUE:ColorTransform = new ColorTransform(1,1,1,1,5,45,100);
		public static const BRIGHTNESS:ColorTransform = new ColorTransform(1,1,1,1,50,50,50);
		public static const RESET_FILTER:ColorTransform = new ColorTransform();
		public static const YELLOW:ColorTransform = new ColorTransform(1,1,1,1,50);
	}
}