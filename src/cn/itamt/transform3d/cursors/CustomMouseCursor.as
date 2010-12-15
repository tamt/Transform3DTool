package cn.itamt.transform3d.cursors 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	/**
	 * use for custom mouse cursor display. Call CustomMouseCursor.init(stage) first. then call CustomMouseCursor.show(..) to display your cursor.
	 * @author tamt
	 */
	public class CustomMouseCursor
	{
		private static var _defaultCursor:String;
		private static var _cursor:DisplayObject;
		private static var _tracking:Boolean;
		private static var _locked:Boolean;
		
		private static var _stage:Stage;
		public static function get stage():Stage {
			return _stage;
		}
		
		public static function init(stage:Stage):void {
			_stage = stage;
		}
		
		public static function get cursor():DisplayObject {
			return _cursor;
		}
		
		/**
		 * display custom cursom
		 * @param	cursor 
		 */
		public static function show(cursor:DisplayObject = null):void {
			if (_locked) return;
			
			if (cursor == null) {
				if (_cursor) {
					startTrackMouse();
				}else{
					clear();
				}
			}else{			
				_defaultCursor = Mouse.cursor;
				
				if (_cursor && _cursor!=cursor) {
					_stage.removeChild(_cursor);
				}
				
				_cursor = cursor;
				_stage.addChild(_cursor);
				startTrackMouse();
			}
			
			if (_cursor)_cursor.visible = true;
			Mouse.hide();
		}
		
		/**
		 * hide cursor.
		 */
		public static function hide():void {
			if (_locked) return;
			
			if (_cursor) {
				_cursor.visible = false;
			}
			stopTrackMouse();
		}
		
		/**
		 * clear the custom cursor setting.
		 */
		public static function clear():void {
			if (_locked) return;
			
			if (_cursor) {
				if(_cursor.parent)_cursor.parent.removeChild(_cursor);
				_cursor = null;
			}
			
			stopTrackMouse();
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseOver);
			
			Mouse.show();
			Mouse.cursor = _defaultCursor?_defaultCursor:"auto";
		}
		
		/**
		 * lock cursor, the cursor won't be changed(show,clear,hide won't work) until unlock.
		 */
		public static function lock():void {
			_locked = true;
		}
		
		/**
		 * unlock cursor
		 */
		public static function unlock():void {
			_locked = false;
		}
		
		//-----------------------------------
		//-----------------------------------
		//---------private functions---------
		//-----------------------------------
		//-----------------------------------
		
		private static function startTrackMouse():void {			
			if (!_tracking) {
				_tracking = true;
				_stage.addEventListener(Event.ENTER_FRAME, keepCursorOnTop);
				_stage.addEventListener(Event.ENTER_FRAME, stickCursorToMouse);
				_stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave);
				
				stickCursorToMouse();
			}
		}
		
		private static function stopTrackMouse():void {
			_tracking = false;
			_stage.removeEventListener(Event.ENTER_FRAME, keepCursorOnTop);
			_stage.removeEventListener(Event.ENTER_FRAME, stickCursorToMouse);
			_stage.removeEventListener(Event.MOUSE_LEAVE, onMouseLeave);
		}
		
		private static function keepCursorOnTop(evt:Event = null):void {
			if (_cursor && _cursor.parent) {
				if (_cursor.parent.getChildIndex(_cursor) != _cursor.parent.numChildren - 1) {
					_cursor.parent.setChildIndex(_cursor, _cursor.parent.numChildren - 1);
				}
			}
		}
		
		private static function stickCursorToMouse(evt:Event = null ):void {
			if (_cursor) {
				_cursor.x = _stage.mouseX;
				_cursor.y = _stage.mouseY;
			}
		}
		
		private static function onMouseLeave(evt:Event):void {
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseOver);
			hide();
		}
		
		private static function onMouseOver(evt:MouseEvent):void {
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseOver);
			show();
		}
	}

}
