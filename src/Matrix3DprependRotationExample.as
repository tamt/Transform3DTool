package {
    import flash.display.MovieClip;
    import flash.display.Shape;
    import flash.display.Graphics;
    import flash.geom.*;
    import flash.events.Event;

    public class Matrix3DprependRotationExample extends MovieClip {
        private var ellipse:Shape = new Shape();
        private var triangle:Shape = new Shape();

        public function Matrix3DprependRotationExample():void {
            ellipse.graphics.beginFill(0xFF0000);
            ellipse.graphics.lineStyle(2);
            ellipse.graphics.drawEllipse(30, 40, 50, 40);
            ellipse.graphics.endFill();
            ellipse.x = 100;
            ellipse.y = 150;
            ellipse.z = 1;

            triangle.graphics.beginFill(0x0000FF);
            triangle.graphics.moveTo(0, 0);
            triangle.graphics.lineTo(40, 40);
            triangle.graphics.lineTo(80, 0);
            triangle.graphics.lineTo(0, 0);
            triangle.graphics.endFill();
            triangle.x = 200;
            triangle.y = 50;
            triangle.z = 1;

            addChild(ellipse);
            addChild(triangle);

            ellipse.addEventListener(Event.ENTER_FRAME, ellipseEnterFrameHandler);
            triangle.addEventListener(Event.ENTER_FRAME, triangleEnterFrameHandler);
        }

        private function ellipseEnterFrameHandler(e:Event):void{
            if(e.target.y > 0) {
                e.target.y -= 1;
                e.target.x -= 1;
            }
        }
        
        private function triangleEnterFrameHandler(e:Event):void{
            e.target.transform.matrix3D.pointAt(ellipse.transform.matrix3D.position,
                                                Vector3D.X_AXIS, Vector3D.Y_AXIS);
        }
    }
}