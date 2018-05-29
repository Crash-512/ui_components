package smart.gui.components
{
	import smart.gui.constants.SG_Align;
	
	public class SG_TextStyle
	{
		public var font:String;
		public var size:uint;
		public var color:uint;
		public var bold:Boolean;
		public var align:String;
		
		private static const PT_SANS:String = "PT Sans";

		public static var listItem:SG_TextStyle		= new SG_TextStyle(PT_SANS, 14, 0x000000);
		public static var textInput:SG_TextStyle	= new SG_TextStyle(PT_SANS, 13, 0x333333);
		public static var label_medium:SG_TextStyle	= new SG_TextStyle(PT_SANS, 14, 0x4E4E4E);
		public static var label_large:SG_TextStyle	= new SG_TextStyle(PT_SANS, 15, 0x666666, true);
		public static var button:SG_TextStyle		= new SG_TextStyle(PT_SANS, 14, 0x666666, true, SG_Align.CENTER);

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