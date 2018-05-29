package smart.gui.components
{
	import flash.display.Graphics;
	
	internal class SG_ListStyle 
	{
		private var list:SG_List;
		private var _upCorners:Boolean = true;
		private var _downCorners:Boolean = true;
		
		public function SG_ListStyle(list:SG_List)
		{
			this.list = list;
			redrawList();
		}
		
		internal function redrawList():void
		{
			var graphics:Graphics = list.listMask.graphics;
			var upSize:Number = (_upCorners) ? 6 : 0;
			var downSize:Number = (_downCorners) ? 6 : 0;

			graphics.clear();
			graphics.beginFill(0x000000);
			graphics.drawRoundRectComplex(1, 1, list.width - 2, list.height - 2, upSize, upSize, downSize, downSize);
			graphics.endFill();
			
			if (_upCorners && _downCorners) list.componentSkin.currentState = 0;
			else if (_upCorners)            list.componentSkin.currentState = 1;
			else if (_downCorners)          list.componentSkin.currentState = 2;
			else                            list.componentSkin.currentState = 3;
		}
		
		public function get itemColor():uint 
		{
			return 0x333333;
		}
		
		public function get highlightColor():uint
		{
			return list.skin.secondActiveColor;
		}
		
		public function set upCorners(value:Boolean):void
		{
			_upCorners = value;
			redrawList();
		}
		
		public function get upCorners():Boolean
		{
			return _upCorners;
		}
	}

}