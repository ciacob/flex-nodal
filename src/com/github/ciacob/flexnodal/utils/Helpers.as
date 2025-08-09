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

    }
}