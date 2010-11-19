package cn.itamt.transform3d 
{
	import cn.itamt.transform3d.controls.*;
	import cn.itamt.transform3d.cursors.*;
	import cn.itamt.transform3d.controls.translation.*;
	import cn.itamt.transform3d.skins.ITranslationDimentionSkin;
	import cn.itamt.transform3d.skins.TranslationDimentionSkin;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Orientation3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author tamt
	 */
	public class TranslationTool extends TransformControl
	{
		protected var _xCtrl:XTranslationControl;
		protected var _yCtrl:YTranslationControl;
		protected var _zCtrl:ZTranslationControl;
		
		protected var _xSkin:DisplayObject;
		protected var _ySkin:DisplayObject;
		protected var _zSkin:DisplayObject;
		
		public function TranslationTool() 
		{
			_perspective = false;
		}
		
		override protected function onAdded(evt:Event = null):void {
			_xCtrl = new XTranslationControl();
			_yCtrl = new YTranslationControl();
			_zCtrl = new ZTranslationControl();
			_ctrls = [_xCtrl, _yCtrl, _zCtrl];
			
			_xCtrl.setCursor(new XControlCursor);
			_yCtrl.setCursor(new YControlCursor);
			_zCtrl.setCursor(new ZControlCursor);
			
			_root.addChild(_xCtrl);
			_root.addChild(_yCtrl);
			_root.addChild(_zCtrl);
			
			super.onAdded(evt);
			
			if(_xSkin == null)_xSkin = new TranslationDimentionSkin(_xCtrl.style.borderColor);
			if(_ySkin == null)_ySkin = new TranslationDimentionSkin(_yCtrl.style.borderColor);
			if(_zSkin == null)_zSkin = new TranslationDimentionSkin(_zCtrl.style.borderColor);
			
			_xCtrl.skin = _xSkin;
			_yCtrl.skin = _ySkin;
			_zCtrl.skin = _zSkin;
			
			_xCtrl.visible = false;
			_yCtrl.visible = false;
			_zCtrl.visible = false;
			
			_skinContainer.addChild(_xSkin);
			_skinContainer.addChild(_ySkin);
			_skinContainer.addChild(_zSkin);
		}
		
		override protected function onRemoved(evt:Event = null):void {
			super.onRemoved(evt);
			
			_xCtrl.dispose();
			_yCtrl.dispose();
			_zCtrl.dispose();
			_regCtrl.dispose();
			
			_xCtrl = null;
			_yCtrl = null;
			_xCtrl = null;
			_regCtrl = null;
		}
		
		//-------------------------------------
		//-------------------------------------
		//-------------------------------------
		protected override function onChangeControlValue(ctrl:DimentionControl):void {
			if(_mode == Transform3DMode.INTERNAL){
				_targetMX.prependTranslation(_xCtrl.distance, _yCtrl.distance, _zCtrl.distance);
			}else if (_mode == Transform3DMode.GLOBAL) {
				_targetMX.appendTranslation(_xCtrl.distance, _yCtrl.distance, _zCtrl.distance);
			}
		}
		
		protected override function updateControls():void {
			super.updateControls();
				
			for each(var ctrl:DimentionControl in _ctrls) {
				if (ctrl == _regCtrl) {
				}else {
					ctrl.matrix = _deltaMx;
				}
			}
			
			var rotations:Vector3D = _deltaMx.decompose(Orientation3D.AXIS_ANGLE)[1];
			
			var pos:Vector3D = _xCtrl.matrix.transformVector(new Vector3D(_xCtrl.length, 0, 0));
			var r:Number = Util.projectRotationX(_deltaMx);
			_xSkin.rotation = r;
			//_xSkin.x = pos.x;
			//_xSkin.y = pos.y;
			if(_xSkin is ITranslationDimentionSkin)(_xSkin as ITranslationDimentionSkin).length = Math.sqrt(pos.x * pos.x + pos.y * pos.y);
			
			pos = _xCtrl.matrix.transformVector(new Vector3D(0, _yCtrl.length, 0));
			r = Util.projectRotationY(_deltaMx);
			_ySkin.rotation = r;
			//_ySkin.x = pos.x;
			//_ySkin.y = pos.y;
			if(_ySkin is ITranslationDimentionSkin)(_ySkin as ITranslationDimentionSkin).length = Math.sqrt(pos.x * pos.x + pos.y * pos.y);
			
			pos = _xCtrl.matrix.transformVector(new Vector3D(0, 0, _zCtrl.length));
			r = Util.projectRotationZ(_deltaMx);
			_zSkin.rotation = r;
			//_zSkin.x = pos.x;
			//_zSkin.y = pos.y;
			if(_zSkin is ITranslationDimentionSkin)(_zSkin as ITranslationDimentionSkin).length = Math.sqrt(pos.x * pos.x + pos.y * pos.y);
		}
		
		//
		protected function buildSkin():void {
			//绘制箭头
		}
		
	}

}