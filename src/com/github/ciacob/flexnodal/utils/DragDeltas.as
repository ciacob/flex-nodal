package com.github.ciacob.flexnodal.utils {

    /**
     * Support class to represent the boundaries marker dragging
     * operations must be confined to.
     */
    public class DragDeltas {

        public var leftDelta:int;
        public var topDelta:int;
        public var rightDelta:int;
        public var bottomDelta:int;

        public function DragDeltas(
                leftDelta:int,
                topDelta:int,
                rightDelta:int,
                bottomDelta:int
            ) {
            this.leftDelta = leftDelta;
            this.topDelta = topDelta;
            this.rightDelta = rightDelta;
            this.bottomDelta = bottomDelta;
        }

        /**
         * Returns a string representation of this class, for debug purposes.
         */
        public function toString():String {
            return '[DragBounds: (L T R B): ' + [leftDelta, topDelta, rightDelta, bottomDelta].join(',') + ']';
        }

    }
}