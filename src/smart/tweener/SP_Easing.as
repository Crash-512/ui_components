/*
 * Класс содержит формулы, используемые для преобразований.
 */

package smart.tweener 
{
	public class SP_Easing 
	{
			
		/**
		 * @param t		Текущее время.
		 * @param b		Начальное значение.
		 * @param c		Конечное значение.
		 * @param d		Полное время преобразования.
		 */
		
		public static function linear(t:Number, b:Number, c:Number, d:Number):Number 
		{
			return c*t/d + b;
		}
		
		public static function quadIn(t:Number, b:Number, c:Number, d:Number):Number 
		{
			return c*(t/=d)*t + b;
		}
		
		public static function quadOut(t:Number, b:Number, c:Number, d:Number):Number 
		{
			return -c *(t/=d)*(t-2) + b;
		}
		
		public static function quadInOut(t:Number, b:Number, c:Number, d:Number):Number 
		{
			if ((t/=d/2) < 1) return c/2*t*t + b;
			return -c/2 * ((--t)*(t-2) - 1) + b;
		}
		
		public static function quadOutIn(t:Number, b:Number, c:Number, d:Number):Number 
		{
			if (t < d/2) return quadOut (t*2, b, c/2, d);
			return quadIn((t*2)-d, b+c/2, c/2, d);
		}
		
		public static function cubicIn(t:Number, b:Number, c:Number, d:Number):Number 
		{
			return c*(t/=d)*t*t + b;
		}
		
		public static function cubicOut(t:Number, b:Number, c:Number, d:Number):Number 
		{
			return c*((t=t/d-1)*t*t + 1) + b;
		}
		
		public static function cubicInOut(t:Number, b:Number, c:Number, d:Number):Number 
		{
			if ((t/=d/2) < 1) return c/2*t*t*t + b;
			return c/2*((t-=2)*t*t + 2) + b;
		}
		
		public static function cubicOutIn(t:Number, b:Number, c:Number, d:Number):Number 
		{
			if (t < d/2) return cubicOut (t*2, b, c/2, d);
			return cubicIn((t*2)-d, b+c/2, c/2, d);
		}
		
		public static function quartIn(t:Number, b:Number, c:Number, d:Number):Number 
		{
			return c*(t/=d)*t*t*t + b;
		}
		
		public static function quartOut(t:Number, b:Number, c:Number, d:Number):Number 
		{
			return -c * ((t=t/d-1)*t*t*t - 1) + b;
		}
		
		public static function quartInOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			if ((t/=d/2) < 1) return c/2*t*t*t*t + b;
			return -c/2 * ((t-=2)*t*t*t - 2) + b;
		}
		
		public static function quartOutIn(t:Number, b:Number, c:Number, d:Number):Number 
		{
			if (t < d/2) return quartOut (t*2, b, c/2, d);
			return quartIn((t*2)-d, b+c/2, c/2, d);
		}
		
		public static function quintIn(t:Number, b:Number, c:Number, d:Number):Number
		{
			return c*(t/=d)*t*t*t*t + b;
		}
		
		public static function quintOut(t:Number, b:Number, c:Number, d:Number):Number 
		{
			return c*((t=t/d-1)*t*t*t*t + 1) + b;
		}
		
		public static function quintInOut(t:Number, b:Number, c:Number, d:Number):Number 
		{
			if ((t/=d/2) < 1) return c/2*t*t*t*t*t + b;
			return c/2*((t-=2)*t*t*t*t + 2) + b;
		}
		
		public static function outInQuint(t:Number, b:Number, c:Number, d:Number):Number 
		{
			if (t < d/2) return quintOut (t*2, b, c/2, d);
			return quintIn((t*2)-d, b+c/2, c/2, d);
		}
		
		public static function sineIn(t:Number, b:Number, c:Number, d:Number):Number
		{
			return -c * Math.cos(t/d * (Math.PI/2)) + c + b;
		}
		
		public static function sineOut(t:Number, b:Number, c:Number, d:Number):Number 
		{
			return c * Math.sin(t/d * (Math.PI/2)) + b;
		}
		
		public static function sineInOut(t:Number, b:Number, c:Number, d:Number):Number 
		{
			return -c/2 * (Math.cos(Math.PI*t/d) - 1) + b;
		}
		
		public static function sineOutIn(t:Number, b:Number, c:Number, d:Number):Number 
		{
			if (t < d/2) return sineOut (t*2, b, c/2, d);
			return sineIn((t*2)-d, b+c/2, c/2, d);
		}
		
		public static function expoIn(t:Number, b:Number, c:Number, d:Number):Number
		{
			return (t==0) ? b : c * Math.pow(2, 10 * (t/d - 1)) + b - c * 0.001;
		}
		
		public static function expoOut(t:Number, b:Number, c:Number, d:Number):Number 
		{
			return (t==d) ? b+c : c * 1.001 * (-Math.pow(2, -10 * t/d) + 1) + b;
		}
		
		public static function expoInOut(t:Number, b:Number, c:Number, d:Number):Number 
		{
			if (t==0) return b;
			if (t==d) return b+c;
			if ((t/=d/2) < 1) return c/2 * Math.pow(2, 10 * (t - 1)) + b - c * 0.0005;
			return c/2 * 1.0005 * (-Math.pow(2, -10 * --t) + 2) + b;
		}
		
		public static function expoOutIn(t:Number, b:Number, c:Number, d:Number):Number 
		{
			if (t < d/2) return expoOut (t*2, b, c/2, d);
			return expoIn((t*2)-d, b+c/2, c/2, d);
		}
		
		public static function circIn(t:Number, b:Number, c:Number, d:Number):Number
		{
			return -c * (Math.sqrt(1 - (t/=d)*t) - 1) + b;
		}
		
		public static function circOut(t:Number, b:Number, c:Number, d:Number):Number 
		{
			return c * Math.sqrt(1 - (t=t/d-1)*t) + b;
		}
		
		public static function circInOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			if ((t/=d/2) < 1) return -c/2 * (Math.sqrt(1 - t*t) - 1) + b;
			return c/2 * (Math.sqrt(1 - (t-=2)*t) + 1) + b;
		}
		
		public static function circOutIn(t:Number, b:Number, c:Number, d:Number):Number 
		{
			if (t < d/2) return circOut (t*2, b, c/2, d);
			return circIn((t*2)-d, b+c/2, c/2, d);
		}
		
		/// @param a	Amplitude.
		/// @param p	Period.
		
		public static function elasticIn(t:Number, b:Number, c:Number, d:Number):Number 
		{
			if (t==0) return b;
			if ((t/=d)==1) return b+c;
			var p:Number = d*.3;
			var s:Number;
			var a:Number = 0;
			
			if (!Boolean(a) || a < Math.abs(c)) 
			{
				a = c;
				s = p/4;
			} 
			else 
			{
				s = p/(2*Math.PI) * Math.asin (c/a);
			}
			return -(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )) + b;
		}
		
		/// @param a	Amplitude.
		/// @param p	Period.
		
		public static function elasticOut(t:Number, b:Number, c:Number, d:Number):Number 
		{
			if (t==0) return b;
			if ((t/=d)==1) return b+c;
			var p:Number = d*.3;
			var s:Number;
			var a:Number = 0;
			if (!Boolean(a) || a < Math.abs(c)) 
			{
				a = c;
				s = p/4;
			} 
			else 
			{
				s = p/(2*Math.PI) * Math.asin (c/a);
			}
			return (a*Math.pow(2,-10*t) * Math.sin( (t*d-s)*(2*Math.PI)/p ) + c + b);
		}
		
		/// @param a	Amplitude.
		/// @param p	Period.
		
		public static function elasticInOut(t:Number, b:Number, c:Number, d:Number):Number 
		{
			if (t==0) return b;
			if ((t/=d/2)==2) return b+c;
			var p:Number = d*(.3*1.5);
			var s:Number;
			var a:Number = 0;
			if (!Boolean(a) || a < Math.abs(c)) {
				a = c;
				s = p/4;
			} else {
				s = p/(2*Math.PI) * Math.asin (c/a);
			}
			if (t < 1) return -.5*(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )) + b;
			return a*Math.pow(2,-10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )*.5 + c + b;
		}
		
		public static function elasticOutIn(t:Number, b:Number, c:Number, d:Number):Number
		{
			if (t < d/2) return elasticOut (t*2, b, c/2, d);
			return elasticIn((t*2)-d, b+c/2, c/2, d);
		}
		
		public static function backIn(t:Number, b:Number, c:Number, d:Number):Number 
		{
			var s:Number = 2.70158;
			return c*(t/=d)*t*((s+1)*t - s) + b;
		}
		
		public static function backOut(t:Number, b:Number, c:Number, d:Number):Number 
		{
			var s:Number = 2.70158;
			return c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b;
		}
		
		public static function slowBackOut(t:Number, b:Number, c:Number, d:Number):Number 
		{
			var s:Number = 1.6;
			return c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b;
		}
		
		public static function slowBackIn(t:Number, b:Number, c:Number, d:Number):Number 
		{
			var s:Number = 1.6;
			return c*(t/=d)*t*((s+1)*t - s) + b;
		}
		
		public static function backInOut(t:Number, b:Number, c:Number, d:Number):Number 
		{
			var s:Number = 1.70158;
			if ((t/=d/2) < 1) return c/2*(t*t*(((s*=(1.525))+1)*t - s)) + b;
			return c/2*((t-=2)*t*(((s*=(1.525))+1)*t + s) + 2) + b;
		}
		
		public static function backOutIn(t:Number, b:Number, c:Number, d:Number):Number 
		{
			if (t < d/2) return backOut (t*2, b, c/2, d);
			return backIn((t*2)-d, b+c/2, c/2, d);
		}
		
		public static function bounceIn(t:Number, b:Number, c:Number, d:Number):Number 
		{
			return c - bounceOut (d-t, 0, c, d) + b;
		}
		
		public static function bounceOut(t:Number, b:Number, c:Number, d:Number):Number 
		{
			if ((t/=d) < (1/2.75))
			{
				return c*(7.5625*t*t) + b;
			} 
			else if (t < (2/2.75))
			{
				return c*(7.5625*(t-=(1.5/2.75))*t + .75) + b;
			} 
			else if (t < (2.5/2.75)) 
			{
				return c*(7.5625*(t-=(2.25/2.75))*t + .9375) + b;
			} 
			else 
			{
				return c*(7.5625*(t-=(2.625/2.75))*t + .984375) + b;
			}
		}
		
		public static function bounceInOut(t:Number, b:Number, c:Number, d:Number):Number 
		{
			if (t < d/2) return bounceIn (t*2, 0, c, d) * .5 + b;
			else return bounceOut (t*2-d, 0, c, d) * .5 + c*.5 + b;
		}
		
		public static function bounceOutIn(t:Number, b:Number, c:Number, d:Number):Number 
		{
			if (t < d/2) return bounceOut (t*2, b, c/2, d);
			return bounceIn((t*2)-d, b+c/2, c/2, d);
		}
		
	}
}
