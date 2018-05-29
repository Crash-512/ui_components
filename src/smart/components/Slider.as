package smart.components
{
	import smart.RandomUtils;
	import smart.gui.components.SG_Slider;
	import smart.gui.components.SG_TextLabel;
	import smart.gui.constants.SG_Align;
	
	internal class Slider extends Component
	{
		private var _defaultValue:int;
		private var _slider:SG_Slider;
		private var _counter:SG_TextLabel;
		
		public function Slider(id:String, name:String, layout:Layout, minValue:Number, maxValue:Number, defaultValue:Number, tickInterval:Number, snapInterval:Number)
		{
			super(id, name, layout);
			useRectAlign = false;
			
			_defaultValue = defaultValue;
			
			_slider = new SG_Slider(minValue, maxValue, tickInterval, snapInterval);
			_slider.width = layout.componentSize;
			_slider.defaultValue = _defaultValue;
			_slider.onUpdate.add(saveValue);
			addChild(_slider);
			
			_counter = createLabel("0", SG_Align.LEFT, layout.counterSize);
			addChild(_counter);
		}
		
		override public function reset():void
		{
			setValue(_defaultValue);
			super.reset();
		}
		
		override public function random():void
		{
			if (_slider.enabled)
			{
				var value:Number = RandomUtils.randomFloat(_slider.minValue, _slider.maxValue);
				setValue(value);
				saveValue();
			}
		}
		
		override protected function setValue(value:*):void
		{
			_slider.value = value;
			var modulo:Number = _slider.snapInterval - int(_slider.snapInterval);
			var rank:int = modulo == 0 ? 0 : modulo < 0.1 ? 2 : 1;
			_counter.text = _slider.value.toFixed(rank);
		}
		
		override public function saveValue():void
		{
			if (_object.hasOwnProperty(_id))
			{
				_object[_id] = _slider.value;
			}
		}
		
		public function get slider():SG_Slider
		{
			return _slider;
		}
	}
}
