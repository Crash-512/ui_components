package smart.gui.skin 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import smart.gui.constants.SG_SkinType;
	
	public class SG_GUISkin extends Sprite
	{
		[Embed(source="textures/buttonSprite.png")]					private static var ButtonSprite:Class;
		[Embed(source="textures/buttonLeftSprite.png")]				private static var ButtonLeftSprite:Class;
		[Embed(source="textures/buttonRightSprite.png")]			private static var ButtonRightSprite:Class;
		[Embed(source="textures/buttonCenterSprite.png")]			private static var ButtonCenterSprite:Class;
		[Embed(source="textures/buttonPressedSprite.png")]			private static var ButtonPressedSprite:Class;
		[Embed(source="textures/buttonRightPressedSprite.png")]		private static var ButtonRightPressedSprite:Class;
		[Embed(source="textures/buttonLeftPressedSprite.png")]		private static var ButtonLeftPressedSprite:Class;
		[Embed(source="textures/buttonCenterPressedSprite.png")]	private static var ButtonCenterPressedSprite:Class;
		[Embed(source="textures/textInputSprite.png")]				private static var TextInputSprite:Class;
		[Embed(source="textures/textInputLeftSprite.png")]			private static var TextInputLeftSprite:Class;
		[Embed(source="textures/textInputRightSprite.png")]			private static var TextInputRightSprite:Class;
		[Embed(source="textures/textInputCenterSprite.png")]		private static var TextInputCenterSprite:Class;
		[Embed(source="textures/listDefault.png")]					private static var ListDefault:Class;
		[Embed(source="textures/listUpCorners.png")]				private static var ListUpCorners:Class;
		[Embed(source="textures/listDownCorners.png")]				private static var ListDownCorners:Class;
		[Embed(source="textures/listNoCorners.png")]				private static var ListNoCorners:Class;
		[Embed(source="textures/pickerSprite.png")]					private static var PickerSprite:Class;
		[Embed(source="textures/pickerActiveSprite.png")]			private static var PickerActiveSprite:Class;
		[Embed(source="textures/sliderSprite.png")]					private static var SliderSprite:Class;
		[Embed(source="textures/sliderActiveSprite.png")]			private static var SliderActiveSprite:Class;
		[Embed(source="textures/switcherSprite.png")]				private static var SwitcherSprite:Class;
		[Embed(source="textures/switcherActiveSprite.png")]			private static var SwitcherActiveSprite:Class;
		[Embed(source="textures/switchButtonLeft.png")]				private static var SwitchButtonLeft:Class;
		[Embed(source="textures/switchButtonRight.png")]			private static var SwitchButtonRight:Class;
		[Embed(source="textures/switchButtonCenter.png")]			private static var SwitchButtonCenter:Class;
		[Embed(source="textures/onWordSprite.png")]					private static var OnWordSprite:Class;
		[Embed(source="textures/offWordSprite.png")]				private static var OffWordSprite:Class;
		[Embed(source="textures/panelSprite.png")]					private static var PanelSprite:Class;
		[Embed(source="textures/panelTitleSprite.png")]				private static var PanelTitleSprite:Class;
		
		private var button:SG_ComponentSkin;
		private var textInput:SG_ComponentSkin;
		private var panel:SG_ComponentSkin;
		private var panelTitle:SG_ComponentSkin;
		private var slider:SG_ComponentSkin;
		private var picker:SG_ComponentSkin;
		private var switcher:SG_ComponentSkin;
		private var onWord:SG_ComponentSkin;
		private var offWord:SG_ComponentSkin;
		private var list:SG_ComponentSkin;
		
		protected var _textColor:uint = 0xC9C9C9;
		protected var _buttonTextColor:uint = 0xC4C4C4;
		protected var _windowTextColor:uint = 0xBABABA;
		protected var _textShadowColor:uint = 0x5D5D5D;
		protected var _secondActiveColor:uint = 0x4C4C4C;
		
		public static var defaultSkin:SG_GUISkin = new SG_GUISkin();
		
		
		public function SG_GUISkin()
		{
			init();
		}
		
		private function init():void
		{
			var buttonFrames:Vector.<SG_ComponentTexture> = new Vector.<SG_ComponentTexture>(8, true);
			var textInputFrames:Vector.<SG_ComponentTexture> = new Vector.<SG_ComponentTexture>(4, true);
			var panelFrames:Vector.<SG_ComponentTexture> = new Vector.<SG_ComponentTexture>(1, true);
			var panelTitleFrames:Vector.<SG_ComponentTexture> = new Vector.<SG_ComponentTexture>(1, true);
			var sliderFrames:Vector.<SG_ComponentTexture> = new Vector.<SG_ComponentTexture>(2, true);
			var pickerFrames:Vector.<SG_ComponentTexture> = new Vector.<SG_ComponentTexture>(2, true);
			var switcherFrames:Vector.<SG_ComponentTexture> = new Vector.<SG_ComponentTexture>(2, true);
			var onWordFrames:Vector.<SG_ComponentTexture> = new Vector.<SG_ComponentTexture>(1, true);
			var offWordFrames:Vector.<SG_ComponentTexture> = new Vector.<SG_ComponentTexture>(1, true);
			var listFrames:Vector.<SG_ComponentTexture> = new Vector.<SG_ComponentTexture>(4, true);

			buttonFrames[0] = getBitmap(ButtonSprite);
			buttonFrames[1] = getBitmap(ButtonLeftSprite);
			buttonFrames[2] = getBitmap(ButtonRightSprite);
			buttonFrames[3] = getBitmap(ButtonCenterSprite);
			buttonFrames[4] = getBitmap(ButtonPressedSprite);
			buttonFrames[5] = getBitmap(ButtonRightPressedSprite);
			buttonFrames[6] = getBitmap(ButtonLeftPressedSprite);
			buttonFrames[7] = getBitmap(ButtonCenterPressedSprite);
			textInputFrames[0] = getBitmap(TextInputSprite);
			textInputFrames[1] = getBitmap(TextInputLeftSprite);
			textInputFrames[2] = getBitmap(TextInputRightSprite);
			textInputFrames[3] = getBitmap(TextInputCenterSprite);
			listFrames[0] = getBitmap(ListDefault);
			listFrames[1] = getBitmap(ListUpCorners);
			listFrames[2] = getBitmap(ListDownCorners);
			listFrames[3] = getBitmap(ListNoCorners);
			pickerFrames[0] = getBitmap(PickerSprite, true);
			pickerFrames[1] = getBitmap(PickerActiveSprite, true);
			sliderFrames[0] = getBitmap(SliderSprite);
			sliderFrames[1] = getBitmap(SliderActiveSprite);
			switcherFrames[0] = getBitmap(SwitcherSprite);
			switcherFrames[1] = getBitmap(SwitcherActiveSprite);
			onWordFrames[0] = getBitmap(OnWordSprite);
			offWordFrames[0] = getBitmap(OffWordSprite);
			panelFrames[0] = getBitmap(PanelSprite);
			panelTitleFrames[0] = getBitmap(PanelTitleSprite);
			
			button = createSkin(buttonFrames, "button");
			list = createSkin(listFrames, "list");
			textInput = createSkin(textInputFrames, SG_SkinType.TEXT_INPUT);
			panel = createSkin(panelFrames, "panel");
			panelTitle = createSkin(panelTitleFrames, "panelTitle");
			slider = createSkin(sliderFrames, "slider");
			picker = createSkin(pickerFrames, SG_SkinType.PICKER);
			switcher = createSkin(switcherFrames, SG_SkinType.SWITCHER);
			onWord = createSkin(onWordFrames, SG_SkinType.WORD_ON);
			offWord = createSkin(offWordFrames, SG_SkinType.WORD_OFF);
		
			button.setScale9Grid(5, 5);
			textInput.setScale9Grid(5, 5);
			list.setScale9Grid(5, 5);
			panel.setScale9Grid(25, 25);
			panelTitle.setScale9Grid(5, 5);
			slider.setScale9Grid(8, 5);
		}
		
		private function getBitmap(type:Class, pivotToCenter:Boolean = false):SG_ComponentTexture
		{
			var bitmapData:BitmapData = new type().bitmapData;
			var rect:Rectangle = new Rectangle(0, 0, bitmapData.width, bitmapData.height);
			if (pivotToCenter)
			{
				rect.x = -rect.width / 2;
				rect.y = -rect.height / 2;
			}
			return new SG_ComponentTexture(bitmapData, rect);
		}
		
		private function createSkin(frames:Vector.<SG_ComponentTexture>, name:String = null):SG_ComponentSkin
		{
			var skin:SG_ComponentSkin = new SG_ComponentSkin(frames, name, this);
			return skin;
		}
		
		public function getComponentSkin(type:String):SG_ComponentSkin
		{
			switch (type)
			{
				case SG_SkinType.BUTTON:         return button.clone();
				case SG_SkinType.TEXT_INPUT:     return textInput.clone();
				case SG_SkinType.SLIDER:         return slider.clone();
				case SG_SkinType.SWITCHER:       return switcher.clone();
				case SG_SkinType.PANEL_TITLE:    return panelTitle.clone();
				case SG_SkinType.PANEL:          return panel.clone();
				case SG_SkinType.WORD_ON:        return onWord.clone();
				case SG_SkinType.WORD_OFF:       return offWord.clone();
				case SG_SkinType.PICKER:         return picker.clone();
				case SG_SkinType.PANE:
				case SG_SkinType.LIST:           return list.clone();
			}
			return null;
		}
		
		public function get textColor():uint
		{
			return _textColor;
		}
		
		public function get buttonTextColor():uint
		{
			return _buttonTextColor;
		}
		
		public function get textShadowColor():uint
		{
			return _textShadowColor;
		}
		
		public function get secondActiveColor():uint
		{
			return _secondActiveColor;
		}
		
		public function get windowTextColor():uint
		{
			return _windowTextColor;
		}
	}

}