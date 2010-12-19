package transform3d.controls.rotation 
{
	import flash.display.Shape;
	import flash.events.Event;
	import net.badimon.five3D.utils.InternalUtils;
	/**
	 * perspective rotation control.
	 * @author tamt
	 */
	public class PRotationControl extends RotationDimentionControl
	{
		//get control degreeX value
		private var _degreeX:Number;
		public function get degreeX():Number {
			return _degreeX;
		}
		
		//get control degreeY value
		private var _degreeY:Number;
		public function get degreeY():Number {
			return _degreeY;
		}
		
		//-----------------------------------
		//-----------------------------------
		//-----------------------------------
		public function PRotationControl() 
		{
			super();
			this._radius = 60;
			this._style.borderColor = 0xff6600;
		}
				
		protected override function draw():void {
			_sp.graphics3D.clear();
			_sp.graphics3D.lineStyle(_style.borderThickness, _style.borderColor);
			_sp.graphics3D.drawCircle(0, 0, _radius);
			_sp.graphics3D.lineStyle(4, _style.borderColor, 0);
			_sp.graphics3D.drawCircle(0, 0, _radius);
		}
		
		override protected function onDraging():void {
			_mousePoint.x = InternalUtils.getScene(this).mouseX - _globalRegPoint.x
			_mousePoint.y = InternalUtils.getScene(this).mouseY - _globalRegPoint.y;
			
			_degreeY = (_mousePoint.x - _startDragPoint.x)*1.5;
			_degreeX = (_mousePoint.y - _startDragPoint.y)*1.5;
		}
		
		protected override function onStopDrag():void {
			_degreeX = _degreeY = 0;
		}
		
	}

}
