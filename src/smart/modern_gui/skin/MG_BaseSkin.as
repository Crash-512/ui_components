package smart.modern_gui.skin
{
	import smart.modern_gui.constants.MG_Colors;
	
	public class MG_BaseSkin
	{
		public var borderColor:uint = MG_Colors.MINT;
		public var mainColor:uint = MG_Colors.GRAY_MEDIUM_1;
		public var listColor:uint = MG_Colors.GRAY_DARK_1;
		public var buttonColor:uint = MG_Colors.GRAY_BRIGHT_1;
		public var titleTextColor:uint = MG_Colors.WHITE;
		public var windowTextColor:uint = MG_Colors.TEXT_GRAY_1;
		public var listTextColor:uint = MG_Colors.WHITE_YELLOW;
		
		  
		public function MG_BaseSkin(borderColor:uint = MG_Colors.MINT,
									mainColor:uint = MG_Colors.GRAY_MEDIUM_1,
									listColor:uint = MG_Colors.GRAY_DARK_1,
									buttonColor:uint = MG_Colors.GRAY_BRIGHT_1,
									titleTextColor:uint = MG_Colors.WHITE,
									windowTextColor:uint = MG_Colors.TEXT_GRAY_1,
									listTextColor:uint = MG_Colors.WHITE_YELLOW)
		{
			this.borderColor = borderColor;
			this.mainColor = mainColor;
			this.listColor = listColor;
			this.buttonColor = buttonColor;
			this.titleTextColor = titleTextColor;
			this.windowTextColor = windowTextColor;
			this.listTextColor = listTextColor;
		}
		
	}
}
