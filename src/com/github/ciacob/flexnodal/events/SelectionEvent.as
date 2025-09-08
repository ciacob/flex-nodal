package com.github.ciacob.flexnodal.events {
    import flash.events.Event;
    import com.github.ciacob.flexnodal.utils.SelectionDetails;

    public class SelectionEvent extends NodalEvent {

        private var _details:SelectionDetails;

        public function SelectionEvent(type:String, uid:String, details:SelectionDetails, bubbles:Boolean=false, cancelable:Boolean=false) {
            super(type, uid, bubbles, cancelable);
            _details = details;
        }

        public function get details():SelectionDetails {
            return _details;
        }

        override public function clone():Event {
            return new SelectionEvent(type, uid, _details, bubbles, cancelable);
        }
    }
}
