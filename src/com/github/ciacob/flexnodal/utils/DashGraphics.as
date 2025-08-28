package com.github.ciacob.flexnodal.utils {
    import flash.display.Graphics;
    import flash.geom.Matrix;

    /**
     * A tiny façade around flash.display.Graphics that adds dashed-lines.
     *
     * Usage:
     *   var g:DashGraphics = new DashGraphics(sprite.graphics);
     *   g.lineStyle(2, 0x990000, 0.75, true, "normal", "round", "round");
     *   g.dashedLineStyle(new <Number>[8, 4]); // dash, gap
     *   g.moveTo(0, 0);
     *   g.dashLineTo(100, 100);
     *   g.lineTo(100, 50);         // mix with normal lines
     *   g.dashLineTo(150, 100);
     */
    public final class DashGraphics {
        private var g:Graphics;

        // Pen position we track (Graphics doesn't expose it).
        private var _cx:Number = NaN;
        private var _cy:Number = NaN;

        // Dash config
        private var _pattern:Vector.<Number> = new <Number>[6, 3];
        private var _phase:Number = 0;

        public function DashGraphics(graphics:Graphics) {
            this.g = graphics;
        }

        // -------- Configuration for dashed lines --------
        /**
         * Set the dash pattern and optional phase (offset in pixels).
         * pattern alternates [dash, gap, dash, gap, ...].
         */
        public function dashedLineStyle(pattern:Vector.<Number>, phase:Number = 0):void {
            if (!pattern || pattern.length == 0) {
                _pattern = new <Number>[6, 3];
            } else {
                var cleaned:Vector.<Number> = new <Number>[];
                for each (var v:Number in pattern)
                    cleaned.push(Math.max(0, v));
                _pattern = cleaned;
            }
            // Normalize phase to [0, cycle)
            var cycle:Number = 0;
            for each (v in _pattern)
                cycle += v;
            _phase = (cycle > 0) ? ((phase % cycle) + cycle) % cycle : 0;
        }

        // Draw dashed segment from current pen to (x2,y2)
        public function dashLineTo(x2:Number, y2:Number):void {
            // If we don't know current pen pos, assume (0,0)
            var x1:Number = isNaN(_cx) ? 0 : _cx;
            var y1:Number = isNaN(_cy) ? 0 : _cy;

            // No-op for degenerate lines
            var dx:Number = x2 - x1, dy:Number = y2 - y1;
            var len:Number = Math.sqrt(dx * dx + dy * dy);
            if (len <= 0 || !isFinite(len)) {
                _cx = x2;
                _cy = y2;
                return;
            }

            // Direction unit vector
            var ux:Number = dx / len, uy:Number = dy / len;

            // Total cycle length
            var cycle:Number = 0;
            for each (var v:Number in _pattern)
                cycle += v;
            if (cycle <= 0) { // pattern of all zeros => draw nothing
                _cx = x2;
                _cy = y2;
                return;
            }

            // Start index and remaining in current segment, honoring phase
            var i:int = 0;
            var segRemain:Number = _pattern[0];
            var phase:Number = _phase;
            while (phase > 0) {
                var step:Number = Math.min(phase, segRemain);
                phase -= step;
                segRemain -= step;
                if (segRemain == 0) {
                    i = (i + 1) % _pattern.length;
                    segRemain = _pattern[i];
                }
            }
            var draw:Boolean = (i % 2 == 0);

            var traveled:Number = 0;
            var cx:Number = x1, cy:Number = y1;

            while (traveled < len) {
                var advance:Number = Math.min(segRemain, len - traveled);
                var nx:Number = cx + ux * advance;
                var ny:Number = cy + uy * advance;

                if (draw && advance > 0) {
                    // Use the underlying graphics
                    g.moveTo(cx, cy);
                    g.lineTo(nx, ny);
                }

                cx = nx;
                cy = ny;
                traveled += advance;

                segRemain -= advance;
                if (segRemain == 0) {
                    i = (i + 1) % _pattern.length;
                    segRemain = _pattern[i];
                    draw = !draw;
                }
            }

            // Update pen position
            _cx = x2;
            _cy = y2;

            // Update phase so the next call continues seamlessly
            _phase = (phase + (len % cycle)) % cycle;
        }

        // --------- Pass-throughs for common Graphics APIs ---------
        public function clear():void {
            g.clear();
            _cx = _cy = NaN;
        }

        public function lineStyle(thickness:Number = NaN, color:uint = 0, alpha:Number = 1.0, pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String = null, joints:String = null, miterLimit:Number = 3):void {
            g.lineStyle(thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit);
        }

        public function moveTo(x:Number, y:Number):void {
            g.moveTo(x, y);
            _cx = x;
            _cy = y;
        }

        public function lineTo(x:Number, y:Number):void {
            g.lineTo(x, y);
            _cx = x;
            _cy = y;
        }

        public function curveTo(cx:Number, cy:Number, ax:Number, ay:Number):void {
            g.curveTo(cx, cy, ax, ay);
            _cx = ax;
            _cy = ay;
        }

        public function beginFill(color:uint, alpha:Number = 1.0):void {
            g.beginFill(color, alpha);
        }

        public function endFill():void {
            g.endFill();
        }

        public function drawRoundRect(x:Number, y:Number, width:Number, height:Number, ellipseWidth:Number, ellipseHeight:Number = NaN):void {
            g.drawRoundRect(x, y, width, height, ellipseWidth, ellipseHeight || null);
        }

        public function drawEllipse(x:Number, y:Number, width:Number, height:Number):void {
            g.drawEllipse(x, y, width, height);
        }

        public function drawCircle(x:Number, y:Number, radius:Number):void {
            g.drawCircle(x, y, radius);
        }

        public function beginGradientFill(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = "pad", interpolationMethod:String = "rgb", focalPointRatio:Number = 0):void {
            g.beginGradientFill(type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
        }

        public function drawRect(x:Number, y:Number, width:Number, height:Number):void {
            g.drawRect(x, y, width, height);
        }


        // Optional: expose the wrapped Graphics for interop
        public function get target():Graphics {
            return g;
        }
    }
}
