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
		
		public static const CROSS:String = "cross";
		public static const DROP:String = "drop";
		public static const STEPPER:String = "stepper";
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
				case STEPPER:
				{
					drawPolygon(canvas, [-4,-2, 4,-2, 0,-7]);
					drawPolygon(canvas, [-4,2, 4,2, 0,7]);
					break;
				}
				case CROSS:
				{
					var a:int = 4;
					var b:int = 3;
					var c:int = 1;
					drawPolygon(canvas, [-a,-b, -b,-a, 0,-c, b,-a, a,-b, c,0, a,b, b,a, 0,c, -b,a, -a,b, -c,0]);
					break;
				}
				case DROP:
				{
					drawPolygon(canvas, [-5,-3, 5,-3, 0,3]);
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
