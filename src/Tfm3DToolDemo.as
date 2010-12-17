package {
	import transform3d.consts.Transform3DMode;
	import transform3d.consts.TransformToolMode;
	import transform3d.toolbar.ToolBar;
	import transform3d.toolbar.ToolButton;
	
	import transform3d.*;
	import transform3d.controls.*;
	import transform3d.controls.rotation.*;
	import transform3d.cursors.*;
	import transform3d.events.TransformEvent;
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.*;
	import flash.text.TextField;
	import net.badimon.five3D.display.Scene3D;
	import net.badimon.five3D.display.Shape3D;
	import net.badimon.five3D.utils.InternalUtils;
	
	import fl.controls.ColorPicker;
	import fl.controls.CheckBox;
	import fl.controls.Slider;
	
	/**
	 * Transform3DTool demo. Useage example of Transform3DTool.
	 * @author tamt
	 */
	public class Tfm3DToolDemo extends Sprite 
	{
		//instances on Flash IDE
		public var test:MovieClip;
		public var showFullControl_cb:CheckBox;
		public var showOutCircle_cb:CheckBox;
		public var xcolor_cp:ColorPicker;
		public var ycolor_cp:ColorPicker;
		public var zcolor_cp:ColorPicker;
		public var ocolor_cp:ColorPicker;
		public var rect_cp:ColorPicker;
		public var reg_cp:ColorPicker;
		public var radius_sd:Slider;
		public var size_sd:Slider;
		public var arrow_w_sd:Slider;
		public var arrow_h_sd:Slider;
		
		//tool selector bar
		protected var _tToolBtn:ToolButton;
		protected var _rToolBtn:ToolButton;
		protected var _modeBtn:ToolButton;
		private var _bar:ToolBar;
		
		//
		private var tool3d:Transform3DTool;
		
		public function Tfm3DToolDemo():void 
		{
			tool3d = new Transform3DTool();
			addChild(tool3d);
			
			test.rotationY = 20;
			test.mc1.mc2.rotationY = -60;
			test.mc1.mc2.rotationX = -20;
			test.mc1.mc3.rotationZ = 20;
			
			//tool selector bar
			_bar = new ToolBar();
			_tToolBtn = new TranslationToolButton();
			_rToolBtn = new RotationToolButton();
			_modeBtn = new TransformModeButton();
			_bar.addToolButton(_tToolBtn);
			_bar.addToolButton(_rToolBtn);
			_bar.addToolButton(_modeBtn, "right");
			addChild(_bar);
			
			init();
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//setup tool3d cursors
			tool3d.rotationTool.xCursor = new XControlCursor();
			tool3d.rotationTool.regCursor = new RegistrationControlCursor();
			tool3d.rotationTool.yCursor = new YControlCursor();
			tool3d.rotationTool.zCursor = new ZControlCursor();
			tool3d.rotationTool.pCursor = new PControlCursor();
			tool3d.translationTool.xCursor = new XControlCursor();
			tool3d.translationTool.regCursor = new RegistrationControlCursor();
			tool3d.translationTool.yCursor = new YControlCursor();
			tool3d.translationTool.zCursor = new ZControlCursor();
			tool3d.globalTranslationTool.cursor = new GlobalTranslationCursor();
			
			//set target.
			tool3d.target = test.mc1.mc2;
			
			//listen config controls
			showFullControl_cb.addEventListener(Event.CHANGE, onConfigValueChange);
			showOutCircle_cb.addEventListener(Event.CHANGE, onConfigValueChange);
			
			//set config controls value
			this.showOutCircle_cb.selected = tool3d.rotationTool.showOutCircle;
			this.radius_sd.value = tool3d.rotationTool.radius;
			this.size_sd.value = tool3d.translationTool.size;
			this.arrow_w_sd.value = tool3d.translationTool.arrowSize.x;
			this.arrow_h_sd.value = tool3d.translationTool.arrowSize.y;
			
			xcolor_cp.selectedColor = tool3d.xCtrlStyle.borderColor;
			ycolor_cp.selectedColor = tool3d.yCtrlStyle.borderColor;
			zcolor_cp.selectedColor = tool3d.zCtrlStyle.borderColor;
			reg_cp.selectedColor = tool3d.regCtrlStyle.fillColor;
			
			ocolor_cp.selectedColor = tool3d.rotationTool.outCircleStyle.borderColor;
			rect_cp.selectedColor = tool3d.globalTranslationTool.ctrl.style.borderColor;
			
			//listen value config
			xcolor_cp.addEventListener(Event.CHANGE, onConfigValueChange);
			ycolor_cp.addEventListener(Event.CHANGE, onConfigValueChange);
			zcolor_cp.addEventListener(Event.CHANGE, onConfigValueChange);
			reg_cp.addEventListener(Event.CHANGE, onConfigValueChange);
			ocolor_cp.addEventListener(Event.CHANGE, onConfigValueChange);
			rect_cp.addEventListener(Event.CHANGE, onConfigValueChange);
			radius_sd.addEventListener(Event.CHANGE, onConfigValueChange);
			size_sd.addEventListener(Event.CHANGE, onConfigValueChange);
			arrow_w_sd.addEventListener(Event.CHANGE, onConfigValueChange);
			arrow_h_sd.addEventListener(Event.CHANGE, onConfigValueChange);
			
			//listen tool update
			tool3d.addEventListener(TransformEvent.UPDATE, onToolUpdate);
			
			//set up select bar tool buttons
			_tToolBtn.active = (tool3d.tool == "translation");
			_rToolBtn.active = (tool3d.tool == "rotation");
			_modeBtn.active = (tool3d.mode == Transform3DMode.GLOBAL);
			onToolUpdate();
			
			//listen bar select tool
			_bar.addEventListener(MouseEvent.CLICK, onClickToolButton);
			
			//listen select target
			this.stage.addEventListener(MouseEvent.MOUSE_DOWN, onClickSth);
		}
		
		private function onClickSth(evt:MouseEvent):void {
			if(tool3d){
				if ((evt.target == test) || test.contains(evt.target as DisplayObject)) {
					tool3d.target = evt.target as DisplayObject;
				}else if (evt.target is Stage) {
					tool3d.target = null;
				}
				
				if(tool3d.target){
					var rect:Rectangle = tool3d.target.getBounds(this);
					_bar.x = rect.x;
					_bar.y = rect.bottom;
					_bar.width = rect.width;
					if (!_bar.visible)_bar.visible = true;
				}else {
					_bar.visible = false;
				}

			}
		}
		
		/**
		 * select tool event
		 * @param	evt
		 */
		protected function onClickToolButton(evt:MouseEvent):void {
			if (evt.target is ToolButton) {
				switch(evt.target) {
					case _modeBtn:
						if (_modeBtn.active) {
							this.tool3d.mode = Transform3DMode.INTERNAL;
							_modeBtn.active = false;
						}else {
							this.tool3d.mode = Transform3DMode.GLOBAL;
							_modeBtn.active = true;
						}
						break;
					case _tToolBtn:
						_tToolBtn.active = !_tToolBtn.active;
						break;
					case _rToolBtn:
						_rToolBtn.active = !_rToolBtn.active;
						break;
				}
				
				if (_tToolBtn.active && _rToolBtn.active) {
					tool3d.tool = TransformToolMode.ALL;
				}else if (_tToolBtn.active) {
					tool3d.tool = TransformToolMode.TRANSLATION;
				}else if(_rToolBtn.active){
					tool3d.tool = TransformToolMode.ROTATION;
				}else{
					tool3d.tool = TransformToolMode.ROTATION;
					_rToolBtn.active = true;
				}
			}
		}
		
		private function onConfigValueChange(evt:Event):void {
			var style:Style;
			switch(evt.target) {
				case this.xcolor_cp:
					tool3d.xCtrlStyle = new Style(xcolor_cp.selectedColor, .7, xcolor_cp.selectedColor, 1, 2);
					break;
				case this.ycolor_cp:
					tool3d.yCtrlStyle = new Style(ycolor_cp.selectedColor, .7, ycolor_cp.selectedColor, 1, 2);
					break;
				case this.zcolor_cp:
					tool3d.zCtrlStyle = new Style(zcolor_cp.selectedColor, .7, zcolor_cp.selectedColor, 1, 2);
					break;
				case this.ocolor_cp:
					tool3d.rotationTool.outCircleStyle = new Style(0, 0, ocolor_cp.selectedColor, .8, 2);
					break;
				case this.reg_cp:
					tool3d.regCtrlStyle = new Style(this.reg_cp.selectedColor, 1, 0, 1, 1);
					break;
				case this.rect_cp:
					tool3d.globalTranslationTool.ctrl.style = new Style(0, 0, this.rect_cp.selectedColor, 1, 1);
					break;
				case this.showFullControl_cb:
					tool3d.rotationTool.showFullControl = this.showFullControl_cb.selected;
					break;
				case this.showOutCircle_cb:
					tool3d.rotationTool.showOutCircle = this.showOutCircle_cb.selected;
					break;
				case this.radius_sd:
					tool3d.rotationTool.radius = this.radius_sd.value;
					break;
				case this.size_sd:
					tool3d.translationTool.size = this.size_sd.value;
					break;
				case this.arrow_w_sd:
					tool3d.translationTool.arrowSize = new Point(this.arrow_w_sd.value, tool3d.translationTool.arrowSize.y);
					break;
				case this.arrow_h_sd:
					tool3d.translationTool.arrowSize = new Point(tool3d.translationTool.arrowSize.x, this.arrow_h_sd.value);
					break;
			}
		}
		
		protected function onToolUpdate(evt:Event = null):void {
			var rect:Rectangle = tool3d.target.getBounds(this);
			_bar.x = rect.x;
			_bar.y = rect.bottom;
			_bar.width = rect.width;
		}
	}
	
}