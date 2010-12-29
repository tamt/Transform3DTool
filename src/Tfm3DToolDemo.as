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
		//test example target.
		public var test:MovieClip;
		//control to toggle Transform3DTool.showFullControl
		public var showFullControl_cb:CheckBox;
		//control to define wether RotationTool show out circle or not.
		public var showOutCircle_cb:CheckBox;
		//controls to define the x/y/z control color
		public var xcolor_cp:ColorPicker;
		public var ycolor_cp:ColorPicker;
		public var zcolor_cp:ColorPicker;
		//control to define out circle color of RotationTool
		public var ocolor_cp:ColorPicker;
		//control to define out rectangle color of GlobalTranslationTool
		public var rect_cp:ColorPicker;
		//control to define registration control color of Transform3DTool
		public var reg_cp:ColorPicker;
		//control to define x/y/z control's radius of RotationTool
		public var radius_sd:Slider;
		//control to define x/y/z control's size of TranslationTool
		public var size_sd:Slider;
		
		//control to change the width/height of x/y/z control arrow of TranslationTool
		public var arrow_w_sd:Slider;
		public var arrow_h_sd:Slider;
		
		//tool selector bar
		//TranslationTool select button
		protected var _tToolBtn:ToolButton;
		//RotationTool select button
		protected var _rToolBtn:ToolButton;
		//ScaleTool select button
		private var _sToolBtn;
		//Transform3DMode select button
		protected var _modeBtn:ToolButton;
		//tool bar contains tool select buttons.
		private var _bar:ToolBar;
		
		//Transform3DTool exmaple instance
		private var tool3d:Transform3DTool;
		
		public function Tfm3DToolDemo():void 
		{
			//create a Transform3DTool instance
			tool3d = new Transform3DTool();
			addChild(tool3d);
			
			//rotate the test MovieClip
			test.rotationY = 20;
			test.mc1.mc2.rotationY = -60;
			test.mc1.mc2.rotationX = -20;
			test.mc1.mc3.rotationZ = 20;
			
			//create a tool selector bar
			_bar = new ToolBar();
			//translation tool button on selector bar
			_tToolBtn = new TranslationToolButton();
			//rotation tool button on selector bar
			_rToolBtn = new RotationToolButton();
			//scale tool button on selector bar
			_sToolBtn = new ScaleToolButton();
			//mode switch button on selector bar
			_modeBtn = new TransformModeButton();
			//add tool buttons to ToolBar
			_bar.addToolButton(_tToolBtn);
			_bar.addToolButton(_rToolBtn);
			_bar.addToolButton(_sToolBtn);
			//add mode button to ToolBar, align right
			_bar.addToolButton(_modeBtn, "right");
			addChild(_bar);
			
			//init the demo, listeners, setting target
			init();
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//setup tool3d cursors
			//set the x/y/z control's cursor of RotationTool
			tool3d.rotationTool.xCursor = new XControlCursor();
			tool3d.rotationTool.yCursor = new YControlCursor();
			tool3d.rotationTool.zCursor = new ZControlCursor();
			//set the registration control's cursor of RotationTool
			tool3d.rotationTool.regCursor = new RegistrationControlCursor();
			//set the perspective rotation control's cursor of RotationTool
			tool3d.rotationTool.pCursor = new PControlCursor();
			
			//set the x/y/z control's cursor of TranslationTool
			tool3d.translationTool.xCursor = new XControlCursor();
			tool3d.translationTool.yCursor = new YControlCursor();
			tool3d.translationTool.zCursor = new ZControlCursor();
			//set the registration control's cursor of RotationTool
			tool3d.translationTool.regCursor = new RegistrationControlCursor();
			//set the registration control's cursor of ScaleTool
			tool3d.scaleTool.cursor = new ScaleControlCursor();
			tool3d.scaleTool.regCursor = new RegistrationControlCursor();
			
			//set the global translation tool's cursor
			tool3d.globalTranslationTool.cursor = new GlobalTranslationCursor();
			
			//tool3d.selectTool("scale");
			tool3d.selectTool(TransformToolMode.GLOBAL_TRANSLATION);
			
			//set Transform3DTool's target.
			tool3d.target = test.mc1.mc2;
			
			//listen config controls value change event.
			showFullControl_cb.addEventListener(Event.CHANGE, onConfigValueChange);
			showOutCircle_cb.addEventListener(Event.CHANGE, onConfigValueChange);
			
			//set config controls value from Transform3DTool
			this.showOutCircle_cb.selected = tool3d.rotationTool.showOutCircle;
			this.radius_sd.value = tool3d.rotationTool.radius;
			this.size_sd.value = tool3d.translationTool.size;
			this.arrow_w_sd.value = tool3d.translationTool.arrowSize.x;
			this.arrow_h_sd.value = tool3d.translationTool.arrowSize.y;
			
			//set color control's value from Transform3DTool's control style
			xcolor_cp.selectedColor = tool3d.xCtrlStyle.borderColor;
			ycolor_cp.selectedColor = tool3d.yCtrlStyle.borderColor;
			zcolor_cp.selectedColor = tool3d.zCtrlStyle.borderColor;
			reg_cp.selectedColor = tool3d.regCtrlStyle.fillColor;
			
			ocolor_cp.selectedColor = tool3d.rotationTool.outCircleStyle.borderColor;
			rect_cp.selectedColor = tool3d.globalTranslationTool.ctrl.style.borderColor;
			
			//listen value config
			//listen color controls "change" event
			xcolor_cp.addEventListener(Event.CHANGE, onConfigValueChange);
			ycolor_cp.addEventListener(Event.CHANGE, onConfigValueChange);
			zcolor_cp.addEventListener(Event.CHANGE, onConfigValueChange);
			reg_cp.addEventListener(Event.CHANGE, onConfigValueChange);
			ocolor_cp.addEventListener(Event.CHANGE, onConfigValueChange);
			rect_cp.addEventListener(Event.CHANGE, onConfigValueChange);
			//listen size controls "change" event
			radius_sd.addEventListener(Event.CHANGE, onConfigValueChange);
			size_sd.addEventListener(Event.CHANGE, onConfigValueChange);
			arrow_w_sd.addEventListener(Event.CHANGE, onConfigValueChange);
			arrow_h_sd.addEventListener(Event.CHANGE, onConfigValueChange);
			
			//listen tool update
			tool3d.addEventListener(TransformEvent.UPDATE, onToolUpdate);
			
			//set up select bar tool buttons
			_tToolBtn.active = tool3d.toolInuse("translation");
			_rToolBtn.active = tool3d.toolInuse("rotation");
			_sToolBtn.active = tool3d.toolInuse("scale");
			_modeBtn.active = (tool3d.mode == Transform3DMode.GLOBAL);
			onToolUpdate();
			
			//listen bar select tool
			_bar.addEventListener(MouseEvent.CLICK, onClickToolButton);
			
			//listen select target
			this.stage.addEventListener(MouseEvent.MOUSE_DOWN, onClickSth);
		}
		
		//when user mouse select a target
		private function onClickSth(evt:MouseEvent):void {
			//is target invalid.
			//keep the target is or inside "test", or, set tool3d.target to null
			if ((evt.target == test) || test.contains(evt.target as DisplayObject)) {
				tool3d.target = evt.target as DisplayObject;
			}else if (evt.target is Stage) {
				tool3d.target = null;
			}
			
			if (tool3d.target) {
				//keep ToolBar at the bottom of target
				var rect:Rectangle = tool3d.target.getBounds(this);
				_bar.x = rect.x;
				_bar.y = rect.bottom;
				_bar.width = rect.width;
				if (!_bar.visible)_bar.visible = true;
			}else {
				//hide ToolBar if target is null
				_bar.visible = false;
			}

		}
		
		/**
		 * when user select tool/mode of Transform3DTool
		 * @param	evt
		 */
		protected function onClickToolButton(evt:MouseEvent):void {
			if (evt.target is ToolButton) {
				switch(evt.target) {
					case _modeBtn:
						//toggle mode button active status, and change the transform mode of Transform3DTool
						if (_modeBtn.active) {
							this.tool3d.mode = Transform3DMode.INTERNAL;
							_modeBtn.active = false;
						}else {
							this.tool3d.mode = Transform3DMode.GLOBAL;
							_modeBtn.active = true;
						}
						break;
					case _tToolBtn:
						//toggle TranslationTool select button active status when click TranslationToolButton
						_tToolBtn.active = !_tToolBtn.active;
						if (_tToolBtn.active) {
							tool3d.selectTool(TransformToolMode.TRANSLATION);
						}else {
							tool3d.deselectTool(TransformToolMode.TRANSLATION);
						}
						break;
					case _rToolBtn:
						//toggle RotationTool select button active status when click TranslationToolButton
						_rToolBtn.active = !_rToolBtn.active;
						if (_rToolBtn.active) {
							tool3d.selectTool(TransformToolMode.ROTATION);
						}else {
							tool3d.deselectTool(TransformToolMode.ROTATION);
						}
						break;
					case _sToolBtn:
						_sToolBtn.active = !_sToolBtn.active;
						if (_sToolBtn.active) {
							tool3d.selectTool(TransformToolMode.SCALE);
						}else {
							tool3d.deselectTool(TransformToolMode.SCALE);
						}
						break;
				}
			}
		}
		
		/**
		 * when config control change value.
		 * @param	evt
		 */
		private function onConfigValueChange(evt:Event):void {
			var style:Style;
			switch(evt.target) {
				case this.xcolor_cp:
					//x control color change.
					tool3d.xCtrlStyle = new Style(xcolor_cp.selectedColor, .7, xcolor_cp.selectedColor, 1, 2);
					break;
				case this.ycolor_cp:
					//y control color change.
					tool3d.yCtrlStyle = new Style(ycolor_cp.selectedColor, .7, ycolor_cp.selectedColor, 1, 2);
					break;
				case this.zcolor_cp:
					//z control color change.
					tool3d.zCtrlStyle = new Style(zcolor_cp.selectedColor, .7, zcolor_cp.selectedColor, 1, 2);
					break;
				case this.ocolor_cp:
					//RotationTool out circle control color change.
					tool3d.rotationTool.outCircleStyle = new Style(0, 0, ocolor_cp.selectedColor, .8, 2);
					break;
				case this.reg_cp:
					//Transform3DTool registration control color change
					tool3d.regCtrlStyle = new Style(this.reg_cp.selectedColor, 1, 0, 1, 1);
					break;
				case this.rect_cp:
					//GlobalTranslationTool rectangle color change
					tool3d.globalTranslationTool.ctrlStyle = new Style(0, NaN, this.rect_cp.selectedColor, 1, 1);
					break;
				case this.showFullControl_cb:
					//set RotationTool show full control or not
					tool3d.rotationTool.showFullControl = this.showFullControl_cb.selected;
					break;
				case this.showOutCircle_cb:
					//set RotationTool show out circle or not
					tool3d.rotationTool.showOutCircle = this.showOutCircle_cb.selected;
					break;
				case this.radius_sd:
					//set RotationTool's radius (size)
					tool3d.rotationTool.radius = this.radius_sd.value;
					break;
				case this.size_sd:
					//set Translation's x/y/z control size
					tool3d.translationTool.size = this.size_sd.value;
					break;
				case this.arrow_w_sd:
					//set Translation's x/y/z control arrow width
					tool3d.translationTool.arrowSize = new Point(this.arrow_w_sd.value, tool3d.translationTool.arrowSize.y);
					break;
				case this.arrow_h_sd:
					//set Translation's x/y/z control arrow height
					tool3d.translationTool.arrowSize = new Point(tool3d.translationTool.arrowSize.x, this.arrow_h_sd.value);
					break;
			}
		}
		
		/**
		 * when Transform3DTool transform target(update)
		 * @param	evt
		 */
		protected function onToolUpdate(evt:Event = null):void {
			var rect:Rectangle = tool3d.target.getBounds(this);
			_bar.x = rect.x;
			_bar.y = rect.bottom;
			_bar.width = rect.width;
		}
	}
	
}