package com.github.ciacob.flexnodal.utils {

    import flash.geom.Point;

    /**
     * Immutable description of a chart instance.
     */
    public class ChartDescriptor {

        private var _uid:String;
        private var _values:Vector.<Point>;
        private var _name:String;
        private var _hueFactor:Number;
        private var _dashStyle:Vector.<Number>;

        public function ChartDescriptor(uid:String, values:Vector.<Point>, name:String = null, hueFactor:Number = 0, dashStyle:Vector.<Number> = null) {
            _uid = uid;
            _values = values ? values.concat() : new Vector.<Point>();
            _name = name != null ? name : uid;
            _hueFactor = hueFactor;
            _dashStyle = dashStyle ? dashStyle.concat() : null;
        }

        public function get uid():String {
            return _uid;
        }

        public function get values():Vector.<Point> {
            return _values.concat();
        }

        public function get name():String {
            return _name;
        }

        public function get hueFactor():Number {
            return _hueFactor;
        }

        public function get dashStyle():Vector.<Number> {
            return _dashStyle ? _dashStyle.concat() : null;
        }
    }
}
