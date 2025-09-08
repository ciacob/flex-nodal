package com.github.ciacob.flexnodal.events {
    import flash.events.Event;

    public class NodalEvent extends Event {

        public static const LAYER_CLICK:String = "layerClick";
        public static const NODES_CHANGE:String = "nodesChange";
        public static const SELECTION_CHANGE:String = "selectionChange";
        public static const SELECTION_PATCH : String = "selectionPatch";
        public static const CHART_DATA_CHANGE:String = "chartDataChange";
        public static const CHART_ACTIVATION:String = "chartActivation";

        private var _uid:String;

        public function NodalEvent (type:String, uid:String, bubbles:Boolean = false, cancelable:Boolean = false) {
            super(type, bubbles, cancelable);
            _uid = uid;
        }

        public function get uid():String {
            return _uid;
        }

        override public function clone():Event {
            return new NodalEvent (type, uid, bubbles, cancelable);
        }
    }
}
