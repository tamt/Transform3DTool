package {
    import flash.display.MovieClip;
    import flash.display.Shape;
    import flash.geom.*;
    import flash.events.MouseEvent;
    
    public class Matrix3DprependRotationExample extends MovieClip {
        private var ellipse:Shape = new Shape();

        public function Matrix3DprependRotationExample():void {

            ellipse.graphics.beginFill(0xFF0000);
            ellipse.graphics.lineStyle(2);
            ellipse.graphics.drawEllipse(-50, -40, 100, 80);
            ellipse.graphics.endFill();

            ellipse.x = (this.stage.stageWidth / 2);
            ellipse.y = (this.stage.stageHeight / 2);
            ellipse.z = 1;
            
            addChild(ellipse);

            stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
        }

        private function mouseMoveHandler(e:MouseEvent):void {
            var y:int;
            var x:int;
            
            if(e.localX > ellipse.x) {
                y = (Math.round(e.localX) / 100);   
            } else {
                y = -(Math.round(e.localX) / 10);   
            }
            
            if(e.localY > ellipse.y) {
                x = (Math.round(e.localY) / 100);
            } else {
                x = -(Math.round(e.localY) / 100);
            }
            
            ellipse.transform.matrix3D.appendRotation(y, Vector3D.Y_AXIS, new Vector3D(50, 50, 50));
            ellipse.transform.matrix3D.appendRotation(x, Vector3D.X_AXIS, new Vector3D(50, 50, 50));
        }
        
    }
}