package smart.gui.skin
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import smart.gui.components.buttons.SG_ButtonType;
	import smart.gui.data.SG_Size;
	import smart.gui.utils.SG_Math;
	
	internal class SG_SkinDrawer
	{
		private static const WINDOW_SIZE:SG_Size = new SG_Size(60, 200);
		private static const BUTTON_SIZE:SG_Size = new SG_Size(32, 33);
		private static const SWITCH_BUTTON_SIZE:SG_Size = new SG_Size(46, 22);
		private static const SWITCHER_SIZE:SG_Size = new SG_Size(50, 20);
		private static const LIST_SIZE:uint = 50;
		private static const TEXT_FIELD_SIZE:uint = 22;

		
		public static function drawSwitchButton(color:SG_SkinColor, type:int):Sprite
		{
			var sprite:Sprite = new Sprite();
			var g:Graphics = sprite.graphics;

			var topColor:uint = color.getColor(8);
			var bottomColor:uint = color.getColor(6);
			var outerBorderColor:uint = color.getColor(2);
			var innerBorderColor:uint = color.getColor(10);

			var WIDTH:int = SWITCH_BUTTON_SIZE.width;
			var HEIGHT:int = SWITCH_BUTTON_SIZE.height;
			
			switch (type)
			{
				case SG_ButtonType.LEFT:
				{
					drawRoundRect(g, [outerBorderColor], [1], [0, 0, WIDTH, HEIGHT], [HEIGHT, 0, HEIGHT, 0]);
					drawRoundRect(g, [innerBorderColor], [1], [1, 1, WIDTH-2, HEIGHT-2], [HEIGHT-2, 0, HEIGHT-2, 0]);
					drawRoundRect(g, [topColor], [1], [2, 2, WIDTH-3, HEIGHT-4], [HEIGHT-4, 0, HEIGHT-4, 0]);
					drawRoundRect(g, [bottomColor], [1], [2, HEIGHT/2, WIDTH-3, (HEIGHT-4)/2], [0, 0,(HEIGHT-4)/2, 0]);
					break;
				}
				case SG_ButtonType.RIGHT:
				{
					drawRoundRect(g, [outerBorderColor], [1], [0, 0, WIDTH, HEIGHT], [0, HEIGHT, 0, HEIGHT]);
					drawRoundRect(g, [innerBorderColor], [1], [0, 1, WIDTH-1, HEIGHT-2], [0, HEIGHT-2, 0, HEIGHT-2]);
					drawRoundRect(g, [topColor], [1], [1, 2, WIDTH-3, HEIGHT-4], [0, HEIGHT-4, 0, HEIGHT-4]);
					drawRoundRect(g, [bottomColor], [1], [1, HEIGHT/2, WIDTH-3, (HEIGHT-4)/2], [0, 0, 0, (HEIGHT-4)/2]);
					break;
				}
				case SG_ButtonType.CENTER:
				{
					drawRoundRect(g, [outerBorderColor], [1], [0, 0, WIDTH, HEIGHT], [0, 0, 0, 0]);
					drawRoundRect(g, [innerBorderColor], [1], [0, 1, WIDTH-1, HEIGHT-2], [0, 0, 0, 0]);
					drawRoundRect(g, [topColor], [1], [1, 2, WIDTH-2, HEIGHT-4], [0, 0, 0, 0]);
					drawRoundRect(g, [bottomColor], [1], [1, HEIGHT/2, WIDTH-2, (HEIGHT-4)/2], [0, 0, 0, 0]);
					break;
				}
			}
			return sprite;
		}
		
		public static function drawButton(color:SG_SkinColor, type:int, isPressed:Boolean = false, target:Sprite = null):Sprite
		{
			var sprite:Sprite = target != null ? target : new Sprite();
			var g:Graphics = sprite.graphics;

			var CORNERS:Number = 7;
			var WIDTH:int = BUTTON_SIZE.width;
			var HEIGHT:int = BUTTON_SIZE.height;
			const VOLUME:Number = 3;
			const HALF_HEIGHT:int = (HEIGHT - VOLUME - 4)/2;

			var topColor:uint = color.getColor(8);
			var bottomColor:uint = color.getColor(6);
			var outerBorderColor:uint = color.getColor(2);
			var innerBorderColor:uint = color.getColor(10);

			if (isPressed) drawRoundRect(g, [0], [0], [0, 0, WIDTH, HEIGHT], [CORNERS]);

			switch (type)
			{
				case SG_ButtonType.DEFAULT:
				{
					if (isPressed)
					{
						HEIGHT -= 1;
						drawRoundRect(g, [outerBorderColor], [1], [0, 1, WIDTH, HEIGHT], [CORNERS]);
						drawRoundRect(g, [bottomColor], [1], [1, 2, WIDTH - 2, HEIGHT - 2], [CORNERS - 2]);
						drawRoundRect(g, [innerBorderColor], [1], [1, 2, WIDTH - 2, HEIGHT - VOLUME - 1], [CORNERS - 2]);
						drawRoundRect(g, [topColor], [1], [2, 3, WIDTH - 4, HALF_HEIGHT], [CORNERS - 5, CORNERS - 5, 0, 0]);
						drawRoundRect(g, [bottomColor], [1], [2, 3 + HALF_HEIGHT, WIDTH - 4, HALF_HEIGHT], [0, 0, CORNERS - 5, CORNERS - 5]);
					}
					else
					{
						drawRoundRect(g, [outerBorderColor], [1], [0, 0, WIDTH, HEIGHT], [CORNERS]);
						drawRoundRect(g, [bottomColor], [1], [1, 1, WIDTH - 2, HEIGHT - 2], [CORNERS - 2]);
						drawRoundRect(g, [innerBorderColor], [1], [1, 1, WIDTH - 2, HEIGHT - VOLUME - 2], [CORNERS - 2]);
						drawRoundRect(g, [topColor], [1], [2, 2, WIDTH - 4, HALF_HEIGHT], [CORNERS - 5, CORNERS - 5, 0, 0]);
						drawRoundRect(g, [bottomColor], [1], [2, 2 + HALF_HEIGHT, WIDTH - 4, HALF_HEIGHT], [0, 0, CORNERS - 5, CORNERS - 5]);
					}
					break;
				}
				case SG_ButtonType.LEFT:
				{
					CORNERS /= 2;

					if (isPressed)
					{
						HEIGHT -= 1;
						drawRoundRect(g, [bottomColor], [1], [1, 2, WIDTH - 2, HEIGHT - 2], [CORNERS - 1, 0, CORNERS - 1, 0]);
						drawRoundRect(g, [innerBorderColor], [1], [1, 2, WIDTH - 1, HEIGHT - VOLUME - 1], [CORNERS - 1, 0, CORNERS - 1, 0]);
						drawRoundRect(g, [topColor], [1], [2, 3, WIDTH - 3, HALF_HEIGHT], [(CORNERS * 2) - 5, 0, 0, 0]);
						drawRoundRect(g, [bottomColor], [1], [2, 3 + HALF_HEIGHT, WIDTH - 3, HALF_HEIGHT], [0, 0, (CORNERS * 2) - 5, 0]);
						drawRoundRect(g, [outerBorderColor], [1], [0, 1, WIDTH, HEIGHT], [CORNERS, 0, CORNERS, 0], true);
					}
					else
					{
						drawRoundRect(g, [bottomColor], [1], [1, 1, WIDTH - 2, HEIGHT - 2], [CORNERS - 1, 0, CORNERS - 1, 0]);
						drawRoundRect(g, [innerBorderColor], [1], [1, 1, WIDTH - 1, HEIGHT - VOLUME - 2], [CORNERS - 1, 0, CORNERS - 1, 0]);
						drawRoundRect(g, [topColor], [1], [2, 2, WIDTH - 3, HALF_HEIGHT], [(CORNERS * 2) - 5, 0, 0, 0]);
						drawRoundRect(g, [bottomColor], [1], [2, 2 + HALF_HEIGHT, WIDTH - 3, HALF_HEIGHT], [0, 0, (CORNERS * 2) - 5, 0]);
						drawRoundRect(g, [outerBorderColor], [1], [0, 0, WIDTH, HEIGHT], [CORNERS, 0, CORNERS, 0], true);
					}
					break;
				}
				case SG_ButtonType.RIGHT:
				{
					CORNERS /= 2;

					if (isPressed)
					{
						HEIGHT -= 1;
						drawRoundRect(g, [outerBorderColor], [1], [0, 1, WIDTH, HEIGHT], [0, CORNERS, 0, CORNERS]);
						drawRoundRect(g, [bottomColor], [1], [1, 2, WIDTH - 2, HEIGHT - 2], [0, CORNERS - 1, 0, CORNERS - 1]);
						drawRoundRect(g, [innerBorderColor], [1], [0, 2, WIDTH - 1, HEIGHT - VOLUME - 1], [0, CORNERS - 1, 0, CORNERS - 1]);
						drawRoundRect(g, [topColor], [1], [1, 3, WIDTH - 3, HALF_HEIGHT], [0, (CORNERS * 2) - 5, 0, 0]);
						drawRoundRect(g, [bottomColor], [1], [1, 3 + HALF_HEIGHT, WIDTH - 3, HALF_HEIGHT], [0, 0, 0, (CORNERS * 2) - 5]);
						drawRoundRect(g, [innerBorderColor], [1], [0, 2, 1, HEIGHT - 2], null);
					}
					else
					{
						drawRoundRect(g, [outerBorderColor], [1], [0, 0, WIDTH, HEIGHT], [0, CORNERS, 0, CORNERS]);
						drawRoundRect(g, [bottomColor], [1], [1, 1, WIDTH - 2, HEIGHT - 2], [0, CORNERS - 1, 0, CORNERS - 1]);
						drawRoundRect(g, [innerBorderColor], [1], [0, 1, WIDTH - 1, HEIGHT - VOLUME - 2], [0, CORNERS - 1, 0, CORNERS - 1]);
						drawRoundRect(g, [topColor], [1], [1, 2, WIDTH - 3, HALF_HEIGHT], [0, (CORNERS * 2) - 5, 0, 0]);
						drawRoundRect(g, [bottomColor], [1], [1, 2 + HALF_HEIGHT, WIDTH - 3, HALF_HEIGHT], [0, 0, 0, (CORNERS * 2) - 5]);
						drawRoundRect(g, [innerBorderColor], [1], [0, 1, 1, HEIGHT - 2], null);
					}
					break;
				}
				case SG_ButtonType.CENTER:
				{
					if (isPressed)
					{
						HEIGHT -= 1;
						drawRoundRect(g, [outerBorderColor], [1], [0, 1, WIDTH, HEIGHT], null);
						drawRoundRect(g, [bottomColor], [1], [1, 2, WIDTH - 2, HEIGHT - 2], null);
						drawRoundRect(g, [innerBorderColor], [1], [1, 2, WIDTH - 2, HEIGHT - VOLUME - 1], null);
						drawRoundRect(g, [topColor], [1], [1, 3, WIDTH - 2, HALF_HEIGHT], null);
						drawRoundRect(g, [bottomColor], [1], [1, 3 + HALF_HEIGHT, WIDTH - 2, HALF_HEIGHT], null);
						drawRoundRect(g, [innerBorderColor], [1], [0, 2, 1, HEIGHT - 2], null);
					}
					else
					{
						drawRoundRect(g, [outerBorderColor], [1], [0, 0, WIDTH, HEIGHT], null);
						drawRoundRect(g, [bottomColor], [1], [1, 1, WIDTH - 2, HEIGHT - 2], null);
						drawRoundRect(g, [innerBorderColor], [1], [1, 1, WIDTH - 2, HEIGHT - VOLUME - 2], null);
						drawRoundRect(g, [topColor], [1], [1, 2, WIDTH - 2, HALF_HEIGHT], null);
						drawRoundRect(g, [bottomColor], [1], [1, 2 + HALF_HEIGHT, WIDTH - 2, HALF_HEIGHT], null);
						drawRoundRect(g, [innerBorderColor], [1], [0, 1, 1, HEIGHT - 2], null);
					}
					break;
				}
			}
			return sprite;
		}
		
		public static function drawBar(color:SG_SkinColor, height:int, target:Sprite = null):Sprite
		{
			var sprite:Sprite = target != null ? target : new Sprite();
			var g:Graphics = sprite.graphics;

			var topColors:Array = [color.getColor(5), color.getColor(7)];
			var bottomColor:uint = color.getColor(3);
			var borderColor:uint = color.getColor(1);

			const WIDTH:int = height*2;
			const HEIGHT:int = height;

			drawRoundRect(g, [bottomColor], [1], [1, 1, WIDTH-2, HEIGHT-2], [0]);
			drawRoundRect(g, topColors, [1, 1], [2, 1, WIDTH-4, HEIGHT/2], [0]);
			drawRoundRect(g, [borderColor], [1], [0, 0, WIDTH, HEIGHT], [0], true);
			drawRoundRect(g, [borderColor], [0.4], [1, 1, WIDTH-2, HEIGHT-2], [0], true);
			if (HEIGHT > 12) drawRoundRect(g, [borderColor], [0.2], [2, 2, WIDTH-4, HEIGHT-4], [0], true);

			return sprite;
		}
		
		public static function drawList(color:SG_SkinColor, upCorners:Boolean, downCorners:Boolean):Sprite
		{
			var sprite:Sprite = new Sprite();
			var g:Graphics = sprite.graphics;

			const SIZE:int = LIST_SIZE;
			const CORNER:Number = 7;

			var mainColor:uint = color.getColor(10);
			var borderColor:uint = color.getColor(5);

			var corners:Array = [0, 0, 0, 0];

			if (upCorners)
			{
				corners[0] = CORNER;
				corners[1] = CORNER;
			}
			if (downCorners)
			{
				corners[2] = CORNER;
				corners[3] = CORNER;
			}
			drawRoundRect(g, [borderColor], [1], [0, 0, SIZE, SIZE], corners);
			drawRoundRect(g, [mainColor], [1], [1, 1, SIZE-2, SIZE-2], corners);

			return sprite;
		}
		
		public static function drawTextInput(color:SG_SkinColor, type:int, target:Sprite = null):Sprite
		{
			var sprite:Sprite = target != null ? target : new Sprite();
			var g:Graphics = sprite.graphics;

			const WIDTH:int = TEXT_FIELD_SIZE;
			const HEIGHT:int = TEXT_FIELD_SIZE;
			var CORNERS:Number = 7;

			var mainColor:uint = color.getColor(10);
			var bottomColor:uint = color.getColor(9);
			var borderColor:uint = color.getColor(5);

			switch (type)
			{
				case SG_ButtonType.DEFAULT:
				{
					drawRoundRect(g, [borderColor], [1], [0, 0, WIDTH, HEIGHT], [CORNERS]);
					drawRoundRect(g, [bottomColor], [1], [1, 1, WIDTH-2, HEIGHT-2], [CORNERS-2]);
					drawRoundRect(g, [mainColor], [1], [1, 1, WIDTH-2, HEIGHT-5], [CORNERS-2]);
					break;
				}
				case SG_ButtonType.LEFT:
				{
					CORNERS /= 2;
					drawRoundRect(g, [borderColor], [1], [0, 0, WIDTH, HEIGHT], [CORNERS, 0, CORNERS, 0]);
					drawRoundRect(g, [bottomColor], [1], [1, 1, WIDTH-2, HEIGHT-2], [CORNERS-1, 0, CORNERS-1, 0]);
					drawRoundRect(g, [mainColor], [1], [1, 1, WIDTH-2, HEIGHT-5], [CORNERS-1, 0, CORNERS-1, 0]);
					break;
				}
				case SG_ButtonType.RIGHT:
				{
					CORNERS /= 2;
					drawRoundRect(g, [borderColor], [1], [0, 0, WIDTH, HEIGHT], [0, CORNERS, 0, CORNERS]);
					drawRoundRect(g, [bottomColor], [1], [1, 1, WIDTH-2, HEIGHT-2], [0, CORNERS-1, 0, CORNERS-1]);
					drawRoundRect(g, [mainColor], [1], [1, 1, WIDTH-2, HEIGHT-5], [0, CORNERS-1, 0, CORNERS-1]);
					break;
				}
				case SG_ButtonType.CENTER:
				{
					drawRect(g, [borderColor], [1], [0, 0, WIDTH, HEIGHT]);
					drawRect(g, [bottomColor], [1], [0, 1, WIDTH, HEIGHT-2]);
					drawRect(g, [mainColor], [1], [0, 1, WIDTH, HEIGHT-5]);
					break;
				}
			}
			return sprite;
		}
		
		public static function drawSwitcher(color:SG_SkinColor, target:Sprite = null):Sprite
		{
			var sprite:Sprite = target != null ? target : new Sprite();
			var g:Graphics = sprite.graphics;

			var topColors:Array = [color.getColor(4), color.getColor(6)];
			var bottomColor:uint = color.getColor(3);
			var borderColor:uint = color.getColor(0);

			const WIDTH:int = SWITCHER_SIZE.width;
			const HEIGHT:int = SWITCHER_SIZE.height;

			drawRoundRect(g, [bottomColor], [1], [1, 1, WIDTH-2, HEIGHT-2], [0]);
			drawRoundRect(g, topColors, [1, 1], [2, 1, WIDTH-4, HEIGHT-8], [HEIGHT-2]);
			drawRoundRect(g, [borderColor], [1], [0, 0, WIDTH, HEIGHT], [0], true);
			drawRoundRect(g, [borderColor], [0.3], [1, 1, WIDTH-2, HEIGHT-2], [0], true);
			drawRoundRect(g, [borderColor], [0.1], [2, 2, WIDTH-4, HEIGHT-4], [0], true);

			return sprite;
		}
		
		public static function drawPanel(color:SG_SkinColor):Sprite
		{
			var sprite:Sprite = new Sprite();
			var g:Graphics = sprite.graphics;

			var mainColors:Array = [color.getColor(7), color.getColor(9)];
			var innerBorderColors:Array = [color.getColor(10), color.getColor(10)];
			var whiteColor:uint = color.getColor(10);
			var topBarColors:Array = [color.getColor(6), color.getColor(4)];
			var outerBorderColor:uint = color.getColor(0);

			const WIDTH:int = WINDOW_SIZE.width;
			const HEIGHT:int = WINDOW_SIZE.height;
			const BAR_HEIGHT:int = 24;
			
			drawRect(g, mainColors, [1, 1], [0, 0, WIDTH, HEIGHT]);
			drawRect(g, topBarColors, [1, 1], [0, 0, WIDTH, BAR_HEIGHT]);
			drawRect(g, [outerBorderColor], [0.3], [1, BAR_HEIGHT-1, WIDTH-2, 1]);
			drawRect(g, [whiteColor], [0.25], [1, 1, WIDTH-2, BAR_HEIGHT-2], true);
			drawRect(g, innerBorderColors, [1, 0.5], [1, BAR_HEIGHT, WIDTH-2, HEIGHT-BAR_HEIGHT-1], true);
			drawRect(g, [outerBorderColor], [0.3], [0, 0, WIDTH, HEIGHT], true);

			return sprite;
		}
		
		public static function drawPanelTitle(color:SG_SkinColor):Sprite
		{
			var sprite:Sprite = new Sprite();
			var g:Graphics = sprite.graphics;

			var whiteColor:uint = color.getColor(10);
			var topBarColors:Array = [color.getColor(6), color.getColor(4)];
			var outerBorderColor:uint = color.getColor(0);

			const WIDTH:int = WINDOW_SIZE.width;
			const HEIGHT:int = 24;
			
			drawRect(g, topBarColors, [1, 1], [0, 0, WIDTH, HEIGHT]);
			drawRect(g, [outerBorderColor], [0.3], [1, HEIGHT-1, WIDTH-2, 1]);
			drawRect(g, [whiteColor], [0.25], [1, 1, WIDTH-2, HEIGHT-2], true);
			drawRect(g, [outerBorderColor], [0.3], [0, 0, WIDTH, HEIGHT], true);

			return sprite;
		}
		
		private static function drawPolygon(g:Graphics, pos:Point, color:uint, points:Array):void
		{
			g.beginFill(color);
			g.moveTo(pos.x + points[0].x, pos.y + points[0].y);
			
			for each (var p:Object in points)
			{
				g.lineTo(pos.x + p.x, pos.y + p.y);
			}
			g.endFill();
		}
		
		private static function drawResizeButton(g:Graphics, color:SG_SkinColor):void
		{
			var color_1:uint = color.getColor(2);
			var color_2:uint = color.getColor(10);
			var pos:Point = new Point(WINDOW_SIZE.width - 21, WINDOW_SIZE.height - 21);
			
			drawPolygon(g, pos, color_1, [{x:14, y:0},  {x:14, y:1},  {x:1, y:14},  {x:0,  y:14}]);
			drawPolygon(g, pos, color_2, [{x:14, y:2},  {x:14, y:3},  {x:3, y:14},  {x:2,  y:14}]);
			drawPolygon(g, pos, color_1, [{x:14, y:4},  {x:14, y:5},  {x:5, y:14},  {x:4,  y:14}]);
			drawPolygon(g, pos, color_2, [{x:14, y:6},  {x:14, y:7},  {x:7, y:14},  {x:6,  y:14}]);
			drawPolygon(g, pos, color_1, [{x:14, y:8},  {x:14, y:8},  {x:8, y:14},  {x:8,  y:14}]);
			drawPolygon(g, pos, color_2, [{x:14, y:10}, {x:14, y:11}, {x:11, y:14}, {x:10, y:14}]);
		}
		
		public static function drawOnWord(color:SG_SkinColor, target:Sprite = null):Sprite
		{
			var sprite:Sprite = target != null ? target : new Sprite();
			var g:Graphics = sprite.graphics;

			var textColor:uint = color.getColor(0);
			var shadowColor:uint = color.getColor(4);

			g.beginFill(shadowColor);
			g.drawRoundRect(0, 1, 6, 10, 4.5, 4.5);
			g.drawRoundRect(2, 3, 2, 6, 2, 2);
			g.drawRect(7, 1, 2, 10);
			g.moveTo(9, 1);
			g.lineTo(12, 7);
			g.lineTo(12, 11);
			g.lineTo(9, 5);
			g.lineTo(9, 1);
			g.drawRect(12, 1, 2, 10);
			g.endFill();

			g.beginFill(textColor);
			g.drawRoundRect(0, 0, 6, 10, 4.5, 4.5);
			g.drawRoundRect(2, 2, 2, 6, 2, 2);
			g.drawRect(7, 0, 2, 10);
			g.moveTo(9, 0);
			g.lineTo(12, 6);
			g.lineTo(12, 10);
			g.lineTo(9, 4);
			g.lineTo(9, 0);
			g.drawRect(12, 0, 2, 10);
			g.endFill();

			return sprite;
		}
		
		public static function drawOffWord(color:SG_SkinColor, target:Sprite = null):Sprite
		{
			var sprite:Sprite = target != null ? target : new Sprite();
			var g:Graphics = sprite.graphics;

			var textColor:uint = color.getColor(0);
			var shadowColor:uint = color.getColor(4);

			g.beginFill(shadowColor);
			g.drawRoundRect(0, 1, 6, 10, 4.5, 4.5);
			g.drawRoundRect(2, 3, 2, 6, 2, 2);
			g.drawRect(7, 1, 2, 10);
			g.drawRect(9, 1, 3, 2);
			g.drawRect(9, 5, 3, 2);
			g.drawRect(13, 1, 2, 10);
			g.drawRect(15, 1, 3, 2);
			g.drawRect(15, 5, 3, 2);
			g.endFill();

			g.beginFill(textColor);
			g.drawRoundRect(0, 0, 6, 10, 4.5, 4.5);
			g.drawRoundRect(2, 2, 2, 6, 2, 2);
			g.drawRect(7, 0, 2, 10);
			g.drawRect(9, 0, 3, 2);
			g.drawRect(9, 4, 3, 2);
			g.drawRect(13, 0, 2, 10);
			g.drawRect(15, 0, 3, 2);
			g.drawRect(15, 4, 3, 2);
			g.endFill();

			return sprite;
		}
		
		public static function drawSliderPicker(color:SG_SkinColor, secondColor:SG_SkinColor = null, target:Sprite = null):Sprite
		{
			var sprite:Sprite = target != null ? target : new Sprite();
			var g:Graphics = sprite.graphics;
			g.clear();

			var borderColor:uint = color.getColor(0);
			var mainColor:uint = color.getColor(10);

			var gradColor_1:uint = color.getColor(9);
			var gradColor_2:uint = color.getColor(8);
			var gradColor_3:uint = color.getColor(7);
			var gradColor_4:uint = color.getColor(4);

			drawCircle(g, 11, borderColor, 0.11);
			drawCircle(g, 9, mainColor);

			drawPie(g, 9, gradColor_1, 90, 240, 162);
			drawPie(g, 9, gradColor_2, 106, 225, 162);
			drawPie(g, 9, gradColor_3, 116, 215, 162);
			drawPie(g, 9, gradColor_4, 126, 202, 162);

			drawPie(g, 9, gradColor_1, 269, 52, 343);
			drawPie(g, 9, gradColor_2, 284, 39, 343);
			drawPie(g, 9, gradColor_3, 294, 30, 343);
			drawPie(g, 9, gradColor_4, 308, 18, 343);

			drawCircle(g, 10, borderColor, 1, true);
			drawCircle(g, 9, mainColor, 1, true);
			drawCircle(g, 4, mainColor);
			drawCircle(g, 3, borderColor);

			if (secondColor) drawCircle(g, 2, secondColor.getCustomColor(20, 0, 50));

			return sprite;
		}
		
		public static function drawRadioButton(color:SG_SkinColor):Sprite
		{
			var sprite:Sprite = new Sprite();
			var g:Graphics = sprite.graphics;

			var borderColor:uint = color.getColor(1);
			var bottomColor:uint = color.getColor(3);
			var topColors:Array = [color.getColor(6), color.getColor(8)];

			const SIZE:int = 9;

			drawCircle(g, SIZE, bottomColor);
			drawRoundRect(g, topColors, [1, 1], [-SIZE+1, -SIZE+1, SIZE*2-2, 11], [25,18]);
			drawCircle(g, SIZE, borderColor, 1, true);
			drawCircle(g, SIZE-1, borderColor, 0.3, true);

			return sprite;
		}
		
		private static function drawRoundRect(g:Graphics, colors:Array, alpha:Array, rect:Array, corners:Array, isBorder:Boolean = false):void
		{
			var cornersWh:int;
			var cornersHt:int;

			if (corners == null) corners = [0, 0, 0, 0];

			if (corners.length == 1)
			{
				if (corners[0] == 0)
				{
					cornersWh = rect[3];
					cornersHt = rect[3];
				}
				else
				{
					cornersWh = corners[0];
					cornersHt = corners[0];
				}
			}
			else
			{
				cornersWh = corners[0];
				cornersHt = corners[1];
			}
			for (var j:int = 0; j < corners.length; j++) if (corners[j] == -1) corners[j] = 0;
			
			if (colors.length > 1)
			{
				var matrix:Matrix = new Matrix();
				matrix.createGradientBox(rect[2], rect[3], SG_Math.degreeToRadians(90), rect[0], rect[1]);
				g.beginGradientFill(GradientType.LINEAR, [colors[1], colors[0]], alpha, [0x00, 0xFF], matrix);
			}
			else g.beginFill(colors[0], alpha[0]);

			if (corners.length == 4) g.drawRoundRectComplex(rect[0], rect[1], rect[2], rect[3], corners[0], corners[1], corners[2], corners[3]);
			else                     g.drawRoundRect(rect[0], rect[1], rect[2], rect[3], cornersWh, cornersHt);

			if (isBorder)
			{
				rect[0] += 1;
				rect[1] += 1;
				rect[2] -= 2;
				rect[3] -= 2;

				if (corners.length == 4)
				{
					for (var i:int = 0; i < corners.length; i++) if (corners[i] != 0) corners[i] -= 1;
					g.drawRoundRectComplex(rect[0], rect[1], rect[2], rect[3], corners[0], corners[1], corners[2], corners[3]);
				}
				else g.drawRoundRect(rect[0], rect[1], rect[2], rect[3], cornersWh-2, cornersHt-2);
			}
			g.endFill();
		}
		
		private static function drawRect(g:Graphics, colors:Array, alpha:Array, rect:Array, isBorder:Boolean = false):void
		{
			if (colors.length > 1)
			{
				var matrix:Matrix = new Matrix();
				matrix.createGradientBox(rect[2], rect[3], SG_Math.degreeToRadians(90), rect[0], rect[1]);
				g.beginGradientFill(GradientType.LINEAR, [colors[1], colors[0]], alpha, [0x00, 0xFF], matrix);
			}
			else g.beginFill(colors[0], alpha[0]);

			g.drawRect(rect[0], rect[1], rect[2], rect[3]);

			if (isBorder)
			{
				rect[0] += 1;
				rect[1] += 1;
				rect[2] -= 2;
				rect[3] -= 2;
				g.drawRect(rect[0], rect[1], rect[2], rect[3]);
			}
			g.endFill();
		}
		
		private static function drawCircle(g:Graphics, radius:int, color:uint, alpha:Number = 1, isBorder:Boolean = false):void
		{
			g.beginFill(color, alpha);
			g.drawCircle(0, 0, radius);
			if (isBorder) g.drawCircle(0, 0, radius-1);
			g.endFill();
		}
		
		private static function drawPie(g:Graphics, radius:int, color:uint, startAngle:Number, endAngle:Number, midAngle:Number):void
		{
			midAngle = SG_Math.degreeToRadians(midAngle);
			startAngle = SG_Math.degreeToRadians(startAngle);
			endAngle = SG_Math.degreeToRadians(endAngle);

			var x1:Number = Math.cos(startAngle) * radius;
			var y1:Number = Math.sin(startAngle) * radius;
			var x2:Number = Math.cos(endAngle) * radius;
			var y2:Number = Math.sin(endAngle) * radius;

			var k:Number = new Point(x2-x1, y2-y1).length/4;
			var cX:Number = Math.cos(midAngle) * (radius + k);
			var cY:Number = Math.sin(midAngle) * (radius + k);

			g.beginFill(color);
			g.moveTo(0, 0);
			g.lineTo(x1, y1);
			g.curveTo(cX, cY, x2, y2);
			g.lineTo(0, 0);
			g.endFill();
		}
		
	}
}
