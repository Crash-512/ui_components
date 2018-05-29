package smart.components
{
	import smart.gui.components.SG_Switcher;
	
	internal class Switcher extends Component
	{
		private var _switcher:SG_Switcher;
		private var _defaultValue:Boolean;
		
		public function Switcher(id:String, name:String, value:Boolean, panelsLayout:Layout)
		{
			super(id, name, panelsLayout);
			_defaultValue = value;
			_switcher = new SG_Switcher(value);
			_switcher.onUpdate.add(saveValue);
			addChild(_switcher);
		}
		
		override public function reset():void
		{
			_switcher.checked = _defaultValue;
			super.reset();
		}
		
		override protected function setValue(value:*):void
		{
			_switcher.checked = value;
		}
		
		override public function saveValue():void
		{
			if (_object.hasOwnProperty(_id))
			{
				_object[_id] = _switcher.checked;
			}
		}
		
		public function get switcher():SG_Switcher
		{
			return _switcher;
		}
	}
}
