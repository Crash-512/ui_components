package smart.modern_gui.utils
{
	public class MG_Utils
	{
		private static const MIN_VALUE:Number = 0.001;
		
		
		public static function lerp(initPos:Number, endPos:Number, k:Number = 0.1, round:Boolean = false):Number
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
		
	}
}
