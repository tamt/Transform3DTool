package cn.itamt.transform3d.controls.rotation 
{
	import cn.itamt.transform3d.Transform3DMode;
	import cn.itamt.transform3d.Util;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author tamt
	 */
	public class YRotationControl extends RotationDimentionControl
	{
		
		public function YRotationControl() 
		{
			super();
			_wedgeStyle.fillColor = 0x00cc00;
			_style.borderColor = 0x00cc00;
		}
		
		protected override function draw():void {
			super.draw();
			
			_sp.graphics3D.clear();
			
			if (_mode == Transform3DMode.GLOBAL) {
				_sp.graphics3D.lineStyle(_style.borderThickness, _style.borderColor);
				_sp.graphics3D.moveTo(-this._radius, 0);
				_sp.graphics3D.lineTo(this._radius, 0);
				_sp.graphics3D.lineStyle(4, _style.borderColor, 0);
				_sp.graphics3D.moveTo(-this._radius, 0);
				_sp.graphics3D.lineTo(this._radius, 0);
			}else if (_mode == Transform3DMode.INTERNAL) {
				_sp.graphics3D.lineStyle(_style.borderThickness, _style.borderColor);
				_sp.graphics3D.drawCircle(0, 0, _radius);
				_sp.graphics3D.lineStyle(4, _style.borderColor, 0);
				_sp.graphics3D.drawCircle(0, 0, _radius);
			}
			
		}
		
		override protected function onStartDrag():void {
			if(_mode == Transform3DMode.GLOBAL){			
				if (_startDragPoint.x >= 0) {
					_startDragPoint.x = _radius;
					_startDragPoint.y = 0;
					_startDragPoint3D.x = _radius;
					_startDragPoint3D.y = 0;
				}else{
					_startDragPoint.x = -_radius;
					_startDragPoint.y = 0;
					_startDragPoint3D.x = -_radius;
					_startDragPoint3D.y = 0;
				}
			}
			
			super.onStartDrag();
			
			if (_mode == Transform3DMode.INTERNAL) {
				_startAngle3D = this.rotationY;
			}
		}
		
		public override function set matrix(value:Matrix3D):void {
			var mx:Matrix3D = value.clone();
			if(_mode == Transform3DMode.INTERNAL){
				mx.prependRotation(90, Vector3D.X_AXIS);
			}
			super.matrix = mx;
			draw();
		}
		
	}

}