package smart.gui.data
{
	public class SG_Point
	{
		public var x:int;
		public var y:int;

		  
		public function SG_Point(x:int, y:int)
		{
			this.x = x;
			this.y = y;
		}
		
		[Inline] final public function dispose():void
		{
			pool.push(this);
		}
		
		public function toString():String
		{
			return "SE_Point [" + x + ", " + y + "]";
		}
		
		
		internal static var pool:Vector.<SG_Point> = new Vector.<SG_Point>();
		
		
		[Inline] public static function create(x:int, y:int):SG_Point
		{
			var point:SG_Point;
			
			if (pool.length != 0)
			{
				point = pool.pop();
				point.x = x;
				point.y = y;
			}
			else point = new SG_Point(x, y);
			
			return point;
		}
		
	}
}