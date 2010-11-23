package cn.itamt.transform3d.controls 
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author tamt
	 */
	public interface ITransformControl 
	{
		function get mode():uint;
		function set mode(val:uint):void;
		
		function get target():DisplayObject;
		function set target(val:DisplayObject):void;
		
		function get registration():Point;
		function set registration(pt:Point):void;
		
		function isTargetValid(target:DisplayObject):Boolean;
		
		function update():void;
	}
	
}