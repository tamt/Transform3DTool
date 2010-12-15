package cn.itamt.transform3d.controls 
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.geom.Matrix3D;
	
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
		
		function update(concatenatedMX:Matrix3D = null, controlMX:Matrix3D = null, deltaMX:Matrix3D = null, outReg:Vector3D = null):void;
	}
	
}
