package smart.gui.components
{
	import smart.gui.signals.SG_Signal;
	
	public class SG_DynamicComponent extends SG_Component
	{
		public var onUpdate:SG_Signal;
		
		  
		public function SG_DynamicComponent()
		{
			super();
			onUpdate = SG_Signal.create();
		}
		
		public function dispatchValue(value:*, hotUpdate:Boolean = false):void
		{
			onUpdate.emit(this);
		}
		
		public function setValue(value:*):void
		{
			if (this is SG_Slider)       (this as SG_Slider).value = value;
			if (this is SG_Stepper)      (this as SG_Stepper).value = value;
			if (this is SG_TextInput)    (this as SG_TextInput).text = value;
			if (this is SG_Switcher)     (this as SG_Switcher).checked = value;
			if (this is SG_ComboBox)     (this as SG_ComboBox).value = value;
		}
	}
}
