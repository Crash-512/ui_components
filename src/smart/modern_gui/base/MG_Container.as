package smart.modern_gui.base
{
	import smart.modern_gui.mg_internal;
	
	use namespace mg_internal;

	public class MG_Container extends MG_ResizableComponent
	{
		  
		public function MG_Container()
		{
			super();
		}
		
		public function updateChildren():void 
		{
			// overriden in subclass
		}
		
		public function add(child:MG_Component, redraw:Boolean = true):void
		{
			if (!child)	return;
			if (child.parent) child.removeFromParent(); 
					
			addChild(child);
			
			if (_lastChild)
			{
				_lastChild.next = child;
				child.prev = _lastChild;
			}
			if (!_firstChild) 
			{
				_firstChild = child;
			}
			_lastChild = child;
			
			child.container = this;
			_hasChildren = true;
			
			if (redraw)
			{
				updateChildren();
				resizeParentChildren();
			}
		}
		
		public function remove(child:MG_Component):void 
		{
			if (!child)	return;
			
			if (child == _firstChild && _lastChild)	_firstChild = _lastChild.next;
			if (child == _lastChild && _lastChild)	_lastChild = _lastChild.prev;
			
			if (child.prev)	child.prev.next = child.next;
			if (child.next)	child.next.prev = child.prev;

			child.next = null;
			child.prev = null;
			child.container = null;
			
			if (_display.contains(child.display))
			{
				_display.removeChild(child.display);
			}
			_hasChildren = _firstChild != null;
			
			if (_hasChildren) updateChildren();
			resizeParentChildren();
		}
		
		public function removeAll():void
		{
			var child:MG_Component;
			
			while (_lastChild)
			{
				child = _lastChild;
				_lastChild = _lastChild.prev;
				
				child.next = null;
				child.prev = null;
				child.container = null;
				
				if (_display.contains(child.display))
				{
					_display.removeChild(child.display);
				}
			}
			_firstChild = null;
			_lastChild = null;
			_hasChildren = false;
		}
		
		override public function redraw():void
		{
			super.redraw();
			
			if (_hasChildren) updateChildren();
			
			resizeParentChildren();
		}
		
	}
}
