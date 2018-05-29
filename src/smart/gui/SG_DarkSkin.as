package smart.gui
{
	import smart.gui.skin.SG_GUISkin;
	import smart.gui.skin.SG_SkinColor;

	public class SG_DarkSkin extends SG_GUISkin
	{
		  
		public function SG_DarkSkin()
		{
			super();
		}
		
		override protected function initColors():void
		{
			super.initColors();
			
			buttonColor = windowColor = new SG_SkinColor(_skinColor, -147, 2);
			sliderColor = new SG_SkinColor(_skinColor, -120);
			pickerColor = new SG_SkinColor(_skinColor, -100);
			textInputColor = new SG_SkinColor(_skinColor, -195);
			_activeColorNormal = new SG_SkinColor(_firstActiveColor, -70);
			_activeColorSaturated = new SG_SkinColor(_firstActiveColor, -80, 0, 15, 10);

			_secondActiveColor = 0x4C4C4C;
			_textColor = 0xC9C9C9;
			_windowTextColor = 0xBABABA;
			_buttonTextColor = 0xC4C4C4;
			_textShadowColor = buttonColor.getColor(8);
		}
		
	}
}
