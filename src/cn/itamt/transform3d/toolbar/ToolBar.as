package cn.itamt.transform3d.toolbar 
{
	import cn.itamt.transform3d.controls.Control;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * tool bar, use for contains Transform3DTool icon tool button, and mode icon button.
	 * @author tamt
	 */
	public class ToolBar extends Sprite
	{
		protected var _width:Number;
		public override function set width(val:Number):void {
			_width = val;
			
			var minW:Number = 0;
			for each(var btn:ToolButton in _leftBtns) {
				minW += btn.width;
			}
			for each(var btn:ToolButton in _rightBtns) {
				minW += btn.width
			}
			minW += Math.max(0, _leftBtns.length -1) * _padding + Math.max(0, _rightBtns.length -1) * _padding;
			if (_leftBtns.length && _rightBtns.length) minW += _padding;
			
			_width = Math.max(_width, minW);
			
			onAdded();
		}
		
		protected var _inited:Boolean = false;
		protected var _leftBtns:Vector.<ToolButton>;
		protected var _rightBtns:Vector.<ToolButton>;
		protected var _padding:Number = 2;
		//-------------------------
		//--------constructor------
		//-------------------------
		
		public function ToolBar() 
		{
			
			_leftBtns = new Vector.<ToolButton>();
			_rightBtns = new Vector.<ToolButton>();
			
			if (stage) onAdded();
			else addEventListener(Event.ADDED_TO_STAGE, onInterAdded);
			
			addEventListener(Event.REMOVED_FROM_STAGE, onInterRemoved);
		}
		
		//-------------------------
		//-----basic functions-----
		//-------------------------
		
		private function onInterAdded(e:Event):void 
		{
			if (_inited) return;
			_inited = true;
			this.onAdded(e);
		}
		
		private function onInterRemoved(e:Event):void {
			if (!_inited) return;
			_inited = false;
			this.onInterRemoved(e);
		}		
		
		protected function onAdded(e:Event = null):void 
		{
			var i:int = 0;
			for (i = 0; i < _leftBtns.length; i++) {
				_leftBtns[i].y = _padding;
				_leftBtns[i].x = (i > 0?(_leftBtns[i - 1].x + _leftBtns[i - 1].width + _padding):0);
			}
			
			for (i = 0; i < _rightBtns.length; i++) {
				_rightBtns[i].y = _padding;
				_rightBtns[i].x = _width + (i > 0?(_rightBtns[i - 1].x -_padding):0) - _rightBtns[i].width;
			}
		}
		
		protected function onRemoved(e:Event = null):void
		{
		}
		
		//-------------------------
		//-----public functions----
		//-------------------------
		
		public function addToolButton(btn:ToolButton, align:String = "left"):void {
			var i:int;
			if(align == "left"){
				i = _leftBtns.indexOf(btn);
				if (i>=0) {
					_leftBtns.splice(i, 1);
				}
				_leftBtns.push(btn);
				addChild(btn);
			}else {
				i = _rightBtns.indexOf(btn);
				if (i>=0) {
					_rightBtns.splice(i, 1);
				}
				_rightBtns.push(btn);
				addChild(btn);
			}
			
			onAdded();
		}
		
		public function removeToolButton(btn:ToolButton):void {
			var i:int = _leftBtns.indexOf(btn);
			if (i>=0) {
				_leftBtns.splice(i, 1);
				removeChild(btn);
			}else {
				i = _rightBtns.indexOf(btn);
				if (i >= 0) {
					_rightBtns.splice(i, 1);
					removeChild(btn);
				}
			}
			
			onAdded();
		}

		/**
		 * dispose object completely
		 */
		public function dispose():void {
			onRemoved();
			this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		}
		
	}

}
