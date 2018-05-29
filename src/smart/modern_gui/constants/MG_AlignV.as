package smart.modern_gui.constants
{
	public class MG_AlignV
	{
		public static const NONE:MG_AlignV = new MG_AlignV("none");
		public static const TOP:MG_AlignV = new MG_AlignV("top");
		public static const BOTTOM:MG_AlignV = new MG_AlignV("bottom");
		public static const CENTER:MG_AlignV = new MG_AlignV("center");
		
		private var _value:String;
		
		
		public function MG_AlignV(value:String) 
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
