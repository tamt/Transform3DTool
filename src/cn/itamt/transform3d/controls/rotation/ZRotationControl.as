package cn.itamt.transform3d.controls.rotation 
{
	import cn.itamt.transform3d.Transform3DMode;
	import flash.display.Shape;
	import flash.events.Event;
	/**
	 * ...
	 * @author tamt
	 */
	public class ZRotationControl extends RotationDimentionControl
	{
		
		public function ZRotationControl() 
		{
			super();
			_wedgeStyle.fillColor = 0x0000ff;
			_style.borderColor = 0x0000ff;
		}
		
		protected override function draw():void {
			super.draw();
			
			_sp.graphics3D.clear();
			
			_sp.graphics3D.lineStyle(_style.borderThickness, _style.borderColor);
			_sp.graphics3D.drawCircle(0, 0, _radius);
			_sp.graphics3D.lineStyle(4, _style.borderColor, 0);
			_sp.graphics3D.drawCircle(0, 0, _radius);
			/*
			if(_mode == Transform3DMode.GLOBAL){
				_sp.graphics3D.lineStyle(_style.borderThickness, _style.borderColor);
				_sp.graphics3D.drawCircle(0, 0, _radius);
				_sp.graphics3D.lineStyle(4, _style.borderColor, 0);
				_sp.graphics3D.drawCircle(0, 0, _radius);
			}else if (_mode == Transform3DMode.INTERNAL) {
				_sp.graphics3D.lineStyle(_style.borderThickness, _style.borderColor);
				_sp.graphics3D.moveTo(0, 0);
				_sp.graphics3D.lineTo(this._length, 0);
				_sp.graphics3D.lineStyle(4, _style.borderColor, 0);
				_sp.graphics3D.moveTo(0, 0);
				_sp.graphics3D.lineTo(this._length, 0);
			}
			*/
		}
		
		override protected function onStartDrag():void {			
			super.onStartDrag();
			
			if (_mode == Transform3DMode.INTERNAL) {
				_startAngle3D = this.rotationZ + 90;
			}
		}
	}

}