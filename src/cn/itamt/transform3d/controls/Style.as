package cn.itamt.transform3d.controls 
{
	/**
	 * ...
	 * @author tamt
	 */
	public class Style
	{
		public var fillColor:uint;
		public var fillAlpha:Number;
		
		public var borderColor:uint;
		public var borderAlpha:Number;
		
		public var borderThickness:Number;
		
		public function Style(fColor:uint = 0x0000ff, fAlpha:Number = .5, bColor:uint = 0x000000, bAlpha:Number = 1, bThickness:Number = 1) 
		{
			this.fillColor = fColor;
			this.fillAlpha = fAlpha;
			this.borderColor = bColor;
			this.borderAlpha = bAlpha;
			this.borderThickness = bThickness;
		}
		
	}

}