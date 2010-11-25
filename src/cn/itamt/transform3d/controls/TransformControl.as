package cn.itamt.transform3d.controls 
{
	import cn.itamt.transform3d.controls.rotation.*;
	import cn.itamt.transform3d.cursors.RegistrationControlCursor;
	import cn.itamt.transform3d.events.TransformEvent;
	import cn.itamt.transform3d.Transform3DMode;
	import cn.itamt.transform3d.Util;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.*;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import net.badimon.five3D.display.Scene3D;
	import net.badimon.five3D.display.Sprite3D;
	/**
	 * ...
	 * @author tamt
	 */
	public class TransformControl extends Sprite implements ITransformControl
	{
		protected var _debug:Boolean;
		
		protected var _root:Scene3D;
		protected var _skinContainer:Sprite;
		protected var _inited:Boolean = false;
		
		//修改注册点的Control
		protected var _regCtrl:RegistrationControl;
		
		protected var _mode:uint = 1;
		public function get mode():uint {
			return _mode;
		}
		
		public function set mode(val:uint):void {
			if (Transform3DMode.isInvalidMode(val)) return;
			_mode = val;
			
			if (!_inited) return;
			
			for each(var control:DimentionControl in _ctrls) {
				control.mode = _mode;
			}
			
			this.update();
		}		
		
		protected var _ctrls:Array;
		//注册点在target内部的坐标
		protected var _innerReg:Vector3D;
		//注册点在target外部的坐标
		protected var _outReg:Vector3D;
		//在stage下的注册点坐标
		protected var _reg:Point;
		public function get registration():Point {
			return _reg;
		}
		public function set registration(pt:Point):void {
			_reg = pt.clone();
			if (_inited) {
				_innerReg = _target.globalToLocal3D(_reg);
				update();
			}
		}
		
		//原始的matrix3d
		protected var _originMX:Matrix3D;
		//计算出的matrix3d
		protected var _targetMX:Matrix3D;
		//应用在control上的mx
		protected var _controlMX:Matrix3D;
		//应用在control上的mx，只包含旋转数据
		protected var _deltaMx:Matrix3D;
		protected var _targetParentInvertMx:Matrix3D;
		//
		private var _perspective:Boolean;
		//目标
		protected var _target:DisplayObject;
		public function get target():DisplayObject {
			return _target;
		}
		
		public function set target(dp:DisplayObject):void {
			if (!isTargetValid(dp)) {
				return;
			}
			
			_target = dp;
			
			if (_target == null) {
				clear();
				return;
			}
			
			if (!_root.visible)_root.visible = true;
			if (!_skinContainer.visible)_skinContainer.visible = true;
			
			if (_target.transform.matrix3D == null) {
				Util.converTo3DDisplayObject(_target);
			}
			
			var pt:Point = this.getProjectionCenter();
			_root.x = pt.x;
			_root.y = pt.y;
			_root.viewDistance = _target.root.transform.perspectiveProjection.focalLength;
			
			_targetParentInvertMx = Util.getParentConcatenatedMatrix3D(_target);
			_targetParentInvertMx.invert();
			
			_originMX = this.getConcatenatedMatrix3D();
			_targetMX = _originMX.clone();
						
			//计算内部注册点
			var internalRect:Rectangle = _target.getRect(_target);
			var pt:Point = new Point(internalRect.left + internalRect.width / 2, internalRect.top + internalRect.height / 2);
			_reg = _target.localToGlobal(pt);
			_innerReg = _target.globalToLocal3D(_reg);
			
			this.update();
		}
		
		//--------------------------------
		//--------------------------------
		//--------------------------------
		public function TransformControl() 
		{	
			_root = new Scene3D();
			addChild(_root);
			
			_skinContainer = new Sprite();
			addChildAt(_skinContainer, 0);
			
			if (stage) onInterAdded();
			else addEventListener(Event.ADDED_TO_STAGE, onInterAdded);
			
			addEventListener(Event.REMOVED_FROM_STAGE, onInterRemoved);
		}
		
		private function onInterAdded(evt:Event = null):void {
			if (_inited) return;
			_inited = true;
			this.onAdded(evt);
		}
		
		private function onInterRemoved(evt:Event = null):void {
			_inited = false;
			this.onRemoved(evt);
		}
		
		protected function onAdded(evt:Event = null):void {
			_regCtrl = new RegistrationControl();
			_regCtrl.setCursor(new RegistrationControlCursor);
			_root.addChild(_regCtrl);
			_ctrls.push(_regCtrl);
						
			//设置mode
			this.mode = _mode;
			
			this.addEventListener(Event.ACTIVATE, onControlActived);
			this.addEventListener(Event.DEACTIVATE, onControlDeactived);
			this.addEventListener(Event.CHANGE, onChange);
			_regCtrl.addEventListener(Event.CHANGE, onChangeReg);
			
			this.target = _target;
		}
		
		protected function onRemoved(evt:Event = null):void {
			this.removeEventListener(Event.ACTIVATE, onControlActived);
			this.removeEventListener(Event.DEACTIVATE, onControlDeactived);
			this.removeEventListener(Event.CHANGE, onChange);
			_regCtrl.removeEventListener(Event.CHANGE, onChangeReg);
			
			_root.removeChild(_regCtrl);
			_regCtrl.dispose();
			_regCtrl = null;
		}
		
		//--------------------------------
		//--------public functions--------
		//--------------------------------
		
		public function update():void {
			if (_target == null) return;
			_originMX = this.getConcatenatedMatrix3D();
			_targetMX = _originMX.clone();
			_outReg = this.caculateOutterReg();
			
			interUpdate();
		}
		
		protected function interUpdate():void {
			var pos:Point = _target.local3DToGlobal(_innerReg);
			var pt:Point = this.getProjectionCenter();
			pos.x -= pt.x;
			pos.y -= pt.y;
			
			pos = this.globalToLocal(pos);
			
			if (_mode == Transform3DMode.GLOBAL) {
				_controlMX = new Matrix3D();
				_controlMX.position = new Vector3D(pos.x, pos.y, 0);
			}else if (_mode == Transform3DMode.INTERNAL) {
				_controlMX = _target.transform.getRelativeMatrix3D(_root);
				_controlMX.position = new Vector3D(pos.x, pos.y, 0);
			}
			
			if(_inited){
				updateControls();
				_root.forceRender();
			}
		}
		
		protected function updateControls():void {
			_deltaMx = _controlMX.clone();
			var comps:Vector.<Vector3D> = new Vector.<Vector3D>(3);
			comps[0] = new Vector3D(0, 0, 0, 0)
			comps[1] = _deltaMx.decompose()[1].clone();
			comps[2] = new Vector3D(1, 1, 1, 0);
			_deltaMx.recompose(comps);
			if(_perspective){
				for each(var ctrl:DimentionControl in _ctrls) {
					if (ctrl == _regCtrl) {
						_regCtrl.x = _controlMX.position.x;
						_regCtrl.y = _controlMX.position.y;
					}else {
						ctrl.matrix = _controlMX;
					}
				}
			}else{
				_root.x = _controlMX.position.x + this.getProjectionCenter().x;
				_root.y = _controlMX.position.y + this.getProjectionCenter().y;
			
				_skinContainer.x = _root.x;
				_skinContainer.y = _root.y;
			}
		}

		//--------------------------------
		//-------protected functions------
		//--------------------------------
		
		/**
		 * 目标是否有效
		 * @param	target
		 * @return
		 */
		public function isTargetValid(dp:DisplayObject):Boolean {
			return !(dp == this || (dp && contains(dp)) || (dp is DisplayObjectContainer && (dp as DisplayObjectContainer).contains(this)));
		}
		
		protected function clear():void {
			_target = null;
			_originMX = null;
			_targetMX = null;
			_controlMX = null;
			_root.visible = false;
			_skinContainer.visible = false;
			
			if (sp) sp.graphics.clear();
		}
		
		protected function onChangeReg(evt:Event):void {
			if (_target == null) return;
			_reg = new Point(stage.mouseX - _regCtrl.dragOffsetX, stage.mouseY - _regCtrl.dragOffsetY);
			_innerReg = _target.globalToLocal3D(_reg);
			_outReg = this.caculateOutterReg();
			
			this.interUpdate();
			
			this.dispatchEvent(new TransformEvent(TransformEvent.REGISTRATION));
		}
		
		private function onChange(evt:Event):void {
			if (_target == null) return;
			evt.stopImmediatePropagation();
			evt.preventDefault();
			
			//注册点的改变事件在onChangeReg中处理。
			if (evt.target == _regCtrl) return;
			
			_targetMX = _originMX.clone();
			
			this.onChangeControlValue(evt.target as DimentionControl);
			
			if (_target.parent.transform.matrix3D) {
				var invertMatrix : Matrix3D = _target.parent.transform.getRelativeMatrix3D(_root);
				invertMatrix.invert();
				_targetMX.append(invertMatrix);
			}
			
			_targetMX.append(_targetParentInvertMx);
			
			_target.transform.matrix3D = _targetMX;
			
			interUpdate();
			this.dispatchEvent(new TransformEvent(TransformEvent.UPDATE));
		}
		
		private function onControlActived(evt:Event):void {
			if (_target == null) return;
			if (!(evt.target is DimentionControl)) return;
			evt.stopImmediatePropagation();
			evt.preventDefault();
			
			_originMX = this.getConcatenatedMatrix3D();
			_targetMX = _originMX.clone();
			
			this.onActiveControl(evt.target as DimentionControl);
		}
		
		private function onControlDeactived(evt:Event):void {
			if (_target == null) return;
			if (!(evt.target is DimentionControl)) return;
			evt.stopImmediatePropagation();
			evt.preventDefault();
			
			this.onDeactiveControl(evt.target as DimentionControl);
			this.interUpdate();
			this.dispatchEvent(new TransformEvent(TransformEvent.UPDATE));
		}
		
		protected function onChangeControlValue(ctrl:DimentionControl):void {
			
		}
		
		protected function onActiveControl(ctrl:DimentionControl):void {
			for each(var ctrl:DimentionControl in _ctrls) {
				if (ctrl == _regCtrl) continue;
				if (!ctrl.actived) {
					ctrl.alpha = 1;
				}else {
					ctrl.alpha = 1;
				}
			}
		}
		
		protected function onDeactiveControl(ctrl:DimentionControl):void {
			for each(var ctrl:DimentionControl in _ctrls) {
				if (ctrl == _regCtrl) continue;
				ctrl.alpha = 1;
			}
		}
		
		protected function getProjectionCenter():Point {
			var pt = _target.root.transform.perspectiveProjection.projectionCenter;
			pt = this.globalToLocal(pt);
			return pt;
		}
		
		/**
		 * 完全释放该对象
		 */
		public function dispose():void {
			onRemoved();
			this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		}
		
		private function getConcatenatedMatrix3D():Matrix3D {
			var mx:Matrix3D = _target.transform.getRelativeMatrix3D(_root);
			if(_target.parent.transform.matrix3D){
				return mx
			}else {
				mx.appendTranslation(_root.x, _root.y, _root.z);
				return mx;
			}
		}
		
		private var sp:Shape;
		private function caculateOutterReg():Vector3D {
			var parentMx:Matrix3D = _target.transform.getRelativeMatrix3D(_target.parent);
			var pos:Vector3D = parentMx.transformVector(_innerReg);
			
			if(_debug){
				if(sp == null){
					sp = new Shape();
					_target.parent.addChild(sp);
				}
				sp.graphics.clear();
				sp.graphics.beginFill(0xff0000);
				sp.graphics.drawCircle(0,  0, 20);
				sp.graphics.endFill();
				sp.x = pos.x;
				sp.y = pos.y;
				sp.z = pos.z;
			}
			return pos;
		}
	}

}