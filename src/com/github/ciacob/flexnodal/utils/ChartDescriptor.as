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
            return (_dashStyle && _dashStyle.length > 0) ? _dashStyle.concat() : null;
        }

        /**
         * Returns a string representation of this ChartDescriptor instance.
         * 
         * @return A string containing all the properties of this ChartDescriptor,
         *         including the uid, name, hueFactor, actual values, and dash style.
         */
        public function toString():String {
            var result:String = "[ChartDescriptor";
            result += " uid=" + _uid;
            result += " name=" + _name;
            result += " hueFactor=" + _hueFactor;
            
            if (_values && _values.length > 0) {
                var valuesStr:String = "";
                for (var i:int = 0; i < _values.length; i++) {
                    if (i > 0) valuesStr += ",";
                    var point:Point = _values[i];
                    valuesStr += "(" + point.x + "," + point.y + ")";
                }
                result += " values=[" + valuesStr + "]";
            } else {
                result += " values=[]";
            }
            
            if (_dashStyle && _dashStyle.length > 0) {
                result += " dashStyle=[" + _dashStyle.join(",") + "]";
            } else {
                result += " dashStyle=null";
            }
            
            result += "]";
            return result;
        }

        
    }
}
