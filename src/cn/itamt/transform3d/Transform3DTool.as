package cn.itamt.transform3d 
{
	import cn.itamt.transform3d.controls.Control;
	import cn.itamt.transform3d.controls.ITransformControl;
	import cn.itamt.transform3d.controls.TransformControl;
	import cn.itamt.transform3d.controls.translation.GlobalTranslationControl;
	import cn.itamt.transform3d.cursors.CustomMouseCursor;
	import cn.itamt.transform3d.events.TransformEvent;
	import cn.itamt.transform3d.toolbar.ToolBar;
	import cn.itamt.transform3d.toolbar.ToolButton;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
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
		
		//操作条相关
		protected var _tToolBtn:ToolButton;
		protected var _rToolBtn:ToolButton;
		protected var _modeBtn:ToolButton;
		private var _bar:ToolBar;
		
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
			
			_modeBtn.active = _mode != Transform3DMode.INTERNAL;
		}
		
		protected var _tool:String = "rotation";
		internal function get tool():String {
			return _tool;
		}
		internal function set tool(val:String):void {
			if (val != "rotation" && val != "translation") return;
			
			_tool = val;
			if (_tool == "rotation") {
				_rToolBtn.active = true;
				if (!this.contains(_rTool)) addChild(_rTool);
				_tToolBtn.active = false;
				if (this.contains(_tTool)) removeChild(_tTool);
			}else if (_tool == "translation") {
				_rToolBtn.active = false;
				if (this.contains(_rTool)) removeChild(_rTool);
				_tToolBtn.active = true;
				if (!this.contains(_tTool)) addChild(_tTool);
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
			
			if(_target){
				var rect:Rectangle = _target.getBounds(this);
				_bar.x = rect.x;
				_bar.y = rect.bottom;
				_bar.width = rect.width;
				if (!_bar.visible)_bar.visible = true;
			}else {
				_bar.visible = false;
			}
		}
		
		//注册点
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
		
		private var _tools:Array = [];
		public function Transform3DTool() 
		{
			_rTool = new RotationTool();
			addChild(_rTool);
			
			_tTool = new TranslationTool();
			addChild(_tTool);
			
			_gTool = new  GlobalTranslationTool();
			addChild(_gTool);
			
			_tools = [_rTool, _tTool, _gTool];
			
			//操作条相关
			_bar = new ToolBar();
			_tToolBtn = new TranslationToolButton();
			_rToolBtn = new RotationToolButton();
			_modeBtn = new TransformModeButton();
			_bar.addToolButton(_tToolBtn);
			_bar.addToolButton(_rToolBtn);
			_bar.addToolButton(_modeBtn, "right");
			addChildAt(_bar, 0);
			
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
			
			_bar.addEventListener(MouseEvent.CLICK, onClickToolButton);
		}
		
		protected override function onRemoved(evt:Event = null):void {
			super.onRemoved(evt);
			
			for each(var tool:TransformControl in _tools) {
				tool.removeEventListener(TransformEvent.UPDATE, onToolUpdate);
				tool.removeEventListener(TransformEvent.REGISTRATION, onRegistrationUpdate);
			}
			
			_bar.removeEventListener(MouseEvent.CLICK, onClickToolButton);
		}
		
		protected function onToolUpdate(evt:Event):void {
			var curTool:TransformControl = evt.target as TransformControl;
			for each(var tool:TransformControl in _tools) {
				if (tool != curTool) {
					tool.update();
				}
			}
			
			if(_target){
				var rect:Rectangle = _target.getBounds(this);
				_bar.x = rect.x;
				_bar.y = rect.bottom;
				_bar.width = rect.width;
			}
		}
		
		protected function onRegistrationUpdate(evt:Event):void {
			var curTool:TransformControl = evt.target as TransformControl;
			for each(var tool:TransformControl in _tools) {
				if (tool != curTool) {
					tool.registration = curTool.registration;
				}
			}
		}
		
		protected function onClickToolButton(evt:MouseEvent):void {
			if (evt.target is ToolButton) {
				switch(evt.target) {
					case _modeBtn:
						if (_modeBtn.active) {
							mode = Transform3DMode.INTERNAL;
						}else {
							mode = Transform3DMode.GLOBAL;
						}
						break;
					case _tToolBtn:
						if (_tToolBtn.active) {
							tool = "rotation";
						}else {
							tool = "translation";
						}
						break;
					case _rToolBtn:
						if (_rToolBtn.active) {
							tool = "translation";
						}else {
							tool = "rotation";
						}
						break;
				}
			}
		}
		
		//------------------------------------
		//-----------public functions---------
		//------------------------------------
		
		public function update():void {
			if (tool == "rotation") _rTool.update();
			if (tool == "translation")_tTool.update();
			_gTool.update();
		}
		
		/**
		 * 目标是否有效
		 * @param	target
		 * @return
		 */
		public function isTargetValid(dp:DisplayObject):Boolean {
			return !(dp == this || (dp is Stage) || (dp && contains(dp)) || (dp is DisplayObjectContainer && (dp as DisplayObjectContainer).contains(this)));
		}
		
	}

}