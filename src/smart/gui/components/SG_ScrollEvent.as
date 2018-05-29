package smart.gui.components
{
	import flash.events.Event;
	
	public class SG_ScrollEvent extends Event
	{
		public static const STOP_SCROLL:String = "stopScroll";
		public static const START_SCROLL:String = "startScroll";
		
		
		public function SG_ScrollEvent(type:String) 
		{
			super(type);
		}
		
	}

}