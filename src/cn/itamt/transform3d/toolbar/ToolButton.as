package cn.itamt.transform3d.toolbar 
{
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	
	/**
	 * ...
	 * @author tamt
	 */
	public class ToolButton extends SimpleButton
	{
		private var _active:Boolean;
		
		private var _originUpState:DisplayObject;
		private var _originDownState:DisplayObject;
		private var _originOverState:DisplayObject;
		
		public function ToolButton() 
		{
			
		}
		
		public function set active(val:Boolean):void {
			if (_originDownState == null)_originDownState = this.downState;
			if (_originUpState == null)_originUpState = this.upState;
			if (_originOverState == null)_originOverState = this.overState;
			
			if (_active == val) return;
			_active = val;
			
			if (_active) {
				this.upState = this._originDownState;
				this.overState = this._originOverState;
				this.downState = this._originUpState;
			}else {
				this.upState = this._originUpState;
				this.overState = this._originOverState;
				this.downState = this._originDownState;
			}
		}
		
		public function get active():Boolean {
			return _active;
		}
		
	}

}