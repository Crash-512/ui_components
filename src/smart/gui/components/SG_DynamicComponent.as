package smart.gui.components
{
	import smart.gui.components.combobox.SG_ComboBox;
	import smart.gui.components.controllers.SG_Slider;
	import smart.gui.components.controllers.SG_Stepper;
	import smart.gui.components.switchers.SG_Switcher;
	import smart.gui.components.text.SG_TextInput;
	import smart.gui.constants.SG_ValueType;
	import smart.gui.signals.SG_Signal;
	
	public class SG_DynamicComponent extends SG_Component
	{
		public var variableName:String = "";
		public var valueType:String = SG_ValueType.NUMBER;
		
		public var onUpdate:SG_Signal;
		
		  
		public function SG_DynamicComponent()
		{
			super();
			onUpdate = SG_Signal.create();
			//addEventListener(SG_ValueEvent.CHANGE_VALUE, setValue);
		}
		
		public function dispatchValue(value:*, hotUpdate:Boolean = false):void
		{
			var valueEvent:SG_ValueEvent = new SG_ValueEvent(SG_ValueEvent.CHANGE_VALUE);
			valueEvent.variableName = variableName;
			valueEvent.value = value;
			valueEvent.hotUpdate = hotUpdate;
			dispatchEvent(valueEvent);
			onUpdate.emit(this);
		}
		
		public function getValue():* 
		{
			if (this is SG_Slider)       return (this as SG_Slider).value;
			if (this is SG_Stepper)      return (this as SG_Stepper).value;
			if (this is SG_TextInput)    return (this as SG_TextInput).text;
			if (this is SG_Switcher)     return (this as SG_Switcher).checked;
			if (this is SG_ComboBox)     return (this as SG_ComboBox).value;
		}
		
		public function setValue(value:*):void
		{
			if (this is SG_Slider)       (this as SG_Slider).value = value;
			if (this is SG_Stepper)      (this as SG_Stepper).value = value;
			if (this is SG_TextInput)    (this as SG_TextInput).text = value;
			if (this is SG_Switcher)     (this as SG_Switcher).checked = value;
			if (this is SG_ComboBox)     (this as SG_ComboBox).value = value;
		}
		
		public function clone():SG_DynamicComponent 
		{
			return this;
		}
		
	}
}
