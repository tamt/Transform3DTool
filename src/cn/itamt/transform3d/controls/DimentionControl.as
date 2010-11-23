package cn.itamt.transform3d.controls 
{
	import cn.itamt.transform3d.cursors.CustomMouseCursor;
	import cn.itamt.transform3d.Transform3DMode;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import net.badimon.five3D.display.Scene3D;
	import net.badimon.five3D.display.Shape3D;
	import net.badimon.five3D.display.Sprite3D;
	
	/**
	 * ...
	 * @author tamt
	 */
	public class DimentionControl extends Control
	{
		//鼠标拖动时显示值
		public var showValue:Boolean;
		
		//该control的值
		protected var _value:Number = 0;
		public function get value():Number {
			return _value;
		}
		
		protected var _isOnMouse:Boolean = false;
		protected var _textfield:TextField;
		protected var _cursor:DisplayObject;
		protected var _mousePoint:Point;
		protected var _mousePoint3D:Point;
		protected var _globalMousePoint:Point;
		protected var _startDragPoint:Point;
		protected var _startDragPoint3D:Point;
		protected var _stopDragPoint:Point;
		protected var _draging:Boolean;
		protected var _actived:Boolean;
		public function get actived():Boolean {
			return _actived;
		}
		//
		protected var _sp:Shape3D;
		public function get shape():Shape3D {
			return _sp;
		}
		
		protected var _style:Style;
		public function get style():Style {
			return _style;
		}
		public function set style(val:Style):void{
			_style = val;
		}
		
		//
		protected var _mode:uint;
		public function get mode():uint {
			return _mode;
		}
		public function set mode(val:uint):void {
			if (Transform3DMode.isInvalidMode(val)) return;
			
			_mode = val;
			
			if(_inited){
				clear();
				draw();
			}
		}
		
		//skin
		protected var _skin:DisplayObject;
		public function get skin():DisplayObject {
			return _skin;
		}
		public function set skin(val:DisplayObject):void {
			if (_skin) {
				clearListenersToSkin();
			}
			_skin = val;
			if (_skin) {
				buildListenersToSkin();
			}
		}
		
		//-------------------------
		//--------constructor------
		//-------------------------
		public function DimentionControl() 
		{
			_style = new Style(0x0000ff, .5, 0, 1, 1);
		}
		
		//-------------------------
		//-----basic functions-----
		//-------------------------
		
		override protected function onAdded(e:Event = null):void 
		{	
			super.onAdded(e);
			
			if (_sp == null) {
				_sp = new Shape3D();
				this.addChild(_sp);
			}
			
			if (_textfield == null) {
				_textfield = new TextField();
				_textfield.autoSize = "left";
				_textfield.mouseEnabled = _textfield.mouseWheelEnabled = _textfield.visible = false;
			}
			
			//addChild(_textfield);
			
			this.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			this.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, onOtherMouseUp);
			
			if (this.hitTestPoint(this.stage.mouseX, this.stage.mouseY, true)) {
				this.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));
			}
			
			if (_skin) this.buildListenersToSkin();
			
			_mousePoint = new Point(mouseX, mouseY);
			_mousePoint3D = _sp.mouseXY;
			_globalMousePoint = new Point(stage.mouseX, stage.mouseY);
			
			this.draw();
		}
		
		override protected function onRemoved(e:Event = null):void {
			super.onRemoved(e);
			
			this.clear();
			
			_mousePoint = null;
			_mousePoint3D = null;
			_globalMousePoint = null;
			_startDragPoint = null;
			_startDragPoint3D = null;
			_stopDragPoint = null;
			
			this.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
			this.removeEventListener(MouseEvent.ROLL_OUT, onRollOut);			
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			if (this.stage) {
				this.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				this.stage.removeEventListener(MouseEvent.MOUSE_UP, onOtherMouseUp);
			}
			
			if (_skin) this.clearListenersToSkin();
		}
		
		/**
		 * 完全释放该对象
		 */
		override public function dispose():void {
			onRemoved();
			this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			
			_cursor = null;
			
			super.dispose();
		}
		
		//----------------------------
		//------private functions-----
		//----------------------------
		private function onMouseDown(evt:MouseEvent):void {
			this.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			this._mousePoint.x = this.mouseX;
			this._mousePoint.y = this.mouseY;
			this._mousePoint3D = _sp.mouseXY;
			this._globalMousePoint.x = this.stage.mouseX;
			this._globalMousePoint.y = this.stage.mouseY;
			
			this._draging = true;
			this._startDragPoint = this._mousePoint.clone();
			this._startDragPoint3D = this._mousePoint3D.clone();
			
			if (CustomMouseCursor.cursor == _cursor) {
				CustomMouseCursor.lock();
			}
			
			_actived = true;
			
			this.onStartDrag();
			
			this.dispatchEvent(new Event(Event.ACTIVATE, true));
		}
		
		private function onMouseUp(evt:MouseEvent):void {
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			this._mousePoint.x = this.mouseX;
			this._mousePoint.y = this.mouseY;
			this._mousePoint3D = _sp.mouseXY;
			this._globalMousePoint.x = this.stage.mouseX;
			this._globalMousePoint.y = this.stage.mouseY;
			
			this._draging = false;
			this._stopDragPoint = this._mousePoint.clone();
			
			if (!this._isOnMouse && CustomMouseCursor.cursor == _cursor) {
				CustomMouseCursor.unlock();
				CustomMouseCursor.clear();
			}
			
			if (this._isOnMouse) {
				CustomMouseCursor.show(_cursor);
			}
			
			_actived = false;
			
			this.onStopDrag();
			
			this.dispatchEvent(new Event(Event.DEACTIVATE, true));
		}
		
		private function onOtherMouseUp(evt:MouseEvent):void {
			if (evt.target == this) return;
			if (this._isOnMouse) {
				if (_cursor && !_draging) {
					CustomMouseCursor.unlock();
					CustomMouseCursor.show(_cursor);
				}
			}
		}
		
		private function onMouseMove(evt:MouseEvent):void {
			this._mousePoint.x = this.mouseX;
			this._mousePoint.y = this.mouseY;
			this._mousePoint3D = _sp.mouseXY;
			this._globalMousePoint.x = this.stage.mouseX;
			this._globalMousePoint.y = this.stage.mouseY;
			
			this.onDraging();
			
			this.dispatchEvent(new Event(Event.CHANGE, true));
		}
		
		private function onRollOver(evt:MouseEvent = null):void {
			this._isOnMouse = true;
			if (_cursor && !_draging)CustomMouseCursor.show(_cursor);
		}
		
		private function onRollOut(evt:MouseEvent = null):void {
			this._isOnMouse = false;
			if (CustomMouseCursor.cursor == _cursor && !_draging) {
				CustomMouseCursor.unlock();
				CustomMouseCursor.clear();
			}
		}
		
		protected function buildListenersToSkin():void {
			_skin.addEventListener(MouseEvent.ROLL_OVER, onRollSkinOver);
			_skin.addEventListener(MouseEvent.ROLL_OUT, onRollSkinOut);
			_skin.addEventListener(MouseEvent.MOUSE_DOWN, onSkinMouseDown);
			
			if (_skin.hitTestPoint(this.stage.mouseX, this.stage.mouseY, true)) {
				_skin.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));
			}
		}
		
		protected function clearListenersToSkin():void {
			_skin.removeEventListener(MouseEvent.ROLL_OVER, onRollSkinOver);
			_skin.removeEventListener(MouseEvent.ROLL_OUT, onRollSkinOut);
			_skin.removeEventListener(MouseEvent.MOUSE_DOWN, onSkinMouseDown);
		}
		
		private function onRollSkinOver(evt:MouseEvent = null):void {
			evt.stopImmediatePropagation();
			evt.preventDefault();
			this.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER, true));
		}
		
		private function onRollSkinOut(evt:MouseEvent = null):void {
			evt.stopImmediatePropagation();
			evt.preventDefault();
			this.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT, true));
		}
		
		private function onSkinMouseDown(evt:MouseEvent = null):void {
			evt.stopImmediatePropagation();
			evt.preventDefault();
			this.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN, true));
		}
		//------------------------------
		//------protected functions-----
		//------------------------------
		
		protected function draw():void {
		}
		
		protected function clear():void {
			_sp.graphics3D.clear();
		}
		
		protected function onStartDrag():void {
			if(showValue)_textfield.visible = true;
		}
		
		protected function onDraging():void {
		}
		
		protected function onStopDrag():void {
			_textfield.text = "";
			_textfield.visible = false;
			_value = 0;
		}
		
		//------------------------------
		//---------public functions-----
		//------------------------------
		/**
		 * 设置该Control的鼠标指针
		 * @param	dp
		 */
		public function setCursor(dp:DisplayObject):void {
			_cursor = dp;
			if (CustomMouseCursor.cursor == _cursor) CustomMouseCursor.show(_cursor);
		}
	}

}