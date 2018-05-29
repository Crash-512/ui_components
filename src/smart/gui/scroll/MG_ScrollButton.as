package smart.gui.scroll
{
	import smart.gui.base.MG_Sprite;
	
	import smart.gui.base.MG_Button;
	import smart.gui.constants.MG_Colors;
	
	internal class MG_ScrollButton extends MG_Button
	{
		private var _icon:MG_Sprite;
		
		private var _iconNormalColor:uint = MG_Colors.GRAY_BRIGHT_1;
		private var _iconOverColor:uint = MG_Colors.GRAY_BRIGHT_2;
		private var _iconPressedColor:uint = MG_Colors.GRAY_BRIGHT_1;
		
		private static const SIZE:int = MG_ScrollBar.THICKNESS;
		private static const ICON_POINTS:Array = [0,0, 3,3, 5,1, 0,-4, -5,1, -3,3];
		
		public static const UP:int = 0;
		public static const DOWN:int = 1;
		  
		public function MG_ScrollButton()
		{
			super();
			
			_autoWidth = false;
			_autoHeight = false;
			
			_normalColor = MG_Colors.GRAY_DARK_1;
			_overColor = MG_Colors.GRAY_DARK_2;
			_pressedColor = MG_Colors.GRAY_DARK_1;
			
			_icon = new MG_Sprite();
			_icon.setPosition(SIZE/2, SIZE/2);
			_display.addChild(_icon);
			
			setSize(SIZE, SIZE);
		}
		
		public function setMode(mode:int):void 
		{
			switch (mode)
			{
				case UP:	_icon.rotation = 0;		break;
				case DOWN:	_icon.rotation = 180;	break;
			}
		}
		
		override public function redraw():void
		{
			super.redraw();
			
			var iconColor:uint;
			
			if (_enabled)
			{
				if (_pressed)			iconColor = _iconPressedColor;
				else if (_highlighted)	iconColor = _iconOverColor;
				else					iconColor = _iconNormalColor;
			}
			
			with (_icon.graphics)
			{
				beginFill(iconColor);
				moveTo(0, 0);
				
				for (var i:int = 0; i < ICON_POINTS.length; i += 2)
				{
					var x:int = ICON_POINTS[i];
					var y:int = ICON_POINTS[i + 1];
					
					lineTo(x, y);
				}
				endFill();
			}
		}
		
	}
}
