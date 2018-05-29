package smart.gui.components.switchers
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;

	import smart.tweener.SP_Easing;
	import smart.tweener.SP_Tweener;
	import smart.gui.components.SG_ComponentType;
	import smart.gui.components.SG_DynamicComponent;
	import smart.gui.components.SG_ValueEvent;
	import smart.gui.constants.SG_SkinType;
	import smart.gui.constants.SG_ValueType;
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

		private static const TEXT_OFF_POS:int = -20;
		private static const TEXT_ON_POS:int = 11;
		private static const CIRCLE_OFF_POS:int = 10;
		private static const CIRCLE_ON_POS:int = 40;
		private static const SWITCH_TIME:int = 5;

		
		public function SG_Switcher(checked:Boolean = false)
		{
			init();
			this.checked = checked;
			type = SG_ComponentType.SWITCHER;
			valueType = SG_ValueType.BOOLEAN;
		}
		
		override public function clone():SG_DynamicComponent
		{
			return new SG_Switcher(_checked);
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
			addEventListener(MouseEvent.MOUSE_WHEEL, scrool);
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
		
		protected function scrool(event:MouseEvent):void
		{
			if (event.delta < 0 && _checked)	mouseDown();
			if (event.delta > 0 && !_checked)	mouseDown();
			
			event.stopPropagation();
			event.stopImmediatePropagation();
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
		
		public function set checked(value:Boolean):void
		{
			if (!text.contains(textOn))	 text.addChild(textOn);
			if (!text.contains(textOff)) text.addChild(textOff);
			_checked = value;

			picker.currentState = (_checked) ? 1 : 0;

			if (stage)
			{
				if (_checked)
				{
					SP_Tweener.addTween(text, {x:TEXT_ON_POS}, {time:SWITCH_TIME, ease:SP_Easing.quadOut});
					SP_Tweener.addTween(activeMask, {scaleX:1}, {time:SWITCH_TIME, ease:SP_Easing.quadOut});
					SP_Tweener.addTween(pickerContainer, {x:CIRCLE_ON_POS}, {time:SWITCH_TIME, ease:SP_Easing.quadOut});
				}
				else
				{
					SP_Tweener.addTween(text, {x:TEXT_OFF_POS}, {time:SWITCH_TIME, ease:SP_Easing.quadOut});
					SP_Tweener.addTween(activeMask, {scaleX:0}, {time:SWITCH_TIME, ease:SP_Easing.quadOut});
					SP_Tweener.addTween(pickerContainer, {x:CIRCLE_OFF_POS}, {time:SWITCH_TIME, ease:SP_Easing.quadOut});
				}
				SP_Tweener.addTween(this, {}, {time:SWITCH_TIME, onComplete:stopMotion});
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