package smart.components
{
	import smart.gui.components.layouts.SG_LayoutV;
	
	internal class Layout extends SG_LayoutV
	{
		public var labelSize:int;
		public var componentSize:int;
		public var counterSize:int;
		public var paddingX:int = 15;
		public var spacingX:int = 8;
		
		  
		public function Layout(labelSize:int = 100, componentSize:int = 110, counterSize:int = 35)
		{
			this.labelSize = labelSize;
			this.componentSize = componentSize;
			this.counterSize = counterSize;
			
			super(0);
		}
		
		public function get panelSize():int 
		{
			return labelSize + componentSize + counterSize + paddingX * 2 + spacingX * 2;
		}
		
	}
}
