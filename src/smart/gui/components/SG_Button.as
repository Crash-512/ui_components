package smart.gui.components
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import smart.gui.skin.SG_SkinType;
	import smart.gui.signals.SG_Signal;
	import smart.gui.skin.SG_GUISkin;
	
	public class SG_Button extends SG_Component
	{
		public var label:SG_TextLabel;

		protected var _labelPosition:Point;
		protected var _text:String;
		protected var _buttonType:int;
		protected var _icon:Sprite;
		protected var _labelFilters:Array;
		protected var _onMouseDown:SG_Signal;
		protected var iconPosition:Point = new Point();
		protected var keyFrame:uint;
		protected var isOver:Boolean;

		protected var centered:Boolean;

		private static const DEFAULT_WIDTH:int = 100;
		private static const ACTIVE:ColorTransform = new ColorTransform(1,1,1,1,-20,0,20);
		private static const NORMAL:ColorTransform = new ColorTransform();
		
		public static const LEFT:int = 1;
		public static const RIGHT:int = 2;
		public static const CENTER:int = 3;
		public function SG_Button(text:String, icon:Sprite = null, buttonType:int = 0)
		{
			_text = text;
			_buttonType = buttonType;
			_skinType = SG_SkinType.BUTTON;
			_icon = icon;
			_onMouseDown = new SG_Signal();
			
			init();

			type = BUTTON;
		}
		
		private function init():void
		{
			redrawSkin();

			if (_icon) createIcon();
			if (_text) createLabel();
			
			if (_text == null || _text == "") iconToCenter();

			doubleClickEnabled = true;
			mouseChildren = false;
			enableEvents(true);
			
			width = DEFAULT_WIDTH;
		}
		
		override public function setSkin(skin:SG_GUISkin):void
		{
			super.setSkin(skin);
			if (_icon is SG_Icon) (_icon as SG_Icon).setSkin(_skin);
		}
		
		override protected function redrawSkin():void
		{
			super.redrawSkin();

			keyFrame = _buttonType;
			_componentSkin.currentState = keyFrame;

			var shadow:DropShadowFilter = new DropShadowFilter(1, 90, _skin.textShadowColor, 1, 1, 1);
			_labelFilters = [shadow];
			
			if (label)
			{
				label.color = _skin.buttonTextColor;
				label.filters = _labelFilters;
			}
			if (_icon) _icon.filters = _labelFilters;
		}
		
		protected function createLabel():void
		{
			label = new SG_TextLabel(_text, SG_TextStyle.button);
			label.color = _skin.buttonTextColor;
			label.filters = _labelFilters;
			addChild(label);
			updateLabelPosition();
		}
		
		private function createIcon():void
		{
			if (_icon)
			{
				addChild(_icon);

				var rect:Rectangle = _icon.getRect(_icon);

				_icon.x = Math.round(18 + (-rect.x - rect.width/2));
				_icon.y = Math.round(15 + (-rect.y - rect.height/2));
				_icon.mouseChildren = false;
				_icon.mouseEnabled = false;
				_icon.filters = _labelFilters;

				iconPosition.x = _icon.x;
				iconPosition.y = _icon.y;
				if (centered) iconToCenter();
			}
		}
		
		public function iconToCenter():void
		{
			var rect:Rectangle = _icon.getRect(_icon);

			_icon.x = Math.round(_componentSkin.width/2 + (-rect.x - rect.width/2));
			_icon.y = Math.round(_componentSkin.height/2 + (-rect.y - rect.height/2)) - 2;

			iconPosition.x = _icon.x;
			iconPosition.y = _icon.y;
			centered = true;
		}
		
		public function updateLabelPosition():void
		{
			if (label)
			{
				if (_labelPosition)
				{
					label.x = _labelPosition.x;
					label.y = _labelPosition.y;
				}
				else
				{
					var iconSize:int = (_icon) ? _icon.width / 2 : 0;
					label.x = Math.round((width - label.width)/2 + iconSize/2);
					label.y = Math.round((height - label.height)/2  - 1);
				}
				width
			}
		}
		
		public function enableEvents(enable:Boolean):void
		{
			if (enable)
			{
				if (!hasEventListener(MouseEvent.MOUSE_DOWN))
				{
					addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
					addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
					addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
					addEventListener(Event.MOUSE_LEAVE, mouseOut);
				}
			}
			else
			{
				if (hasEventListener(MouseEvent.MOUSE_DOWN))
				{
					removeEventListener(MouseEvent.MOUSE_OVER, mouseOver);
					removeEventListener(MouseEvent.MOUSE_OUT, mouseOut);
					removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
					removeEventListener(Event.MOUSE_LEAVE, mouseOut);
				}
			}
		}
		
		public function mouseUp(event:Event = null):void
		{
			if (label) label.y -= 1;
			if (_icon) _icon.y = iconPosition.y;
			_componentSkin.currentState = keyFrame;

			if (stage)
			{
				stage.removeEventListener(Event.MOUSE_LEAVE, mouseUp);
				stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			}
		}
		
		public function mouseDown(event:MouseEvent = null):void
		{
			if (label) label.y += 1;
			if (_icon) _icon.y = iconPosition.y + 1;
			_componentSkin.currentState = keyFrame + 4;
			stage.addEventListener(Event.MOUSE_LEAVE, mouseUp);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			_onMouseDown.emit(this);
			
			if (event)
			{
				event.stopImmediatePropagation();
				event.stopPropagation();
			}
		}
		
		public function mouseOut(event:MouseEvent = null):void
		{
			if (isOver) 
			{
				_componentSkin.transform.colorTransform = NORMAL;
				isOver = false;
			}
		}
		
		public function mouseOver(event:MouseEvent = null):void
		{
			if (!isOver)
			{
				_componentSkin.transform.colorTransform = ACTIVE;
				isOver = true;
			}
		}
		
		override public function setSize(width:uint, height:uint = 0):void
		{
			_componentSkin.width = width;
			if (height != 0) _componentSkin.height = height;
			updateLabelPosition();
			if (centered) iconToCenter();
		}
		

		// *** PROPERTIES *** //

		
		override public function set width(value:Number):void
		{
			_width = value;
			_componentSkin.width = value;
			updateLabelPosition();
			if (centered) iconToCenter();
		}
		
		override public function set height(value:Number):void
		{
			_height = value;
			_componentSkin.height = value;
			updateLabelPosition();
			if (centered) iconToCenter();
		}
		
		public function set labelPosition(value:Point):void 
		{
			_labelPosition = value;
			updateLabelPosition();
		}
		
		public function get labelPosition():Point
		{
			if (_labelPosition) return _labelPosition;
			else                return new Point(label.x, label.y);
		}
		
		override public function set enabled(value:Boolean):void
		{
			_enabled = value;
			mouseEnabled = _enabled;
			mouseChildren = _enabled;

			if (_enabled)
			{
				if (label) label.alpha = 1;
				if (_icon) _icon.alpha = 1;
				filters = [];
			}
			else
			{
				if (label) label.alpha = 0.4;
				if (_icon) _icon.alpha = 0.4;
			}
		}
		
		public function set labelFilters(value:Array):void
		{
			_labelFilters = value;

			label.filters = _labelFilters;
			if (_icon) _icon.filters = _labelFilters;
		}
		
		public function set icon(value:Sprite):void
		{
			if (_icon) removeChild(_icon);

			_icon = value;
			createIcon();
		}
		
		public function set text(value:String):void
		{
			_text = value;
			if (!label) createLabel();
		}
		
		public function get labelFilters():Array
		{
			return _labelFilters;
		}
		
		public function get icon():Sprite
		{
			return _icon;
		}
		
		public function get text():String
		{
			return _text;
		}
		
		public function get onMouseDown():SG_Signal
		{
			return _onMouseDown;
		}
		
	}

}