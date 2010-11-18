package cn.itamt.transform3d
{
	import cn.itamt.transform3d.controls.*;
	import cn.itamt.transform3d.controls.rotation.*;
	import cn.itamt.transform3d.cursors.*;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.*;
	import net.badimon.five3D.display.Scene3D;
	
	/**
	 * ...
	 * @author tamt
	 */
	public class RotationTool extends TransformControl
	{
		protected var _radius:Number = 50;
		
		protected var _xCtrl:XRotationControl;
		protected var _yCtrl:YRotationControl;
		protected var _zCtrl:ZRotationControl;
		protected var _pCtrl:PRotationControl;
		
		protected var _xMask:Shape;
		protected var _yMask:Shape;
		protected var _zMask:Shape;
		protected var _maskContainer:Sprite;
		
		//显示半圆还是显示全圆
		private var _showFullControl:Boolean;
		private var _canUseMask:Boolean;
		
		//
		public override function set mode(val:uint):void {
			if (Transform3DMode.isInvalidMode(val)) return;
			super.mode = val;
			
			if (_mode == Transform3DMode.GLOBAL) {
				_canUseMask = false;
				this.clearMask();
			}else if(_mode == Transform3DMode.INTERNAL){
				_canUseMask = true;
				if(!_showFullControl && _target)this.applyMask();
			}
		}
		
		public function RotationTool():void {
			_perspective = false;
			
			super();
		}
		
		override protected function onAdded(evt:Event = null):void {
			_xCtrl = new XRotationControl();
			_yCtrl = new YRotationControl();
			_zCtrl = new ZRotationControl();
			_pCtrl = new PRotationControl();
			_ctrls = [_xCtrl, _yCtrl, _zCtrl, _pCtrl];
			
			_pCtrl.visible = false;
			_xCtrl.radius = _yCtrl.radius = _zCtrl.radius = _pCtrl.radius = _radius;
			
			_xCtrl.setCursor(new XControlCursor);
			_yCtrl.setCursor(new YControlCursor);
			_zCtrl.setCursor(new ZControlCursor);
			_pCtrl.setCursor(new PControlCursor);
			
			_xCtrl.name = "x";
			_yCtrl.name = "y";
			_zCtrl.name = "z";
			_pCtrl.name = "p";
			
			_root.addChild(_xCtrl);
			_root.addChild(_yCtrl);
			_root.addChild(_zCtrl);
			_root.addChild(_pCtrl);
			
			
			//---------------------------------------
			//-------------半圆遮罩------------------
			this._maskContainer = new Sprite();
			this._maskContainer.mouseEnabled = false;
			this.addChild(this._maskContainer);
			
			_xMask = this.buildControlMask();
			this._maskContainer.addChild(_xMask);
			_xCtrl.shape.mask = _xMask;
			_xMask.visible = false;
			
			_yMask = this.buildControlMask();
			this._maskContainer.addChild(_yMask);
			_yCtrl.shape.mask = _yMask;
			_yMask.visible = false;
			
			_zMask = this.buildControlMask();
			this._maskContainer.addChild(_zMask);
			_zCtrl.shape.mask = _zMask;
			_zMask.visible = false;
			//---------------------------------------
			
			super.onAdded(evt);
		}
		
		override protected function onRemoved(evt:Event = null):void {
			super.onRemoved(evt);
			
			_xCtrl.dispose();
			_yCtrl.dispose();
			_zCtrl.dispose();
			_pCtrl.dispose();
			_regCtrl.dispose();
			
			_xCtrl = null;
			_yCtrl = null;
			_xCtrl = null;
			_pCtrl = null;
			_regCtrl = null;
		}
		
		
		//-------------------------------------
		//-------------------------------------
		//-------------------------------------
		
		
		protected override function onActiveControl(ctrl:DimentionControl):void {
			super.onActiveControl(ctrl);
			
			if (_showFullControl || !_canUseMask || !(ctrl is RotationDimentionControl)) return;
			this.clearMask(ctrl.name);
		}
		
		protected override function onDeactiveControl(ctrl:DimentionControl):void {
			super.onDeactiveControl(ctrl);
			
			if (_showFullControl || !_canUseMask || !(ctrl is RotationDimentionControl)) return;
			this.applyMask(ctrl.name);
		}
		
		protected override function onChangeControlValue(ctrl:DimentionControl):void {
			if(_mode == Transform3DMode.INTERNAL){
				_targetMX.prependTranslation(_interReg.x, _interReg.y, _interReg.z);
				
				switch(ctrl) {
					case _xCtrl:
						_targetMX.prependRotation(_xCtrl.degree, Vector3D.X_AXIS);
						break;
					case _yCtrl:
						_targetMX.prependRotation(_yCtrl.degree, Vector3D.Y_AXIS);
						break;
					case _zCtrl:
						_targetMX.prependRotation(_zCtrl.degree, Vector3D.Z_AXIS);
						break;
					case _pCtrl:
						_targetMX.prependRotation(_pCtrl.degreeX, Vector3D.X_AXIS);
						_targetMX.prependRotation(_pCtrl.degreeY, Vector3D.Y_AXIS);
						break;
				}
				
				_targetMX.prependTranslation( -_interReg.x, -_interReg.y, -_interReg.z);
			}else if (_mode == Transform3DMode.GLOBAL) {
				_targetMX.appendTranslation(-_outReg.x,-_outReg.y,-_outReg.z);
				
				switch(ctrl) {
					case _xCtrl:
						_targetMX.appendRotation(_xCtrl.degree, Vector3D.X_AXIS);
						break;
					case _yCtrl:
						_targetMX.appendRotation(_yCtrl.degree, Vector3D.Y_AXIS);
						break;
					case _zCtrl:
						_targetMX.appendRotation(_zCtrl.degree, Vector3D.Z_AXIS);
						break;
					case _pCtrl:
						_targetMX.appendRotation(_pCtrl.degreeX, Vector3D.X_AXIS);
						_targetMX.appendRotation(_pCtrl.degreeY, Vector3D.Y_AXIS);
						break;
				}
				_targetMX.appendTranslation(_outReg.x,_outReg.y,_outReg.z);
				
			}
		}
		
		protected override function updateControls():void {
			super.updateControls();
			
			for each(var ctrl:DimentionControl in _ctrls) {
				if (ctrl == _regCtrl || ctrl == _pCtrl) {
				}else {
					ctrl.matrix = _deltaMx;
				}
			}
			
			//半圆遮罩处理
			if (!_canUseMask && _showFullControl) return;
			
			this._maskContainer.x = _root.x;
			this._maskContainer.y = _root.y;
			
			var tolerance:Number = 1;
			var crv:Vector3D = _deltaMx.decompose()[1];
			
			//_xCtrl
			var rz:Number = (Util.projectRotationZ(_xCtrl.matrix));
			var ty:Number = Math.sin(crv.y);
			_xMask.rotation = rz + (ty > 0?90: -90);
			if (!_xCtrl.actived) {
				ty = (crv.y * Util.RADIAN) % 90;
				if (Math.abs(ty) < tolerance || (90-Math.abs(ty))<tolerance) {
					this.clearMask("x");
				}else {
					this.applyMask("x");
				}
			}
			
			//_yCtrl
			rz = (Util.projectRotationZ(_yCtrl.matrix));
			ty = Math.sin(crv.x);
			_yMask.rotation = rz - (ty > 0?90: -90);
			if (!_yCtrl.actived) {
				ty = (crv.z * Util.RADIAN) % 90;
				if (Math.abs(ty) < tolerance || (90-Math.abs(ty))<tolerance) {
					this.clearMask("y");
				}else {
					this.applyMask("y");
				}
			}
			
			
			//_zCtrl
			rz = (Util.projectRotationZ(_zCtrl.matrix));
			ty = Math.cos(crv.x);
			_zMask.rotation = rz + (ty > 0?90: -90);
			if(!_zCtrl.actived){
				ty = (crv.x * Util.RADIAN) % 90;
				if (Math.abs(ty) < tolerance || (90-Math.abs(ty))<tolerance) {
					this.clearMask("z");
				}else {
					this.applyMask("z");
				}
			}
			
			//trace(int(crv.x*Util.RADIAN), int(crv.y*Util.RADIAN), int(crv.z*Util.RADIAN));
		}
		
		private function buildControlMask():Shape {
			var shape:Shape = new Shape();
			shape.graphics.beginFill(0xffffff, .5);
			shape.graphics.drawRect(-_radius*2, -_radius*2, 4*_radius, _radius*2+1);
			shape.graphics.endFill();
			
			return shape;
		}
		
		/**
		 * 清除某一个contrl的遮罩
		 * @param	dimention
		 */
		private function clearMask(dimention:String = null):void {
			switch(dimention) {
				case "x":
					_xCtrl.shape.mask = null;
					break;
				case "y":
					_yCtrl.shape.mask = null;
					break;
				case "z":
					_zCtrl.shape.mask = null;
					break;
				case null:
					_xCtrl.shape.mask = null;
					_yCtrl.shape.mask = null;
					_zCtrl.shape.mask = null;
					this._maskContainer.graphics.clear();
			}
		}
		
		/**
		 * 给某一个contrl应用遮罩
		 * @param	dimention
		 */
		private function applyMask(dimention:String = null):void {
			switch(dimention) {
				case "x":
					_xCtrl.shape.mask = _xMask;
					break;
				case "y":
					_yCtrl.shape.mask = _yMask;
					break;
				case "z":
					_zCtrl.shape.mask = _zMask;
					break;
				case null:
					_xCtrl.shape.mask = _xMask;
					_yCtrl.shape.mask = _yMask;
					_zCtrl.shape.mask = _zMask;
			}
			
			this._maskContainer.graphics.clear();
			this._maskContainer.graphics.lineStyle(2, 0, .6);
			this._maskContainer.graphics.drawCircle(0, 0, _radius);
		}
		
		protected override function clear():void {
			this._maskContainer.graphics.clear();
			super.clear();
		}
	}
	
}