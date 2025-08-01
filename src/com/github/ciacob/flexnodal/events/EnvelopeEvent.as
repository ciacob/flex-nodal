package com.github.ciacob.flexnodal.events {
    import flash.events.Event;

    public class EnvelopeEvent extends Event {

        public static const PARAMETER_CHANGE:String = "parameterChange";
        public static const NODES_CHANGE:String = "nodesChange";

        public var payload:Object;

        public function EnvelopeEvent(type:String, payload:Object = null, bubbles:Boolean = false, cancelable:Boolean = false) {
            super(type, bubbles, cancelable);
            this.payload = payload;
        }

        override public function clone():Event {
            return new EnvelopeEvent(type, payload, bubbles, cancelable);
        }
    }
}
