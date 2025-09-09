package com.github.ciacob.flexnodal.utils {
    import flash.geom.Point;

    /**
     * Describes an edit operation for a chart.
     *
     * Holds a unique identifier alongside a list of points that
     * define the edit. The received values are copied on
     * construction and further access to them is read only.
     */
    public class ChartEdit {

        private var _uid:String;
        private var _values:Vector.<Point>;
        private var _name:String;

        /**
         * Creates a new ChartEdit instance.
         *
         * @param uid     Unique identifier for this edit.
         * @param values  Collection of points describing the edit.
         * @param name    Optional friendly name; defaults to `uid` when null.
         */
        public function ChartEdit(uid:String, values:Vector.<Point>, name:String = null) {
            _uid = uid;
            _name = name != null ? name : uid;
            _values = values ? values.concat() : new <Point>[];
        }

        /** Returns the unique identifier of this edit. */
        public function get uid():String {
            return _uid;
        }

        /** Returns the human-friendly name of this edit. */
        public function get name():String {
            return _name;
        }

        /**
         * Returns the points describing this edit.
         *
         * A fresh copy is returned so callers can safely modify it
         * without affecting internal state.
         */
        public function get values():Vector.<Point> {
            return _values.concat();
        }

        /**
         * Returns a string representation of this ChartEdit instance.
         * 
         * Includes all properties: uid, name, and all values (points).
         * Each point is displayed as (x,y) coordinates.
         * 
         * @return A formatted string containing the uid, name, and all point values.
         */
        public function toString():String {
            var result:String = "ChartEdit {";
            result += " uid: '" + _uid + "'";
            result += ", name: '" + _name + "'";
            result += ", values: [";
            
            for (var i:int = 0; i < _values.length; i++) {
                if (i > 0) {
                    result += ", ";
                }
                var point:Point = _values[i];
                result += "(" + point.x + "," + point.y + ")";
            }
            
            result += "] }";
            return result;
        }

    }
}
