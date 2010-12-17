package cn.itamt.transform3d.controls.translation 
{
	import cn.itamt.transform3d.consts.Transform3DMode;
	import cn.itamt.transform3d.util.Util;
	import net.badimon.five3D.display.Scene3D;
	import net.badimon.five3D.utils.InternalUtils;
	import flash.geom.Matrix3D;
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
			_arrowSize = 20;
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
			var root:Scene3D = InternalUtils.getScene(this);
			_globalMousePoint = new Point(root.mouseX, root.mouseY);
			
			var pt:Point = _globalMousePoint.subtract(_globalStartDragPoint);
			var b:Number = Math.atan2(pt.y, pt.x);
			var a:Number = Util.projectRotationX(this.matrix) / Util.RADIAN;
			var a:Number = a - b;
			_value = Math.cos(a) * (Math.sqrt(pt.x * pt.x + pt.y * pt.y));
			
			//显示度数
			if (showValue) {
				if (!_textfield.visible)_textfield.visible = true;
				_textfield.text = Math.round(_value).toString();
				var pos:Point = Point.interpolate(_globalStartDragPoint, _mousePoint, .5);
				_textfield.x = pos.x - _textfield.width / 2;
				_textfield.y = pos.y - _textfield.height / 2;
			}
		}
		
		public override function set matrix(value:Matrix3D):void {
			super.matrix = value;
			draw();
		}
	}

}