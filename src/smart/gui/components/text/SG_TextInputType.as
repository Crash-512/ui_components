package smart.gui.components.text 
{
	public class SG_TextInputType 
	{
		public static const STRING:String 	= "string";
		public static const INT:String		= "int";
		public static const FLOAT:String	= "float";
		public static const UINT:String 	= "uint";
		public static const UFLOAT:String	= "ufloat";
		
		private static const STRING_RESTRICT:String 	= "\\ -_0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
		private static const INT_RESTRICT:String		= "\\-0123456789";
		private static const FLOAT_RESTRICT:String		= "\\-.0123456789";
		private static const UINT_RESTRICT:String 		= "0123456789";
		private static const UFLOAT_RESTRICT:String		= ".0123456789";
		
		
		public static function getRestrict(type:String):String 
		{
			switch (type)
			{
				case STRING:	return STRING_RESTRICT;
				case INT:		return INT_RESTRICT;
				case FLOAT:		return FLOAT_RESTRICT;
				case UINT:		return UINT_RESTRICT;
				case UFLOAT:	return UFLOAT_RESTRICT;
				default:		return STRING_RESTRICT;
			}
		}
		
	}

}