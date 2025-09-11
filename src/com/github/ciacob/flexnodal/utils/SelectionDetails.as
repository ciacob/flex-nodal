package com.github.ciacob.flexnodal.utils {
    import flash.geom.Point;

    /**
     * Immutable data container for selection details.
     */
    public class SelectionDetails {

        private var _selectedValue:Point;
        private var _selectedValues:Vector.<Point>;
        private var _selectionAnchor:Point;
        private var _chartName:String;

        public function SelectionDetails(selectedValue:Point, selectedValues:Vector.<Point>, selectionAnchor:Point, chartName:String = null) {
            _selectedValue = selectedValue ? selectedValue.clone() : null;
            _selectedValues = new <Point>[];
            if (selectedValues) {
                for each (var p:Point in selectedValues) {
                    _selectedValues.push(p.clone());
                }
            }
            _selectionAnchor = selectionAnchor ? selectionAnchor.clone() : null;
            _chartName = chartName;
        }

        public function get selectedValue():Point {
            return _selectedValue ? _selectedValue.clone() : null;
        }

        public function get selectedValues():Vector.<Point> {
            var copy:Vector.<Point> = new <Point>[];
            for each (var p:Point in _selectedValues) {
                copy.push(p.clone());
            }
            return copy;
        }

        public function get selectionAnchor():Point {
            return _selectionAnchor ? _selectionAnchor.clone() : null;
        }

        public function get chartName():String {
            return _chartName;
        }

        /**
         * Returns a string representation of the SelectionDetails object.
         * Includes all properties: selectedValue, selectedValues count, selectionAnchor, and chartName.
         * 
         * @return A string representation of this SelectionDetails instance.
         */
        public function toString():String {
            var result:String = "[SelectionDetails";
            
            // Add selectedValue
            result += " selectedValue=" + (_selectedValue ? "(" + _selectedValue.x + "," + _selectedValue.y + ")" : "null");
            
            // Add selectedValues count and details
            result += " selectedValues=[" + (_selectedValues ? _selectedValues.length : 0) + " items";
            if (_selectedValues && _selectedValues.length > 0) {
                result += ":";
                for (var i:int = 0; i < _selectedValues.length; i++) {
                    if (i > 0) result += ",";
                    result += "(" + _selectedValues[i].x + "," + _selectedValues[i].y + ")";
                }
            }
            result += "]";
            
            // Add selectionAnchor
            result += " selectionAnchor=" + (_selectionAnchor ? "(" + _selectionAnchor.x + "," + _selectionAnchor.y + ")" : "null");
            
            // Add chartName
            result += " chartName=" + (_chartName ? "\"" + _chartName + "\"" : "null");
            
            result += "]";
            return result;
        }
    }
}
