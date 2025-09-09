# Code Examples - Nodal Library

Practical examples for common use cases and integration patterns.

## Table of Contents

1. [Basic Examples](#basic-examples)
2. [Chart Configuration](#chart-configuration)
3. [Event Handling](#event-handling)
4. [Selection Management](#selection-management)
5. [Styling and Theming](#styling-and-theming)
6. [Advanced Patterns](#advanced-patterns)
7. [Integration Examples](#integration-examples)

## Basic Examples

### Minimal Setup (MXML)

The simplest possible implementation:

```xml
<?xml version="1.0" encoding="utf-8"?>
<s:Application xmlns:fx="http://ns.adobe.com/mxml/2009"
               xmlns:s="library://ns.adobe.com/flex/spark"
               xmlns:flexnodal="com.github.ciacob.flexnodal.*">
    
    <fx:Script>
        <![CDATA[
            import com.github.ciacob.flexnodal.utils.ChartDescriptor;
            import flash.geom.Point;
            
            [Bindable]
            private var simpleChart:Vector.<ChartDescriptor> = new <ChartDescriptor>[
                new ChartDescriptor("basic", new <Point>[
                    new Point(0, 0.5),
                    new Point(1, 0.5)
                ], "Flat Line")
            ];
        ]]>
    </fx:Script>
    
    <flexnodal:Nodal width="400" height="200" dataProvider="{simpleChart}" />
</s:Application>
```

### Complete Basic Implementation (Pure ActionScript)

```actionscript
package {
    import spark.components.Application;
    import com.github.ciacob.flexnodal.Nodal;
    import com.github.ciacob.flexnodal.utils.ChartDescriptor;
    import com.github.ciacob.flexnodal.events.*;
    import flash.geom.Point;
    import mx.collections.ArrayCollection;
    
    public class BasicNodalApp extends Application {
        
        [Bindable]
        private var chartData:Vector.<ChartDescriptor>;
        
        [Bindable]
        private var gridData:ArrayCollection;
        
        override protected function createChildren():void {
            super.createChildren();
            setupData();
            createUI();
        }
        
        private function setupData():void {
            // Create a simple envelope
            chartData = new <ChartDescriptor>[
                new ChartDescriptor(
                    "envelope1",
                    new <Point>[
                        new Point(0, 0.1),     // Attack
                        new Point(0.2, 0.8),   // Peak
                        new Point(0.6, 0.6),   // Sustain
                        new Point(1, 0)        // Release
                    ],
                    "ADSR Envelope"
                )
            ];
            
            // Create grid markers
            gridData = new ArrayCollection([
                {axis: 'x', stop: 0.2, label: 'A'},
                {axis: 'x', stop: 0.6, label: 'S'},
                {axis: 'y', stop: 0.25, label: '25%'},
                {axis: 'y', stop: 0.5, label: '50%'},
                {axis: 'y', stop: 0.75, label: '75%'}
            ]);
        }
        
        private function createUI():void {
            var editor:Nodal = new Nodal();
            editor.percentWidth = 100;
            editor.percentHeight = 100;
            editor.dataProvider = chartData;
            editor.gridDataProvider = gridData;
            editor.addEventListener(NodalEvent.SELECTION_CHANGE, onSelectionChanged);
            editor.addEventListener(NodalEvent.NODES_CHANGE, onNodesChanged);
            
            addElement(editor);
        }
        
        private function onSelectionChanged(event:SelectionEvent):void {
            trace("Selection changed:", event.details.selectedValues.length, "nodes");
        }
        
        private function onNodesChanged(event:ChartEditEvent):void {
            trace("Chart modified:", event.edit.name);
            // Save changes to your data model here
        }
    }
}
```

## Chart Configuration

### Multiple Charts with Different Styles

```actionscript
private function createMultipleCharts():Vector.<ChartDescriptor> {
    return new <ChartDescriptor>[
        // Solid red line
        new ChartDescriptor(
            "volume",
            new <Point>[
                new Point(0, 0.3),
                new Point(0.4, 0.9),
                new Point(1, 0.1)
            ],
            "Volume",
            0.0,                        // Red hue
            null                        // Solid line
        ),
        
        // Dashed green line
        new ChartDescriptor(
            "filter",
            new <Point>[
                new Point(0, 0.8),
                new Point(0.3, 0.2),
                new Point(0.7, 0.7),
                new Point(1, 0.4)
            ],
            "Filter Cutoff",
            0.33,                       // Green hue
            new <Number>[8, 4]          // Dashed: 8px line, 4px gap
        ),
        
        // Dotted blue line
        new ChartDescriptor(
            "pitch",
            new <Point>[
                new Point(0, 0.5),
                new Point(0.5, 0.3),
                new Point(1, 0.6)
            ],
            "Pitch Bend",
            0.66,                       // Blue hue
            new <Number>[2, 3]          // Dotted: 2px dot, 3px gap
        )
    ];
}
```

### Custom Grid Configuration

```actionscript
private function createDetailedGrid():ArrayCollection {
    var grid:ArrayCollection = new ArrayCollection();
    
    // Time markers every 10%
    for (var t:Number = 0.1; t <= 0.9; t += 0.1) {
        grid.addItem({
            axis: 'x', 
            stop: t, 
            label: Math.round(t * 100) + '%'
        });
    }
    
    // Value markers with custom labels
    var valueLabels:Array = ['Low', 'Med-Low', 'Medium', 'Med-High', 'High'];
    for (var i:int = 0; i < valueLabels.length; i++) {
        grid.addItem({
            axis: 'y',
            stop: (i + 1) * 0.2,
            label: valueLabels[i]
        });
    }
    
    return grid;
}
```

## Event Handling

### Complete Event Handler Setup

```actionscript
public class NodalEventHandler {
    
    private var editor:Nodal;
    private var currentSelection:SelectionDetails;
    
    public function setupEventHandlers(nodal:Nodal):void {
        editor = nodal;
        
        // Selection events
        editor.addEventListener(NodalEvent.SELECTION_CHANGE, onSelectionChanged);
        
        // Chart modification events
        editor.addEventListener(NodalEvent.NODES_CHANGE, onNodesChanged);
        
        // Chart activation events
        editor.addEventListener(NodalEvent.CHART_ACTIVATION, onChartActivated);
    }
    
    private function onSelectionChanged(event:SelectionEvent):void {
        currentSelection = event.details;
        
        if (currentSelection.selectedValue) {
            // Single selection
            var point:Point = currentSelection.selectedValue;
            trace("Selected node - Time:", point.x, "Value:", point.y);
            updateSelectionUI(currentSelection);
        } else {
            // No selection
            trace("Selection cleared");
            clearSelectionUI();
        }
    }
    
    private function onNodesChanged(event:ChartEditEvent):void {
        var edit:ChartEdit = event.edit;
        trace("Chart '" + edit.name + "' modified");
        trace("New values:", edit.values.length, "points");
        
        // Save to data model
        saveChartData(edit.uid, edit.values);
        
        // Notify other components
        dispatchEvent(new Event("chartDataChanged"));
    }
    
    private function onChartActivated(event:NodalEvent):void {
        trace("Chart activated:", event.uid);
        
        // Update UI to reflect active chart
        updateActiveChartIndicator(event.uid);
        
        // Load chart-specific settings
        loadChartSettings(event.uid);
    }
    
    private function updateSelectionUI(selection:SelectionDetails):void {
        // Update selection panel or other UI components
        if (selectionPanel) {
            selectionPanel.dataProvider = selection;
        }
    }
    
    private function clearSelectionUI():void {
        if (selectionPanel) {
            selectionPanel.dataProvider = null;
        }
    }
}
```

### Handling Selection Panel Events

```actionscript
private function setupSelectionPanel():void {
    selectionPanel.addEventListener(NodalEvent.SELECTION_PATCH, onSelectionPatched);
}

private function onSelectionPatched(event:SelectionEvent):void {
    var patchedSelection:SelectionDetails = event.details;
    
    // Apply the changes to the main editor
    editor.patchSelection(patchedSelection, true);
    
    // Log the changes
    trace("Selection patched:", patchedSelection.selectedValues.length, "nodes updated");
}
```

## Selection Management

### Programmatic Selection Control

```actionscript
public class SelectionController {
    
    private var editor:Nodal;
    
    public function SelectionController(nodal:Nodal) {
        this.editor = nodal;
    }
    
    // Clear all selections
    public function clearAll():void {
        editor.clearSelection();
    }
    
    // Delete selected nodes
    public function deleteSelected():void {
        editor.deleteSelection();
    }
    
    // Set specific values for selected nodes
    public function setSelectedValue(value:Number):void {
        if (!editor.currentSelection) return;
        
        var patchedValues:Vector.<Point> = new <Point>[];
        for each (var point:Point in editor.currentSelection.selectedValues) {
            patchedValues.push(new Point(point.x, value));
        }
        
        var patch:SelectionDetails = new SelectionDetails(
            patchedValues[0],
            patchedValues,
            editor.currentSelection.selectionAnchor,
            editor.currentSelection.chartName
        );
        
        editor.patchSelection(patch, true);
    }
    
    // Offset selected values by a delta
    public function offsetSelected(delta:Number):void {
        if (!editor.currentSelection) return;
        
        var patchedValues:Vector.<Point> = new <Point>[];
        for each (var point:Point in editor.currentSelection.selectedValues) {
            var newValue:Number = Math.max(0, Math.min(1, point.y + delta));
            patchedValues.push(new Point(point.x, newValue));
        }
        
        var patch:SelectionDetails = new SelectionDetails(
            patchedValues[0],
            patchedValues,
            editor.currentSelection.selectionAnchor,
            editor.currentSelection.chartName
        );
        
        editor.patchSelection(patch, true);
    }
}
```

### Selection Utilities

```actionscript
public class SelectionUtils {
    
    // Get the range (min/max) of selected values
    public static function getValueRange(selection:SelectionDetails):Object {
        if (!selection || !selection.selectedValues.length) {
            return {min: NaN, max: NaN, avg: NaN};
        }
        
        var min:Number = 1;
        var max:Number = 0;
        var sum:Number = 0;
        
        for each (var point:Point in selection.selectedValues) {
            min = Math.min(min, point.y);
            max = Math.max(max, point.y);
            sum += point.y;
        }
        
        return {
            min: min,
            max: max,
            avg: sum / selection.selectedValues.length
        };
    }
    
    // Check if selection forms a continuous range
    public static function isContinuousSelection(selection:SelectionDetails):Boolean {
        if (!selection || selection.selectedValues.length < 2) {
            return false;
        }
        
        // Sort by X coordinate
        var sorted:Vector.<Point> = selection.selectedValues.concat();
        sorted.sort(function(a:Point, b:Point):int {
            return a.x < b.x ? -1 : (a.x > b.x ? 1 : 0);
        });
        
        // Check for gaps
        for (var i:int = 1; i < sorted.length; i++) {
            // If there's a significant gap, it's not continuous
            if (sorted[i].x - sorted[i-1].x > 0.01) {
                return false;
            }
        }
        
        return true;
    }
}
```

## Styling and Theming

### CSS Styling Example

```css
/* Main chart editor styles */
.customNodalEditor {
    lineColor: #2E86AB;
    lineColorOver: #A23B72;
    lineColorSelected: #F18F01;
    lineColorAnchor: #C73E1D;
    lineThickness: 3;
}

/* Background grid styles */
.customBackground {
    bgColor: #F8F9FA;
    bgAlpha: 0.6;
    textColor: #495057;
    textFontSize: 10;
    padding: 6;
}

/* Selection panel styles */
.customSelectionPanel {
    headerStyle: "headerText";
    bodyStyle: "bodyText";
    buttonStyle: "actionButton";
    rowHeight: 24;
    horizontalGap: 8;
}

.headerText {
    fontSize: 12;
    fontWeight: "bold";
    color: #343A40;
}

.bodyText {
    fontSize: 11;
    color: #6C757D;
}

.actionButton {
    fontSize: 10;
    cornerRadius: 3;
}
```

### Programmatic Styling

```actionscript
private function applyCustomTheme():void {
    // Create style declarations
    var chartStyle:CSSStyleDeclaration = new CSSStyleDeclaration();
    chartStyle.setStyle("lineColor", 0x3366CC);
    chartStyle.setStyle("lineColorSelected", 0xFF6600);
    chartStyle.setStyle("lineThickness", 4);
    
    var backgroundStyle:CSSStyleDeclaration = new CSSStyleDeclaration();
    backgroundStyle.setStyle("bgColor", 0xF0F8FF);
    backgroundStyle.setStyle("textColor", 0x333333);
    
    // Apply to components
    editor.setStyle("chartStyle", chartStyle);
    backgroundLayer.setStyle("backgroundStyle", backgroundStyle);
}
```

## Advanced Patterns

### Data Binding Integration

```actionscript
public class ChartDataModel extends EventDispatcher {
    
    [Bindable]
    public var charts:Vector.<ChartDescriptor>;
    
    [Bindable]
    public var activeChartId:String;
    
    private var editor:Nodal;
    
    public function bind(nodal:Nodal):void {
        editor = nodal;
        
        // Bind data
        BindingUtils.bindProperty(editor, "dataProvider", this, "charts");
        BindingUtils.bindProperty(editor, "activeChartId", this, "activeChartId");
        BindingUtils.bindProperty(this, "activeChartId", editor, "activeChartId");
        
        // Listen for changes
        editor.addEventListener(NodalEvent.NODES_CHANGE, onChartChanged);
        editor.addEventListener(NodalEvent.CHART_ACTIVATION, onActiveChartChanged);
    }
    
    private function onChartChanged(event:ChartEditEvent):void {
        // Update the model with new values
        updateChartInModel(event.edit.uid, event.edit.values);
        
        // Notify observers
        dispatchEvent(new Event("chartDataChanged"));
    }
    
    private function onActiveChartChanged(event:NodalEvent):void {
        activeChartId = event.uid;
    }
    
    private function updateChartInModel(uid:String, values:Vector.<Point>):void {
        for (var i:int = 0; i < charts.length; i++) {
            if (charts[i].uid === uid) {
                // Create new chart descriptor with updated values
                charts[i] = new ChartDescriptor(
                    uid,
                    values,
                    charts[i].name,
                    charts[i].hueFactor,
                    charts[i].dashStyle
                );
                break;
            }
        }
    }
}
```

### Custom Operating Mode Implementation

```actionscript
public class CustomModeController {
    
    private var editor:Nodal;
    private var customMode:String = "STEP_EDIT";
    
    public function enableStepEditMode():void {
        // Custom mode where only one node can be selected at a time
        editor.operatingMode = Nodal.EXCLUSIVE;
        
        editor.addEventListener(NodalEvent.SELECTION_CHANGE, onStepEditSelection);
    }
    
    private function onStepEditSelection(event:SelectionEvent):void {
        var selection:SelectionDetails = event.details;
        
        if (selection.selectedValues.length > 1) {
            // Force single selection by clearing and selecting only the first
            editor.clearSelection();
            // Implementation would require custom selection logic
        }
    }
}
```

## Integration Examples

### Flex Module Integration

```actionscript
// NodalEditorModule.mxml
<?xml version="1.0" encoding="utf-8"?>
<s:Module xmlns:fx="http://ns.adobe.com/mxml/2009"
          xmlns:s="library://ns.adobe.com/flex/spark"
          xmlns:flexnodal="com.github.ciacob.flexnodal.*"
          creationComplete="onCreationComplete()">
    
    <fx:Script>
        <![CDATA[
            import com.github.ciacob.flexnodal.utils.ChartDescriptor;
            import mx.messaging.events.ModuleEvent;
            
            public var moduleData:Object;
            
            [Bindable]
            private var chartData:Vector.<ChartDescriptor>;
            
            private function onCreationComplete():void {
                if (moduleData && moduleData.charts) {
                    chartData = moduleData.charts;
                }
                
                // Notify parent of ready state
                dispatchEvent(new ModuleEvent("moduleReady"));
            }
            
            public function getChartData():Vector.<ChartDescriptor> {
                return chartData;
            }
        ]]>
    </fx:Script>
    
    <s:VGroup width="100%" height="100%">
        <flexnodal:Nodal id="editor"
            width="100%" height="100%"
            dataProvider="{chartData}" />
    </s:VGroup>
</s:Module>
```

### AIR Application Integration

```actionscript
// MainWindow.mxml - AIR Application
<?xml version="1.0" encoding="utf-8"?>
<s:WindowedApplication xmlns:fx="http://ns.adobe.com/mxml/2009"
                       xmlns:s="library://ns.adobe.com/flex/spark"
                       xmlns:flexnodal="com.github.ciacob.flexnodal.*">
    
    <fx:Script>
        <![CDATA[
            import flash.filesystem.File;
            import flash.filesystem.FileMode;
            import flash.filesystem.FileStream;
            
            private function saveCharts():void {
                var file:File = File.documentsDirectory.resolvePath("charts.json");
                var stream:FileStream = new FileStream();
                
                try {
                    stream.open(file, FileMode.WRITE);
                    stream.writeUTFBytes(JSON.stringify(serializeCharts()));
                } finally {
                    stream.close();
                }
            }
            
            private function loadCharts():void {
                var file:File = File.documentsDirectory.resolvePath("charts.json");
                if (!file.exists) return;
                
                var stream:FileStream = new FileStream();
                try {
                    stream.open(file, FileMode.READ);
                    var data:String = stream.readUTFBytes(stream.bytesAvailable);
                    chartEditor.dataProvider = deserializeCharts(JSON.parse(data));
                } finally {
                    stream.close();
                }
            }
        ]]>
    </fx:Script>
    
    <s:VGroup width="100%" height="100%">
        <s:HGroup>
            <s:Button label="Save" click="saveCharts()" />
            <s:Button label="Load" click="loadCharts()" />
        </s:HGroup>
        
        <flexnodal:Nodal id="chartEditor"
            width="100%" height="100%" />
    </s:VGroup>
</s:WindowedApplication>
```

---

*These examples demonstrate the flexibility and power of the Nodal library for various use cases and integration scenarios.*
