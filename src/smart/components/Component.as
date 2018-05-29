package smart.components
{
	import smart.gui.components.layouts.SG_LayoutH;
	import smart.gui.components.text.SG_TextLabel;
	import smart.gui.components.text.SG_TextStyle;
	import smart.gui.constants.SG_Align;
	import smart.gui.constants.SG_TextColors;
	
	public class Component extends SG_LayoutH
	{
		protected var _id:String;
		protected var _object:Object;
		
		public function Component(id:String, name:String, panelsLayout:Layout, customLabelSize:int = -1)
		{
			_id = id;
			super(panelsLayout.spacingX, SG_Align.CENTER);
			
			var label:SG_TextLabel = createLabel(name, SG_Align.RIGHT, customLabelSize > 0 ? customLabelSize : panelsLayout.labelSize);
			addChild(label);
		}
		
		public static function createLabel(text:String, align:String, width:int = 150):SG_TextLabel
		{
			var label:SG_TextLabel = new SG_TextLabel(text, SG_TextStyle.label_medium, align);
			label.color = SG_TextColors.BRIGHT_VERY;
			label.bold = true;
			label.width = width;
			return label;
		}
		
		public function setObject(object:Object):void
		{
			_object = object;
			
			if (_object.hasOwnProperty(_id))
			{
				setValue(_object[_id]);
			}
		}
		
		public function reset():void
		{
			saveValue();
		}
		
		public function random():void
		{
		}
		
		public function saveValue():void
		{
		}
		
		protected function setValue(value:*):void
		{
		}
	}
}
