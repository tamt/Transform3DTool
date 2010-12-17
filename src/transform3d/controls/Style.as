package transform3d.controls 
{
	/**
	 * style data
	 * @author tamt
	 */
	public class Style
	{
		public var fillColor:uint;
		public var fillAlpha:Number;
		
		public var borderColor:uint;
		public var borderAlpha:Number;
		
		public var borderThickness:Number;
		
		public function Style(fColor:uint = 0x0000ff, fAlpha:Number = NaN, bColor:uint = 0x000000, bAlpha:Number = NaN, bThickness:Number = 1) 
		{
			this.fillColor = fColor;
			this.fillAlpha = fAlpha;
			this.borderColor = bColor;
			this.borderAlpha = bAlpha;
			this.borderThickness = bThickness;
		}
		
		public function clone():Style {
			return new Style(this.fillColor, this.fillAlpha, this.borderColor, this.borderAlpha, this.borderThickness);
		}
		
	}

}
