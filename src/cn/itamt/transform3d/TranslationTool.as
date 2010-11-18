package cn.itamt.transform3d 
{
	import cn.itamt.transform3d.controls.*;
	import cn.itamt.transform3d.cursors.*;
	import cn.itamt.transform3d.controls.translation.*;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author tamt
	 */
	public class TranslationTool extends TransformControl
	{
		protected var _xCtrl:XTranslationControl;
		protected var _yCtrl:YTranslationControl;
		protected var _zCtrl:ZTranslationControl;
		
		public function TranslationTool() 
		{
		}
		
		override protected function onAdded(evt:Event = null):void {
			_xCtrl = new XTranslationControl();
			_yCtrl = new YTranslationControl();
			_zCtrl = new ZTranslationControl();
			_ctrls = [_xCtrl, _yCtrl, _zCtrl];
			
			_xCtrl.setCursor(new XControlCursor);
			_yCtrl.setCursor(new YControlCursor);
			_zCtrl.setCursor(new ZControlCursor);
			
			_root.addChild(_xCtrl);
			_root.addChild(_yCtrl);
			_root.addChild(_zCtrl);
			
			super.onAdded(evt);
		}
		
		override protected function onRemoved(evt:Event = null):void {
			super.onRemoved(evt);
			
			_xCtrl.dispose();
			_yCtrl.dispose();
			_zCtrl.dispose();
			_regCtrl.dispose();
			
			_xCtrl = null;
			_yCtrl = null;
			_xCtrl = null;
			_regCtrl = null;
		}
		
		//-------------------------------------
		//-------------------------------------
		//-------------------------------------
		protected override function onChangeControlValue(ctrl:DimentionControl):void {
			if(_mode == Transform3DMode.INTERNAL){
				_targetMX.prependTranslation(_xCtrl.distance, _yCtrl.distance, _zCtrl.distance);
			}else if (_mode == Transform3DMode.GLOBAL) {
				_targetMX.appendTranslation(_xCtrl.distance, _yCtrl.distance, _zCtrl.distance);
			}
		}
		
	}

}