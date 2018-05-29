package smart.gui.components.text 
{
	public class SG_TextRestrict 
	{
		public static const DIGITS:String = "0123456789";
		public static const ENGLISH:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
		public static const CYRILLIC:String = "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЬЪЫЭЮЯабвгдеёжзийклмнопрстуфхцчшщьъыэюя";
		public static const SPECIAL:String = "*|:\/?";
		public static const SYMBOLS:String = " '\\-\\^~!;,.+_{}[]$%#@&()";
		
		public static const ALL:String = DIGITS + ENGLISH + CYRILLIC + SPECIAL + SYMBOLS;
	}

}