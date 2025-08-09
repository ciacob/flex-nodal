package com.github.ciacob.flexnodal.utils {

    /**
     * Holder for various (potentially) generic helper functions.
     */
    public class Helpers {

        /**
         * To be used with Array/Vector `sort()`. Sorts a Nodes by their `nx` field.
         * @see Array.sort()
         */
        public static function byNx(a:Node, b:Node):int {
            if (a === b) {
                return 0;
            }
            if (!a) {
                return -1;
            }
            if (!b) {
                return 1;
            }
            return (a.nx < b.nx) ? -1 : (a.nx > b.nx ? 1 : 0);
        }

        /**
         * Given the current `_selectedNodes` after a splice at `selIndex`,
         * returns the most reasonable replacement selection.
         *
         * @param list - The selection vector after removal.
         * @param selIndex - The index where the removal occurred.
         * @return The replacement Node, or null if none available.
         */
        public static function getReplacement(list:Vector.<Node>, selIndex:int):Node {
            if (!list || list.length == 0) {
                return null;
            }
            // If selIndex is still within bounds, just return that slot.
            if (selIndex < list.length && selIndex >= 0) {
                return list[selIndex];
            }
            // If selIndex was beyond the last index, return new last.
            if (selIndex >= list.length) {
                return list[list.length - 1];
            }
            // Defensive fallback — should not be hit with valid indices.
            return null;
        }

    }
}