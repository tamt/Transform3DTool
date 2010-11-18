package cn.itamt.transform3d.controls.translation 
{
	import cn.itamt.transform3d.Transform3DMode;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author tamt
	 */
	public class XTranslationControl extends TranslationDimentionControl
	{
		
		public function XTranslationControl() 
		{
			super();
			_style.borderColor = 0xff0000;
		}
		
		protected override function draw():void {
			super.draw();
			
			_sp.graphics3D.clear();
			
			if(_mode == Transform3DMode.GLOBAL){
				_sp.graphics3D.lineStyle(_style.borderThickness, _style.borderColor);
				_sp.graphics3D.moveTo(0, 0);
				_sp.graphics3D.lineTo(this._length, 0);
				_sp.graphics3D.lineStyle(4, _style.borderColor, 0);
				_sp.graphics3D.moveTo(0, 0);
				_sp.graphics3D.lineTo(this._length, 0);
			}else if (_mode == Transform3DMode.INTERNAL) {
				_sp.graphics3D.lineStyle(_style.borderThickness, _style.borderColor);
				_sp.graphics3D.moveTo(0, 0);
				_sp.graphics3D.lineTo(this._length, 0);
				_sp.graphics3D.lineStyle(4, _style.borderColor, 0);
				_sp.graphics3D.moveTo(0, 0);
				_sp.graphics3D.lineTo(this._length, 0);	
			}
			
		}
		
		override protected function onDraging():void {
			_value = _globalMousePoint.x - _globalStartDragPoint.x;
			
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