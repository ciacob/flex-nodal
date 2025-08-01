package com.github.ciacob.flexnodal.utils {
    /**
     * Encapsulates selection modifier logic (Shift, Ctrl, Alt).
     */
    public class SelectionMode {
        public var shift:Boolean;
        public var ctrl:Boolean;
        public var alt:Boolean;

        public function SelectionMode(shift:Boolean = false, ctrl:Boolean = false, alt:Boolean = false) {
            this.shift = shift;
            this.ctrl = ctrl;
            this.alt = alt;
        }
    }
}
