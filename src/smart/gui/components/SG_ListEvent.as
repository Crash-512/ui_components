package smart.gui.components
{
	import flash.events.Event;
	
	public class SG_ListEvent extends Event
	{
		public static const SELECT_ITEM:String = "selectItem";
		
		public function SG_ListEvent(type:String) 
		{
			super(type);
		}
		
	}

}