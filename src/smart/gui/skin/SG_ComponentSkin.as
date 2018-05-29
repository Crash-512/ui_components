package smart.gui.skin
{
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import smart.gui.constants.SG_SkinType;
	
	public class SG_ComponentSkin extends Sprite
	{
		private var frames:Vector.<SG_ComponentTexture>;
		private var grids:Vector.<SG_ComponentGrid>;
		private var scale9GridMode:Boolean;
		private var canvas:Sprite;
		private var _name:String;
		private var _color:SG_SkinColor;
		private var _skin:SG_GUISkin;
		private var _smoothing:Boolean;
		private var _currentState:uint;
		private var _width:uint;
		private var _height:uint;
		
		  
		public function SG_ComponentSkin(frames:Vector.<SG_ComponentTexture>, color:SG_SkinColor, name:String, skin:SG_GUISkin)
		{
			this.frames = frames;
			_skin = skin;
			_color = color;
			_name = name;
			init();
		}
		
		private function init():void
		{
			_currentState = 0;
			canvas = new Sprite();
			addChild(canvas);
			redraw();
		}
		
		public function clone():SG_ComponentSkin 
		{
			var clone:SG_ComponentSkin = new SG_ComponentSkin(frames, color, _name, _skin);
			clone.scale9GridMode = scale9GridMode;
			clone.grids = grids;
			clone._width = _width;
			clone._height = _height;
			return clone;
		}
		
		public function setScale9Grid(width:uint, height:uint):void 
		{
			grids = new Vector.<SG_ComponentGrid>();
			
			for each (var frame:SG_ComponentTexture in frames)
			{
				var grid:SG_ComponentGrid = new SG_ComponentGrid(frame, width, height);
				grids.push(grid);
			}
			scale9GridMode = true;
			redraw();
		}
		
		public function setGridForFrame(index:uint, width:uint, height:uint):void
		{
			if (grids == null) grids = new Vector.<SG_ComponentGrid>(frames.length, true);

			var frame:SG_ComponentTexture = frames[index];
			var grid:SG_ComponentGrid = new SG_ComponentGrid(frame, width, height);
			
			grids[index] = grid;
			scale9GridMode = true;
		}
		
		public function redraw():void 
		{
			canvas.graphics.clear();
			canvas.x = 0;
			canvas.y = 0;
			
			if (scale9GridMode)
			{
				switch (_name)
				{
					default:
					{
						redrawScale9Grid();
						break;
					}
					case SG_SkinType.BUTTON:
					{
						SG_SkinDrawer.drawButton(_color, _currentState % 4, _currentState >= 4, canvas);
						redrawScale9Grid_Alt();
						break;
					}
					case SG_SkinType.SLIDER:
					{
						SG_SkinDrawer.drawBar(_currentState > 0 ? _skin.activeColorSaturated : _color, SG_GUISkin.SLIDER_SIZE, canvas);
						redrawScale9Grid_Alt();
						break;
					}
					case SG_SkinType.TEXT_INPUT:
					{
						SG_SkinDrawer.drawTextInput(_color, _currentState, canvas);
						redrawScale9Grid_Alt();
						break;
					}
				}
			}
			else
			{
				normalRedraw();
			}
		}
		
		private function redrawScale9Grid_Alt():void
		{
			var frame:SG_ComponentTexture = frames[_currentState];
			var rect:Rectangle = frame.rect;
			var grid:SG_ComponentGrid = grids[_currentState];
			
			var width:Number = _width == 0 ? rect.width : _width;
			var height:Number = _height == 0 ? rect.height : _height;
			
			canvas.scaleX = 1;
			canvas.scaleY = 1;
			
			var gridRect:Rectangle = new Rectangle(grid.width, grid.height, rect.width - grid.width * 2, rect.height - grid.height * 2);
			canvas.scale9Grid = gridRect;
			canvas.width = width;
			canvas.height = height;
		}
		
		private function normalRedraw():void
		{
			var frame:SG_ComponentTexture = frames[_currentState];
			var rect:Rectangle = frame.rect;

			switch (_name)
			{
				default:
				{
					canvas.x = rect.x;
					canvas.y = rect.y;
					canvas.graphics.beginBitmapFill(frame.bitmapData, null, false, _smoothing);
					canvas.graphics.drawRect(0, 0, rect.width, rect.height);
					canvas.graphics.endFill();
					break;
				}
				case SG_SkinType.WORD_ON:
				{
					SG_SkinDrawer.drawOnWord(_color, canvas);
					break;
				}
				case SG_SkinType.WORD_OFF:
				{
					SG_SkinDrawer.drawOffWord(_color, canvas);
					break;
				}
				case SG_SkinType.SWITCHER:
				{
					SG_SkinDrawer.drawSwitcher(_currentState != 0 ? _skin.activeColorNormal : _color, canvas);
					break;
				}
				case SG_SkinType.PICKER:
				{
					SG_SkinDrawer.drawSliderPicker(_color, _currentState != 0 ? _skin.activeColorSaturated : null, canvas);
					break;
				}
			}
		}
		
		private function redrawScale9Grid():void
		{
			canvas.x = 0;
			canvas.y = 0;

			var frame:SG_ComponentTexture = frames[_currentState];
			var rect:Rectangle = frame.rect;

			var grid:SG_ComponentGrid = grids[_currentState];
			var width:uint = (_width == 0) ? rect.width : _width;
			var height:uint = (_height == 0) ? rect.height : _height;

			var matrix:Matrix = new Matrix();
			var middleWidth:uint = width - grid.width*2;
			var middleHeight:uint = height - grid.height*2;
			var sx:Number;
			var sy:Number;

			for (var i:int = 1; i <= 9; i++)
			{
				sx = 1;
				sy = 1;
				frame = grid.frames[i-1];
				rect = frame.rect.clone();

				if (i == 2 || i == 5 || i == 8)
				{
					sx = middleWidth/rect.width;
					rect.width = middleWidth;
				}
				if (i >= 4 && i <= 6)
				{
					sy = middleHeight/rect.height;
					rect.height = middleHeight;
				}
				if (i % 3 == 0) rect.x = grid.width + middleWidth;
				if (i >= 7)     rect.y = grid.height + middleHeight;

				if (rect.width != 0 && rect.height != 0)
				{
					matrix.identity();
					matrix.scale(sx, sy);
					matrix.translate(rect.x, rect.y);

					canvas.graphics.beginBitmapFill(frame.bitmapData, matrix, false, _smoothing);
					canvas.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
					canvas.graphics.endFill();
				}
			}
		}
		
		public function setSize(width:Number, height:Number):void 
		{
			_width = width;
			_height = height;
			redraw();
		}
		
		public function setPosition(x:int, y:int):void
		{
			this.x = x;
			this.y = y;
		}
		
		override public function set width(value:Number):void 
		{
			if (value > 1)
			{
				_width = value;
				redraw();
			}
		}
		
		override public function set height(value:Number):void 
		{
			if (value > 1)
			{
				_height = value;
				redraw();
			}
		}
		
		public function set currentState(value:uint):void
		{
			if (value < frames.length)
			{
				_currentState = value;
				redraw();
			}
		}
		
		public function set smoothing(value:Boolean):void
		{
			_smoothing = value;
			redraw();
		}
		
		public function get currentState():uint
		{
			return _currentState;
		}
		
		override public function get width():Number
		{
			return canvas.width;
		}
		
		override public function get height():Number
		{
			return canvas.height;
		}
		
		public function get smoothing():Boolean
		{
			return _smoothing;
		}
		
		public function get color():SG_SkinColor
		{
			return _color;
		}
		
	}
}
