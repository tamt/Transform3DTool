package cn.itamt.transform3d.controls.translation 
{
	import cn.itamt.transform3d.Transform3DMode;
	import flash.geom.Point;
	/**
	 * ...
	 * @author tamt
	 */
	public class YTranslationControl extends TranslationDimentionControl
	{
		
		public function YTranslationControl() 
		{
			super();
			_style.borderColor = 0x00ff00;
		}
		
		protected override function draw():void {
			super.draw();
			
			_sp.graphics3D.clear();
			
			if(_mode == Transform3DMode.GLOBAL){
				_sp.graphics3D.lineStyle(_style.borderThickness, _style.borderColor);
				_sp.graphics3D.moveTo(0, 0);
				_sp.graphics3D.lineTo(0, -this._length);
				_sp.graphics3D.lineStyle(4, _style.borderColor, 0);
				_sp.graphics3D.moveTo(0, 0);
				_sp.graphics3D.lineTo(0, -this._length);
			}else if (_mode == Transform3DMode.INTERNAL) {
				_sp.graphics3D.lineStyle(_style.borderThickness, _style.borderColor);
				_sp.graphics3D.moveTo(0, 0);
				_sp.graphics3D.lineTo(0, -this._length);
				_sp.graphics3D.lineStyle(4, _style.borderColor, 0);
				_sp.graphics3D.moveTo(0, 0);
				_sp.graphics3D.lineTo(0, -this._length);
			}
			
		}
		
		override protected function onDraging():void {
			_value = _globalMousePoint.y - _globalStartDragPoint.y;
			
			//显示度数
			if (showValue) {
				if (!_textfield.visible)_textfield.visible = true;
				_textfield.text = Math.round(_value).toString();
				var pos:Point = Point.interpolate(_globalStartDragPoint, _globalMousePoint, .5);
				_textfield.x = pos.x - _textfield.width / 2;
				_textfield.y = pos.y - _textfield.height / 2;
			}
		}
		
	}

}