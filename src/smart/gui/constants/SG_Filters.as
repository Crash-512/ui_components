package smart.gui.constants
{
	import flash.filters.ColorMatrixFilter;
	
	import smart.gui.colorFilter.SG_AdjustColor;
	
	public class SG_Filters
	{
		public static const NO_SATURATION:ColorMatrixFilter = SG_AdjustColor.getFilter(0,0,-100,0);
		public static const DISABLED:ColorMatrixFilter = SG_AdjustColor.getFilter(35,-10,-100,0);
	}

}