package smart.gui.data
{
	import flash.events.EventDispatcher;
	[Event(name="preDataChange", type="smart.gui.data.SG_DataChangeEvent")]
	[Event(name="dataChange", type="smart.gui.data.SG_DataChangeEvent")]
	
	 public class SP_DataProvider extends EventDispatcher
	 {
		 protected var data:Array;
		
		 public function SP_DataProvider(value:Object = null)
		 {
			 if (value == null)
			 {
				 data = [];
			 }
			 else
			 {
				 data = getDataFromObject(value);
			 }
		 }
		 
		 public function get length():uint
		 {
			 return data.length;
		 }
		 
		 public function invalidateItemAt(index:int):void
		 {
			 checkIndex(index, data.length - 1);
			 dispatchChangeEvent(SG_DataChangeType.INVALIDATE, [data[index]], index, index);
		 }
		 
		 public function invalidateItem(item:Object):void
		 {
			 var index:uint = getItemIndex(item);
			 if (index == -1)
			 {
				 return;
			 }
			 invalidateItemAt(index);
		 }
		 
		 public function invalidate():void
		 {
			 dispatchEvent(new SG_DataChangeEvent(SG_DataChangeEvent.DATA_CHANGE, SG_DataChangeType.INVALIDATE_ALL, data.concat(), 0, data.length));
		 }
		 
		 public function addItemAt(item:Object, index:uint):void
		 {
			 checkIndex(index, data.length);
			 dispatchPreChangeEvent(SG_DataChangeType.ADD, [item], index, index);
			 data.splice(index, 0, item);
			 dispatchChangeEvent(SG_DataChangeType.ADD, [item], index, index);
		 }
		 
		 public function addItem(item:Object):void
		 {
			 dispatchPreChangeEvent(SG_DataChangeType.ADD, [item], data.length - 1, data.length - 1);
			 data.push(item);
			 dispatchChangeEvent(SG_DataChangeType.ADD, [item], data.length - 1, data.length - 1);
		 }
		 
		 public function addItemsAt(items:Object, index:uint):void
		 {
			 checkIndex(index, data.length);
			 var arr:Array = getDataFromObject(items);
			 dispatchPreChangeEvent(SG_DataChangeType.ADD, arr, index, index + arr.length - 1);
			 data.splice.apply(data, [index, 0].concat(arr));
			 dispatchChangeEvent(SG_DataChangeType.ADD, arr, index, index + arr.length - 1);
		 }
		 
		 public function addItems(items:Object):void
		 {
			 addItemsAt(items, data.length);
		 }
		 
		 public function concat(items:Object):void
		 {
			 addItems(items);
		 }
		 
		 public function merge(newData:Object):void
		 {
			 var arr:Array = getDataFromObject(newData);
			 var l:uint = arr.length;
			 var startLength:uint = data.length;
			 
			 dispatchPreChangeEvent(SG_DataChangeType.ADD, data.slice(startLength, data.length), startLength, this.data.length - 1);
			 
			 for (var i:uint = 0; i < l; i++)
			 {
				 var item:Object = arr[i];
				 if (getItemIndex(item) == -1)
				 {
					 data.push(item);
				 }
			 }
			 if (data.length > startLength)
			 {
				 dispatchChangeEvent(SG_DataChangeType.ADD, data.slice(startLength, data.length), startLength, this.data.length - 1);
			 }
			 else
			 {
				 dispatchChangeEvent(SG_DataChangeType.ADD, [], -1, -1);
			 }
		 }
		 
		 public function getItemAt(index:uint):Object
		 {
			 checkIndex(index, data.length - 1);
			 return data[index];
		 }
		 
		 public function getItemIndex(item:Object):int
		 {
			 return data.indexOf(item);
		 }
		 
		 public function removeItemAt(index:uint):Object
		 {
			 checkIndex(index, data.length - 1);
			 dispatchPreChangeEvent(SG_DataChangeType.REMOVE, data.slice(index, index + 1), index, index);
			 var arr:Array = data.splice(index, 1);
			 dispatchChangeEvent(SG_DataChangeType.REMOVE, arr, index, index);
			 return arr[0];
		 }
		 
		 public function removeItem(item:Object):Object
		 {
			 var index:int = getItemIndex(item);
			 if (index != -1)
			 {
				 return removeItemAt(index);
			 }
			 return null;
		 }
		 
		 public function removeAll():void
		 {
			 var arr:Array = data.concat();
			 
			 dispatchPreChangeEvent(SG_DataChangeType.REMOVE_ALL, arr, 0, arr.length);
			 data = [];
			 dispatchChangeEvent(SG_DataChangeType.REMOVE_ALL, arr, 0, arr.length);
		 }
		 
		 public function replaceItem(newItem:Object, oldItem:Object):Object
		 {
			 var index:int = getItemIndex(oldItem);
			 if (index != -1)
			 {
				 return replaceItemAt(newItem, index);
			 }
			 return null;
		 }
		 
		 public function replaceItemAt(newItem:Object, index:uint):Object
		 {
			 checkIndex(index, data.length - 1);
			 var arr:Array = [data[index]];
			 dispatchPreChangeEvent(SG_DataChangeType.REPLACE, arr, index, index);
			 data[index] = newItem;
			 dispatchChangeEvent(SG_DataChangeType.REPLACE, arr, index, index);
			 return arr[0];
		 }
		 
		 public function sort(...sortArgs:Array):*
		 {
			 dispatchPreChangeEvent(SG_DataChangeType.SORT, data.concat(), 0, data.length - 1);
			 var returnValue:Array = data.sort.apply(data, sortArgs);
			 dispatchChangeEvent(SG_DataChangeType.SORT, data.concat(), 0, data.length - 1);
			 return returnValue;
		 }
		 
		 public function sortOn(fieldName:Object, options:Object = null):*
		 {
			 dispatchPreChangeEvent(SG_DataChangeType.SORT, data.concat(), 0, data.length - 1);
			 var returnValue:Array = data.sortOn(fieldName, options);
			 dispatchChangeEvent(SG_DataChangeType.SORT, data.concat(), 0, data.length - 1);
			 return returnValue;
		 }
		 
		 public function clone():SP_DataProvider
		 {
			 return new SP_DataProvider(data);
		 }
		 
		 public function toArray():Array
		 {
			 return data.concat();
		 }
		 
		 override public function toString():String
		 {
			 return "DataProvider [" + data.join(" , ") + "]";
		 }
		 
		 protected function getDataFromObject(obj:Object):Array
		 {
			 var retArr:Array;
			 if (obj is Array)
			 {
				 var arr:Array = obj as Array;
				 if (arr.length > 0)
				 {
					 if (arr[0] is String || arr[0] is Number)
					 {
						 retArr = [];
						 
						 for (var i:uint = 0; i < arr.length; i++)
						 {
							 var o:Object = {label: String(arr[i]), data: arr[i]};
							 retArr.push(o);
						 }
						 return retArr;
					 }
				 }
				 return obj.concat();
			 }
			 else if (obj is SP_DataProvider)
			 {
				 return obj.toArray();
			 }
			 else if (obj is XML)
			 {
				 var xml:XML = obj as XML;
				 retArr = [];
				 var nodes:XMLList = xml.*;
				 
				 for each (var node:XML in nodes)
				 {
					 var _obj:Object = {};
					 var attrs:XMLList = node.attributes();
					 
					 for each (var attr:XML in attrs)
					 {
						 _obj[attr.localName()] = attr.toString();
					 }
					 var propNodes:XMLList = node.*;
					 
					 for each (var propNode:XML in propNodes)
					 {
						 if (propNode.hasSimpleContent())
						 {
							 _obj[propNode.localName()] = propNode.toString();
						 }
					 }
					 retArr.push(_obj);
				 }
				 return retArr;
			 }
			 else
			 {
				 throw new TypeError("Error: Type Coercion failed: cannot convert " + obj + " to Array or DataProvider.");
			 }
		 }
		 
		 protected function checkIndex(index:int, maximum:int):void
		 {
			 if (index > maximum || index < 0)
			 {
				 throw new RangeError("DataProvider index (" + index + ") is not in acceptable range (0 - " + maximum + ")");
			 }
		 }
		 
		 protected function dispatchChangeEvent(evtType:String, items:Array, startIndex:int, endIndex:int):void
		 {
			 dispatchEvent(new SG_DataChangeEvent(SG_DataChangeEvent.DATA_CHANGE, evtType, items, startIndex, endIndex));
		 }
		 
		 protected function dispatchPreChangeEvent(evtType:String, items:Array, startIndex:int, endIndex:int):void
		 {
			 dispatchEvent(new SG_DataChangeEvent(SG_DataChangeEvent.PRE_DATA_CHANGE, evtType, items, startIndex, endIndex));
		 }
		
	 }
}