package com.github.ciacob.flexnodal.utils {

    /**
     * Represents all geometry needed to draw/edit a chart at a given time.
     */
    public class ChartCoordinates {

        public var screenPoints:Vector.<ScreenPoint>;

        public var plotsAreaX:Number;
        public var plotsAreaY:Number;
        public var plotsAreaW:Number;
        public var plotsAreaH:Number;

        public var bgAreaX:Number;
        public var bgAreaY:Number;
        public var bgAreaW:Number;
        public var bgAreaH:Number;

        public var drawnMarkerRadius:Number;

        public function ChartCoordinates(
            screenPoints:Vector.<ScreenPoint>,
            plotsAreaX:Number, plotsAreaY:Number, plotsAreaW:Number, plotsAreaH:Number,
            bgAreaX:Number, bgAreaY:Number, bgAreaW:Number, bgAreaH:Number,
            drawnMarkerRadius:Number
        ) {
            this.screenPoints = screenPoints || new Vector.<ScreenPoint>;

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
            return new ChartCoordinates(
                new <ScreenPoint>[],
                0, 0, 0, 0,
                0, 0, 0, 0,
                0
            );
        }
    }
}