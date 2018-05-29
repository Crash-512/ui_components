package smart.tweener
{
	import flash.events.Event;

	public class SP_TweenerEvent extends Event
	{
		public static const ALL_TWEENS_FINISHED:String = "SE_allTweensFinished";
		
		  
		public function SP_TweenerEvent(type:String)
		{
			super(type);
		}
		
	}
}
