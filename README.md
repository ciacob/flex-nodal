# Nodal

*A Flex/AIR library for interactive multi-chart line editing.*

## Features
*Node-based envelope editor with dynamic grids and selection tools.*
- Edit multiple charts simultaneously.
- Drag nodes to adjust chart lines with real-time feedback.
- Background grids with customizable rows and columns.
- Selection tools for averaging, flooring, or ceiling selected nodes.
- Lightweight utilities for coordinate math, dashed graphics, and object pooling.

## Getting Started
*Add the library to your Flex project and instantiate the `Nodal` component.*

### Requirements
*Flex SDK 4.x or newer and an AIR-compatible build environment.*

### Installing
*Clone the repository and include the `src` folder in your project's source path.*
```bash
git clone https://github.com/ciacob/flex-nodal.git
```
*Compile your project as usual; no additional build steps are required.*

### Running the demo
*An integration demo lives in a separate repository.*
The [flex-nodal-tester](https://github.com/ciacob/flex-nodal-tester) repository provides sample data and a ready-to-run application.

## Architecture
*Modular components cooperate through events and shared utilities.*
- **Nodal.mxml** – top-level component managing charts and user actions.
- **LineChartLayer.mxml** – renders and edits chart lines and nodes.
- **BackgroundChartLayer.mxml** – draws the underlying grid.
- **SelectionPanel.mxml** – exposes actions for the current selection.
- **Utilities** – helper classes for geometry, selection management, and graphics.

## Development
*Contributions are welcome through pull requests.*
- Follow Flex coding conventions.
- Tests and demos reside in [`flex-nodal-tester`](https://github.com/ciacob/flex-nodal-tester) and should accompany significant changes.

## License
Licensed under the [MIT](https://github.com/ciacob/flex-nodal/blob/master/LICENSE) license terms.
