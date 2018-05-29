package smart.components
{
	import smart.gui.components.combobox.SG_ComboBox;
	import smart.gui.components.controllers.SG_Slider;
	import smart.gui.signals.SG_Signal;
	
	internal class ComboBox extends Component
	{
		private var _comboBox:SG_ComboBox;
		
		public function ComboBox(id:String, name:String, items:Vector.<String>, panelsLayout:Layout)
		{
			super(id, name, panelsLayout);
			
			_comboBox = new SG_ComboBox("Select Item", items);
			_comboBox.width = panelsLayout.componentSize + panelsLayout.counterSize + panelsLayout.spacingX;
			_comboBox.selectedIndex = 0;
			_comboBox.dropdownCount = 30;
			_comboBox.onUpdate.add(saveValue);
			addChild(_comboBox);
		}
		
		override public function reset():void
		{
			_comboBox.selectedIndex = 0;
			super.reset();
		}
		
		override protected function setValue(value:*):void
		{
			_comboBox.selectItemByName(value);
		}
		
		override public function saveValue():void
		{
			if (_object.hasOwnProperty(_id))
			{
				_object[_id] = _comboBox.value;
			}
		}
		
		public function get comboBox():SG_ComboBox
		{
			return _comboBox;
		}
	}
}
