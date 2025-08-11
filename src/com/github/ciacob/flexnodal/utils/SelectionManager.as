package com.github.ciacob.flexnodal.utils {
    import flash.events.MouseEvent;

    public class SelectionManager {

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
            _selectedNodes = new <Node>[];
        }

        /**
         * Storage for the received pool of available nodes. Useful for
         * establishing selection context.
         */
        private var _nodes:Vector.<Node>;

        /**
         * Convenience storage for all the nodes currently selected,.
         * These are always sorted by their `nx` filed, ascending, regardless
         * of the order they where collected.
         */
        private var _selectedNodes:Vector.<Node>;

        /**
         * The last Node that was added to `_selectedNodes`. Useful for
         * situations where a single selection is needed.
         */
        private var _selectedNode:Node;

        /**
         * Whether at least one node should be redrawn with respect to
         * its "anchor" appearance.
         */
        private var __haveAnchorChanges:Boolean;

        /**
         * Returns `true` only once after each raise of the
         * `__haveAnchorChanges` flag. We do this in an attempt to minimize
         * the number of unneeded redraw operations.
         */
        private function get _haveAnchorChanges():Boolean {
            if (__haveAnchorChanges) {
                __haveAnchorChanges = false;
                return true;
            }
            return false;
        }

        /**
         * The last Node that has been passed as the second argument of
         * `accountFor`, regardless of its selected state. Useful for
         * establishing ranges. There can be at most one anchor node per
         * SelectionManager instance.
         */
        private var __anchorNode:Node;

        /**
         * Returns the last anchor set.
         */
        private function get _anchorNode():Node {
            return __anchorNode;
        }

        /**
         * Sets a new anchor. Can be `null`.
         */
        private function set _anchorNode(value:Node):void {

            // Un-marks the previous anchor, if any.
            if (__anchorNode && __anchorNode !== value) {
                __anchorNode.isAnchor = false;
                __anchorNode.isDirty = true;
                __haveAnchorChanges = true;
            }

            // Set and mark the new anchor.
            __anchorNode = value;
            if (__anchorNode) {
                __anchorNode.isAnchor = true;
                __anchorNode.isDirty = true;
                __haveAnchorChanges = true;
            }
        }

        /**
         * Helper. Sets selection and dirtiness flags of given `node`.
         * @param node - Node to set the state of.
         * @param selected - Whether to mark the node as selected.
         *
         * @return Returns`true` if a change in state took place, `false otherwise`.
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
         * Returns the currently selected nodes, sorted by their `nx` property.
         * DO NOT directly manipulate the selection-related properties of these
         * Nodes! Only use the SelectionManager to handle selection.
         */
        public function get selectedNodes():Vector.<Node> {
            return _selectedNodes;
        }

        /**
         * Returns the last Node that was selected, regardless of its place in the
         * `selectedNodes` list.
         * DO NOT directly manipulate the selection-related properties of this Node!
         * Only use the SelectionManager to handle selection.
         */
        public function get selectedNode():Node {
            return _selectedNode;
        }

        /**
         * Returns the last touched note, whether it was selected or not.
         * DO NOT directly manipulate the selection-related properties of this Node!
         * Only use the SelectionManager to handle selection.
         */
        public function get anchorNode():Node {
            return _anchorNode;
        }

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
         * @param   currentNode
         *          The Node instance the event's target resolves to.
         *
         * @return  Returns `true` if the event resulted in changing the current
         *          selection, `false` otherwise.
         */
        public function accountFor(event:MouseEvent, currentNode:Node):Boolean {
            if (!event || !currentNode) {
                return false;
            }

            // Clicking a synthetic node only changes the current anchor.
            if (currentNode.isSynthetic) {
                _anchorNode = currentNode;
                return _haveAnchorChanges;
            }

            const hasShift:Boolean = event.shiftKey;
            const hasCtrl:Boolean = (event.ctrlKey || event.commandKey);
            var selIndex:int;

            // Clicking a selected node without either SHIFT or CTRL/CMD
            // depressed only changes the current anchor.
            if (currentNode.isSelected && !hasCtrl && !hasShift) {
                _anchorNode = currentNode;
                return _haveAnchorChanges;
            }

            // Clicking a non-selected node without SHIFT depressed (or with
            // SHIFT depressed, but without an anchor) sets current selection
            // TO that node. If CTRL/CMD is not depressed, the current selection is
            // discarded as well.
            if (!currentNode.isSelected && (!hasShift || !_anchorNode)) {

                // Without CTRL, selection is reset
                if (!hasCtrl) {
                    clearSelection();
                }

                // With CTRL/CMD, current selection is preserved
                _setState(currentNode, true);
                _selectedNode = currentNode;
                _anchorNode = currentNode;
                _selectedNodes.push(currentNode);
                return true;
            }

            // Clicking a node with SHIFT depressed, and with an anchor, establishes
            // a range. That range will be selected when CTRL/CMD is _not_ depressed,
            // or reversed when CTRL/CMD _is_ depressed.
            if (hasShift && _anchorNode) {
                var haveChanges:Boolean = false;
                const anchorIndex:int = _nodes.indexOf(_anchorNode);
                if (anchorIndex < 0) {
                    return false;
                }
                const targetIndex:int = _nodes.indexOf(currentNode);
                if (targetIndex < 0) {
                    return false;
                }
                const startIndex:int = Math.min(anchorIndex, targetIndex);
                const endIndex:int = Math.max(anchorIndex, targetIndex);
                for (var i:int = startIndex; i <= endIndex; i++) {
                    const rangeNode:Node = _nodes[i];

                    // (a) We stumbled on a range node that was already selected.
                    if (rangeNode.isSelected) {
                        if (!hasCtrl) {
                            continue;
                        }
                        // With CTRL selected, we "invert" the already selected
                        // node, thus unselecting it.
                        haveChanges = _setState(rangeNode, false) || haveChanges;
                        selIndex = _selectedNodes.indexOf(rangeNode);
                        if (selIndex < 0) {
                            continue;
                        }
                        _selectedNodes.splice(selIndex, 1);
                        _selectedNode = Helpers.getReplacement(_selectedNodes, selIndex);
                        continue;
                    }

                    // (b) We stumbled on a range node that was not selected.
                    // CTRL/CMD is irrelevant here.
                    haveChanges = _setState(rangeNode, true) || haveChanges;
                    _selectedNodes.push(rangeNode);
                    _selectedNode = rangeNode;
                }
                _selectedNodes.sort(Helpers.byNx);

                // The current node becomes the next anchor.
                _anchorNode = currentNode;

                return haveChanges || _haveAnchorChanges;
            }

            // Finally, clicking on a node with only CTRL/CMD depressed "inverts"
            // its selection.
            if (hasCtrl) {
                if (currentNode.isSelected) {
                    selIndex = _selectedNodes.indexOf(currentNode);
                    if (selIndex >= 0) {
                        _selectedNodes.splice(selIndex, 1);
                    }
                    _setState(currentNode, false);
                    _selectedNode = Helpers.getReplacement(_selectedNodes, selIndex);
                } else {
                    _setState(currentNode, true);
                    _selectedNodes.push(currentNode);
                    _selectedNodes.sort(Helpers.byNx);
                    _selectedNode = currentNode;
                }
                _anchorNode = currentNode;
                return true;
            }

            // If we reach down here, we had an unsupported scenario.
            return false;
        }

        /**
         * Marks all nodes as not selected, and marks "dirty" all the ones that were
         * previously selected.
         *
         * @return  Returns`true` if at least one change in state took place,
         *          `false otherwise`.
         */
        public function clearSelection():Boolean {
            _selectedNode = null;
            _anchorNode = null;
            if (!_selectedNodes || !_selectedNodes.length) {
                return false;
            }
            var haveChanges:Boolean = false;
            for each (var node:Node in _selectedNodes) {
                haveChanges = _setState(node, false) || haveChanges;
            }
            _selectedNodes.length = 0;
            return haveChanges || _haveAnchorChanges;
        }
    }
}
