package cn.itamt.transform3d.controls.translation 
{
	import cn.itamt.transform3d.Transform3DMode;
	import flash.geom.Point;
	/**
	 * ...
	 * @author tamt
	 */
	public class ZTranslationControl extends TranslationDimentionControl
	{
		
		public function ZTranslationControl() 
		{
			super();
			_style.fillColor = 0x0000ff;
			_style.fillAlpha = 1;
			_style.borderColor = 0x0000ff;
		}
		
		protected override function draw():void {
			super.draw();
			
			_sp.graphics3D.clear();
			
			if(_mode == Transform3DMode.GLOBAL){
				_sp.graphics3D.beginFill(_style.fillColor, _style.fillAlpha);
				_sp.graphics3D.drawCircle(0, 0, 10);
				_sp.graphics3D.endFill();
			}else if (_mode == Transform3DMode.INTERNAL) {
				_sp.graphics3D.lineStyle(_style.borderThickness, _style.borderColor);
				_sp.graphics3D.moveToSpace(0, 0, 0);
				_sp.graphics3D.lineToSpace(0, 0, _length);
				_sp.graphics3D.lineStyle(4, _style.borderColor, 0);
				_sp.graphics3D.moveToSpace(0, 0, 0);
				_sp.graphics3D.lineToSpace(0, 0, _length);
				
				//_sp.graphics3D.moveTo(0, 0);
				//_sp.graphics3D.lineTo(0, -_length);
				//_sp.graphics3D.lineStyle(4, _style.borderColor, 0);
				//_sp.graphics3D.moveTo(0, 0);
				//_sp.graphics3D.lineTo(0, -_length);
			}
			
		}
		
		override protected function onDraging():void {
			_value = _globalStartDragPoint.y - _globalMousePoint.y;
			
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