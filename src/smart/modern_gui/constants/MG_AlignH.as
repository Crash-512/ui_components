package smart.modern_gui.constants
{
	public class MG_AlignH
	{
		public static const NONE:MG_AlignH = new MG_AlignH("none");
		public static const LEFT:MG_AlignH = new MG_AlignH("left");
		public static const RIGHT:MG_AlignH = new MG_AlignH("right");
		public static const CENTER:MG_AlignH = new MG_AlignH("center");
		
		private var _value:String;
		
		
		public function MG_AlignH(value:String) 
		{
			_value = value;
		}
		
		public function toString():String 
		{
			return _value;
		}
		
		public function valueOf():Object 
		{
			return _value;
		}
		
	}
}
