package smart.components
{
	import smart.RandomUtils;
	import smart.gui.components.controllers.SG_Stepper;
	
	internal class Stepper extends Component
	{
		private var _defaultValue:int;
		private var _stepper:SG_Stepper;
		
		public function Stepper(id:String, name:String, layout:Layout, minValue:Number, maxValue:Number, defaultValue:Number, step:Number)
		{
			super(id, name, layout);
			useRectAlign = false;
			
			_defaultValue = defaultValue;
			
			_stepper = new SG_Stepper(_defaultValue, step, minValue, maxValue);
			_stepper.width = layout.componentSize;
			_stepper.defaultValue = _defaultValue;
			_stepper.onUpdate.add(saveValue);
			addChild(_stepper);
		}
		
		override public function reset():void
		{
			_stepper.value = _defaultValue;
			super.reset();
		}
		
		override public function random():void
		{
			if (_stepper.enabled)
			{
				var value:Number = RandomUtils.randomFloat(_stepper.minValue, _stepper.maxValue);
				var roundFactor:int = 10 * _stepper.roundIndex;
				value = roundFactor == 0 ? Math.round(value) : Math.round(value * roundFactor) / roundFactor;
				setValue(value);
				saveValue();
			}
		}
		
		override protected function setValue(value:*):void
		{
			_stepper.value = value;
		}
		
		override public function saveValue():void
		{
			if (_object.hasOwnProperty(_id))
			{
				_object[_id] = _stepper.value;
			}
		}
		
		public function get stepper():SG_Stepper
		{
			return _stepper;
		}
	}
}
