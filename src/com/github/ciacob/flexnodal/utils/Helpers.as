package com.github.ciacob.flexnodal.utils {

    import mx.core.UIComponent;

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
         * Helper, reads a CSS style with a fallback value.
         *
         * @param host - Host component to invoke `getStyle` on.
         * @param name - Name of the style to read.
         * @param fallback - Default value to assume if no style can be retrieved for given name.
         */
        public static function $getStyle(host:UIComponent, name:String, fallback:*):* {
            var val:* = host.getStyle(name);
            if (val === undefined) {
                return fallback;
            }
            return val;
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

        /**
         * Computes pixel coordinates and chart background geometry from existing nodes.
         * 
         * @param   host
         *          The UIComponent hosting the chart whose coordinates are to be computed.
         * 
         * @param   availableWidth
         *          The most up to date, precalculated width of the host.
         * 
         * @param   availableHeight
         *          The most up to date, precalculated height of the host.
         * 
         * @param   nodes
         *          Optional vector with all the logical "nodes" that represent this chart. If given, their `screenX` and `screenY` properties will be respectively calculated and set, as a side effect.
         */
        public static function computeChartCoords(
                host:UIComponent,
                availableWidth:Number,
                availableHeight:Number,
                nodes:Vector.<Node> = null):ChartCoordinates {
            if (!host || !availableWidth || !availableHeight) {
                return ChartCoordinates.empty();
            }

            // Styles
            const padding:Number = Helpers.$getStyle(host, "padding", DefaultStyles.DEFAULT_PADDING);
            const thickness:Number = Helpers.$getStyle(host, "lineThickness", DefaultStyles.DEFAULT_LINE_THICKNESS);

            const drawnMarkerRadius:Number = thickness * 2;
            const actualMarkerHalf:Number = thickness * 2.5;
            const actualMarkerSize:Number = actualMarkerHalf * 2;

            const plotsAreaX:Number = padding + actualMarkerHalf;
            const plotsAreaY:Number = padding + actualMarkerHalf;
            const plotsAreaW:Number = availableWidth - (padding * 2) - actualMarkerSize;
            const plotsAreaH:Number = availableHeight - (padding * 2) - actualMarkerSize;

            const bgAreaX:Number = padding;
            const bgAreaY:Number = padding;
            const bgAreaW:Number = availableWidth - (padding * 2);
            const bgAreaH:Number = availableHeight - (padding * 2);

            // Map normalized to pixel coords
            if (nodes && nodes.length) {
                for (var i:int = 0; i < nodes.length; i++) {
                    const node:Node = nodes[i];
                    node.screenX = plotsAreaX + node.logicalX * plotsAreaW;
                    node.screenY = plotsAreaY + (1 - node.logicalY) * plotsAreaH; // invert Y
                }
            }

            return new ChartCoordinates(
                    plotsAreaX, plotsAreaY, plotsAreaW, plotsAreaH,
                    bgAreaX, bgAreaY, bgAreaW, bgAreaH,
                    drawnMarkerRadius
                );
        }

    }
}
