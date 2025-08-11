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
            return (a.logicalX < b.logicalX) ? -1 : (a.logicalX > b.logicalX ? 1 : 0);
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

        /**
         * Performs linear interpolation of a Y value given an X value
         * and two known points (x1, y1) and (x2, y2).
         *
         * <p>If the segment is vertical (x1 == x2) or the given X lies
         * outside the range [x1, x2], the specified <code>fallbackY</code>
         * is returned instead of interpolating.</p>
         *
         * @param x1 The X coordinate of the first point.
         * @param y1 The Y coordinate of the first point.
         * @param x2 The X coordinate of the second point.
         * @param y2 The Y coordinate of the second point.
         * @param x The X coordinate for which to interpolate a Y value.
         * @param fallbackY The value to return if interpolation is not possible
         *                  due to a vertical segment or extrapolation.
         *
         * @return The interpolated Y value, or <code>fallbackY</code> if
         *         the calculation cannot be performed.
         */
        public static function interpolateYAtX(x1:Number, y1:Number, x2:Number, y2:Number, x:Number, fallbackY:Number):Number {
            // Case 1: vertical segment
            if (x2 == x1)
                return fallbackY;

            var t:Number = (x - x1) / (x2 - x1);

            // Case 2: extrapolation
            if (t < 0 || t > 1)
                return fallbackY;

            // Normal interpolation
            return y1 + t * (y2 - y1);
        }


    }
}
