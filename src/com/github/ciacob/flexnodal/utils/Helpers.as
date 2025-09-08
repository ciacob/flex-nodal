package com.github.ciacob.flexnodal.utils {

    import mx.core.UIComponent;
    import mx.styles.CSSStyleDeclaration;
    import flash.geom.Point;

    /**
     * Holder for various (potentially) generic helper functions.
     */
    public class Helpers {

        /**
         * Trims given string
         */
        public static function trim(value:String):String {
            if (value) {
                return value.replace(/^\s+|\s+$/g, '');
            }
            return value;
        }

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
         * <p>Accepts either a <code>UIComponent</code> or a
         * <code>CSSStyleDeclaration</code> as <code>host</code>.</p>
         *
         * @param host - UIComponent or CSSStyleDeclaration to invoke `getStyle` on.
         * @param name - Name of the style to read.
         * @param fallback - Default value to assume if no style can be retrieved for given name.
         */
        public static function $getStyle(host:*, name:String, fallback:*):* {
            if (!host || !(host is UIComponent || host is CSSStyleDeclaration)) {
                return fallback;
            }

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
        public static function computeChartCoords(host:UIComponent, availableWidth:Number, availableHeight:Number, nodes:Vector.<Node> = null):ChartCoordinates {
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

            return new ChartCoordinates(plotsAreaX, plotsAreaY, plotsAreaW, plotsAreaH, bgAreaX, bgAreaY, bgAreaW, bgAreaH, drawnMarkerRadius);
        }

        /**
         * Computes and returns a hue based on a base color and a factor. Uses the 360 degrees color hues circle model.
         *
         * @param   baseColor
         *          The color to use as base for hie computation. Should not be black, or the computed hue will also be
         *          black, regardless of the factor used.
         *
         * @param   hueFactor
         *          A factor to resolve to a hue offset to use, for shifting the current color (e.g., 0.5 means -180 degrees,
         *          which results in the chromatically opposite color).
         *
         * @return  The computed hue.
         */
        public static function getHue(baseColor:uint, hueFactor:Number = NaN):uint {
            var newColor:uint = baseColor;

            // Only compute the new color if a hue factor was given
            if (!isNaN(hueFactor)) {

                var r:uint = (baseColor >> 16) & 0xFF;
                var g:uint = (baseColor >> 8) & 0xFF;
                var b:uint = baseColor & 0xFF;

                var hsv:Array = RGBtoHSV(r, g, b);
                var h:Number = hsv[0], s:Number = hsv[1], v:Number = hsv[2];
                h = (h + (hueFactor * 360 - 360)) % 360;

                // Normalize to 0–360
                if (h < 0) {
                    h += 360;
                }

                var rgb:Array = HSVtoRGB(h, s, v);
                newColor = (rgb[0] << 16) | (rgb[1] << 8) | rgb[2];
            }

            return newColor;
        }

        /**
         * Converts Red, Green, Blue to Hue, Saturation, Value
         * @r channel between 0-255
         * @s channel between 0-255
         * @v channel between 0-255
         */
        public static function RGBtoHSV(r:uint, g:uint, b:uint):Array {
            var max:uint = Math.max(r, g, b);
            var min:uint = Math.min(r, g, b);

            var hue:Number = 0;
            var saturation:Number = 0;
            var value:Number = 0;

            var hsv:Array = [];

            // get Hue
            if (max == min) {
                hue = 0;
            } else if (max == r) {
                hue = (60 * (g - b) / (max - min) + 360) % 360;
            } else if (max == g) {
                hue = (60 * (b - r) / (max - min) + 120);
            } else if (max == b) {
                hue = (60 * (r - g) / (max - min) + 240);
            }

            // get Value
            value = max;

            // get Saturation
            if (max == 0) {
                saturation = 0;
            } else {
                saturation = (max - min) / max;
            }

            hsv = [Math.round(hue), Math.round(saturation * 100), Math.round(value / 255 * 100)];
            return hsv;
        }

        /**
         * Converts Hue, Saturation, Value to Red, Green, Blue
         * @h Angle between 0-360
         * @s percent between 0-100
         * @v percent between 0-100
         */
        public static function HSVtoRGB(h:Number, s:Number, v:Number):Array {
            var r:Number = 0;
            var g:Number = 0;
            var b:Number = 0;
            var rgb:Array = [];

            var tempS:Number = s / 100;
            var tempV:Number = v / 100;

            var hi:int = Math.floor(h / 60) % 6;
            var f:Number = h / 60 - Math.floor(h / 60);
            var p:Number = (tempV * (1 - tempS));
            var q:Number = (tempV * (1 - f * tempS));
            var t:Number = (tempV * (1 - (1 - f) * tempS));

            switch (hi) {
                case 0:
                    r = tempV;
                    g = t;
                    b = p;
                    break;
                case 1:
                    r = q;
                    g = tempV;
                    b = p;
                    break;
                case 2:
                    r = p;
                    g = tempV;
                    b = t;
                    break;
                case 3:
                    r = p;
                    g = q;
                    b = tempV;
                    break;
                case 4:
                    r = t;
                    g = p;
                    b = tempV;
                    break;
                case 5:
                    r = tempV;
                    g = p;
                    b = q;
                    break;
            }

            rgb = [Math.round(r * 255), Math.round(g * 255), Math.round(b * 255)];
            return rgb;
        }

        /**
         * Generates a v4-style UUID.
         */
        public static function makeUuid():String {
            const hex:Function = function(c:int):String {
                const chars:String = "0123456789abcdef";
                return chars.charAt((c >> 4) & 0x0F) + chars.charAt(c & 0x0F);
            };

            const uuid:Array = [];
            for (var i:int = 0; i < 16; i++) {
                uuid[i] = Math.floor(Math.random() * 256);
            }

            uuid[6] = (uuid[6] & 0x0F) | 0x40; // version 4
            uuid[8] = (uuid[8] & 0x3F) | 0x80; // variant 10x

            return [hex(uuid[0]) + hex(uuid[1]) + hex(uuid[2]) + hex(uuid[3]),
                hex(uuid[4]) + hex(uuid[5]),
                hex(uuid[6]) + hex(uuid[7]),
                hex(uuid[8]) + hex(uuid[9]),
                hex(uuid[10]) + hex(uuid[11]) + hex(uuid[12]) + hex(uuid[13]) + hex(uuid[14]) + hex(uuid[15])].join("-");
        }

        /**
         * Overridable function that translates a time percent (e.g., `0.5`) to a label.
         * Default function just puts `time` in standard percent format (e.g. `50%`).
         */
        public static var timeToLabel:Function = function(time:Number):String {
            return Helpers.toPercent(time) + '%';
        };

        /**
         * Converts, e.g., `0.5` to `50`.
         */
        public static function toPercent(val:Number):int {
            return Math.round(val * 100);
        }

        /**
         * Converts, e.g., `50` to `0.5`.
         */
        public static function fromPercent(val:int):Number {
            return val / 100;
        }

        /**
         * Analyzes given `nodes` and returns an Object with their
         * minimum, maximum and average values.
         *
         * @param   `nodes`
         *           Assumed valid, non-empty Vector of Points.
         *
         * @return  An Object similar to:
         *          {min: 0, max: 0.5, avg: 1}
         */
        public static function analyzeY(nodes:Vector.<Point>):Object {
            var sum:Number = 0;
            var min:Number = Number.MAX_VALUE;
            var max:Number = -Number.MAX_VALUE;

            const len:int = nodes.length;
            for (var i:int = 0; i < len; i++) {
                const y:Number = nodes[i].y;
                if (y < min) {
                    min = y;
                }
                if (y > max) {
                    max = y;
                }
                sum += y;
            }

            var avg:Number = sum / len;
            return {min: min, max: max, avg: avg};
        }


    }
}
