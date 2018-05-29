package smart.gui.utils
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;

	public class SG_Math 
	{
		public static var pseudoRandom:Boolean;
		
		public static const RADIANS_TO_DEGREE_PI:Number = 180/Math.PI;
		public static const DEGREE_TO_RADIANS_PI:Number = Math.PI/180;
		
		private static const MIN_VALUE:Number = 0.001;
		private static const EPS:Number = 0.0000000001;	// Погрешность
		
		
		[Inline] public static function isEqualInt(valueA:int, valueB:int, delta:Number):Boolean
		{
			return (valueA + delta >= valueB) && (valueA - delta <= valueB);
		}
		
		[Inline] public static function inEqualFloat(valueA:Number, valueB:Number, delta:Number):Boolean
		{
			return (valueA + delta >= valueB) && (valueA - delta <= valueB);
		}
		
		[Inline] public static function cropToRange(value:Number, min:Number, max:Number):Number
		{
			if (value > max) return max;
			if (value < min) return min;
			return value;
		}
		
		[Inline] public static function getTimeString(timeInSeconds:int):String
		{
			var string:String = "";
			
			var mins:int = (timeInSeconds/60) % 60;
			var seconds:int = timeInSeconds % 60;
			
			string += mins + ":";
			if (seconds < 10) string += "0";
			string += seconds;
			
			return string;
		}
		
		[Inline] public static function randomNegative():int
		{
			if (randomBoolean()) return -1;
			else                 return 1;
		}
		
		[Inline] public static function randomBoolean():Boolean
		{
			return Math.random() >= 0.5;
		}
		
		[Inline] public static function valueInRange(value:Number, minValue:Number, maxValue:Number):Boolean
		{
			return value >= minValue && value <= maxValue;
		}
		
		[Inline] public static function radiansToDegree(value:Number):Number
		{
			return value * RADIANS_TO_DEGREE_PI;
		}
		
		[Inline] public static function degreeToRadians(value:Number):Number
		{
			return value * DEGREE_TO_RADIANS_PI;
		}
		
		public static function random(min:Number, max:Number, round:Boolean = false):Number
		{
			var value:Number;
			
			if (pseudoRandom)	value =  min + (max - min)/2;
			else				value = (Math.random() * (max-min) + min);
			
			if (round) value = Math.round(value);
			
			return value;
		}
		
		[Inline] public static function roundTo(value:Number, index:Number):Number
		{
			return Number(value.toFixed(index));
		}
		
		[Inline] public static function getCosinusAmplitude(speed:Number, amplitude:Number):Number
		{
			return Math.cos(getTimer() * (speed/1000)) * amplitude; 
		}
		
		public static function linearMove(initPos:Number, endPos:Number, speed:Number, round:Boolean = false):Number
		{
			speed = Math.abs(speed);
			
			if (initPos < endPos)
			{
				if (initPos + speed < endPos) return initPos + speed;
				return endPos;
			}
			else
			{
				if (initPos - speed > endPos) return initPos - speed;
				return endPos;
			}
		}
		
		public static function smoothMove(initPos:Number, endPos:Number, k:Number = 0.1, round:Boolean = false):Number
		{
			var value:Number = k * (endPos - initPos);
			
			if (value > 0)
			{
				if (value < MIN_VALUE) value = MIN_VALUE;
			}
			else 
			{
				if (value > -MIN_VALUE) value = -MIN_VALUE;
			}
			var result:Number = initPos + value;
			return (round) ? (initPos < endPos) ? Math.ceil(result) : Math.floor(result) : result;
		}
		
		[Inline] public static function rotatePointToDegree(point:Point, angle:Number):void
		{
			/* Поворот вершины */
			angle = -angle * DEGREE_TO_RADIANS_PI;
			
			var x:Number = point.x;
			var y:Number = point.y;
			
			point.x = x * Math.cos(angle) + y * Math.sin(angle);
			point.y = x * -Math.sin(angle) + y * Math.cos(angle);
		}
		
		[Inline] public static function rotatePointToRadians(point:Point, angle:Number):void
		{
			var x:Number = point.x;
			var y:Number = point.y;
			
			point.x = x * Math.cos(angle) + y * Math.sin(angle);
			point.y = x * -Math.sin(angle) + y * Math.cos(angle);
		}
		
		[Inline] public static function rotateAroundPoint(matrix:Matrix, x:Number, y:Number, angle:Number):void
		{
			matrix.tx -= x;
			matrix.ty -= y;
			matrix.rotate(angle * DEGREE_TO_RADIANS_PI);
			matrix.tx += x;
			matrix.ty += y;
		}
		
		[Inline] public static function getMinPoint(v1:Point,v2:Point):Point
		{
			/* Откладывание 100 пикселей на векторе */
			var precent:Number = 100 / sideLength(v1,v2);
			var xPos:Number = v2.x + (v1.x - v2.x) * precent;
			var yPos:Number = v2.y + (v1.y - v2.y) * precent;
			
			return new Point(xPos, yPos);
		}
		
		[Inline] public static function getAngle(v1:Point,v2:Point,v3:Point):Number
		{
			/* Вычисление угла между векторами */
			var a:Number = scalMul(v1,v2,v3);
			var exp:Number = a/sideLength(v1,v2)/sideLength(v3,v2);
			
			return Math.acos(exp)*180/Math.PI;
		}
		
		[Inline] public static function getTwoPointsAngle(v1:Point, v2:Point):Number
		{
			var angle:Number = Math.atan((v2.y-v1.y)/(v2.x-v1.x))*180/Math.PI;
			
			if (v2.x < v1.x)
			{
				if (v2.y > v1.y) angle += 180;
				if (v2.y <= v1.y) angle -= 180;
			}
			return angle;
		}
		
		[Inline] public static function sideLength(v1:Point, v2:Point):Number
		{
			/* Вычисление длины вектора */
			return Math.sqrt((v1.x-v2.x)*(v1.x-v2.x)+(v1.y-v2.y)*(v1.y-v2.y));
		}
		
		[Inline] public static function quadLength(v1:Point, v2:Point):Number
		{
			/* Вычисление квадрата длины вектора */
			return (v1.x-v2.x)*(v1.x-v2.x)+(v1.y-v2.y)*(v1.y-v2.y);
		}
		
		[Inline] public static function vectorMul(v1:Point, v2:Point, v3:Point, orient:int):Number
		{
			/* Векторное произведение */
			return ((v2.x-v1.x)*(v3.y-v2.y) - (v2.y-v1.y)*(v3.x-v2.x))*orient;	
		}
		
		[Inline] public static function scalMul(v1:Point,v2:Point,v3:Point):Number
		{
			/* Скалярное произведение */
			return (v1.x-v2.x)*(v3.x-v2.x)+(v1.y-v2.y)*(v3.y-v2.y)
		}
		
		
		// *** SEGMENT *** //
		
		
		[Inline] public static function centerOfSegment(p1:Point, p2:Point):Point
		{
			var x:Number = p1.x - (p1.x - p2.x)/2;
			var y:Number = p1.y - (p1.y - p2.y)/2;
			
			return new Point(x,y);
		}
		
		[Inline] public static function pointInSegment(v1:Point, v2:Point, point:Point):Boolean
		{
			/* Принадлежность точки к отрезку */
			if (pointInRect(point, v1, v2))
			{
				var a:Number = v2.y - v1.y;
				var b:Number = v1.x - v2.x;
				var c:Number = - a * v1.x - b * v1.y;

				return !(Math.abs(a * point.x + b * point.y + c) > EPS);
			}
			else return false;
		}
		
		[Inline] public static function segmentCross(v1:Point, v2:Point, v3:Point, v4:Point):Boolean
		{
			/* Проверка пересечения двух отрезков */
			var rect1:Rectangle = getSegmentRect(v1,v2);
			var rect2:Rectangle = getSegmentRect(v3,v4);
			
			if (SG_Math.rectCross(rect1,rect2))
			{
				var con_1:Boolean = vectorMul(v3,v1,v2,1) * vectorMul(v4,v1,v2,1) <= 0;
				var con_2:Boolean = vectorMul(v1,v3,v4,1) * vectorMul(v2,v3,v4,1) <= 0;
				
				return (con_1 && con_2);
			}
			else return false;
		}
		
		[Inline] public static function getSegmentRect(v1:Point, v2:Point):Rectangle
		{
			/* Получение прямоугольника, содержащего в себе отрезок */
			var x:Number = Math.min(v1.x,v2.x);
			var y:Number = Math.min(v1.y,v2.y);
			
			var width:Number = Math.abs(v1.x - v2.x);
			var height:Number = Math.abs(v1.y - v2.y);
			
			return new Rectangle(x, y, width, height);
		}
		
		
		// *** TRIANGLE *** //
		
		
		[Inline] public static function triangleCenter(v1:Point, v2:Point, v3:Point):Point
		{
			// Определение центра треугольника
			var xPos:Number = (v1.x + v2.x + v3.x)/3;
			var yPos:Number = (v1.y + v2.y + v3.y)/3;
			
			return new Point(xPos, yPos);
		}
		
		[Inline] public static function ptsInTriangle(v1:Point,v2:Point,v3:Point, pts:Array):Boolean
		{
			/* Проверка на содержание точек в треугольнике */
			var areaABC:Number;
			var areaParts:Number;
			var p:Point;
			
			for (var i:int=0; i<pts.length; i++) 
			{
				p = pts[i];
				
				if (p == v1 || p == v2 || p == v3) continue;
				
				areaABC = triangleArea(v1,v2,v3);
				areaParts = triangleArea(p,v2,v3) + triangleArea(v1,p,v3) + triangleArea(v1,v2,p);
				
				if (Math.abs(areaABC-areaParts) < 5) return true;
			}
			return false;
		}
		
		[Inline] public static function getBisectrix(v1:Point,v2:Point,v3:Point):Point
		{
			/* Нахождение биссектрисы угла */
			var bis:Point = Point.interpolate(getMinPoint(v1,v2),getMinPoint(v3,v2),0.5);
			
			var xPos:Number = bis.x - (bis.x - v2.x)*2;
			var yPos:Number = bis.y - (bis.y - v2.y)*2;
			
			return new Point(xPos,yPos);
		}
		
		[Inline] public static function triangleArea(a:Point, b:Point, c:Point):Number 
		{
			/* Вычисление площади треугольника */
			var area:Number = Math.abs((a.x-b.x)*(c.y-b.y)-(a.y-b.y)*(c.x-b.x))/2;
			return area;
		}
		
		
		// *** RECTANGLE *** //
		
		
		[Inline] public static function roundRect(rect:Rectangle):Rectangle
		{
			/* Округление размеров прямоугольника */
			rect.x = Math.floor(rect.x);
			rect.y = Math.floor(rect.y);
			rect.width = Math.ceil(rect.width);
			rect.height = Math.ceil(rect.height);
			
			return rect;
		}
		
		[Inline] public static function resizeRect(rect:Rectangle, x:Number, y:Number):Rectangle
		{
		    rect.x -= x;
		    rect.y -= y;
		    rect.width += x*2;
		    rect.height += y*2;

			return rect;
		}
		
		[Inline] public static function rectCross(rect1:Rectangle,rect2:Rectangle):Boolean
		{
			/* Проверка пересечения двух прямоугольников */
			var xCross:Boolean = Math.min(rect1.right, rect2.right) >= Math.max(rect1.left, rect2.left);
			var yCross:Boolean = Math.max(rect1.top, rect2.top) <= Math.min(rect1.bottom, rect2.bottom);
			
			return (xCross && yCross);
		}
		
		[Inline] public static function rectCrossingArea(rectA:Rectangle, rectB:Rectangle):Number
		{
			/* Площать пересечения двух прямоугольников */
			/*SE_DebugCanvas.clear();
			SE_DebugCanvas.drawRect(rectA);
			SE_DebugCanvas.drawRect(rectB);
			*/
			var xAxis:Number = 0;
			var yAxis:Number = 0; 

			if (rectA.left < rectB.left)
			{
				if (rectA.right > rectB.left) xAxis = rectA.right - rectB.left;
			}
			else if (rectA.left < rectB.right) xAxis = rectB.right - rectA.left;

			if (rectA.top < rectB.top)
			{
				if (rectA.bottom > rectB.top) yAxis = rectA.bottom - rectB.top;
			}
			else if (rectA.top < rectB.bottom) yAxis = rectB.bottom - rectA.top;

			return xAxis * yAxis;
		}
		
		[Inline] public static function pointInRect(t:Point, p1:Point, p2:Point):Boolean
		{
			/* Точки в прямоугольнике */
			var minX:Number = Math.min(p1.x, p2.x);
			var minY:Number = Math.min(p1.y, p2.y);
			var maxX:Number = Math.max(p1.x, p2.x);
			var maxY:Number = Math.max(p1.y, p2.y);
			
			var a:Boolean = (Math.abs(t.x - minX) <= EPS || minX <= t.x);
            var b:Boolean = (Math.abs(maxX - t.x) <= EPS || maxX >= t.x);
            var c:Boolean = (Math.abs(t.y - minY) <= EPS || minY <= t.y);
            var d:Boolean = (Math.abs(maxY - t.y) <= EPS || maxY >= t.y);
			
			return (a && b && c && d);
		}
		
	}
}