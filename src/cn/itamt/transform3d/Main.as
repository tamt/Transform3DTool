package cn.itamt.transform3d
{
	import cn.itamt.transform3d.controls.Control;
	import cn.itamt.transform3d.controls.rotation.*;
	import cn.itamt.transform3d.controls.TransformControl;
	import cn.itamt.transform3d.controls.translation.XTranslationControl;
	import cn.itamt.transform3d.controls.translation.YTranslationControl;
	import cn.itamt.transform3d.cursors.*;
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
	
	/**
	 * ...
	 * @author tamt
	 */
	public class Main extends Sprite 
	{
		
		public var test:MovieClip;
		public var mode:TextField;
		public var tool:TextField;
		
		var rotationTool:RotationTool;
		var translationTool:TranslationTool;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			CustomMouseCursor.init(this.stage);
			
			test.rotationX = test.rotationY = test.rotationZ = 45;
			
			rotationTool = new RotationTool();
			addChild(rotationTool);
			rotationTool.target = test;
			
			translationTool = new TranslationTool();
			addChild(translationTool);
			translationTool.target = null;
			
			//改变模式
			mode.text = Transform3DMode.toString(rotationTool.mode);
			mode.addEventListener(MouseEvent.CLICK, onClickMode);
			
			//工具选择
			tool.text = "rotation";
			tool.addEventListener(MouseEvent.CLICK, onClickTool);
				
		}
		
		private function onClickMode(evt:MouseEvent):void {
			if (rotationTool.mode == Transform3DMode.INTERNAL) {
				translationTool.mode = rotationTool.mode = Transform3DMode.GLOBAL;
			}else {
				translationTool.mode = rotationTool.mode = Transform3DMode.INTERNAL;
			}
			
			mode.text = Transform3DMode.toString(rotationTool.mode);
		}
		
		private function onClickTool(evt:MouseEvent):void {
			if (rotationTool.target == test) {
				rotationTool.target = null;
				translationTool.target = test;
				tool.text = "translation";
			}else {
				rotationTool.target = test;
				translationTool.target = null;
				tool.text = "rotation";	
			}
		}
		
	}
	
}