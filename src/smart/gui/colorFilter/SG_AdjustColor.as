package smart.gui.colorFilter
{
	import flash.filters.*;
	import flash.geom.Matrix;

	public class SG_AdjustColor
	{
		private var m_brightnessMatrix:SG_ColorMatrix;
		private var m_contrastMatrix:SG_ColorMatrix;
		private var m_saturationMatrix:SG_ColorMatrix;
		private var m_hueMatrix:SG_ColorMatrix;
		private var m_finalMatrix:SG_ColorMatrix;
		
		private static var s_arrayOfDeltaIndex:Array =
		[                                      
		  	0,    0.01, 0.02, 0.04, 0.05, 0.06, 0.07, 0.08, 0.1,  0.11,
		  	0.12, 0.14, 0.15, 0.16, 0.17, 0.18, 0.20, 0.21, 0.22, 0.24,
		  	0.25, 0.27, 0.28, 0.30, 0.32, 0.34, 0.36, 0.38, 0.40, 0.42,
		  	0.44, 0.46, 0.48, 0.5,  0.53, 0.56, 0.59, 0.62, 0.65, 0.68, 
		  	0.71, 0.74, 0.77, 0.80, 0.83, 0.86, 0.89, 0.92, 0.95, 0.98,
		  	1.0,  1.06, 1.12, 1.18, 1.24, 1.30, 1.36, 1.42, 1.48, 1.54,
		  	1.60, 1.66, 1.72, 1.78, 1.84, 1.90, 1.96, 2.0,  2.12, 2.25, 
		  	2.37, 2.50, 2.62, 2.75, 2.87, 3.0,  3.2,  3.4,  3.6,  3.8,
		  	4.0,  4.3,  4.7,  4.9,  5.0,  5.5,  6.0,  6.5,  6.8,  7.0,
		  	7.3,  7.5,  7.8,  8.0,  8.4,  8.7,  9.0,  9.4,  9.6,  9.8, 
		  	10.0  
		];
		
		
		public function SG_AdjustColor(brightness:Number = 0, contrast:Number = 0, saturation:Number = 0, hue:Number = 0):void
		{
			this.brightness = brightness;
			this.contrast = contrast;
			this.saturation = saturation;
			this.hue = hue;
		}
		
		public static function getFilteredColor(color:uint, brightness:Number = 0, contrast:Number = 0, saturation:Number = 0, hue:Number = 0):uint
		{
			var m:Array = getFilter(brightness, contrast, saturation, hue).matrix;
			var bits:int = 16;
			
			var srcR:Number = (color >> bits) & 0xFF;
			var srcG:Number = (color >> (bits - 8)) & 0xFF;
			var srcB:Number = (color >> (bits - 16)) & 0xFF;

			var red:Number   = (m[0]  * srcR) + (m[1]  * srcG) + (m[2]  * srcB) + m[3] + m[4];
			var green:Number = (m[5]  * srcR) + (m[6]  * srcG) + (m[7]  * srcB) + m[8] + m[9];
			var blue:Number  = (m[10] * srcR) + (m[11] * srcG) + (m[12] * srcB) + m[13] + m[14];

			var redS:String = Math.max(0, Math.min(255, red)).toString(16);
			var greenS:String = Math.max(0, Math.min(255, green)).toString(16);
			var blueS:String = Math.max(0, Math.min(255, blue)).toString(16);

			if (redS.length < 2)	redS = "0" + redS;
			if (greenS.length < 2)	greenS = "0" + greenS;
			if (blueS.length < 2)	blueS = "0" + blueS;

			var string:String = "0x" + redS + greenS + blueS;
			var newColor:uint = parseInt(string, 16);

			return newColor;
		}
		
		public static function getFilter(brightness:Number = 0, contrast:Number = 0, saturation:Number = 0, hue:Number = 0):ColorMatrixFilter
		{
			var matrix:SG_AdjustColor = new SG_AdjustColor(brightness, contrast, saturation, hue);
			var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix.getArray());
			
			return filter;
		}
		
		public function set brightness(value:Number):void
		{
			if (m_brightnessMatrix == null) m_brightnessMatrix = new SG_ColorMatrix();
			if (value != 0)	                m_brightnessMatrix.SetBrightnessMatrix(value);
		}
		
		public function set contrast(value:Number):void
		{	
			var deNormVal:Number = value;
			
			if (value == 0)     deNormVal = 127;
			else if (value > 0) deNormVal = s_arrayOfDeltaIndex[int(value)] * 127 + 127;
			else                deNormVal = (value / 100 * 127) + 127;
		
			if (m_contrastMatrix == null) m_contrastMatrix = new SG_ColorMatrix();
			
			m_contrastMatrix.SetContrastMatrix(deNormVal);
		}
		
		public function set saturation(value:Number):void
		{
			var deNormVal:Number = value;
			
			if (value == 0)     deNormVal = 1;
			else if (value > 0) deNormVal = 1.0 + (3 * value / 100);
			else                deNormVal = value / 100 + 1;
		
			if(m_saturationMatrix == null) m_saturationMatrix = new SG_ColorMatrix();
			m_saturationMatrix.SetSaturationMatrix(deNormVal);
		}
		
		public function set hue(value:Number):void
		{
			if(m_hueMatrix == null) m_hueMatrix = new SG_ColorMatrix();
			if(value != 0)          m_hueMatrix.SetHueMatrix(value * Math.PI / 180.0);
		}
		
		public function AllValuesAreSet():Boolean
		{
			return (m_brightnessMatrix && m_contrastMatrix && m_saturationMatrix && m_hueMatrix);
		}
		
		public function getArray():Array
		{
			if(CalculateFinalMatrix()) return m_finalMatrix.GetFlatArray();
			return null;
		}
		
		private function CalculateFinalMatrix():Boolean
		{
			if (!AllValuesAreSet()) return false;
			
			m_finalMatrix = new SG_ColorMatrix();
			m_finalMatrix.Multiply(m_brightnessMatrix);
			m_finalMatrix.Multiply(m_contrastMatrix);
			m_finalMatrix.Multiply(m_saturationMatrix);
			m_finalMatrix.Multiply(m_hueMatrix);
			
			return true;
		}
		
	}
}