package smart.gui.components.list 
{
	import flash.display.Stage;
	import flash.events.*;
	import flash.text.*;
	import flash.ui.*;
	import smart.gui.components.*;
	import smart.gui.constants.*;
	import smart.gui.components.text.*;
	
	internal class SG_ListLabel extends SG_TextLabel
	{
		public var isRenaming:Boolean;
		private var stageLink:Stage;
		
		
		public function SG_ListLabel(text:String, style:SG_TextStyle) 
		{
			super(text, style);
			textField.maxChars = 100;
		}
		
		public function rename(selectAll:Boolean):void
		{
			isRenaming = true;
			textField.text = _text;
			
			var index:int = textField.length;
			
			textField.type = TextFieldType.INPUT;
			textField.mouseEnabled = true;
			textField.background = true;
			textField.alwaysShowSelection = true;
			textField.selectable = true;
			textField.multiline = false;
			textField.alpha = 1;
			
			if (selectAll)	textField.setSelection(0,index);
			else			textField.setSelection(index,index);
			
			stage.focus = textField;
			addEventListener(FocusEvent.FOCUS_OUT, stopRenaming);
			stageLink = stage;
			stageLink.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			
			mouseChildren = true;
			mouseEnabled = true;
			
			var listEvent:SG_ListEvent = new SG_ListEvent(SG_ListEvent.START_RENAMING);
			dispatchEvent(listEvent);
		}
		
		private function keyDown(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				case Keyboard.ESCAPE:
				case Keyboard.ENTER:
				{
					event.stopImmediatePropagation();
					stopRenaming();
					break;
				}
			}
		}
		
		private function stopRenaming(event:Event = null):void
		{
			isRenaming = false;
			textField.type = TextFieldType.DYNAMIC;
			textField.alwaysShowSelection = false;
			textField.selectable = false;
			textField.mouseEnabled = false;
			textField.background = false;
			textField.setSelection(0,0);
			
			removeEventListener(FocusEvent.FOCUS_OUT, stopRenaming);
			stageLink.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			stageLink = null;
			
			mouseChildren = false;
			mouseEnabled = false;
			
			_text = textField.text;
			width = _width;
			
			var listEvent:SG_ListEvent = new SG_ListEvent(SG_ListEvent.STOP_RENAMING);
			dispatchEvent(listEvent);
		}
		
	}

}