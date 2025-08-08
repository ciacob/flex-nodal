package com.github.ciacob.flexnodal.utils {
    import flash.events.MouseEvent;

    public class SelectionManager {
        private var _nodes:Vector.<Node>;

        /**
         * Dedicated class to handle adding and removing nodes to/from the
         * current selection. Does not do any (re)drawing, this is client
         * code's responsibility.
         *
         * @param   nodes
         *          The pool of nodes whose selection is to be managed.
         *          Selection is managed in-place, via Node's `isSelected`
         *          property. Changed nodes will also be marked as "dirty",
         *          by turning their `isDirty` flag on.
         */
        public function SelectionManager(nodes:Vector.<Node>) {
            _nodes = nodes;

            trace ('Nodes is: ', _nodes);

            _selectedNodes = new <Node>[];
        }

        /**
         * Convenience storage for all the nodes currently selected,.
         * These are always sorted by their `nx` filed, ascending, regardless
         * of the order they where collected.
         */
        private var _selectedNodes:Vector.<Node>;

        /**
         * The last Node that was added to `_selectedNodes`. Useful for
         * establishing ranges.
         */
        private var _selectedNode:Node;

        /**
         * Returns the pool of nodes currently in use.
         */
        public function get nodes():Vector.<Node> {
            return _nodes;
        }

        /**
         * Sets a new pool of nodes to use (and implicitly clears the current
         * selection).
         */
        public function set nodes(value:Vector.<Node>):void {
            _nodes = value;
            clearSelection();
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
        public function accountFor(event:MouseEvent, targetNode:Node):Boolean {
            if (!event || !targetNode) {
                return false;
            }
            const hasShift:Boolean = event.shiftKey;
            const hasCtrl:Boolean = (event.ctrlKey || event.commandKey);
            var selIndex:int;

            // Clicking a selected node without CTRL/CMD depressed does nothing.
            if (targetNode.isSelected && !hasCtrl) {
                return false;
            }

            // Clicking a non-selected node without SHIFT depressed (or with
            // SHIFT depressed, but without an anchor) sets current selection
            // TO that node alone. CTRL/CMD makes no difference here.
            if (!targetNode.isSelected && (!hasShift || !_selectedNode)) {
                clearSelection();
                _setState(targetNode, true);
                _selectedNode = targetNode;
                _selectedNodes.push(targetNode);
                return true;
            }

            // Clicking a non-selected node with SHIFT depressed, with and
            // anchor, establishes a selected range. The range will be selected
            // if CTRL/CMD is note depressed, or reversed if CTRL/CMD is depressed.
            if (!targetNode.isSelected && hasShift && _selectedNode) {
                trace ('targetNode is:', targetNode, 'and _selectedNode is:', _selectedNode);

                var haveChanges:Boolean = false;
                const anchorIndex:int = _nodes.indexOf(_selectedNode);
                
                trace ('anchorIndex is: ', anchorIndex);

                if (anchorIndex < 0) {
                    return false;
                }
                const targetIndex:int = _nodes.indexOf(targetNode);

                trace ('targetIndex is:', targetIndex);

                if (targetIndex < 0) {
                    return false;
                }
                const startIndex:int = Math.min(anchorIndex, targetIndex);
                const endIndex:int = Math.max(anchorIndex, targetIndex);
                for (var i:int = startIndex; i <= endIndex; i++) {
                    const node:Node = _nodes[i];

                    // (a) "This" node included in the range was already selected.
                    if (node.isSelected) {
                        if (!hasCtrl) {
                            continue;
                        }
                        // With CTRL selected, we "invert" a selected node, thus
                        // unselecting it.
                        haveChanges = _setState(node, false) || haveChanges;
                        selIndex = _selectedNodes.indexOf(node);
                        if (selIndex < 0) {
                            continue;
                        }
                        _selectedNodes.splice(selIndex, 1);
                        continue;
                    }

                    // (b) "This" node included in the range was not selected. CTRL/CMD
                    // is irrelevant here.
                    haveChanges = _setState(node, true) || haveChanges;
                    _selectedNodes.push(node);
                }
                _selectedNodes.sort(_byNx);

                // The "target node" becomes the next anchor.
                _selectedNode = targetNode;

                return haveChanges;
            }

            // Finally, clicking on a node with only CTRL/CMD depressed "inverts"
            // its selection.
            if (hasCtrl) {
                if (targetNode.isSelected) {
                    selIndex = _selectedNodes.indexOf(targetNode);
                    if (selIndex >= 0) {
                        _selectedNodes.splice(selIndex, 1);
                    }
                    _setState(targetNode, false);
                    _selectedNode = null;
                }
                else {
                    _setState(targetNode, true);
                    _selectedNodes.push(targetNode);
                    _selectedNodes.sort(_byNx);
                    _selectedNode = targetNode;
                }
                return true;
            }

            // If we reach down here, we had an unsupported scenario.
            return false;
        }

        /**
         * Marks all nodes as not selected, and marks "dirty" all the ones that were
         * previously selected.
         */
        public function clearSelection():void {
            _selectedNode = null;
            if (!_selectedNodes || !_selectedNodes.length) {
                return;
            }
            for each (var node:Node in _selectedNodes) {
                _setState(node, false);
            }
            _selectedNodes.length = 0;
        }

        /**
         * Helper. Sets selection and dirtiness flags of given `node`.
         * @param node - Node to set the state of.
         * @param selected - Whether to mark the node as selected.
         *
         * @return Returns`true` if a change in state took place, `false otherwise`
         */
        private function _setState(node:Node, selected:Boolean):Boolean {
            if (!node || node.isSelected === selected) {
                return false;
            }
            node.isDirty = true;
            node.isSelected = selected;
            return true;
        }

        /**
         * Helper, to be used with Array/Vector `sort()`. Sorts a Nodes by their `nx`
         * field.
         * @see Array.sort()
         */
        private function _byNx(a:Node, b:Node):int {
            if (a === b) {
                return 0;
            }
            if (!a) {
                return -1;
            }
            if (!b) {
                return 1;
            }
            return (a.nx < b.nx) ? -1 : (a.nx > b.nx ? 1 : 0);
        }
    }
}