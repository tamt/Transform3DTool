package {
	import cn.itamt.transform3d.*;
	import cn.itamt.transform3d.controls.*;
	import cn.itamt.transform3d.controls.rotation.*;
	import cn.itamt.transform3d.controls.TransformControl;
	import cn.itamt.transform3d.controls.translation.GlobalTranslationControl;
	import cn.itamt.transform3d.controls.translation.XTranslationControl;
	import cn.itamt.transform3d.controls.translation.YTranslationControl;
	import cn.itamt.transform3d.cursors.*;
	import cn.itamt.transform3d.events.TransformEvent;
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix3D;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import flash.geom.Utils3D;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	import net.badimon.five3D.display.Scene3D;
	import net.badimon.five3D.display.Shape3D;
	import net.badimon.five3D.utils.InternalUtils;
	
	import fl.controls.ColorPicker;
	import fl.controls.CheckBox;
	import fl.controls.Slider;
	
	/**
	 * ...
	 * @author tamt
	 */
	public class Tfm3DToolDemo extends Sprite 
	{
		public var test:MovieClip;
		public var showFullControl_cb:CheckBox;
		public var showOutCircle_cb:CheckBox;
		public var xcolor_cp:ColorPicker;
		public var ycolor_cp:ColorPicker;
		public var zcolor_cp:ColorPicker;
		public var ocolor_cp:ColorPicker;
		public var rect_cp:ColorPicker;
		public var radius_sd:Slider;
		public var size_sd:Slider;
		public var arrow_w_sd:Slider;
		public var arrow_h_sd:Slider;
		
		private var tool3d:Transform3DTool
		
		public function Tfm3DToolDemo():void 
		{
			tool3d = new Transform3DTool();
			addChild(tool3d);
			
			test.rotationY = 20;
			test.mc1.mc2.rotationY = -60;
			test.mc1.mc3.rotationZ = 20;
			
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
			
			this.showOutCircle_cb.selected = tool3d.rotationTool.showOutCircle;
			this.radius_sd.value = tool3d.rotationTool.radius;
			this.size_sd.value = tool3d.translationTool.size;
			this.arrow_w_sd.value = tool3d.translationTool.arrowSize.x;
			this.arrow_h_sd.value = tool3d.translationTool.arrowSize.y;
			
			xcolor_cp.selectedColor = tool3d.rotationTool.xControl.style.borderColor;
			ycolor_cp.selectedColor = tool3d.rotationTool.yControl.style.borderColor;
			zcolor_cp.selectedColor = tool3d.rotationTool.zControl.style.borderColor;
			ocolor_cp.selectedColor = tool3d.rotationTool.outCircleStyle.borderColor;
			rect_cp.selectedColor = tool3d.globalTranslationTool.ctrl.style.borderColor;
			
			//listen value config
			xcolor_cp.addEventListener(Event.CHANGE, onConfigValueChange);
			ycolor_cp.addEventListener(Event.CHANGE, onConfigValueChange);
			zcolor_cp.addEventListener(Event.CHANGE, onConfigValueChange);
			ocolor_cp.addEventListener(Event.CHANGE, onConfigValueChange);
			rect_cp.addEventListener(Event.CHANGE, onConfigValueChange);
			radius_sd.addEventListener(Event.CHANGE, onConfigValueChange);
			size_sd.addEventListener(Event.CHANGE, onConfigValueChange);
			arrow_w_sd.addEventListener(Event.CHANGE, onConfigValueChange);
			arrow_h_sd.addEventListener(Event.CHANGE, onConfigValueChange);
			
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
			}
		}
		
		private function onConfigValueChange(evt:Event):void {
			var style:Style;
			switch(evt.target) {
				case this.xcolor_cp:
					tool3d.rotationTool.xControl.style = new Style(xcolor_cp.selectedColor, .7, xcolor_cp.selectedColor, 1, 2);
					break;
				case this.ycolor_cp:
					tool3d.rotationTool.yControl.style = new Style(ycolor_cp.selectedColor, .7, ycolor_cp.selectedColor, 1, 2);
					break;
				case this.zcolor_cp:
					tool3d.rotationTool.zControl.style = new Style(zcolor_cp.selectedColor, .7, zcolor_cp.selectedColor, 1, 2);
					break;
				case this.ocolor_cp:
					tool3d.rotationTool.outCircleStyle = new Style(0, 0, ocolor_cp.selectedColor, .8, 2);
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
	}
	
}