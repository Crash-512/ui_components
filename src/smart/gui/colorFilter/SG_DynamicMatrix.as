package smart.gui.colorFilter
{
	internal class SG_DynamicMatrix 
	{
		public static const MATRIX_ORDER_PREPEND:int = 0;
		public static const MATRIX_ORDER_APPEND:int = 1;
		
		protected var m_width:int;
		protected var m_height:int;
		protected var m_matrix:Array;
		
		
		public function SG_DynamicMatrix(width:int, height:int)
		{
			Create(width, height);
		}
		
		protected function Create(width:int, height:int):void
		{
			if(width > 0 && height > 0) 
			{
				m_width = width;
				m_height = height;
				
				m_matrix = new Array(height);
				for(var i:int = 0; i < height; i++)
				{
					m_matrix[i] = new Array(width);
					for(var j:int = 0; j < height; j++)
					{
						m_matrix[i][j] = 0;
					}
				}
			}
		}
		
		protected function Destroy():void
		{
			m_matrix = null;
		}
		
		public function GetWidth():Number 
		{
			return m_width;
		}
	    
		public function GetHeight():Number
		{
			return m_height;
		}
		
		public function GetValue(row:int, col:int):Number
		{
			var value:Number = 0;
			if(row >= 0 && row < m_height && col >= 0 && col <= m_width)
			{
				value = m_matrix[row][col];
			}
			
			return value;
		}
		
		public function SetValue(row:int, col:int, value:Number):void
		{
			if(row >= 0 && row < m_height && col >= 0 && col <= m_width)
			{
				m_matrix[row][col] = value;
			}
		}
		
		public function LoadIdentity():void
		{
			if(m_matrix) 
			{
				for(var i:int = 0; i < m_height; i++)
				{
					for(var j:int = 0; j < m_width; j++)
					{
						if(i == j) {
							m_matrix[i][j] = 1;
						}
						else {
							m_matrix[i][j] = 0;
						}
					}
				}
			}
		}
		
		public function LoadZeros():void
		{
			if(m_matrix)
			{
				for(var i:int = 0; i < m_height; i++)
				{
					for(var j:int = 0; j < m_width; j++)
					{
						m_matrix[i][j] = 0;
					}
				}
			}
		}
		
		public function Multiply(inMatrix:SG_DynamicMatrix, order:int = MATRIX_ORDER_PREPEND):Boolean
		{
			if(!m_matrix || !inMatrix)
				return false;
				
			var inHeight:int = inMatrix.GetHeight();
			var inWidth:int = inMatrix.GetWidth();
			
			if(order == MATRIX_ORDER_APPEND)
			{
				//inMatrix on the left
				if(m_width != inHeight)
					return false;
					
				var result:SG_DynamicMatrix = new SG_DynamicMatrix(inWidth, m_height);
				for(var i:int = 0; i < m_height; i++)
				{
					for(var j:int = 0; j < inWidth; j++)
					{
						var total:Number = 0;
						for(var k:int = 0, m:int = 0; k < Math.max(m_height, inHeight) && m < Math.max(m_width, inWidth); k++, m++)
						{
							total = total + (inMatrix.GetValue(k, j) * m_matrix[i][m]);
						}
						
						result.SetValue(i, j, total);
					}
				}

				// destroy self and recreate with a new size
				Destroy();
				Create(inWidth, m_height);
				
				// assign result back to self
				for(i = 0; i < inHeight; i++)
				{
					for(j = 0; j < m_width; j++) 
					{
						m_matrix[i][j] = result.GetValue(i, j);
					}
				}
			}
			
			else {
				// inMatrix on the right
				if(m_height != inWidth)
					return false;
					
				result = new SG_DynamicMatrix(m_width, inHeight);
				for(i = 0; i < inHeight; i++)
				{
					for(j = 0; j < m_width; j++)
					{
						total = 0;
						for(k = 0, m = 0; k < Math.max(inHeight, m_height) && m < Math.max(inWidth, m_width); k++, m++)
						{
							total = total + (m_matrix[k][j] * inMatrix.GetValue(i, m));
						}
						result.SetValue(i, j, total);
					}
				}
				
				// destroy self and recreate with a new size
				Destroy();
				Create(m_width, inHeight);
				
				// assign result back to self
				for(i = 0; i < inHeight; i++)
				{
					for(j = 0; j < m_width; j++)
					{
						m_matrix[i][j] = result.GetValue(i, j);
					}
				}
			}
			
			return true;
		}
		
		public function MultiplyNumber(value:Number):Boolean
		{
			if(!m_matrix)
				return false;
			
			for(var i:int = 0; i < m_height; i++)
			{
				for(var j:int = 0; j < m_width; j++)
				{
					var total:Number = 0;
					total = m_matrix[i][j] * value;
					m_matrix[i][j] = total;
				}
			}
			
			return true;
		}
		
		public function Add(inMatrix:SG_DynamicMatrix):Boolean
		{
			if(!m_matrix || !inMatrix)
				return false;
			
			var inHeight:int = inMatrix.GetHeight();
			var inWidth:int = inMatrix.GetWidth();
			
			if(m_width != inWidth || m_height != inHeight)
				return false;
				
			for(var i:int = 0; i < m_height; i++)
			{
				for(var j:int = 0; j < m_width; j++)
				{
					var total:Number = 0;
					total = m_matrix[i][j] + inMatrix.GetValue(i, j);
					m_matrix[i][j] = total;
				}
			}
			
			return true;
		}
		
	}
}