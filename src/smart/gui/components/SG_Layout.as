package smart.gui.components
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class SG_Layout extends Sprite
	{
		public var autoUpdate:Boolean = true;
		public var enableAlign:Boolean = true;
		public var useRectAlign:Boolean = true;
		
		protected var _reverse:Boolean;
		protected var content:Sprite;
		protected var _paddingV:uint = 0;
		protected var _paddingH:uint = 0;
		protected var _spacing:int = 10;
		protected var _align:String;
		
		public function SG_Layout(spacing:int, align:String)
		{
			_align = align;
			_spacing = spacing;
			content = new Sprite();
			super.addChild(content);
			
			addEventListener(Event.ADDED_TO_STAGE, update);
		}
		
		public function setPosition(x:int = 0, y:int = 0):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function setSize(width:int, height:int):void
		{
			this.width = width;
			this.height = height;
		}
		
		public function update(event:Event = null):void 
		{
			content.x += _paddingH;
			content.y += _paddingV;
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			content.addChild(child);
			update();
			return child;
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			content.addChildAt(child, index);
			return child; 
		}
		
		override public function getChildAt(index:int):DisplayObject
		{
			var length:int = content.numChildren - 1;

			if (index < 0)      index = length;
			if (index > length) index = 0;
			
			return content.getChildAt(index);
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			if (content.contains(child))
			{
				content.removeChild(child);
				update();
			}
			return child;
		}
		
		override public function removeChildAt(index:int):DisplayObject
		{
			return content.removeChildAt(index);
		}
		
		public function getObjects():Array
		{
			var objects:Array = [];
			
			for (var i:int=0; i<content.numChildren; i++)
			{
				var object:DisplayObject = content.getChildAt(i);
				if (object.visible) objects.push(object);
			}
			
			if (_reverse)	return objects.reverse();
			else			return objects;
		}
		
		// *** PROPERTIES *** //
		
		public function set spacing(value:int):void 
		{
			_spacing = value;
			update();
		}
		
		public function set align(value:String):void 
		{
			_align = value;
			update();
		}
		
		public function set paddingV(value:uint):void
		{
			_paddingV = value;
			update();
		}
		
		public function set paddingH(value:uint):void 
		{
			_paddingH = value;
			update();
		}
		
		public function set reverse(value:Boolean):void 
		{
			_reverse = value;
			update();
		}
		
		public function get spacing():int 
		{
			return _spacing;
		}
		
		public function get align():String 
		{
			return _align;
		}
		
		public function get paddingV():uint 
		{
			return _paddingV;
		}
		
		public function get paddingH():uint 
		{
			return _paddingH;
		}
		
		public function get reverse():Boolean 
		{
			return _reverse;
		}
		
		public function get length():uint 
		{
			return content.numChildren;
		}
		
		public function get objectsArray():Array
		{
			var array:Array = [];
			
			for (var i:int=0; i<content.numChildren; i++)
			{
				var object:DisplayObject = content.getChildAt(i);
				if (object.visible) array.push(object);
			}
			return array;
		}
		
	}
}