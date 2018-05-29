package smart.gui.components
{
	import smart.gui.SG_Fonts;
	import smart.gui.constants.SG_Align;
	import smart.gui.constants.SG_TextColors;
	
	public class SG_TextStyle
	{
		public var font:String;
		public var size:uint;
		public var color:uint;
		public var bold:Boolean;
		public var align:String;

		public static var label_small:SG_TextStyle = new SG_TextStyle(SG_Fonts.PT_SANS, 12, SG_TextColors.DARK_SOFT, true);
		public static var label_medium:SG_TextStyle = new SG_TextStyle(SG_Fonts.PT_SANS, 14, SG_TextColors.DARK_MEDIUM, false);
		public static var label_large:SG_TextStyle = new SG_TextStyle(SG_Fonts.PT_SANS, 15, SG_TextColors.DARK_SOFT, true);

		public static var textSwitcher_small:SG_TextStyle = new SG_TextStyle(SG_Fonts.PT_SANS, 13, SG_TextColors.BRIGHT_SOFT, true, SG_Align.CENTER);
		public static var textSwitcher_medium:SG_TextStyle = new SG_TextStyle(SG_Fonts.PT_SANS, 14, SG_TextColors.BRIGHT_SOFT, true, SG_Align.CENTER);
		public static var textSwitcher_large:SG_TextStyle = new SG_TextStyle(SG_Fonts.PT_SANS, 16, SG_TextColors.BRIGHT_SOFT, true, SG_Align.CENTER);

		public static var tab_medium:SG_TextStyle = new SG_TextStyle(SG_Fonts.PT_SANS, 14, SG_TextColors.DARK_MEDIUM, false, SG_Align.CENTER);

		public static var textInput_small:SG_TextStyle = new SG_TextStyle(SG_Fonts.PT_SANS, 11, SG_TextColors.DARK_VERY);
		public static var textInput_medium:SG_TextStyle = new SG_TextStyle(SG_Fonts.PT_SANS, 13, SG_TextColors.DARK_VERY);
		public static var textInput_large:SG_TextStyle = new SG_TextStyle(SG_Fonts.PT_SANS, 15, SG_TextColors.DARK_VERY);

		public static var comboBox_small:SG_TextStyle = new SG_TextStyle(SG_Fonts.PT_SANS, 10, SG_TextColors.DARK_VERY);
		public static var comboBox_medium:SG_TextStyle = new SG_TextStyle(SG_Fonts.PT_SANS, 13, SG_TextColors.DARK_VERY);
		public static var comboBox_large:SG_TextStyle = new SG_TextStyle(SG_Fonts.PT_SANS, 16, SG_TextColors.DARK_VERY);

		public static var button_small:SG_TextStyle = new SG_TextStyle(SG_Fonts.PT_SANS, 12, SG_TextColors.DARK_SOFT, true, SG_Align.CENTER);
		public static var button_medium:SG_TextStyle = new SG_TextStyle(SG_Fonts.PT_SANS, 14, SG_TextColors.DARK_SOFT, true, SG_Align.CENTER);
		public static var button_large:SG_TextStyle = new SG_TextStyle(SG_Fonts.PT_SANS, 16, SG_TextColors.DARK_SOFT, true, SG_Align.CENTER);

		public static var list_message:SG_TextStyle = new SG_TextStyle(SG_Fonts.ARIAL, 16, SG_TextColors.BRIGHT_VERY, true);
		public static var listLabel_small:SG_TextStyle = new SG_TextStyle(SG_Fonts.PT_SANS, 12, SG_TextColors.BLACK);
		public static var listLabel_medium:SG_TextStyle = new SG_TextStyle(SG_Fonts.PT_SANS, 14, SG_TextColors.BLACK);
		public static var listLabel_large:SG_TextStyle = new SG_TextStyle(SG_Fonts.PT_SANS, 16, SG_TextColors.BLACK);

		public static var code:SG_TextStyle = new SG_TextStyle(SG_Fonts.CONSOLAS, 13, SG_TextColors.DARK_MEDIUM, true);
		public static var progress_precent:SG_TextStyle = new SG_TextStyle(SG_Fonts.PT_SANS, 13, SG_TextColors.DARK_MEDIUM, true);

		
		public function SG_TextStyle(font:String = "Arial", size:uint = 14, color:uint = 0x000000, bold:Boolean = false, align:String = "left")
		{
			this.align = align;
			this.bold = bold;
			this.color = color;
			this.size = size;
			this.font = font;
		}
		
		public function clone():SG_TextStyle 
		{
			return new SG_TextStyle(font, size, color, bold, align);
		}
		
	}

}