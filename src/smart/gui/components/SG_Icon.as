package smart.gui.components
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	import smart.gui.skin.SG_GUISkin;

	public class SG_Icon extends Sprite
	{
		private var _type:String;
		private var _skin:SG_GUISkin = SG_GUISkin.defaultSkin;
		private var customColor:uint;
		private var useCustomColor:Boolean;
		private var vector:Shape;
		private var bitmap:Shape;
		private var bitmapData:BitmapData;
		
		  
		public function SG_Icon(type:String)
		{
			_type = type;
			init();
		}
		
		private function init():void
		{
			vector = new Shape();
			bitmap = new Shape();
			addChild(vector);
			
			redrawIcon();
			renderIcon();
		}
		
		public function setCustomColor(color:Number = -1):void 
		{
			useCustomColor = (color >= 0);
			customColor = int(color);
			redrawIcon();
			renderIcon();
		}
		
		public function setSkin(skin:SG_GUISkin):void 
		{
			_skin = skin;
			redrawIcon();
			renderIcon();
		}
		
		private function renderIcon():void 
		{
			if (bitmapData) 
			{
				bitmapData.dispose();
				bitmapData = null;
			}
			
			bitmapData = new BitmapData(vector.width, vector.height, true, 0x00000000);
			var rect:Rectangle = vector.getRect(vector);
			var matrix:Matrix = new Matrix();
			
			matrix.translate(-rect.x, -rect.y);
			bitmapData.draw(vector, matrix);

			bitmap.x = rect.x;
			bitmap.y = rect.y;
			
			var canvas:Graphics = bitmap.graphics;
			
			canvas.clear();
			canvas.beginBitmapFill(bitmapData);
			canvas.drawRect(0, 0, rect.width, rect.height);
			canvas.endFill();
		}
		
		private function redrawIcon():void
		{
			var canvas:Graphics = vector.graphics;

			canvas.clear();
			canvas.beginFill(0, 0);
			canvas.drawRect(-11, -11, 22, 22);
			canvas.endFill();
			
			var fillColor:uint = (useCustomColor) ? customColor : _skin.buttonTextColor;
			
			canvas.beginFill(fillColor, 1);
			
			switch (_type)
			{
				case SG_IconType.STATISTICS:
				{
					canvas.drawRect(-7, 3, 4, 4);
					canvas.drawRect(-2, -1, 4, 8);
					canvas.drawRect(3, -7, 4, 14);
					break;
				}
				case SG_IconType.PLUS:
				{
					canvas.drawRect(-2, -7, 4, 14);
					canvas.drawRect(-7, -2, 5, 4);
					canvas.drawRect(2, -2, 5, 4);
					break;
				}
				case SG_IconType.BROWSE:
				{
					canvas.drawRect(-5, 4, 2, 2);
					canvas.drawRect(-1, 4, 2, 2);
					canvas.drawRect(3, 4, 2, 2);
					break;
				}
				case SG_IconType.PAUSE:
				{
					canvas.drawRect(-6, -6, 4, 12);
					canvas.drawRect(2, -6, 4, 12);
					break;
				}
				case SG_IconType.STOP:
				{
					canvas.drawRect(-6, -5, 12, 12);
					break;
				}
				case SG_IconType.PLAY:
				{
					drawPolygon(canvas, [-5,-7, 7,0, -5,7]);
					break;
				}
				case SG_IconType.PREVIOUS:
				{
					drawPolygon(canvas, [-6,0, 4,6, 4,-6]);
					break;
				}
				case SG_IconType.NEXT:
				{
					drawPolygon(canvas, [6,0, -4,-6, -4,6]);
					break;
				}
				case SG_IconType.COLLAPSE:
				{
					drawPolygon(canvas, [-2,5, 2,0, -2,-5]);
					break;
				}
				case SG_IconType.DROP:
				{
					drawPolygon(canvas, [-5,-3, 5,-3, 0,3]);
					break;
				}
				case SG_IconType.REWIND_LEFT:
				{
					drawPolygon(canvas, [-11,0, -1,-6, -1,-0.6, 8,-6, 8,6, -1,0.6, -1,6]);
					break;
				}
				case SG_IconType.REWIND_RIGHT:
				{
					drawPolygon(canvas, [-8,6, -8,-6, 1,-0.6, 1,-6, 11,0, 1,6, 1,0.6]);
					break;
				}
				case SG_IconType.STEPPER:
				{
					drawPolygon(canvas, [-4,-2, 4,-2, 0,-7]);
					drawPolygon(canvas, [-4,2, 4,2, 0,7]);
					break;
				}
				case SG_IconType.CROSS:
				{
					var a:int = 4;
					var b:int = 3;
					var c:int = 1;
					drawPolygon(canvas, [-a,-b, -b,-a, 0,-c, b,-a, a,-b, c,0, a,b, b,a, 0,c, -b,a, -a,b, -c,0]);
					break;
				}
				case SG_IconType.MINIMIZE:
				{
					canvas.drawRect(-6, 3, 12, 3);
					break;
				}
				case SG_IconType.MAXIMIZE:
				{
					canvas.drawRect(-6, -6, 12, 12);
					canvas.drawRect(-4, -3, 8, 7);
					break;
				}
				case SG_IconType.CHECK:
				{
					drawPolygon(canvas, [-1.1,6, 6,-4.3, 3.55,-6, -1.6,2, -4.2,-0.4, -6,1.4]);
					break;
				}
				case SG_IconType.PIN:
				{
					drawPolygon(canvas, [-5.36,6.4, -6.35,5.7, -2.8,2.15, -6.35,-1.4, -4.95,-2.8, -3.5,-1.4, 1.45,-6.35, 6.4,-1.4, 1.45,3.55, 2.85,5, 1.45,6.4, -2.1,2.85]);
					break;
				}
				case SG_IconType.PLAY_CONTOUR:
				{
					drawPolygon(canvas, [-9,9, 9,0.05, -9,-9]);
					drawPolygon(canvas, [-7,5.75, -7,-5.75, 4.55,0.05]);
					drawPolygon(canvas, [-6,4.15, -6,-4.15, 2.25,0]);
					break;
				}
				case SG_IconType.SETTINGS:
				{
					var settingsPoints:Array = 
					[
						-4.95,-2.15, -5,-2, -8,-1.4, -8,1.4, -5,2, -4.95,2.15, -6.65,4.65, -4.65,6.65,
						-2.15,4.95, -2,5, -1.4,8, 1.4,8, 2,5, 2.15,4.95, 4.65,6.65, 6.65,4.65, 4.95,2.15,
						5,2, 8,1.4, 8,-1.4, 5,-2, 4.95,-2.15, 6.65,-4.65, 4.65,-6.65, 2.15,-4.95, 2,-5,
						1.4,-8, -1.4,-8, -2,-5, -2.15,-4.95, -4.65,-6.65, -6.65,-4.65
					];
					drawPolygon(canvas, settingsPoints);
					canvas.drawCircle(0, 0, 2.5);
					break;
				}
				case SG_IconType.OPEN:
				{
					drawPolygon(canvas, [-12,9, 5,9, 6,8, 10,0, 10,-2, 5,-2, 5,-6, 4,-7, -2,-7, -4,-10, -9,-10, -11,-7, -12,-7]);
					drawPolygon(canvas, [-6,-2, 3,-2, 3,-5, -10,-5, -10,6]);
					drawPolygon(canvas, [4.5,7, 8,0, -5,0, -8.5,7]);
					drawPolygon(canvas, [-4,-7, -5,-8.5, -8,-8.5, -9,-7]);
					break;
				}
				case SG_IconType.SAVE:
				{
					drawPolygon(canvas, [-9,10, 9,10, 9,-4, 4,-9, -9,-9]);
					drawPolygon(canvas, [-7,8, -5,8, -5,1, 5,1, 5,8, 7,8, 7,-3.5, 3.5,-7, 3,-7, 3,-1, -5,-1, -5,-7, -7,-7]);
					drawPolygon(canvas, [-4,-2, 2,-2, 2,-7, 0,-7, 0,-3, -3,-3, -3,-7, -4,-7]);
					canvas.drawRect(-4, 2, 8, 6);
					canvas.drawRect(-3, 3, 6, 1);
					canvas.drawRect(-3, 5, 6, 1);
					break;
				}
				case SG_IconType.THRASH:
				{
					canvas.drawRoundRect(-7, -8, 15, 5, 2.3, 2.3);
					canvas.drawRoundRectComplex(-6, -3, 13, 12, 0, 0, 2.3, 2.3);
					canvas.drawRoundRectComplex(-2, -9, 5, 1, 2.3, 2.3, 0, 0);
					canvas.drawRect(-4, -4, 9, 11);
					canvas.drawRect(-5, -6, 11, 1);
					canvas.drawRect(-3, -3, 1, 9);
					canvas.drawRect(-1, -3, 1, 9);
					canvas.drawRect(1, -3, 1, 9);
					canvas.drawRect(3, -3, 1, 9);
					break;
				}
				case SG_IconType.NEW_DOCUMENT:
				{
					drawPolygon(canvas, [-8, -10, 4, -10, 8, -4, 8, 10, -8, 10]);
					drawPolygon(canvas, [-6, -8, 1, -8, 1, -2, 6, -2, 6, 8, -6, 8]);
					drawPolygon(canvas, [3, -7.8, 5.7, -4, 3, -4]);
					break;
				}
				case SG_IconType.IMPORT:
				{
					break;
				}
				case SG_IconType.EXPORT:
				{
					break;
				}
				case SG_IconType.ADD_DOCUMENT:
				{
					break;
				}
				case SG_IconType.ADD_FOLDER:
				{
					break;
				}
			}
			canvas.endFill();
		}
		
		private static function drawPolygon(canvas:Graphics, points:Array):void
		{
			for (var i:int = 0; i < points.length-1; i += 2)
			{
				var x:Number = points[i];
				var y:Number = points[i + 1];
				
				if (i == 0) canvas.moveTo(x, y);
				else        canvas.lineTo(x, y);
			}
			canvas.lineTo(points[0], points[1]);
		}
		
		public function setScale(scale:Number):void 
		{
			scaleX = scale;
			scaleY = scale;
		}
		
		public function setPosition(x:int, y:int):void 
		{
			this.x = x;
			this.y = y;
		}
		
		public function set type(value:String):void
		{
			_type = value;
			redrawIcon();
			renderIcon();
		}
		
		public function get type():String
		{
			return _type;
		}
		
	}
}
