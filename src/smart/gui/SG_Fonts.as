package smart.gui 
{
	import flash.text.Font;
	
	public class SG_Fonts 
	{
		public static const ARIAL:String = "Arial CYR";
		public static const CONSOLAS:String = "Consolas";
		public static const CENTURY_GOTHIC:String = "Century Gothic";
		public static const PT_SANS:String = "PT Sans";
		public static const DIGITAL:String = "Digital-7";
		
		
		public static function initFonts():void
		{
			Font.registerFont(FontArial);
			Font.registerFont(FontArialBold);
			Font.registerFont(FontConsolas);
			Font.registerFont(FontConsolasBold);
			Font.registerFont(FontCenturyGothic);
			Font.registerFont(FontCenturyGothicBold);
			Font.registerFont(FontPtSans);
			Font.registerFont(FontPtSansBold);
			Font.registerFont(FontDSDigital);
			Font.registerFont(FontDSDigitalBold);
		}
		
	}
}