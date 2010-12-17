package cn.itamt.transform3d 
{
	import cn.itamt.transform3d.consts.Transform3DMode;
	import cn.itamt.transform3d.controls.*;
	import cn.itamt.transform3d.cursors.*;
	import cn.itamt.transform3d.controls.translation.*;
	import cn.itamt.transform3d.skins.ITranslationDimentionSkin;
	import cn.itamt.transform3d.skins.TranslationDimentionSkin;
	import cn.itamt.transform3d.util.Util;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Orientation3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	/**
	 * translation component of Transform3DTool
	 * @author tamt
	 */
	public class TranslationTool extends TransformControl
	{
		protected var _xCtrl:XTranslationControl;
		protected var _yCtrl:YTranslationControl;
		protected var _zCtrl:ZTranslationControl;
		
		//---------------------------
		//cursors
		//---------------------------
		//xctrl cursor
		protected var _xCursor:DisplayObject;
		public function get xCursor():DisplayObject {
			return _xCursor;
		}
		public function set xCursor(dp:DisplayObject):void {
			_xCursor = dp;
			if (_inited) {
				_xCtrl.setCursor(_xCursor);
			}
		}
		
		//yctrl cursor
		protected var _yCursor:DisplayObject;
		public function get yCursor():DisplayObject {
			return _yCursor;
		}
		public function set yCursor(dp:DisplayObject):void {
			_yCursor = dp;
			if (_inited) {
				_yCtrl.setCursor(_yCursor);
			}
		}
		//zctrl cursor
		protected var _zCursor:DisplayObject;
		public function get zCursor():DisplayObject {
			return _zCursor;
		}
		public function set zCursor(dp:DisplayObject):void {
			_zCursor = dp;
			if (_inited) {
				_zCtrl.setCursor(_zCursor);
			}
		}
		
		//---------------------
		//skins
		//---------------------
		protected var _xSkin:DisplayObject;
		protected var _ySkin:DisplayObject;
		protected var _zSkin:DisplayObject;
		
		//---------------------
		//size, arrow size;
		//---------------------
		protected var _size:Number = 80;
		public function get size():Number {
			return _size;
		}
		public function set size(val:Number):void {
			_size = val;
			if (_inited) {
				_xCtrl.length = _yCtrl.length = _zCtrl.length = _size;
				this.updateControls();
			}
		}
		private var _arrowSize:Point = new Point(15, 12);
		public function set arrowSize(val:Point):void {
			_arrowSize = val;
			if (_inited) {
				if (_xSkin is TranslationDimentionSkin)(_xSkin as TranslationDimentionSkin).arrowSize = _arrowSize;
				if (_ySkin is TranslationDimentionSkin)(_ySkin as TranslationDimentionSkin).arrowSize = _arrowSize;
				if (_zSkin is TranslationDimentionSkin)(_zSkin as TranslationDimentionSkin).arrowSize = _arrowSize;
			}
		}
		public function get arrowSize():Point {
			return _arrowSize;
		}
		
		public function TranslationTool() 
		{
		}
		
		override protected function onAdded(evt:Event = null):void {
			_xCtrl = new XTranslationControl();
			_yCtrl = new YTranslationControl();
			_zCtrl = new ZTranslationControl();
			_ctrls = [_xCtrl, _yCtrl, _zCtrl];
			
			if(xCursor)_xCtrl.setCursor(xCursor);
			if(yCursor)_yCtrl.setCursor(yCursor);
			if(zCursor)_zCtrl.setCursor(zCursor);
			
			_root.addChild(_xCtrl);
			_root.addChild(_yCtrl);
			_root.addChild(_zCtrl);
			
			if(_xSkin == null)_xSkin = new TranslationDimentionSkin(_xCtrl.style.borderColor, this.size, arrowSize.x, arrowSize.y);
			if(_ySkin == null)_ySkin = new TranslationDimentionSkin(_yCtrl.style.borderColor, this.size, arrowSize.x, arrowSize.y);
			if(_zSkin == null)_zSkin = new TranslationDimentionSkin(_zCtrl.style.borderColor, this.size, arrowSize.x, arrowSize.y);
			
			_xCtrl.skin = _xSkin;
			_yCtrl.skin = _ySkin;
			_zCtrl.skin = _zSkin;
			
			_xCtrl.visible = false;
			_yCtrl.visible = false;
			_zCtrl.visible = false;
			
			super.onAdded(evt);
			
			_skinContainer.addChild(_xSkin);
			_skinContainer.addChild(_ySkin);
			_skinContainer.addChild(_zSkin);
		}
		
		override protected function onRemoved(evt:Event = null):void {
			
			_xCtrl.dispose();
			_yCtrl.dispose();
			_zCtrl.dispose();
			
			_xCtrl = null;
			_yCtrl = null;
			_xCtrl = null;
			
			_skinContainer.removeChild(_xSkin);
			_skinContainer.removeChild(_ySkin);
			_skinContainer.removeChild(_zSkin);
			
			_xSkin = null;
			_ySkin = null;
			_zSkin = null;
			
			super.onRemoved(evt);
		}
		
		//-------------------------------------
		//-------------------------------------
		//-------------------------------------
		protected override function onChangeControlValue(ctrl:DimentionControl):void {
			var focalLen:Number = _target.root.transform.perspectiveProjection.focalLength;
			var ratio:Number = Math.sin(_target.root.transform.perspectiveProjection.fieldOfView * .5 / Util.RADIAN);
			var pos:Vector3D = _target.transform.matrix3D.position;
			ratio *= (focalLen + pos.z) / focalLen;
			
			var xdist:Number = (_xCtrl.distance * ratio);
			var ydist:Number = (_yCtrl.distance * ratio);
			var zdist:Number = (_zCtrl.distance * ratio);
			
			if (_mode == Transform3DMode.INTERNAL) {
				_targetMX.prependTranslation(xdist, ydist, zdist);
			}else if (_mode == Transform3DMode.GLOBAL) {
				var mx:Matrix3D = this._originConcatenatedMX.clone();
				mx.appendTranslation(xdist, ydist, zdist);
				var parentMX:Matrix3D = _originParentConcatenatedMX.clone();
				parentMX.invert();
				mx.append(parentMX);
				_targetMX = mx.clone();
			}
		}
		
		protected override function updateControls(deltaMX:Matrix3D = null):void {
			super.updateControls(deltaMX);
				
			for each(var ctrl:DimentionControl in _ctrls) {
				if (ctrl == _regCtrl) {
				}else {
					ctrl.matrix = _deltaMx;
				}
			}
			
			var rotations:Vector3D = _deltaMx.decompose(Orientation3D.AXIS_ANGLE)[1];
			
			var pos:Vector3D = _deltaMx.transformVector(new Vector3D(_xCtrl.length, 0, 0));
			var r:Number = Util.projectRotationX(_deltaMx);
			_xSkin.rotation = r;
			if(_xSkin is ITranslationDimentionSkin)(_xSkin as ITranslationDimentionSkin).length = Math.sqrt(pos.x * pos.x + pos.y * pos.y);
			
			pos = _deltaMx.transformVector(new Vector3D(0, _yCtrl.length, 0));
			r = Util.projectRotationY(_deltaMx);
			_ySkin.rotation = r;
			if(_ySkin is ITranslationDimentionSkin)(_ySkin as ITranslationDimentionSkin).length = Math.sqrt(pos.x * pos.x + pos.y * pos.y);
			
			pos = _deltaMx.transformVector(new Vector3D(0, 0, _zCtrl.length));
			r = Util.projectRotationZ(_deltaMx);
			_zSkin.rotation = r;
			if(_zSkin is ITranslationDimentionSkin)(_zSkin as ITranslationDimentionSkin).length = Math.sqrt(pos.x * pos.x + pos.y * pos.y);
		}
		
	}

}
