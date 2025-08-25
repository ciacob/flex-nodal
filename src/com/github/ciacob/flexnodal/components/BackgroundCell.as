package com.github.ciacob.flexnodal.components {

    import spark.components.Label;
    import com.github.ciacob.flexnodal.utils.Helpers;
    import com.github.ciacob.flexnodal.utils.DefaultStyles;
    import flash.display.Graphics;
    import spark.components.Group;

    [Style(name="textFontSize", type="Number", inherit="false")]
    [Style(name="textColor", type="uint", inherit="false")]
    [Style(name="padding", type="uint", inherit="false")]
    [Style(name="bgColor", type="uint", format="Color", inherit="false")]
    [Style(name="bgAlpha", type="Number", inherit="false")]

    /**
     * Represents a single labeled row or column drawn inside the background chart layer.
     */
    public class BackgroundCell extends Group {

        public function BackgroundCell() {
            super();
        }

        // Storage for the last read "textFontSize" style value.
        private var _fontSize:Number = DefaultStyles.DEFAULT_FONT_SIZE;

        // Storage for the last read "textColor" style value.
        private var _color:uint = DefaultStyles.DEFAULT_LINE_COLOR;

        // Flag to raise when there are pending style changes for the optional
        // Label component.
        private var _labelStyleChanged:Boolean;

        // Storage for the optional Label component displaying the cell text
        private var _labelComponent:Label;

        // --------------------
        // The `label` property
        // --------------------

        // Storage for the text being displayed by the label
        private var _label:String;

        // Flag to raise when the `label` property has been externally
        // changed.
        private var _labelChanged:Boolean;

        /**
         * Returns the current label of this cell.
         */
        public function get label():String {
            return _label;
        }

        /**
         * Sets the label this component will use.
         */
        public function set label(value:String):void {
            value = Helpers.trim(value);
            if (value !== _label) {
                _label = value;
                _labelChanged = true;
                invalidateProperties();
            }
        }

        /**
         * Overridden to account for setting the label
         */
        override protected function commitProperties():void {
            super.commitProperties();

            // Label
            if (_labelChanged) {
                _labelChanged = false;

                // Delay creating our Label component until we have a text to
                // put in-there. However, empty text received after the Label
                // was created _will_ be passed on.
                if (_label) {
                    if (!_labelComponent) {
                        _labelComponent = new Label;
                        _labelComponent.percentWidth = 100;
                        _labelComponent.maxDisplayedLines = 1;
                        _labelComponent.showTruncationTip = false;
                        if (_labelStyleChanged) {
                            _labelStyleChanged = false;
                            _styleLabel();
                        }
                        addElement(_labelComponent);
                    }
                }
                if (_labelComponent) {
                    _labelComponent.text = _label;
                    invalidateDisplayList();
                }
            }
        }

        /**
         * Overridden to catch setting the `textFontSize` or `textColor`. Attempts to minimize
         * changing the `_labelComponent` style.
         */
        override public function setStyle(styleProp:String, newValue:*):void {
            super.setStyle(styleProp, newValue);

            if (styleProp === 'textFontSize' && newValue != _fontSize) {
                _fontSize = newValue;
                _labelStyleChanged = true;
            }

            if (styleProp === 'textColor' && newValue != _color) {
                _color = newValue;
                _labelStyleChanged = true;
            }

            if (_labelStyleChanged && _labelComponent) {
                _labelStyleChanged = false;
                _styleLabel();
            }
        }

        /**
         * Overridden to draw background and to position the label.
         */
        override protected function updateDisplayList(uW:Number, uH:Number):void {
            super.updateDisplayList(uW, uH);

            // Read styles
            const padding:uint = Helpers.$getStyle(this, 'padding', DefaultStyles.DEFAULT_PADDING);
            const bgColor:uint = Helpers.$getStyle(this, 'bgColor', DefaultStyles.DEFAULT_LAYER_COLOR);
            const bgAlpha:Number = Helpers.$getStyle(this, 'bgAlpha', DefaultStyles.DEFAULT_CHART_BG_ALPHA);

            // Draw background
            const g:Graphics = graphics;
            g.clear();
            g.beginFill(bgColor, bgAlpha);
            g.drawRect(1, 1, uW - 2, uH - 2);

            // Position and style the label, if any
            if (_labelComponent) {

                // Bottom left, not changeable
                _labelComponent.x = padding;
                _labelComponent.y = uH - padding - _labelComponent.height;
            }
        }

        /**
         * Applies pending style changes to the optional Label component.
         */
        private function _styleLabel():void {
            if (!_labelComponent) {
                return;
            }
            _labelComponent.setStyle('color', _color);
            _labelComponent.setStyle('fontSize', _fontSize);
            invalidateDisplayList();
        }

    }
}