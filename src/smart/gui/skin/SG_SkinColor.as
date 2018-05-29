package smart.gui.skin
{
	import smart.gui.colorFilter.SG_AdjustColor;
	
	public class SG_SkinColor
	{
		private var brightness:int;
		private var contrast:int;
		private var saturation:int;
		private var hue:int;
		private var sourceColor:uint;
		private var colors:Vector.<uint>;
		
		  
		public function SG_SkinColor(color:uint, brightness:int = 0, contrast:int = 0, saturation:int = 0, hue:int = 0)
		{
			this.brightness = brightness;
			this.contrast = contrast;
			this.saturation = saturation;
			this.hue = hue;
			
			sourceColor = color;
			colors = new Vector.<uint>(11, true);
			
			colors[0] = getCustomColor(-105);
			colors[1] = getCustomColor(-76);
			colors[2] = getCustomColor(-33);
			colors[3] = getCustomColor(-20);
			colors[4] = getCustomColor(-7);
			colors[5] = getCustomColor(0);
			colors[6] = getCustomColor(11);
			colors[7] = getCustomColor(18);
			colors[8] = getCustomColor(29);
			colors[9] = getCustomColor(35);
			colors[10] = getCustomColor(44);
		}
		
		public function getColor(index:uint):uint 
		{
			return colors[index];
		}
		
		public function getCustomColor(brightness:int = 0, contrast:int = 0, saturation:int = 0, hue:int = 0):uint
		{
			brightness += this.brightness;
			contrast += this.contrast;
			saturation += this.saturation;
			hue += this.hue;
			
			var color:uint = sourceColor;
			var bits:int = 16;
			var m:Array = SG_AdjustColor.getFilter(brightness, contrast, saturation, hue).matrix;
			
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
		
	}
}
