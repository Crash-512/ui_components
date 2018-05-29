package smart.gui.components.list 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	internal class SG_ListEmptyItem extends SG_ListItem
	{
		
		public function SG_ListEmptyItem(list:SG_List, preset:SG_ListPreset) 
		{
			var icon:MovieClip = new MovieClip();
			
			icon.graphics.beginFill(0, 0);
			icon.graphics.drawRect(0,0,20,20);
			icon.graphics.endFill();
			isEmpty = true;
			
			super("(пусто)", list, preset, icon);
			
			label.color = 0x999999;
			doubleClickEnabled = false;
			
			removeEvents();
		}
		
	}

}