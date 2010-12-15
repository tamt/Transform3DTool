package cn.itamt.transform3d
{
	import cn.itamt.transform3d.controls.Control;
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
	
	/**
	 * ...
	 * @author tamt
	 */
	public class Main extends Sprite 
	{
		public var mode:TextField;
		public var test:MovieClip;
		
		private var tool3d:Transform3DTool
		private var tTool:TranslationTool;
		private var rTool:RotationTool;
		private var gTool:GlobalTranslationTool;
		
		public function Main():void 
		{
			
			var _root:Scene3D = new Scene3D();
			this.addChild(_root);
			var sp:Shape3D = new Shape3D();
			sp.graphics3D.beginFill(0xff00ff);
			Util.drawWedge3D(sp.graphics3D, 100, 100, 50, 180, 100, 10);
			sp.graphics3D.endFill();
			_root.addChild(sp);
						
			tool3d = new Transform3DTool();
			addChild(tool3d);
			init();
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			CustomMouseCursor.init(this.stage);
			
			//test.x = 30;
			//test.y = 30;
			//test.rotation = 20;
			
			//tTool = new TranslationTool();
			//addChild(tTool);
			
			//rTool = new RotationTool();
			//addChild(rTool);
			
			//gTool = new GlobalTranslationTool();
			//addChild(gTool);
			
			this.stage.addEventListener(MouseEvent.MOUSE_DOWN, onClickSth);
		}
		
		private function onClickSth(evt:MouseEvent):void {
			
			if(tool3d){
				if (evt.target is DisplayObject) {
					if(evt.target is Stage){
						tool3d.target = null;
						return;
					}
					tool3d.target = evt.target as DisplayObject;
				}
			}
			
			if(tTool){
				if (evt.target is MovieClip) {
					tTool.target = evt.target as MovieClip;
				}else if(evt.target is Stage){
					tTool.target = null;
				}
			}
			
			if(rTool){
				if (evt.target is MovieClip) {
					rTool.target = evt.target as MovieClip;
				}else if(evt.target is Stage){
					rTool.target = null;
				}
			}
			
			if (gTool) {
				if (evt.target is MovieClip) {
					gTool.target = evt.target as MovieClip;
				}else if(evt.target is Stage){
					gTool.target = null;
				}
			}
		}
				
	}
	
}