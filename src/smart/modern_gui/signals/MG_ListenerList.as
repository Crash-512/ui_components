package smart.modern_gui.signals
{
	internal class MG_ListenerList
	{
		public var firstItem:MG_Listener;
		
		  
		public function MG_ListenerList()
		{
			super();
		}
		
		public function add(item:MG_Listener):void 
		{
			if (firstItem)
			{
				firstItem.prev = item;
				item.next = firstItem;
			}
			firstItem = item;
		}
		
		public function remove(item:MG_Listener):void 
		{
			if (item == firstItem) firstItem = firstItem.next;
			
			if (item.prev) item.prev.next = item.next;
			if (item.next) item.next.prev = item.prev;
			
			item.next = null;
			item.prev = null;
		}
		
		public function removeAll():void
		{
			var item:MG_Listener;
			
			while (firstItem)
			{
				item = firstItem;
				firstItem = item.next;
				item.dispose();
			}
			firstItem = null;
		}
		
	}
}
