package com.github.ciacob.flexnodal.utils
{
    import flash.events.MouseEvent;

    public class SelectionManager {
        private var _nodes : Vector.<Node>;

        /**
         * Dedicated class to handle adding and removing nodes to/from the
         * current selection.
         * 
         * @param   nodes
         *          The pool of nodes whose selection is to be managed.
         *          Selection is managed in-place, via Node's `isSelected`
         *          property. Changed nodes will also be marked as "dirty",
         *          by turning their `isDirty` flag on.        
         */
        public function SelectionManager (nodes: Vector.<Node>) {
            _nodes = nodes;
        }

        /**
         * Returns the pool of nodes currently in use.
         */
        public function get nodes () : Vector.<Node> {
            return _nodes;
        }

        /**
         * Sets a new pool of nodes to use (and implicitly clears the current
         * selection).
         */
        public function set nodes (value : Vector.<Node>) : void {
            _nodes = value;
        }

        /**
         * Accepts a MouseEvent that will be interpreted in the context of the 
         * current nodes pool, possibly resulting in a selection change.
         * 
         * @param   event
         *          The mouse event to account for.
         * 
         * @param   targetNode
         *          The Node instance the event's target resolves to.
         * 
         * @return  Returns `true` if the event resulted in changing the current
         *          selection, `false` otherwise.
         */
        public function accountFor (event: MouseEvent, targetNode : Node) : Boolean {
                // TBD
                return false;
        }

        /**
         * Marks all nodes as not selected, and marks "dirty" all the ones that were
         * previously selected.
         */
        public function clearSelection () : void {
            // TBD
        }

        /**
         * 
         * 
         */
        private function _buildSelection () : void {
            // TBD
        }
    }
}