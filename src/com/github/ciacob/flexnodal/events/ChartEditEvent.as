package com.github.ciacob.flexnodal.events {
    import flash.events.Event;
    import com.github.ciacob.flexnodal.utils.ChartEdit;

    public class ChartEditEvent extends NodalEvent {

        private var _edit:ChartEdit;

        public function ChartEditEvent (type:String, uid:String, edit:ChartEdit, bubbles:Boolean = false, cancelable:Boolean = false) {
            super(type, uid, bubbles, cancelable);
            _edit = edit;
        }

        public function get edit():ChartEdit {
            return _edit;
        }

        override public function clone():Event {
            return new ChartEditEvent(type, uid, _edit, bubbles, cancelable);
        }
    }
}
