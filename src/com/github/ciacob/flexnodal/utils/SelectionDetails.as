package com.github.ciacob.flexnodal.utils {
    import flash.geom.Point;

    /**
     * Immutable data container for selection details.
     */
    public class SelectionDetails {

        private var _selectedValue:Point;
        private var _selectedValues:Vector.<Point>;
        private var _selectionAnchor:Point;

        public function SelectionDetails(selectedValue:Point, selectedValues:Vector.<Point>, selectionAnchor:Point) {
            _selectedValue = selectedValue ? selectedValue.clone() : null;
            _selectedValues = new <Point>[];
            if (selectedValues) {
                for each (var p:Point in selectedValues) {
                    _selectedValues.push(p.clone());
                }
            }
            _selectionAnchor = selectionAnchor ? selectionAnchor.clone() : null;
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
    }
}
