package smart.gui.components.list 
{
	import flash.events.Event;
	
	public class SG_ListEvent extends Event
	{
		public var item:SG_ListItem;
		public var folder:SG_ListFolder;
		
		public static const ADD_ITEM:String = "addItem";
		public static const SELECT_ITEM:String = "selectItem";
		public static const REMOVE_ITEM:String = "removeItem";
		public static const START_RENAMING:String = "startRenaming";
		public static const STOP_RENAMING:String = "stopRenaming";
		public static const REFRESH:String = "refreshList";
		public static const RESET_SELECTION:String = "resetSelection";
		
		
		public function SG_ListEvent(type:String) 
		{
			super(type);
		}
		
	}

}