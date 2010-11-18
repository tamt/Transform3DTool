package cn.itamt.transform3d
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Stage;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import net.badimon.five3D.display.Graphics3D;
	/**
	 * ...
	 * @author tamt
	 */
	public class Util
	{
		
		public static const RADIAN:Number = 180 / Math.PI;
		
		/**
		 * draws pie shaped wedges.  Could be employeed to draw pie charts.
		 * 
		 * @param target the Graphics on which the wedge is to be drawn.
		 * @param x x coordinate of the center point of the wedge
		 * @param y y coordinate of the center point of the wedge
		 * @param radius the radius of the wedge 
		 * @param arc the sweep of the wedge. negative values draw clockwise
		 * @param startAngle the starting angle in degrees
		 * @param yRadius [optional] the y axis radius of the wedge. 
		 * If not defined, then yRadius = radius.
		 * 
		 * based on mc.drawWedge() - by Ric Ewing (ric@formequalsfunction.com) - version 1.4 - 4.7.2002
		 */
		public static function drawWedge3D(target : Graphics3D, x : Number, y : Number, radius : Number, arc : Number, startAngle : Number = 0,  yRadius : Number = 0) : void {
			
			// if yRadius is undefined, yRadius = radius
			if (yRadius == 0) {
				yRadius = radius;
			}
			
			// move to x,y position
			target.moveTo( x, y );
			// if yRadius is undefined, yRadius = radius
			if (yRadius == 0) {
				yRadius = radius;
			}
			// Init vars
			var segAngle : Number, theta : Number, angle : Number, angleMid : Number, segs : Number, ax : Number, ay : Number, bx : Number, by : Number, cx : Number, cy : Number;
			// limit sweep to reasonable numbers
			if (Math.abs( arc ) > 360) {
				arc = 360;
			}
			// Flash uses 8 segments per circle, to match that, we draw in a maximum
			// of 45 degree segments. First we calculate how many segments are needed
			// for our arc.
			segs = Math.ceil( Math.abs( arc ) / 45 );
			// Now calculate the sweep of each segment.
			segAngle = arc / segs;
			// The math requires radians rather than degrees. To convert from degrees
			// use the formula (degrees/180)*Math.PI to get radians.
			theta = segAngle / Util.RADIAN;
			// convert angle startAngle to radians
			angle = startAngle / Util.RADIAN;
			// draw the curve in segments no larger than 45 degrees.
			if (segs > 0) {
				// draw a line from the center to the start of the curve
				ax = x + Math.cos( startAngle / Util.RADIAN) * radius;
				ay = y + Math.sin( startAngle / Util.RADIAN) * yRadius;
				target.lineTo( ax, ay );
				// Loop for drawing curve segments
				for (var i : int = 0; i < segs; ++i) {
					angle += theta;
					angleMid = angle - (theta / 2);
					bx = x + Math.cos( angle ) * radius;
					by = y + Math.sin( angle ) * yRadius;
					cx = x + Math.cos( angleMid ) * (radius / Math.cos( theta / 2 ));
					cy = y + Math.sin( angleMid ) * (yRadius / Math.cos( theta / 2 ));
					target.curveTo( cx, cy, bx, by );
				}
				// close the wedge by drawing a line to the center
				target.lineTo( x, y );
			}
		}
		
		public static function drawArc3D(target : Graphics3D, x : Number, y : Number, radius : Number, arc : Number, startAngle : Number = 0,  yRadius : Number = 0) : void {
			
			// if yRadius is undefined, yRadius = radius
			if (yRadius == 0) {
				yRadius = radius;
			}
			
			// if yRadius is undefined, yRadius = radius
			if (yRadius == 0) {
				yRadius = radius;
			}
			// Init vars
			var segAngle : Number, theta : Number, angle : Number, angleMid : Number, segs : Number, ax : Number, ay : Number, bx : Number, by : Number, cx : Number, cy : Number;
			// limit sweep to reasonable numbers
			if (Math.abs( arc ) > 360) {
				arc = 360;
			}
			// Flash uses 8 segments per circle, to match that, we draw in a maximum
			// of 45 degree segments. First we calculate how many segments are needed
			// for our arc.
			segs = Math.ceil( Math.abs( arc ) / 45 );
			// Now calculate the sweep of each segment.
			segAngle = arc / segs;
			// The math requires radians rather than degrees. To convert from degrees
			// use the formula (degrees/180)*Math.PI to get radians.
			theta = segAngle / Util.RADIAN;
			// convert angle startAngle to radians
			angle = startAngle / Util.RADIAN;
			// draw the curve in segments no larger than 45 degrees.
			if (segs > 0) {
				// draw a line from the center to the start of the curve
				ax = x + Math.cos( startAngle / Util.RADIAN ) * radius;
				ay = y + Math.sin( startAngle / Util.RADIAN ) * yRadius;
				target.moveTo( ax, ay );
				// Loop for drawing curve segments
				for (var i : int = 0; i < segs; ++i) {
					angle += theta;
					angleMid = angle - (theta / 2);
					bx = x + Math.cos( angle ) * radius;
					by = y + Math.sin( angle ) * yRadius;
					cx = x + Math.cos( angleMid ) * (radius / Math.cos( theta / 2 ));
					cy = y + Math.sin( angleMid ) * (yRadius / Math.cos( theta / 2 ));
					target.curveTo( cx, cy, bx, by );
				}
			}
		}
		
		/**
		 * 获取一个matrix在投射在屏幕上x角度
		 * @param	matrix
		 * @return
		 */
		public static function projectRotationY(matrix:Matrix3D):Number {
			var vt:Vector3D = Vector3D.Y_AXIS;
			vt = matrix.deltaTransformVector(vt);
			var a:Number = Math.atan2(vt.y, vt.x);
			
			return a * Util.RADIAN;
		}
		
		/**
		 * 获取一个matrix在投射在屏幕上y角度
		 * @param	matrix
		 * @return
		 */
		public static function projectRotationX(matrix:Matrix3D):Number {
			var mx:Matrix3D = matrix.clone();
			mx.prependRotation(-90, Vector3D.Z_AXIS);
			
			var vt:Vector3D = Vector3D.Y_AXIS;
			vt = mx.deltaTransformVector(vt);
			var a:Number = Math.atan2(vt.y, vt.x);
			
			return a * Util.RADIAN;
		}
		
		/**
		 * 获取一个matrix在投射在屏幕上y角度
		 * @param	matrix
		 * @return
		 */
		public static function projectRotationZ(matrix:Matrix3D):Number {
			var mx:Matrix3D = matrix.clone();
			mx.prependRotation(-90, Vector3D.Z_AXIS);
			
			var vt:Vector3D = Vector3D.Z_AXIS;
			vt = mx.deltaTransformVector(vt);
			var a:Number = Math.atan2(vt.y, vt.x);
			
			return a * Util.RADIAN;
		}
		
		/**
		 * 某对象的3d点映射到目标对象的坐标
		 * @param	vt
		 * @param	displayObject
		 * @return
		 */
		public static function local3DToTarget(local:DisplayObject, vt:Vector3D, target:DisplayObject):Point {
			return target.globalToLocal(local.local3DToGlobal(vt));
		}
		
	}

}