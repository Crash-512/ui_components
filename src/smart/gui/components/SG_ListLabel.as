package smart.gui.components
{
	internal class SG_ListLabel extends SG_TextLabel
	{
		public function SG_ListLabel(text:String, style:SG_TextStyle)
		{
			super(text, style);
			textField.maxChars = 100;
		}
	}

}