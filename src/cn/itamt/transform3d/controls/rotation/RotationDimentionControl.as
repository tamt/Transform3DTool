package cn.itamt.transform3d.controls.rotation 
{
	import cn.itamt.transform3d.controls.DimentionControl;
	import cn.itamt.transform3d.controls.Style;
	import cn.itamt.transform3d.Transform3DMode;
	import cn.itamt.transform3d.Util;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	import net.badimon.five3D.display.Shape3D;
	import net.badimon.five3D.utils.InternalUtils;
	
	/**
	 * ...
	 * @author tamt
	 */
	public class RotationDimentionControl extends DimentionControl
	{	
		//显示内部坐标线
		public var showDimenLine:Boolean;
		
		protected var _radius:Number = 100;
		public function get radius():Number {
			return _radius;
		}
		public function set radius(val:Number):void{
			_radius = val;
			if (_inited) {
				this.draw();
			}
		}
		
		protected var _startAngle:Number;
		protected var _startAngle3D:Number;
		protected var _globalRegPoint:Point;
		
		//旋转的度数
		public function get degree():Number {
			return _value;
		}
		
		//饼状图形的样式
		protected var _wedgeStyle:Style;
		public function get wedgeStyle():Style {
			return _wedgeStyle;
		}
		public function set wedgeStyle(style:Style):void {
			_wedgeStyle = style;
		}
		
		
		/**
		 * 构造函数
		 */
		public function RotationDimentionControl() 
		{
			super();
			_wedgeStyle = new Style(0x0000ff, .7, 0x000000, 0);
			_style.borderThickness = 1.5;
		}
		
		override protected function onAdded(evt:Event = null):void {			
			super.onAdded(evt);
		}
		
		protected override function draw():void {
			if(showDimenLine){
				graphics3D.lineStyle(_style.borderThickness, _style.borderColor);
				graphics3D.moveToSpace(0, 0, 0);
				graphics3D.lineToSpace(_radius, 0, 0);
				graphics3D.lineStyle(_style.borderThickness, 0x00ff00);
				graphics3D.moveToSpace(0, 0, 0);
				graphics3D.lineToSpace(0, _radius, 0);
				graphics3D.lineStyle(_style.borderThickness, 0x0000ff);
				graphics3D.moveToSpace(0, 0, 0);
				graphics3D.lineToSpace(0, 0, _radius);
			}
		}
		
		override protected function onStartDrag():void {
			super.onStartDrag();
			
			var regVector:Vector3D = this.concatenatedMatrix.position;
			_globalRegPoint = new Point(regVector.x, regVector.y);
			_startDragPoint = new Point(InternalUtils.getScene(this).mouseX - _globalRegPoint.x, InternalUtils.getScene(this).mouseY - _globalRegPoint.y);
			
			_startAngle = Math.atan2(_startDragPoint.y, _startDragPoint.x)*Util.RADIAN;
			_startAngle3D = Math.atan2(_startDragPoint3D.y, _startDragPoint3D.x)*Util.RADIAN;
		}
		
		override protected function onDraging():void {
			_mousePoint.x = InternalUtils.getScene(this).mouseX - _globalRegPoint.x
			_mousePoint.y = InternalUtils.getScene(this).mouseY - _globalRegPoint.y;
			
			this.graphics3D.clear();
			this.graphics3D.lineStyle(_wedgeStyle.borderThickness, _wedgeStyle.borderColor, _wedgeStyle.borderAlpha);
			this.graphics3D.beginFill(_wedgeStyle.fillColor, _wedgeStyle.fillAlpha*.3);
			this.graphics3D.drawCircle(0, 0, _radius);
			this.graphics3D.endFill();
			
			this.graphics3D.beginFill(_wedgeStyle.fillColor, _wedgeStyle.fillAlpha);
			
			//计算该Control的值
			_value = Math.atan2(_mousePoint.y, _mousePoint.x) * Util.RADIAN - _startAngle;
			
			var showValueNum:int = int(_value);
			if (Math.abs(showValueNum) > 180) {
				if(showValueNum>0){
					showValueNum = showValueNum - 360;
				}else {
					showValueNum = showValueNum + 360;
				}
			}
			Util.drawWedge3D(this.graphics3D, 0, 0, this._radius, showValueNum, _startAngle3D);
			
			this.graphics3D.endFill();
			
			//显示度数
			if (showValue) {
				if (!_textfield.visible)_textfield.visible = true;
				_textfield.text = Math.round(showValueNum).toString();
				var pos:Point = Point.polar(20, (_startAngle + showValueNum / 2)/Util.RADIAN);
				_textfield.x = pos.x - _textfield.width / 2;
				_textfield.y = pos.y - _textfield.height / 2;
			}
		}
		
		override protected  function onStopDrag():void {
			super.onStopDrag();
			this.graphics3D.clear();
			//this.draw();
		}
		
		override public function dispose():void {
			_wedgeStyle = null;
			
			super.dispose();
		}
		
	}

}