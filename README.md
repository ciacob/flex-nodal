# Nodal - Interactive Multi-Chart Line Editor

*A powerful Flex/AIR library for creating node-based envelope editors with dynamic grids and advanced selection tools.*

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flex Version](https://img.shields.io/badge/Flex-4.x%2B-blue.svg)]()
[![AIR Compatible](https://img.shields.io/badge/AIR-Compatible-green.svg)]()

## ✨ Features

### Core Functionality
- **Multi-Chart Editing**: Edit multiple chart lines with independent behavior
- **Real-Time Interaction**: Drag nodes to adjust values with immediate visual feedback
- **Advanced Selection**: Multi-select with Ctrl/Cmd and Shift for advanced selection 
- **Grid Background**: Customizable background grids with labels for visual context
- **Operating Modes**: Multiple modes including *readonly*, *normal*, *exclusive*, and *isolated* editing

### Visual & Performance
- **Smooth Graphics**: Hardware-accelerated rendering with custom dashed line support
- **Object Pooling**: Memory-efficient component recycling for optimal performance
- **Flexible Styling**: CSS-based theming with customizable colors, thickness, and other visual properties
- **Responsive Design**: Scales smoothly across different screen sizes

### Selection Tools
- **Smart Selection**: Click, Ctrl/Cmd+click, and Shift+Ctrl/Cmd+click selection patterns
- **Bulk Operations**: Floor, ceiling, and average operations on selected nodes
- **Value Editing**: Direct numerical input for precise value control
- **Range Visualization**: Visual feedback for selection ranges and values

## 🚀 Quick Start

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/ciacob/flex-nodal.git
   ```

2. **Add to your Flex project:**
   - Include the `src` folder in your project's source path
   - Or compile as SWC and add to library path

3. **Import and use:**
   ```actionscript
   import com.github.ciacob.flexnodal.Nodal;
   import com.github.ciacob.flexnodal.utils.ChartDescriptor;
   ```

### Basic Usage

```xml
<!-- In your MXML file -->
<flexnodal:Nodal id="chartEditor"
    width="100%" height="400"
    dataProvider="{chartData}"
    gridDataProvider="{gridData}"
    operatingMode="{Nodal.NORMAL}"
    selectionChange="_onSelectionChanged(event)"
    nodesChange="_onNodesChanged(event)"
    chartActivation="_onChartActivated(event)" />
```

```actionscript
// Create chart data
private var chartData:Vector.<ChartDescriptor> = new <ChartDescriptor>[
    new ChartDescriptor(
        "chart1",                           // uid
        new <Point>[                        // values
            new Point(0, 0.2),             // (time, value) pairs
            new Point(0.5, 0.8),
            new Point(1, 0.1)
        ],
        "My Chart",                         // display name
        0.3,                               // hue factor (0-1)
        new <Number>[8, 4]                 // dash style [dash, gap]
    )
];

// Create grid data
private var gridData:ArrayCollection = new ArrayCollection([
    {axis: 'x', stop: 0.25, label: '25%'},
    {axis: 'x', stop: 0.5, label: '50%'},
    {axis: 'x', stop: 0.75, label: '75%'},
    {axis: 'y', stop: 0.2, label: '20%'},
    {axis: 'y', stop: 0.4, label: '40%'},
    {axis: 'y', stop: 0.6, label: '60%'},
    {axis: 'y', stop: 0.8, label: '80%'}
]);
```

## 📋 Requirements

- **Flex SDK**: 4.x or newer
- **Runtime**: Adobe AIR or Flash Player 11.1+
- **ActionScript**: 3.0
- **Build Tools**: Compatible with asconfigc, Flash Builder, or similar

## 🏗️ Architecture

The library follows a modular, event-driven architecture:

```
Nodal (Main Container & Orchestrator)
├── LineChartLayer (Individual Charts)
├── BackgroundChartLayer (Grid)
├── SelectionPanel (Selection Tools)
└── Utilities
    ├── SelectionManager
    ├── ChartCoordinates
    ├── DashGraphics
    └── InstanceFactory (Object Pooling)
```

### Key Components

| Component | Purpose | Key Features |
|-----------|---------|--------------|
| `Nodal.mxml` | Main orchestrator | Multi-chart management, mode switching |
| `LineChartLayer.mxml` | Individual chart rendering | Node editing, selection, drag & drop |
| `BackgroundChartLayer.mxml` | Grid background | Customizable grid lines and labels |
| `SelectionPanel.mxml` | Selection tools | Bulk operations, value editing |

## 🎛️ Operating Modes

| Mode | Description | Use Case |
|------|-------------|----------|
| `READONLY` | View-only, no interaction | Display mode, previews |
| `NORMAL` | Full editing, click to switch active chart | Standard multi-chart editing |
| `EXCLUSIVE` | Only active chart **editable** | Focus on single chart |
| `ISOLATED` | Only active chart **visible** | Distraction-free editing |

## 📊 Data Format

Charts use normalized coordinates where:
- **X-axis**: 0.0 (start) to 1.0 (end) - represents time/position
- **Y-axis**: 0.0 (bottom) to 1.0 (top) - represents value/amplitude

```actionscript
// Example: Envelope that starts low, peaks in middle, ends low
new <Point>[
    new Point(0, 0.1),      // Start at 10%
    new Point(0.5, 0.9),    // Peak at 50% time, 90% value
    new Point(1, 0.2)       // End at 20%
]
```

## 🎨 Styling

Nodal supports CSS-based styling:

```css
/* Chart line appearance */
.myChart {
    lineColor: #3366CC;
    lineColorOver: #FF6600;
    lineColorSelected: #FF0000;
    lineColorAnchor: #00FF00;
    lineThickness: 3;
}

/* Background styling */
.myBackground {
    bgColor: #F0F0F0;
    bgAlpha: 0.8;
    textColor: #333333;
    textFontSize: 12;
}
```

## 🔧 Events

| Event | When Fired | Data Provided |
|-------|------------|---------------|
| `selectionChange` | Node selection changes | `SelectionEvent` with selection details |
| `nodesChange` | Chart values modified | `ChartEditEvent` with new values |
| `chartActivation` | Active chart switches | `NodalEvent` with chart UID |

## 🎮 Demo Application

A complete demo application is available in the [flex-nodal-tester](https://github.com/ciacob/flex-nodal-tester) repository, showing:

- Multi-chart setup and configuration
- Event handling patterns
- Selection panel integration
- Mode switching examples
- Styling customization

## 🤝 Contributing

Contributions are welcome! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

1. Fork the repository
2. Create a feature branch
3. Add tests for new functionality
4. Ensure all tests pass
5. Submit a pull request

## 📄 License

Licensed under the [MIT License](LICENSE) - see the LICENSE file for details.

## 🔗 Related Projects

- [flex-nodal-tester](https://github.com/ciacob/flex-nodal-tester) - Demo application and integration examples

---

*Made with ❤️ for the ActionScript/Flex community*
