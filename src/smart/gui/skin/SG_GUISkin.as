package smart.gui.skin 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import smart.gui.components.buttons.SG_ButtonType;
	import smart.gui.constants.SG_SkinType;
	import smart.gui.utils.SG_Math;
	
	public class SG_GUISkin extends Sprite
	{
		private var button:SG_ComponentSkin;
		private var textInput:SG_ComponentSkin;
		private var panel:SG_ComponentSkin;
		private var panelTitle:SG_ComponentSkin;
		private var progressBar:SG_ComponentSkin;
		private var slider:SG_ComponentSkin;
		private var picker:SG_ComponentSkin;
		private var switcher:SG_ComponentSkin;
		private var radioButton:SG_ComponentSkin;
		private var onWord:SG_ComponentSkin;
		private var offWord:SG_ComponentSkin;
		private var list:SG_ComponentSkin;
		private var textSwitcher:SG_ComponentSkin;

		protected var switchButtonLeft:Sprite;
		protected var switchButtonRight:Sprite;
		protected var switchButtonCenter:Sprite;
		protected var listDefault:Sprite;
		protected var listUpCorners:Sprite;
		protected var listDownCorners:Sprite;
		protected var listNoCorners:Sprite;
		protected var buttonSprite:Sprite;
		protected var buttonLeftSprite:Sprite;
		protected var buttonRightSprite:Sprite;
		protected var buttonCenterSprite:Sprite;
		protected var buttonPressedSprite:Sprite;
		protected var buttonLeftPressedSprite:Sprite;
		protected var buttonRightPressedSprite:Sprite;
		protected var buttonCenterPressedSprite:Sprite;
		protected var textInputSprite:Sprite;
		protected var textInputLeftSprite:Sprite;
		protected var textInputRightSprite:Sprite;
		protected var textInputCenterSprite:Sprite;
		protected var panelSprite:Sprite;
		protected var panelTitleSprite:Sprite;
		protected var progressSmallSprite:Sprite;
		protected var progressMediumSprite:Sprite;
		protected var progressLargeSprite:Sprite;
		protected var progressSmallActiveSprite:Sprite;
		protected var progressMediumActiveSprite:Sprite;
		protected var progressLargeActiveSprite:Sprite;
		protected var sliderSprite:Sprite;
		protected var sliderActiveSprite:Sprite;
		protected var pickerSprite:Sprite;
		protected var pickerActiveSprite:Sprite;
		protected var switcherSprite:Sprite;
		protected var switcherActiveSprite:Sprite;
		protected var radioButtonSprite:Sprite;
		protected var onWordSprite:Sprite;
		protected var offWordSprite:Sprite;
		
		protected var _textColor:uint;
		protected var _buttonTextColor:uint;
		protected var _windowTextColor:uint;
		protected var _textShadowColor:uint;
		
		protected var _skinColor:uint;
		protected var _firstActiveColor:uint;
		protected var _secondActiveColor:uint;
		
		protected var _activeColorNormal:SG_SkinColor;
		protected var _activeColorSaturated:SG_SkinColor;
		
		protected var buttonColor:SG_SkinColor;
		protected var sliderColor:SG_SkinColor;
		protected var pickerColor:SG_SkinColor;
		protected var windowColor:SG_SkinColor;
		protected var textInputColor:SG_SkinColor;

		public static const SLIDER_SIZE:uint = 12;
		public static const BAR_SMALL:uint = 10;
		public static const BAR_MEDIUM:uint = 16;
		public static const BAR_LARGE:uint = 20;
		
		public static var defaultSkin:SG_GUISkin = new SG_GUISkin();
		
		
		public function SG_GUISkin(mainColor:uint = 0xD3D3D3, firstActiveColor:uint = 0xAAD7F0, secondActiveColor:uint = 0xECFFDA) 
		{
			_skinColor = mainColor;
			_firstActiveColor = firstActiveColor;
			_secondActiveColor = secondActiveColor;
			initColors();
			drawComponents();
			renderComponents();
			setScaleGrids();
		}
		
		protected function initColors():void
		{
			buttonColor = sliderColor = pickerColor = windowColor = textInputColor = new SG_SkinColor(_skinColor);

			_activeColorNormal = new SG_SkinColor(_firstActiveColor);
			_activeColorSaturated = new SG_SkinColor(_firstActiveColor, -25, 0, 15, 10);
			
			_textColor = buttonColor.getCustomColor(-150);
			_windowTextColor = buttonColor.getCustomColor(-150);
			_buttonTextColor = buttonColor.getColor(0);
			_textShadowColor = buttonColor.getColor(10);
		}
		
		public function getComponentSkin(type:String):SG_ComponentSkin
		{
			switch (type)
			{
				case SG_SkinType.BUTTON:         return button.clone();
				case SG_SkinType.TEXT_INPUT:     return textInput.clone();
				case SG_SkinType.SLIDER:         return slider.clone();
				case SG_SkinType.SWITCHER:       return switcher.clone();
				case SG_SkinType.RADIO_BUTTON:   return radioButton.clone();
				case SG_SkinType.PANEL_TITLE:    return panelTitle.clone();
				case SG_SkinType.PANEL:          return panel.clone();
				case SG_SkinType.WORD_ON:        return onWord.clone();
				case SG_SkinType.WORD_OFF:       return offWord.clone();
				case SG_SkinType.PICKER:         return picker.clone();
				case SG_SkinType.PROGRESS_BAR:   return progressBar.clone();
				case SG_SkinType.PANE:
				case SG_SkinType.LIST:           return list.clone();
				case SG_SkinType.TEXT_SWITCHER:  return textSwitcher.clone();
			}
			return null;
		}
		
		protected function drawComponents():void
		{
			buttonSprite = SG_SkinDrawer.drawButton(buttonColor, SG_ButtonType.DEFAULT);
			buttonLeftSprite = SG_SkinDrawer.drawButton(buttonColor, SG_ButtonType.LEFT);
			buttonRightSprite = SG_SkinDrawer.drawButton(buttonColor, SG_ButtonType.RIGHT);
			buttonCenterSprite = SG_SkinDrawer.drawButton(buttonColor, SG_ButtonType.CENTER);
			
			buttonPressedSprite = SG_SkinDrawer.drawButton(buttonColor, SG_ButtonType.DEFAULT, true);
			buttonLeftPressedSprite = SG_SkinDrawer.drawButton(buttonColor, SG_ButtonType.LEFT, true);
			buttonRightPressedSprite = SG_SkinDrawer.drawButton(buttonColor, SG_ButtonType.RIGHT, true);
			buttonCenterPressedSprite = SG_SkinDrawer.drawButton(buttonColor, SG_ButtonType.CENTER, true);
			
			switchButtonLeft = SG_SkinDrawer.drawSwitchButton(buttonColor, 1);
			switchButtonRight = SG_SkinDrawer.drawSwitchButton(buttonColor, 2);
			switchButtonCenter = SG_SkinDrawer.drawSwitchButton(buttonColor, 3);
			
			textInputSprite = SG_SkinDrawer.drawTextInput(textInputColor, 0);
			textInputLeftSprite = SG_SkinDrawer.drawTextInput(textInputColor, 1);
			textInputRightSprite = SG_SkinDrawer.drawTextInput(textInputColor, 2);
			textInputCenterSprite = SG_SkinDrawer.drawTextInput(textInputColor, 3);
			
			panelSprite = SG_SkinDrawer.drawPanel(windowColor);
			panelTitleSprite = SG_SkinDrawer.drawPanelTitle(windowColor);
			progressSmallSprite = SG_SkinDrawer.drawBar(sliderColor, BAR_SMALL);
			progressMediumSprite = SG_SkinDrawer.drawBar(sliderColor, BAR_MEDIUM);
			progressLargeSprite = SG_SkinDrawer.drawBar(sliderColor, BAR_LARGE);
			sliderSprite = SG_SkinDrawer.drawBar(sliderColor, SLIDER_SIZE);
			sliderActiveSprite = SG_SkinDrawer.drawBar(_activeColorSaturated, SLIDER_SIZE);
			pickerSprite = SG_SkinDrawer.drawSliderPicker(pickerColor);
			pickerActiveSprite = SG_SkinDrawer.drawSliderPicker(pickerColor, _activeColorSaturated);
			switcherSprite = SG_SkinDrawer.drawSwitcher(sliderColor);
			radioButtonSprite = SG_SkinDrawer.drawRadioButton(sliderColor);
			offWordSprite = SG_SkinDrawer.drawOffWord(sliderColor);
			onWordSprite = SG_SkinDrawer.drawOnWord(_activeColorNormal);
			listDefault = SG_SkinDrawer.drawList(textInputColor, true, true);
			listUpCorners = SG_SkinDrawer.drawList(textInputColor, true, false);
			listDownCorners = SG_SkinDrawer.drawList(textInputColor, false, true);
			listNoCorners = SG_SkinDrawer.drawList(textInputColor, false, false);
			progressSmallActiveSprite = SG_SkinDrawer.drawBar(_activeColorSaturated, BAR_SMALL);
			progressMediumActiveSprite = SG_SkinDrawer.drawBar(_activeColorSaturated, BAR_MEDIUM);
			progressLargeActiveSprite = SG_SkinDrawer.drawBar(_activeColorSaturated, BAR_LARGE);
			switcherActiveSprite = SG_SkinDrawer.drawSwitcher(_activeColorNormal);
		}
		
		private function renderComponents():void
		{
			var buttonFrames:Vector.<SG_ComponentTexture> = new Vector.<SG_ComponentTexture>(8, true);
			var textInputFrames:Vector.<SG_ComponentTexture> = new Vector.<SG_ComponentTexture>(4, true);
			var windowFrames:Vector.<SG_ComponentTexture> = new Vector.<SG_ComponentTexture>(9, true);
			var panelFrames:Vector.<SG_ComponentTexture> = new Vector.<SG_ComponentTexture>(1, true);
			var panelTitleFrames:Vector.<SG_ComponentTexture> = new Vector.<SG_ComponentTexture>(1, true);
			var progressBarFrames:Vector.<SG_ComponentTexture> = new Vector.<SG_ComponentTexture>(6, true);
			var sliderFrames:Vector.<SG_ComponentTexture> = new Vector.<SG_ComponentTexture>(2, true);
			var pickerFrames:Vector.<SG_ComponentTexture> = new Vector.<SG_ComponentTexture>(2, true);
			var switcherFrames:Vector.<SG_ComponentTexture> = new Vector.<SG_ComponentTexture>(2, true);
			var radioButtonFrames:Vector.<SG_ComponentTexture> = new Vector.<SG_ComponentTexture>(1, true);
			var onWordFrames:Vector.<SG_ComponentTexture> = new Vector.<SG_ComponentTexture>(1, true);
			var offWordFrames:Vector.<SG_ComponentTexture> = new Vector.<SG_ComponentTexture>(1, true);
			var listFrames:Vector.<SG_ComponentTexture> = new Vector.<SG_ComponentTexture>(4, true);
			var textSwitcherFrames:Vector.<SG_ComponentTexture> = new Vector.<SG_ComponentTexture>(3, true);

			buttonFrames[0] = convertToBitmap(buttonSprite);
			buttonFrames[1] = convertToBitmap(buttonLeftSprite);
			buttonFrames[2] = convertToBitmap(buttonRightSprite);
			buttonFrames[3] = convertToBitmap(buttonCenterSprite);
			
			buttonFrames[4] = convertToBitmap(buttonPressedSprite);
			buttonFrames[5] = convertToBitmap(buttonRightPressedSprite);
			buttonFrames[6] = convertToBitmap(buttonLeftPressedSprite);
			buttonFrames[7] = convertToBitmap(buttonCenterPressedSprite);

			textInputFrames[0] = convertToBitmap(textInputSprite);
			textInputFrames[1] = convertToBitmap(textInputLeftSprite);
			textInputFrames[2] = convertToBitmap(textInputRightSprite);
			textInputFrames[3] = convertToBitmap(textInputCenterSprite);

			listFrames[0] = convertToBitmap(listDefault);
			listFrames[1] = convertToBitmap(listUpCorners);
			listFrames[2] = convertToBitmap(listDownCorners);
			listFrames[3] = convertToBitmap(listNoCorners);

			progressBarFrames[0] = convertToBitmap(progressSmallSprite);
			progressBarFrames[1] = convertToBitmap(progressSmallActiveSprite);
			progressBarFrames[2] = convertToBitmap(progressMediumSprite);
			progressBarFrames[3] = convertToBitmap(progressMediumActiveSprite);
			progressBarFrames[4] = convertToBitmap(progressLargeSprite);
			progressBarFrames[5] = convertToBitmap(progressLargeActiveSprite);
			
			pickerFrames[0] = convertToBitmap(pickerSprite);
			pickerFrames[1] = convertToBitmap(pickerActiveSprite);
			
			sliderFrames[0] = convertToBitmap(sliderSprite);
			sliderFrames[1] = convertToBitmap(sliderActiveSprite);
			
			switcherFrames[0] = convertToBitmap(switcherSprite);
			switcherFrames[1] = convertToBitmap(switcherActiveSprite);

			textSwitcherFrames[0] = convertToBitmap(switchButtonLeft);
			textSwitcherFrames[1] = convertToBitmap(switchButtonRight);
			textSwitcherFrames[2] = convertToBitmap(switchButtonCenter);
			
			radioButtonFrames[0] = convertToBitmap(radioButtonSprite);
			onWordFrames[0] = convertToBitmap(onWordSprite);
			offWordFrames[0] = convertToBitmap(offWordSprite);
			
			panelFrames[0] = convertToBitmap(panelSprite);
			panelTitleFrames[0] = convertToBitmap(panelTitleSprite);
			
			button = createSkin(buttonFrames, buttonColor, "button");
			list = createSkin(listFrames, textInputColor, "list");
			textInput = createSkin(textInputFrames, textInputColor, SG_SkinType.TEXT_INPUT);
			panel = createSkin(panelFrames, windowColor, "panel");
			panelTitle = createSkin(panelTitleFrames, windowColor, "panelTitle");
			progressBar = createSkin(progressBarFrames, sliderColor, "progressBar");
			slider = createSkin(sliderFrames, sliderColor, "slider");
			picker = createSkin(pickerFrames, pickerColor, SG_SkinType.PICKER);
			switcher = createSkin(switcherFrames, sliderColor, SG_SkinType.SWITCHER);
			radioButton = createSkin(radioButtonFrames, sliderColor, "radioButton");
			onWord = createSkin(onWordFrames, _activeColorNormal, SG_SkinType.WORD_ON);
			offWord = createSkin(offWordFrames, sliderColor, SG_SkinType.WORD_OFF);
			textSwitcher = createSkin(textSwitcherFrames, buttonColor, "textSwitcher");
		}
		
		private function setScaleGrids():void 
		{
			button.setScale9Grid(5, 5);
			textSwitcher.setScale9Grid(12, 10);
			textInput.setScale9Grid(5, 5);
			list.setScale9Grid(5, 5);
			panel.setScale9Grid(25, 25);
			panelTitle.setScale9Grid(5, 5);
			slider.setScale9Grid(8, 5);

			progressBar.setGridForFrame(0, BAR_SMALL/2+1, BAR_SMALL/2-1);
			progressBar.setGridForFrame(1, BAR_SMALL/2+1, BAR_SMALL/2-1);
			progressBar.setGridForFrame(2, BAR_MEDIUM/2+1, BAR_MEDIUM/2-1);
			progressBar.setGridForFrame(3, BAR_MEDIUM/2+1, BAR_MEDIUM/2-1);
			progressBar.setGridForFrame(4, BAR_LARGE/2+1, BAR_LARGE/2-1);
			progressBar.setGridForFrame(5, BAR_LARGE/2+1, BAR_LARGE/2-1);
			progressBar.redraw();
		}
		
		private function createSkin(frames:Vector.<SG_ComponentTexture>, color:SG_SkinColor, name:String = null):SG_ComponentSkin 
		{
			var skin:SG_ComponentSkin = new SG_ComponentSkin(frames, color, name, this);
			return skin;
		}
		
		private static function convertToBitmap(component:Sprite):SG_ComponentTexture
		{
			var rect:Rectangle = component.getBounds(component);
			rect = SG_Math.roundRect(rect);

			var matrix:Matrix = new Matrix();
			matrix.translate(-rect.x, -rect.y);

			var bitmapData:BitmapData = new BitmapData(rect.width, rect.height, true, 0x00000000);
			bitmapData.draw(component, matrix);

			var frame:SG_ComponentTexture = new SG_ComponentTexture(bitmapData, rect);

			return frame;
		}
		
		public function setFilter(colorTransform:ColorTransform):void
		{
			var components:Array =
			[
				buttonSprite, buttonLeftSprite, buttonRightSprite, buttonCenterSprite,
				buttonPressedSprite, buttonLeftPressedSprite, buttonRightPressedSprite, buttonCenterPressedSprite,
				textInputSprite, textInputLeftSprite, panelTitleSprite, panelSprite,
				textInputRightSprite, textInputCenterSprite, progressSmallSprite, progressMediumSprite,
				progressLargeSprite, sliderSprite, pickerSprite, pickerActiveSprite,
				switcherSprite, radioButtonSprite, offWordSprite, onWordSprite
			];
			for each (var component:Sprite in components) component.transform.colorTransform = colorTransform;
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
		
		public function get activeColorSaturated():SG_SkinColor
		{
			return _activeColorSaturated;
		}
		
		public function get activeColorNormal():SG_SkinColor
		{
			return _activeColorNormal;
		}
	}

}