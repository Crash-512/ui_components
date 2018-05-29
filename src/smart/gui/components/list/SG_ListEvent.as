package smart.gui.components.list 
{
	import flash.events.Event;
	
	import smart.gui.components.list.history.SG_ListAction;
	
	public class SG_ListEvent extends Event
	{
		public var item:SG_ListItem;
		public var folder:SG_ListFolder;
		public var action:SG_ListAction;
		public var manual:Boolean;
		
		public static const START_DRAG:String = "startDrag";
		public static const STOP_DRAG:String = "stopDrag";
		public static const ADD_ITEM:String = "addItem";
		public static const MOVE_ITEM:String = "modeItem";
		public static const ADD_FOLDER:String = "addFolder";
		public static const SELECT_ITEM:String = "selectItem";
		public static const SELECT_FOLDER:String = "selectFolder";
		public static const REMOVE_ITEM:String = "removeItem";
		public static const START_RENAMING:String = "startRenaming";
		public static const STOP_RENAMING:String = "stopRenaming";
		public static const SAVE_HISTORY:String = "saveHistory";
		public static const REFRESH:String = "refreshList";
		public static const EXPAND_FOLDER:String = "expandFolder";
		public static const RESET_SELECTION:String = "resetSelection";
		
		
		public function SG_ListEvent(type:String) 
		{
			super(type);
		}
		
	}

}