# API Reference - Nodal Library

Complete reference for the Nodal interactive chart editing library.

## Table of Contents

1. [Main Components](#main-components)
2. [Data Classes](#data-classes)
3. [Event Classes](#event-classes)
4. [Utility Classes](#utility-classes)
5. [Constants](#constants)
6. [Style Properties](#style-properties)

## Main Components

### Nodal

The main container component that manages multiple chart layers and user interactions.

```actionscript
public class Nodal extends Group
```

#### Properties

| Property | Type | Description | Default |
|----------|------|-------------|---------|
| `dataProvider` | `Vector.<ChartDescriptor>` | Collection of charts to display | `null` |
| `gridDataProvider` | `ArrayCollection` | Grid lines and labels data | `null` |
| `operatingMode` | `int` | Interaction mode (see constants) | `NORMAL` |
| `activeChartId` | `String` | UID of currently active chart | `null` |

#### Methods

| Method | Parameters | Returns | Description |
|--------|------------|---------|-------------|
| `clearSelection()` | None | `void` | Clears all node selections |
| `deleteSelection()` | None | `void` | Removes selected nodes |
| `patchSelection()` | `patch:SelectionDetails`, `dispatch:Boolean=false` | `void` | Updates selected node values |

#### Events

| Event | Type | Description |
|-------|------|-------------|
| `selectionChange` | `SelectionEvent` | Fired when node selection changes |
| `nodesChange` | `ChartEditEvent` | Fired when chart values are modified |
| `chartActivation` | `NodalEvent` | Fired when active chart changes |

#### Usage Example

```xml
<flexnodal:Nodal id="editor"
    width="100%" height="400"
    dataProvider="{chartData}"
    gridDataProvider="{gridData}"
    operatingMode="{Nodal.NORMAL}"
    selectionChange="_onSelectionChanged(event)"
    nodesChange="_onNodesChanged(event)" />
```

---

### SelectionPanel

A UI component for manipulating selected nodes with numeric controls and bulk operations.

```actionscript
public class SelectionPanel extends Group
```

#### Properties

| Property | Type | Description | Default |
|----------|------|-------------|---------|
| `dataProvider` | `SelectionDetails` | Current selection information | `null` |
| `chartUid` | `String` | UID of associated chart | `null` |
| `floorBtnContent` | `Object` | Icon and/or text for floor button | `"Floor"` |
| `ceilBtnContent` | `Object` | Icon and/or text for ceiling button | `"Ceil"` |
| `averageBtnContent` | `Object` | Icon and/or text for average button | `"Average"` |

#### Methods

| Method | Parameters | Returns | Description |
|--------|------------|---------|-------------|
| `reset()` | None | `void` | Resets internal state |

#### Events

| Event | Type | Description |
|-------|------|-------------|
| `selectionPatch` | `SelectionEvent` | Fired when values are modified via panel |

---

### LineChartLayer

Individual chart layer responsible for rendering and editing a single chart line.

```actionscript
public class LineChartLayer extends Group
```

#### Properties

| Property | Type | Description | Default |
|----------|------|-------------|---------|
| `dataProvider` | `ChartDescriptor` | Chart data and configuration | `null` |
| `editable` | `Boolean` | Whether chart can be edited | `true` |
| `markersFactory` | `InstanceFactory` | Factory for creating node markers | Auto-created |

#### Methods

| Method | Parameters | Returns | Description |
|--------|------------|---------|-------------|
| `clearSelection()` | `dispatch:Boolean=true` | `void` | Clears node selection |
| `deleteSelection()` | `dispatch:Boolean=true` | `void` | Removes selected nodes |
| `patchSelection()` | `patch:SelectionDetails`, `dispatch:Boolean=false` | `void` | Updates selected values |

## Data Classes

### ChartDescriptor

Immutable configuration for a chart line.

```actionscript
public class ChartDescriptor
```

#### Constructor

```actionscript
public function ChartDescriptor(
    uid:String, 
    values:Vector.<Point>, 
    name:String = null, 
    hueFactor:Number = 0, 
    dashStyle:Vector.<Number> = null
)
```

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| `uid` | `String` | Unique identifier (read-only) |
| `values` | `Vector.<Point>` | Chart points (read-only copy) |
| `name` | `String` | Display name (read-only) |
| `hueFactor` | `Number` | Color hue 0-1 (read-only) |
| `dashStyle` | `Vector.<Number>` | Dash pattern [dash,gap,...] (read-only) |

#### Example

```actionscript
var chart:ChartDescriptor = new ChartDescriptor(
    "envelope1",
    new <Point>[
        new Point(0, 0.1),
        new Point(0.5, 0.8),
        new Point(1, 0.2)
    ],
    "Volume Envelope",
    0.3,                        // Orange hue
    new <Number>[6, 3]          // Dashed line
);
```

---

### SelectionDetails

Immutable container for selection state information.

```actionscript
public class SelectionDetails
```

#### Constructor

```actionscript
public function SelectionDetails(
    selectedValue:Point, 
    selectedValues:Vector.<Point>, 
    selectionAnchor:Point, 
    chartName:String = null
)
```

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| `selectedValue` | `Point` | Primary selected node (read-only copy) |
| `selectedValues` | `Vector.<Point>` | All selected nodes (read-only copy) |
| `selectionAnchor` | `Point` | Last clicked node (read-only copy) |
| `chartName` | `String` | Associated chart name (read-only) |

---

### ChartEdit

Immutable container for chart modification operations.

```actionscript
public class ChartEdit
```

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| `uid` | `String` | Chart identifier (read-only) |
| `name` | `String` | Chart name (read-only) |
| `values` | `Vector.<Point>` | New chart values (read-only copy) |

## Event Classes

### NodalEvent

Base event class for Nodal library communications.

```actionscript
public class NodalEvent extends Event
```

#### Constants

| Constant | Value | Description |
|----------|-------|-------------|
| `LAYER_CLICK` | `"layerClick"` | Chart line clicked |
| `SELECTION_CHANGE` | `"selectionChange"` | Selection modified |
| `NODES_CHANGE` | `"nodesChange"` | Chart values changed |
| `CHART_ACTIVATION` | `"chartActivation"` | Active chart changed |
| `SELECTION_PATCH` | `"selectionPatch"` | Values modified via panel |

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| `uid` | `String` | Chart identifier |

---

### SelectionEvent

Event fired when node selection changes.

```actionscript
public class SelectionEvent extends NodalEvent
```

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| `details` | `SelectionDetails` | Selection information |

---

### ChartEditEvent

Event fired when chart values are modified.

```actionscript
public class ChartEditEvent extends NodalEvent
```

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| `edit` | `ChartEdit` | Modification details |

## Utility Classes

### InstanceFactory

Object pooling factory for memory-efficient component recycling.

```actionscript
public class InstanceFactory
```

#### Constructor

```actionscript
public function InstanceFactory(
    clazz:Class, 
    initialize:Function, 
    purge:Function
)
```

#### Methods

| Method | Parameters | Returns | Description |
|--------|------------|---------|-------------|
| `give()` | None | `*` | Gets instance from pool |
| `takeBack()` | `obj:*` | `void` | Returns instance to pool |
| `clear()` | None | `void` | Clears all pooled instances |

---

### Node

Internal representation of a chart node/marker.

```actionscript
public class Node
```

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| `logicalX` | `Number` | Normalized X position (0-1) |
| `logicalY` | `Number` | Normalized Y position (0-1) |
| `screenX` | `Number` | Screen X coordinate |
| `screenY` | `Number` | Screen Y coordinate |
| `isSynthetic` | `Boolean` | Auto-generated node |
| `isSelected` | `Boolean` | Selection state |
| `isAnchor` | `Boolean` | Last touched node |
| `isHovered` | `Boolean` | Mouse hover state |

## Constants

### Operating Modes

| Constant | Value | Description |
|----------|-------|-------------|
| `Nodal.READONLY` | `-1` | View-only mode, no interaction |
| `Nodal.NORMAL` | `0` | Full editing, click to switch charts |
| `Nodal.EXCLUSIVE` | `1` | Only active chart  editable |
| `Nodal.ISOLATED` | `2` | Active chart only, others hidden |

### Usage

```actionscript
chartEditor.operatingMode = Nodal.READONLY;
```

## Style Properties

### Chart Line Styles

| Style | Type | Description | Default |
|-------|------|-------------|---------|
| `lineColor` | `uint` | Normal line/node color | `0x3366CC` |
| `lineColorOver` | `uint` | Hover node color | `0xFF6600` |
| `lineColorSelected` | `uint` | Selected node color | `0xFF0000` |
| `lineColorAnchor` | `uint` | Anchor node border color | `0x00FF00` |
| `lineThickness` | `Number` | Line thickness in pixels. Nodes are 5x larger | `2` |

### Background Styles

| Style | Type | Description | Default |
|-------|------|-------------|---------|
| `bgColor` | `uint` | Background color | `0xF0F0F0` |
| `bgAlpha` | `Number` | Background transparency | `0.1` |
| `textColor` | `uint` | Label text color | `0x333333` |
| `textFontSize` | `Number` | Label font size | `11` |
| `padding` | `Number` | Cell padding | `5` |

### CSS Example

```css
.myNodalEditor {
    lineColor: #0066CC;
    lineColorSelected: #FF3300;
    lineThickness: 3;
}

.myBackground {
    bgColor: #F8F8F8;
    textColor: #666666;
    textFontSize: 10;
}
```

---

*This API reference covers version 1.0+ of the Nodal library.*
