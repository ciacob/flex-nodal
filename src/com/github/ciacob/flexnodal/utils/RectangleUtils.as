package com.github.ciacob.flexnodal.utils {
    import flash.geom.Rectangle;

    public class RectangleUtils {
        public static function intersects(a:Rectangle, b:Rectangle):Boolean {
            return a.intersects(b);
        }
    }
}
