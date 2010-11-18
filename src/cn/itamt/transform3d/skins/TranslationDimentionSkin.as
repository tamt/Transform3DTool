package cn.itamt.transform3d.skins 
{
	import cn.itamt.transform3d.controls.Style;
	import flash.geom.Point;
	/**
	 * ...
	 * @author tamt
	 */
	public class TranslationDimentionSkin extends DimentionSkin
	{
		
		private var _length:Number = 50;
		public function get length():Number {
			return _length;
		}
		public function set length(len:Number):void {
			_length = len;
			clear();
			draw();
		}
		
		private var _arrowHeight:Number = 10;
		private var _arrowWidth:Number = 20;
		
		public function set arrowSize(pt:Point):void {
			_arrowWidth = pt.x;
			_arrowHeight = pt.y;
			
			clear();
			draw();
		}
		
		private var _style:Style;
		
		public function TranslationDimentionSkin(color:uint, length:Number = 50, arrowWidth:Number = 15, arrowHeight:Number = 12) 
		{
			_style = new Style(color, .5, color, 1, 1);
			this._length = length;
			this._arrowWidth = arrowWidth;
			this._arrowHeight = arrowHeight;
			
			super();
		}
		
		protected override function draw():void {
			//graphics.beginFill(_style.borderColor, _style.borderAlpha);
			//graphics.moveTo(0, 0);
			//graphics.lineTo(this.length, 0);
			//graphics.moveTo(this._length + _arrowWidth, 0);
			//graphics.lineTo(this._length, _arrowWidth/2);
			//graphics.lineTo(this._length, -_arrowWidth/2);
			//graphics.lineTo(this._length + _arrowWidth, 0);
			//graphics.endFill();
			//graphics.beginFill(_style.borderColor, .5);
			//graphics.drawEllipse(this._length - _arrowWidth/4, -_arrowWidth/2, _arrowWidth, _arrowWidth);
			//graphics.endFill();	
			
			var radius:Number = _arrowHeight / 2;
			var alpha:Number = Math.acos(radius/_arrowWidth);
			var a:Number = Math.cos(alpha) * radius;
			var b:Number = Math.sin(alpha) * radius;
			var fx:Number = _arrowWidth - a;
			var fy:Number = b;
			
			graphics.beginFill(_style.borderColor, _style.borderAlpha);
			graphics.moveTo(0, 0);
			graphics.lineTo(this.length, 0);
			graphics.moveTo(this._length + _arrowWidth, 0);
			graphics.lineTo(this._length + a, fy);
			graphics.lineTo(this._length + a, -fy);
			graphics.lineTo(this._length + _arrowWidth, 0);
			graphics.endFill();
			graphics.beginFill(_style.borderColor, 1);
			graphics.drawEllipse(this._length - radius, -radius, _arrowHeight, _arrowHeight);
			graphics.endFill();
			
		}
		
		protected override function clear():void {
			graphics.clear();
		}
		
		public override function dispose():void {
			_style = null;
			super.dispose();
		}
	}

}