package cn.itamt.transform3d 
{
	import cn.itamt.transform3d.controls.DimentionControl;
	import cn.itamt.transform3d.controls.TransformControl;
	import cn.itamt.transform3d.controls.translation.GlobalTranslationControl;
	import cn.itamt.transform3d.cursors.GlobalTranslationCursor;
	import cn.itamt.transform3d.cursors.RegistrationControlCursor;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.geom.Matrix3D;
	
	/**
	 * ...
	 * @author tamt
	 */
	public class GlobalTranslationTool extends TransformControl
	{
		protected var _gCtrl:GlobalTranslationControl;
		
		public override function set target(dp:DisplayObject):void {
			if (!isTargetValid(dp)) {
				return;
			}
			
			super.target = dp;
			
			if (_inited) {
				_gCtrl.skin = _target;
				if(_target){
					var rect:Rectangle = _target.getBounds(_gCtrl);
					_gCtrl.targetRect = rect;
				}
			}
		}
		
		public function GlobalTranslationTool() 
		{
			_debug = false;
			super();
		}
		
		protected override function onAdded(evt:Event = null):void {
			_gCtrl = new GlobalTranslationControl();
			_ctrls = [_gCtrl];
			
			_gCtrl.setCursor(new GlobalTranslationCursor);
			_root.addChild(_gCtrl);
			
			super.onAdded(evt);
			
			_root.removeChild(_regCtrl);
		}
		
		override protected function onRemoved(evt:Event = null):void {
			super.onRemoved(evt);
			
			_gCtrl.dispose();
			_gCtrl = null;
		}
		
		protected override function updateControls(deltaMX:Matrix3D = null):void {
			super.updateControls(deltaMX);
			
			var rect:Rectangle = _target.getBounds(_gCtrl);
			_gCtrl.targetRect = rect;
		}
	
		protected override function onChangeControlValue(ctrl:DimentionControl):void {
			if (ctrl == _gCtrl) {
				
				var focalLen:Number = _target.root.transform.perspectiveProjection.focalLength;
				var ratio:Number = Math.sin(_target.root.transform.perspectiveProjection.fieldOfView * .5 / Util.RADIAN);
				var pos:Vector3D = _target.transform.matrix3D.position;
				ratio = (focalLen + pos.z)/focalLen ;
			
				_targetMX.appendTranslation(_gCtrl.valueX * ratio, _gCtrl.valueY * ratio, 0);
			}

			_outReg = caculateOutterReg();
		}
		
	}

}
