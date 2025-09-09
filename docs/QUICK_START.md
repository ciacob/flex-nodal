# Quick Start Guide - Nodal Library

Get up and running with the Nodal interactive chart editor in 10 minutes.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Installation](#installation)
3. [Basic Setup](#basic-setup)
4. [First Chart](#first-chart)
5. [Adding Interactivity](#adding-interactivity)
6. [Common Patterns](#common-patterns)
7. [Next Steps](#next-steps)

## Prerequisites

Before you begin, ensure you have:

- **Flex SDK 4.x or newer** installed
- **Adobe AIR** or Flash Player 11.1+ runtime
- A **Flex/ActionScript IDE** (Flash Builder, VSCode with AS3 extension, etc.)
- Basic knowledge of **MXML and ActionScript 3.0**

## Installation

### Option 1: Source Integration (Recommended)

1. **Download the library:**
   ```bash
   git clone https://github.com/ciacob/flex-nodal.git
   ```

2. **Add to your project:**
   - Copy the `src/com/github/ciacob/flexnodal` folder to your project's source directory
   - Or add the path to your project's source path configuration

### Option 2: SWC Library

1. **Compile the SWC:**
   ```bash
   asconfigc --sdk /path/to/flex/sdk --project flex-nodal
   ```

2. **Add to project:**
   - Copy `bin/flex-nodal.swc` to your project's `libs` folder
   - Add to your project's library path

## Basic Setup

### 1. Import Required Classes

```actionscript
// In your ActionScript file
import com.github.ciacob.flexnodal.Nodal;
import com.github.ciacob.flexnodal.utils.ChartDescriptor;
import com.github.ciacob.flexnodal.events.SelectionEvent;
import com.github.ciacob.flexnodal.events.ChartEditEvent;
import com.github.ciacob.flexnodal.events.NodalEvent;
import flash.geom.Point;
import mx.collections.ArrayCollection;
```

### 2. Add Namespace to MXML

```xml
<s:Application xmlns:fx="http://ns.adobe.com/mxml/2009"
               xmlns:s="library://ns.adobe.com/flex/spark"
               xmlns:flexnodal="com.github.ciacob.flexnodal.*">
```

## First Chart

### 1. Create Chart Data

```actionscript
// Simple envelope curve: low -> high -> low
[Bindable]
private var myChartData:Vector.<ChartDescriptor> = new <ChartDescriptor>[
    new ChartDescriptor(
        "envelope1",                    // Unique ID
        new <Point>[                    // Points (time, value) from 0-1
            new Point(0, 0.1),         // Start low
            new Point(0.3, 0.8),       // Rise to peak
            new Point(0.7, 0.6),       // Sustain
            new Point(1, 0.0)          // Release to zero
        ],
        "My Envelope"                   // Display name
    )
];
```

### 2. Add Nodal Component

```xml
<flexnodal:Nodal id="chartEditor"
    width="600" height="300"
    dataProvider="{myChartData}"
    operatingMode="{Nodal.NORMAL}" />
```

### 3. Run Your Application

You should now see an interactive chart with draggable nodes!

## Adding Interactivity

### 1. Handle Selection Changes

```actionscript
private function onSelectionChanged(event:SelectionEvent):void {
    if (event.details && event.details.selectedValue) {
        var point:Point = event.details.selectedValue;
        trace("Selected node at time:", point.x, "value:", point.y);
    }
}
```

```xml
<flexnodal:Nodal id="chartEditor"
    width="600" height="300"
    dataProvider="{myChartData}"
    selectionChange="onSelectionChanged(event)" />
```

### 2. Handle Chart Modifications

```actionscript
private function onNodesChanged(event:ChartEditEvent):void {
    trace("Chart modified:", event.edit.name);
    trace("New values:", event.edit.values);
    
    // You can save the new values to your data model here
    updateDataModel(event.edit);
}
```

### 3. Add Background Grid

```actionscript
[Bindable]
private var gridData:ArrayCollection = new ArrayCollection([
    // Vertical lines (time markers)
    {axis: 'x', stop: 0.25, label: '25%'},
    {axis: 'x', stop: 0.5, label: '50%'},
    {axis: 'x', stop: 0.75, label: '75%'},
    
    // Horizontal lines (value markers)
    {axis: 'y', stop: 0.2, label: '20%'},
    {axis: 'y', stop: 0.4, label: '40%'},
    {axis: 'y', stop: 0.6, label: '60%'},
    {axis: 'y', stop: 0.8, label: '80%'}
]);
```

```xml
<flexnodal:Nodal id="chartEditor"
    width="600" height="300"
    dataProvider="{myChartData}"
    gridDataProvider="{gridData}"
    selectionChange="onSelectionChanged(event)"
    nodesChange="onNodesChanged(event)" />
```

## Common Patterns

### Multiple Charts

```actionscript
private var multiChartData:Vector.<ChartDescriptor> = new <ChartDescriptor>[
    new ChartDescriptor("chart1", envelope1Points, "Volume", 0.0),     // Red hue
    new ChartDescriptor("chart2", envelope2Points, "Filter", 0.3),     // Green hue  
    new ChartDescriptor("chart3", envelope3Points, "Pitch", 0.6)       // Blue hue
];
```

### Dashed Lines

```actionscript
new ChartDescriptor(
    "dashedChart", 
    points, 
    "Dashed Line",
    0.5,
    new <Number>[8, 4]  // 8px dash, 4px gap
)
```

### Readonly Mode

```xml
<flexnodal:Nodal operatingMode="{Nodal.READONLY}" />
```

### Selection Tools Integration

```xml
<s:VGroup>
    <flexnodal:Nodal id="chartEditor" />
    <components:SelectionPanel id="selectionPanel" 
        dataProvider="{currentSelection}" />
</s:VGroup>
```

### Programmatic Selection Control

```actionscript
// Clear all selections
chartEditor.clearSelection();

// Delete selected nodes
chartEditor.deleteSelection();

// Set active chart
chartEditor.activeChartId = "chart2";
```

## Next Steps

### Learn More
- **[API Reference](API_REFERENCE.md)** - Complete API documentation
- **[Developer Guide](DEVELOPER_GUIDE.md)** - Advanced usage patterns
- **[Styling Guide](STYLING_GUIDE.md)** - Customization and theming

### Examples
- **[Demo Application](https://github.com/ciacob/flex-nodal-tester)** - Complete working example
- **[Code Examples](EXAMPLES.md)** - Common use cases and patterns

### Advanced Features
- Custom styling and theming
- Performance optimization
- Event handling best practices
- Integration with data binding frameworks

---

## Troubleshooting

**Chart not showing?**
- Verify your data points are in 0-1 range
- Check that Flex SDK is 4.x or newer
- Ensure proper namespaces are imported

**Performance issues?**
- Limit number of simultaneous charts
- Consider ISOLATION mode for displaying only the currently active chart

**Selection not working?**
- Verify operatingMode is not READONLY
- Check event handlers are properly attached
- Ensure chart has valid data

---

Ready to build amazing interactive charts! 🚀
