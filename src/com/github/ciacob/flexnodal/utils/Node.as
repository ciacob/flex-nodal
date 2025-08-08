package com.github.ciacob.flexnodal.utils {
    /**
     * Support class to represent a chart "node". A node is a logical representation of
     * a marker. It contains information about the state of that marker (e.g.,
     * whether it is currently selected, its originating values, etc.).
     *
     * A "marker" is a visual representation of a chart line joint that can be interacted
     * with (e.g., via mouse).
     *
     * The two are loosely bound.
     */
    public class Node {
        public function Node(nx : Number = 0, ny: Number = 0, isSynthetic : Boolean = false) {
            this.nx = nx;
            this.ny = ny;
            this.isSynthetic = isSynthetic;

            // Nodes are created as "dirty" by default.
            this.isDirty = true;
        }

        // "Normalized", or "logic" X-axis value of this node, unrelated to actual
        // screen coordinates. Values are in the [0,1] range.
        public var nx:Number;

        // "Normalized", or "logic" Y-axis value of this node, unrelated to actual
        // screen coordinates. Values are in the [0,1] range.
        public var ny:Number;

        // `True` if this node has been automatically added to the left and/or right
        // of an incomplete chart dataset (a dataset not starting and/or ending at
        // `0`, `respectively `1` on the X-axis)
        public var isSynthetic:Boolean;

        // `True` if this node's corresponding marker is pending a redraw operation.
        public var isDirty:Boolean;

        // `True` if, on the next redraw operation, this node's corresponding marker
        // should be depicted as selected (e.g., different color, etc.).
        public var isSelected:Boolean;

        // `True` if, on the next redraw operation, this node's corresponding marker
        // should be depicted as mouse hovered (e.g., different color, etc.).
        public var isHovered:Boolean;

        /**
         * Returns a string representation of this class for debugging purposes.
         */
        public function toString () : String {
            return '[' + (isSynthetic? 'Synthetic Node: ' : 'Node: ') + nx + ',' + ny + ']';
        }
    }
}