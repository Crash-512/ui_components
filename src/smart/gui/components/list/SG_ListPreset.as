package smart.gui.components.list 
{
	import smart.gui.components.text.SG_TextStyle;
	
	public class SG_ListPreset 
	{
		public static const SMALL:int = 0;
		public static const MEDIUM:int = 1;
		public static const LARGE:int = 2;
		
		public static const PRESET:Array =
		[
			new SG_ListPreset(20, 16, 2, 10, SG_TextStyle.listLabel_small),
			new SG_ListPreset(25, 20, 3, 14, SG_TextStyle.listLabel_medium),
			new SG_ListPreset(32, 26, 6, 18, SG_TextStyle.listLabel_large)
		];
		
		
		
		public var itemHeight:uint;
		public var iconMargin:uint;
		public var iconSize:uint;
		public var depthMargin:uint;
		public var textStyle:SG_TextStyle;
		
		
		public function SG_ListPreset(itemHeight:uint, iconSize:uint, iconMargin:uint, depthMargin:uint, textStyle:SG_TextStyle):void
		{
			this.itemHeight = itemHeight;
			this.iconMargin = iconMargin;
			this.iconSize = iconSize;
			this.depthMargin = depthMargin;
			this.textStyle = textStyle;
		}
		
	}

}