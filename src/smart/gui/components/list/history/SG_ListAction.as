package smart.gui.components.list.history 
{
	import smart.gui.components.list.SG_List;
	import smart.gui.components.list.SG_ListEvent;
	import smart.gui.components.list.SG_ListFolder;
	import smart.gui.components.list.SG_ListItem;

	public class SG_ListAction 
	{
		public var correct:Boolean = true;
		public var type:String;
		public var item:SG_ListItem;
		public var undoVars:SG_ListActionVars;
		public var redoVars:SG_ListActionVars;
		public var fastHistory:Boolean;
		
		public static const SELECT:String = "select";
		public static const CREATE:String = "create";
		public static const REMOVE:String = "remove";
		public static const RENAME:String = "rename";
		public static const MOVING:String = "moving";
		public static const EXPAND:String = "expand";
		
		
		public function SG_ListAction(item:SG_ListItem, type:String, fastHistory:Boolean = false) 
		{
			this.fastHistory = fastHistory;
			this.type = type;
			this.item = item;
			undoVars = new SG_ListActionVars();
			redoVars = new SG_ListActionVars();
			parseVars(undoVars);
		}
		
		public function parseEndVars():void
		{
			parseVars(redoVars);
			checkAction();
		}
		
		private function checkAction():void 
		{
			switch (type)
			{
				case CREATE: case REMOVE: case MOVING:
				{
					if (undoVars.list != redoVars.list) correct = false;
					break;
				}
				case RENAME:
				{
					if (undoVars.name == redoVars.name) correct = false;
					break;
				}
			}
		}
		
		private function moveItem(index:int, folder_id:int, recover:Boolean = false):void
		{
			var list:SG_List = item.list;
			var folder:SG_ListFolder = list.folders[folder_id];
			folder.insertToIndex(item, index);
			
			var event:SG_ListEvent = new SG_ListEvent(SG_ListEvent.STOP_DRAG);
			event.item = item;
			list.dispatchEvent(event);
		}
		
		private function removeItem():void
		{
			item.remove();
		}
		
		public function apply(undo:Boolean):void 
		{
			var vars:SG_ListActionVars = (undo) ? undoVars : redoVars;
			var list:SG_List = item.list;
			
			switch (type)
			{
				case CREATE:
				{
					if (undo)	removeItem();
					else		moveItem(vars.childIndex, vars.folder, true);
					break;
				}
				case REMOVE:
				{
					if (undo)	moveItem(vars.childIndex, vars.folder, true);
					else		removeItem();
					break;
				}
				case MOVING:
				{
					moveItem(vars.childIndex, vars.folder);
					break;
				}
				case RENAME:
				{
					item.name = vars.name;
					break;
				}
				case EXPAND:
				{
					(item as SG_ListFolder).opened = vars.opened;
					break;
				}
			}
			if (item.parent) list.selectItem(item);
			list.refresh();
		}
		
		private function parseVars(vars:SG_ListActionVars):void
		{	
			switch (type)
			{
				case CREATE: case REMOVE: case MOVING:
				{
					vars.childIndex = item.childIndex;
					vars.folder = item.folderID;
					vars.list = item.list;
					break;
				}
				case RENAME:
				{
					vars.name = item.name;
					break;
				}
				case EXPAND:
				{
					vars.opened = (item as SG_ListFolder).opened;
					break;
				}
			}
		}
		
	}
}