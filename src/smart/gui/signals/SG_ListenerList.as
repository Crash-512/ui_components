package smart.gui.signals
{
	internal class SG_ListenerList
	{
		public var firstItem:SG_Listener;
		
		  
		public function SG_ListenerList()
		{
			super();
		}
		
		public function add(item:SG_Listener):void 
		{
			if (firstItem)
			{
				firstItem.prev = item;
				item.next = firstItem;
			}
			firstItem = item;
		}
		
		public function remove(item:SG_Listener):void 
		{
			if (item == firstItem) firstItem = firstItem.next;
			
			if (item.prev) item.prev.next = item.next;
			if (item.next) item.next.prev = item.prev;
			
			item.next = null;
			item.prev = null;
		}
		
		public function removeAll():void
		{
			var item:SG_Listener;
			
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
