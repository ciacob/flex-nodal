package com.github.ciacob.flexnodal.utils {

    /**
     * A physical screen coordinate where a Node's marker actually lives.
     */
    public class ScreenPoint {

        public var x:Number;
        public var y:Number;
        public var synthetic:Boolean;

        public function ScreenPoint(x:Number = 0, y:Number = 0, synthetic:Boolean = false) {
            this.x = x;
            this.y = y;
            this.synthetic = synthetic;
        }
    }
}