package smart.gui.components 
{
	import flash.events.Event;

	public class SG_ValueEvent extends Event
	{
		public var variableName:String;
		public var hotUpdate:Boolean;
		public var value:*;
		
		public static var CHANGE_VALUE:String = "sg_changeValue";
		
		
		public function SG_ValueEvent(type:String) 
		{
			this.hotUpdate = hotUpdate;
			super(type);
		}
		
	}
}