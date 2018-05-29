package smart.gui.components 
{
	import flash.display.Sprite;
	
	import smart.gui.data.SG_Size;
	import smart.gui.skin.SG_ComponentSkin;
	import smart.gui.skin.SG_GUISkin;
	
	public class SG_Component extends Sprite implements SG_IEnabledObject
	{
		public var type:String;
		public var debugMode:Boolean;

		protected var _name:String;
		protected var _skin:SG_GUISkin = SG_GUISkin.defaultSkin;
		protected var _enabled:Boolean = true;
		protected var _componentSkin:SG_ComponentSkin;
		protected var _skinType:String;
		protected var _width:int;
		protected var _height:int;
		
		
		public function SG_Component() 
		{
			super();
		}
		
		public function setSkin(skin:SG_GUISkin):void 
		{
			if (skin != null && skin != _skin) 
			{
				_skin = skin;
				redrawSkin();
			}
		}
		
		protected function redrawSkin():void
		{
			var size:SG_Size;
			
			if (_componentSkin) 
			{
				size = new SG_Size(_componentSkin.width, _componentSkin.height);
				if (_componentSkin.parent) _componentSkin.parent.removeChild(_componentSkin);
				_componentSkin = null;
			}
			_componentSkin = _skin.getComponentSkin(_skinType);
			
			if (_componentSkin) 
			{
				if (size) _componentSkin.setSize(size.width, size.height);
				super.addChildAt(_componentSkin, 0);
			}
		}
		
		public function setSize(width:uint, height:uint = 0):void 
		{
			_componentSkin.width = width;
			_componentSkin.height = height;
		}
		
		public function setPosition(posX:int, posY:int):void
		{
			x = posX;
			y = posY;
		}
		
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
		}
		
		public function set skin(value:SG_GUISkin):void
		{
			_skin = value;
		}
		
		public function get enabled():Boolean 
		{
			return _enabled;
		}
		
		public function get skin():SG_GUISkin
		{
			return _skin;
		}
		
		public function get componentSkin():SG_ComponentSkin
		{
			return _componentSkin;
		}
		
		override public function set name(value:String):void
		{
			_name = value;
		}
		
		override public function set width(value:Number):void
		{
			if (_componentSkin) _componentSkin.width = value;
			else                super.width = value;
		}
		
		override public function set height(value:Number):void
		{
			if (_componentSkin) _componentSkin.height = value;
			else                super.height = value;
		}
		
		override public function get name():String
		{
			return _name;
		}
		
		override public function get width():Number
		{
			if (_componentSkin) return _componentSkin.width;
			else                return super.width;
		}
		
		override public function get height():Number
		{
			if (_componentSkin) return _componentSkin.height;
			else                return super.height;
		}
		
		public function set skinType(value:String):void
		{
			_skinType = value;
			redrawSkin();
		}
		
	}
}