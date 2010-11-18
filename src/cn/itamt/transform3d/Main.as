package cn.itamt.transform3d
{
	import cn.itamt.transform3d.controls.Control;
	import cn.itamt.transform3d.controls.rotation.*;
	import cn.itamt.transform3d.controls.TransformControl;
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
	
	/**
	 * ...
	 * @author tamt
	 */
	public class Main extends Sprite 
	{
		
		public var test:MovieClip;
		public var mode:TextField;
		
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
			
			test.rotationX = test.rotationY = test.rotationZ = 20;
			
			rotationTool = new RotationTool();
			addChild(rotationTool);
			rotationTool.target = test;
			rotationTool.addEventListener(TransformEvent.UPDATE, onRotate);
			
			translationTool = new TranslationTool();
			addChild(translationTool);
			translationTool.target = test;
			translationTool.addEventListener(TransformEvent.UPDATE, onTranslate);
			
			//改变模式
			mode.text = Transform3DMode.toString(rotationTool.mode);
			mode.addEventListener(MouseEvent.CLICK, onClickMode);
			
		}
		
		private function onRotate(evt:Event):void {
			translationTool.update();
		}
		
		private function onTranslate(evt:Event):void {
			rotationTool.update();
		}
		
		private function onClickMode(evt:MouseEvent):void {
			if (rotationTool.mode == Transform3DMode.INTERNAL) {
				translationTool.mode = rotationTool.mode = Transform3DMode.GLOBAL;
			}else {
				translationTool.mode = rotationTool.mode = Transform3DMode.INTERNAL;
			}
			
			mode.text = Transform3DMode.toString(rotationTool.mode);
		}
		
	}
	
}