package smart.gui.components
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import smart.gui.skin.SG_SkinType;
	import smart.gui.skin.SG_ComponentSkin;
	
	public class SG_Switcher extends SG_DynamicComponent
	{
		private var _checked:Boolean;

		private var offBackground:SG_ComponentSkin;
		private var onBackground:SG_ComponentSkin;
		private var picker:SG_ComponentSkin;
		private var pickerContainer:Sprite;
		private var textOff:SG_ComponentSkin;
		private var textOn:SG_ComponentSkin;
		
		private var text:Sprite;
		private var textMask:Sprite;
		private var activeMask:Sprite;
		private var components:Array;
		private var _animation:Boolean;
		
		private static const TEXT_SPEED:Number = 5.2;
		private static const MASK_SPEED:Number = 0.2;
		private static const CIRCLE_SPEED:Number = 5;
		
		private static const TEXT_OFF_POS:int = -20;
		private static const TEXT_ON_POS:int = 11;
		private static const CIRCLE_OFF_POS:int = 10;
		private static const CIRCLE_ON_POS:int = 40;

		
		public function SG_Switcher(checked:Boolean = false)
		{
			init();
			this.checked = checked;
			type = SWITCHER;
		}
		
		private function init():void
		{
			text = new Sprite();
			text.x = TEXT_OFF_POS;
			text.y = 5;

			activeMask = new Sprite();
			pickerContainer = new Sprite();
			textMask = new Sprite();
			text.mask = textMask;
			
			redrawSkin();
			pickerContainer.x = offBackground.height/2;
			pickerContainer.y = offBackground.height/2;
			
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		override protected function redrawSkin():void
		{
			if (components)
			{
				for each (var component:SG_ComponentSkin in components)
				{
					if (component.parent) component.parent.removeChild(component);
				}
			}
			offBackground = _skin.getComponentSkin(SG_SkinType.SWITCHER);
			addChild(offBackground);

			onBackground = _skin.getComponentSkin(SG_SkinType.SWITCHER);
			onBackground.currentState = 1;
			addChild(onBackground);

			textOn = _skin.getComponentSkin(SG_SkinType.WORD_ON);
			textOff = _skin.getComponentSkin(SG_SkinType.WORD_OFF);
			textOff.x = 44;
			
			if (_checked) text.addChild(textOn);
			else          text.addChild(textOff);

			picker = _skin.getComponentSkin(SG_SkinType.PICKER);
			pickerContainer.addChild(picker);

			components = [offBackground, onBackground, textOn, textOff, picker];
			redrawActiveMask();
			redrawTextMask();

			addChild(activeMask);
			addChild(text);
			addChild(textMask);
			addChild(pickerContainer);

			picker.currentState = (_checked) ? 1 : 0;
			activeMask.scaleX = (_checked) ? 1 : 0;
		}
		
		private function redrawTextMask():void
		{
			var width:int = onBackground.width-2;
			var height:int = onBackground.height-2;
			
			var canvas:Graphics = textMask.graphics;
			canvas.clear();
			canvas.beginFill(0);
			canvas.drawRoundRect(1, 1, width, height, height, height);
			canvas.endFill();
		}
		
		private function redrawActiveMask():void
		{
			var canvas:Graphics = activeMask.graphics;
			canvas.clear();
			canvas.beginFill(0);
			canvas.drawRect(0, 0, offBackground.width, offBackground.height);
			canvas.endFill();
			
			activeMask.scaleX = 0;
			onBackground.mask = activeMask;
		}
		
		private function mouseDown(event:MouseEvent = null):void
		{
			checked = !_checked;
			dispatchValue(_checked);
			
			if (event)
			{
				event.stopImmediatePropagation();
				event.stopPropagation();
			}
		}
		
		private function onEnterFrame(event:Event):void
		{
			if (_animation)
			{
				if (_checked)
				{
					if (pickerContainer.x < CIRCLE_ON_POS)
					{
						text.x += TEXT_SPEED;
						activeMask.scaleX += MASK_SPEED;
						pickerContainer.x += CIRCLE_SPEED;
					}
					else
					{
						stopMotion();
					}
				}
				else
				{
					if (pickerContainer.x > CIRCLE_OFF_POS)
					{
						text.x -= TEXT_SPEED;
						activeMask.scaleX -= MASK_SPEED;
						pickerContainer.x -= CIRCLE_SPEED;
					}
					else
					{
						stopMotion();
					}
				}
			}
		}
		
		public function set checked(value:Boolean):void
		{
			if (!text.contains(textOn))	 text.addChild(textOn);
			if (!text.contains(textOff)) text.addChild(textOff);
			_checked = value;

			picker.currentState = (_checked) ? 1 : 0;

			if (stage)
			{
				_animation = true;
			}
			else
			{
				stopMotion();
				
				if (_checked)
				{
					activeMask.scaleX = 1;
					text.x = TEXT_ON_POS;
					pickerContainer.x = CIRCLE_ON_POS;
				}
				else
				{
					activeMask.scaleX = 0;
					text.x = TEXT_OFF_POS;
					pickerContainer.x = CIRCLE_OFF_POS;
				}
			}
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function stopMotion():void
		{
			if (_checked)
			{
				if (text.contains(textOff))	text.removeChild(textOff);
			}
			else
			{
				if (text.contains(textOn))	 text.removeChild(textOn);
			}
			text.x = int(text.x);
			_animation = false;
		}
		
		public function get checked():Boolean
		{
			return _checked;
		}
		
		override public function set enabled(value:Boolean):void
		{
			_enabled = value;
			mouseEnabled = value;
			mouseChildren = value;

			if (_enabled)
			{
				text.alpha = 1;
				picker.alpha = 1;
			}
			else
			{
				text.alpha = 0.5;
				picker.alpha = 0.5;
			}
		}
		
		override public function set width(value:Number):void
		{
			_width = value;
		}
		
		override public function set height(value:Number):void
		{
			_height = value;
		}
		
		override public function getRect(targetCoordinateSpace:DisplayObject):Rectangle
		{
			return offBackground.getRect(targetCoordinateSpace);
		}
		
	}
}