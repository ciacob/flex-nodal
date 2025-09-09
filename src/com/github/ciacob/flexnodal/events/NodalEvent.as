package com.github.ciacob.flexnodal.events {
    import flash.events.Event;

    /**
     * Base event used for circulating information inside the Nodal library. This base
     * class only transmits the `uid` of the chart being affected. Subclasses add
     * more information as needed.
     */
    public class NodalEvent extends Event {

        /**
         * Dispatched by `LineChartLayer` when the line of a chart is clicked.
         * Uses the base `NodalEvent` class.
         */
        public static const LAYER_CLICK:String = "layerClick";


        /**
         * Dispatched by `LineChartLayer` when one or more nodes of a `LineChartLayer`
         * become selected or unselected. Redispatched as-is by `Nodal`. Uses the
         * `SelectionEvent` sub-class.
         */
        public static const SELECTION_CHANGE:String = "selectionChange";

        /**
         * Dispatched by `LineChartLayer` when the nodes configuration of a chart
         * is changed by dragging, deleting, or adding nodes. Redispatched as-is by
         * `Nodal`. Uses the `ChartEditEvent` sub-class.
         */
        public static const NODES_CHANGE:String = "nodesChange";

        /**
         * Dispatched by `Nodal` when the foreground chart (and the one receiving editing,
         * if editing is enabled) changes. Uses the base `NodalEvent` class.
         */
        public static const CHART_ACTIVATION:String = "chartActivation";


        /**
         * Dispatched by `SelectionPanel` when the selected nodes' values have been altered
         * by means of the `SelectionPanel`utils. Uses the `SelectionEvent` sub-class.
         */
        public static const SELECTION_PATCH:String = "selectionPatch";

        // Storage for the `_uid` variable.
        private var _uid:String;

        /**
         * Base event used for circulating information inside the Nodal library. This base
         * class only transmits the `uid` of the chart being affected. Subclasses add
         * more information as needed.
         *
         * @param   type
         *          Type of the event. Must be one of the available constants.
         *
         * @param   uid
         *          The unique id of the affected chart this event is related to.
         *
         * @param   bubbles
         *          See flash.events.Event.
         *
         * @param   cancelable
         *          See flash.events.Event.
         */
        public function NodalEvent(type:String, uid:String, bubbles:Boolean = false, cancelable:Boolean = false) {
            super(type, bubbles, cancelable);
            _uid = uid;
        }

        /**
         * The unique id of the affected chart this event is related to.
         */
        public function get uid():String {
            return _uid;
        }

        /**
         * @see flash.events.Event.
         */
        override public function clone():Event {
            return new NodalEvent(type, uid, bubbles, cancelable);
        }
    }
}
