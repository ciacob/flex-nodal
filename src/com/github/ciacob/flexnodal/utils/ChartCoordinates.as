package com.github.ciacob.flexnodal.utils {

    /**
     * Represents all geometry needed to draw/edit a chart at a given time.
     */
    public class ChartCoordinates {

        public var plotsAreaX:Number;
        public var plotsAreaY:Number;
        public var plotsAreaW:Number;
        public var plotsAreaH:Number;

        public var bgAreaX:Number;
        public var bgAreaY:Number;
        public var bgAreaW:Number;
        public var bgAreaH:Number;

        public var drawnMarkerRadius:Number;

        public function ChartCoordinates(plotsAreaX:Number, plotsAreaY:Number, plotsAreaW:Number, plotsAreaH:Number, bgAreaX:Number, bgAreaY:Number, bgAreaW:Number, bgAreaH:Number, drawnMarkerRadius:Number) {

            this.plotsAreaX = plotsAreaX;
            this.plotsAreaY = plotsAreaY;
            this.plotsAreaW = plotsAreaW;
            this.plotsAreaH = plotsAreaH;

            this.bgAreaX = bgAreaX;
            this.bgAreaY = bgAreaY;
            this.bgAreaW = bgAreaW;
            this.bgAreaH = bgAreaH;

            this.drawnMarkerRadius = drawnMarkerRadius;
        }

        /** Factory for an "empty" coordinates instance. */
        public static function empty():ChartCoordinates {
            return new ChartCoordinates(0, 0, 0, 0, 0, 0, 0, 0, 0);
        }

        /**
         * Returns a string representation of this ChartCoordinates instance,
         * for debug purposes.
         */
        public function toString():String {
            return '[ChartCoordinates:\n' + JSON.stringify({plotsAreaX: plotsAreaX,
                    plotsAreaY: plotsAreaY,
                    plotsAreaW: plotsAreaW,
                    plotsAreaH: plotsAreaH,
                    bgAreaX: bgAreaX,
                    bgAreaY: bgAreaY,
                    bgAreaW: bgAreaW,
                    bgAreaH: bgAreaH}, null, '\t') + '\n]';
        }
    }
}
