package smart
{
	public class RandomUtils
	{
		public static function randomFloat(min:Number, max:Number):Number
		{
			return min + (max - min) * Math.random();
		}
		
		public static function randomInt(min:int, max:int):int
		{
			return Math.round(randomFloat(min, max));
		}
	}
}
