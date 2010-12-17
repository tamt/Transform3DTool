package transform3d 
{
	import transform3d.consts.Transform3DMode;
	import transform3d.consts.TransformToolMode;
	import transform3d.controls.Control;
	import transform3d.controls.ITransformControl;
	import transform3d.controls.Style;
	import transform3d.controls.TransformControl;
	import transform3d.controls.translation.GlobalTranslationControl;
	import transform3d.cursors.CustomMouseCursor;
	import transform3d.events.TransformEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.geom.Rectangle;

	/**
	 * Transform3DTool, contains two tool components: RotationTool, TranslationTool.
	 * @example
	 * var tool3d:Transform3DTool = new Transform3DTool();
	 * addChild(tool3d);
	 * 
	 * tool3d.target = mc1;
	 * 
	 * tool3d.addEventListener(TransformEvent.UPDATE, updateEventHandler);
	 * @author tamt
	 */
	public class Transform3DTool extends Control implements ITransformControl
	{
		private var _rTool:RotationTool;
		private var _tTool:TranslationTool;
		private var _gTool:GlobalTranslationTool;
		
		public function get rotationTool():RotationTool {
			return _rTool;
		}
		
		public function get translationTool():TranslationTool {
			return _tTool;
		}
		
		public function get globalTranslationTool():GlobalTranslationTool {
			return _gTool;
		}
				
		protected var _mode:uint = Transform3DMode.INTERNAL;
		public function get mode():uint {
			return _mode;
		}
		public function set mode(val:uint):void {
			if (Transform3DMode.isInvalidMode(val)) return;
			
			_mode = val;
			_rTool.mode = _mode;
			_tTool.mode = _mode;
			_gTool.mode = _mode;
		}
		
		protected var _tool:String = "rotation";
		public function get tool():String {
			return _tool;
		}
		public function set tool(val:String):void {
			if(TransformToolMode.isInvalidMode(val)) return;
			
			_tool = val;
			if (_tool == TransformToolMode.ROTATION){
				if (!this.contains(_rTool)) addChild(_rTool);
				if (this.contains(_tTool)) removeChild(_tTool);
			}else if (_tool == TransformToolMode.TRANSLATION) {
				if (this.contains(_rTool)) removeChild(_rTool);
				if (!this.contains(_tTool)) addChild(_tTool);
			}else if (_tool == TransformToolMode.ALL) {
				if (!this.contains(_tTool)) addChild(_tTool);
				if (!this.contains(_rTool)) addChild(_rTool);
			}
		}
		
		protected var _target:DisplayObject;
		public function get target():DisplayObject {
			return _target;
		}
		public function set target(val:DisplayObject):void {
			if (!this.isTargetValid(val)) return;
			
			_target = val;
			_rTool.target = _target;
			_tTool.target = _target;
			_gTool.target = _target;
		}
		
		//registration
		protected var _reg:Point;
		public function get registration():Point {
			return _reg;
		}
		public function set registration(pt:Point):void {
			_reg = pt.clone();
			_rTool.registration = _reg;
			_tTool.registration = _reg;
			_gTool.registration = _reg;
		}
		
		//--------------------------------
		//---------- styles --------------
		//--------------------------------
		protected var _xCtrlStyle:Style = new Style(0xff0000, .7, 0xff0000, .9,  1.5);
		public function get xCtrlStyle():Style {
			return _xCtrlStyle;
		}
		public function set xCtrlStyle(val:Style):void {
			_xCtrlStyle = val;
			if(_inited){
				_rTool.xCtrlStyle = _xCtrlStyle;
				_tTool.xCtrlStyle = _xCtrlStyle;
			}
		}
		
		protected var _yCtrlStyle:Style = new Style(0x00ff00, .7, 0x00ff00, .9,  1.5);
		public function get yCtrlStyle():Style {
			return _yCtrlStyle;
		}
		public function set yCtrlStyle(val:Style):void {
			_yCtrlStyle = val;
			if(_inited){
				_rTool.yCtrlStyle = _yCtrlStyle;
				_tTool.yCtrlStyle = _yCtrlStyle;
			}
		}
		
		protected var _zCtrlStyle:Style = new Style(0x0000ff, .7, 0x0000ff, .9,  1.5);
		public function get zCtrlStyle():Style {
			return _zCtrlStyle;
		}
		public function set zCtrlStyle(val:Style):void {
			_zCtrlStyle = val;
			if(_inited){
				_rTool.zCtrlStyle = _zCtrlStyle;
				_tTool.zCtrlStyle = _zCtrlStyle;
			}
		}
		
		//regctrl style
		protected var _regCtrlStyle:Style = new Style(0xffffff, 1, 0, 1, 1);;
		public function get regCtrlStyle():Style {
			return _regCtrlStyle;
		}
		public function set regCtrlStyle(val:Style):void {
			_regCtrlStyle = val;
			
			if (_inited) {
				_rTool.regCtrlStyle = _regCtrlStyle;
				_tTool.regCtrlStyle = _regCtrlStyle;
			}
		}
		
		//-------------------------------
		//---------tool components-------
		//-------------------------------
		private var _tools:Array = [];
		
		//---------------------------------
		//----------- constructor ---------
		//---------------------------------
		public function Transform3DTool() 
		{
			_rTool = new RotationTool();
			addChild(_rTool);
			
			_tTool = new TranslationTool();
			addChild(_tTool);
			
			_gTool = new  GlobalTranslationTool();
			addChild(_gTool);
			
			_tools = [_rTool, _tTool, _gTool];
			
			super();
			
			this.mode = _mode;
			this.target = _target;
			this.tool = _tool;
		}
		
		protected override function onAdded(evt:Event = null):void {
			super.onAdded(evt);
			
			CustomMouseCursor.init(this.stage);
			
			for each(var tool:TransformControl in _tools) {
				tool.addEventListener(TransformEvent.UPDATE, onToolUpdate);
				tool.addEventListener(TransformEvent.REGISTRATION, onRegistrationUpdate);
			}
		}
		
		protected override function onRemoved(evt:Event = null):void {
			super.onRemoved(evt);
			
			for each(var tool:TransformControl in _tools) {
				tool.removeEventListener(TransformEvent.UPDATE, onToolUpdate);
				tool.removeEventListener(TransformEvent.REGISTRATION, onRegistrationUpdate);
			}
			
		}
		
		protected function onToolUpdate(evt:Event):void {
			var curTool:TransformControl = evt.target as TransformControl;
			for each(var tool:TransformControl in _tools) {
				if (tool != curTool) {
					tool.update(curTool.concatenatedMX, curTool.controlMX, curTool.deltaMX, curTool.outReg);
				}
			}
			
			dispatchEvent(new TransformEvent(TransformEvent.UPDATE, true, true));
		}
		
		protected function onRegistrationUpdate(evt:Event):void {
			var curTool:TransformControl = evt.target as TransformControl;
			for each(var tool:TransformControl in _tools) {
				if (tool != curTool) {
					tool.registration = curTool.registration;
				}
			}
			
			dispatchEvent(new TransformEvent(TransformEvent.REGISTRATION, true, true));
		}
		
		
		//------------------------------------
		//-----------public functions---------
		//------------------------------------
		
		public function update(concatenatedMX:Matrix3D = null, controlMX:Matrix3D = null, deltaMX:Matrix3D = null, outReg:Vector3D = null):void {
			if (tool == "rotation" || tool == "all") _rTool.update(concatenatedMX, controlMX, deltaMX, outReg);
			if (tool == "translation" || tool == "all")_tTool.update(concatenatedMX, controlMX, deltaMX, outReg);
			_gTool.update(concatenatedMX, controlMX, deltaMX, outReg);
		}
		
		/**
		 * is target valid
		 * @param	target
		 * @return
		 */
		public function isTargetValid(dp:DisplayObject):Boolean {
			return !(dp == this || (dp is Stage) || (dp && contains(dp)) || (dp is DisplayObjectContainer && (dp as DisplayObjectContainer).contains(this)));
		}
		
	}

}
