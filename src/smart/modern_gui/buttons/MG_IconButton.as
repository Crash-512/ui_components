package smart.modern_gui.buttons
{
	import flash.display.Sprite;
	
	public class MG_IconButton extends MG_Button
	{
		  
		public function MG_IconButton(iconClass:Class, width:int = 40, height:int = 40)
		{
			super(width, height);
			
			var icon:Sprite = new iconClass();
			setIcon(icon);
		}
		
	}
}
