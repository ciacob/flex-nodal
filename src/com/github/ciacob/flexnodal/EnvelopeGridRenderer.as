package com.github.ciacob.flexnodal.utils {
    import spark.components.Group;

    /**
     * Handles grid drawing & label rendering.
     */
    public class EnvelopeGridRenderer extends Group {
        public function EnvelopeGridRenderer() {
            super();
        }

        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            graphics.clear();
            graphics.lineStyle(1, 0xCCCCCC);
            graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
        }
    }
}
