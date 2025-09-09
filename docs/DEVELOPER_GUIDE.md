# Developer Guide - Nodal Library

This developer guide provides the foundation for understanding and extending the Nodal library.

### Component Hierarchy

The Nodal library follows a layered architecture with clear separation of concerns:

```
┌─────────────────────────────────────────┐
│ Nodal (Orchestrator)                    │
├─────────────────────────────────────────┤
│ ┌─────────────┐ ┌─────────────────────┐ │
│ │Background   │ │ Chart Layers Stack  │ │
│ │Layer        │ │ ┌─────────────────┐ │ │
│ │             │ │ │ LineChartLayer  │ │ │
│ │ ┌─────────┐ │ │ │ ┌─────────────┐ │ │ │
│ │ │ Grid    │ │ │ │ │ Markers     │ │ │ │
│ │ │ Cells   │ │ │ │ │ Layer       │ │ │ │
│ │ └─────────┘ │ │ │ └─────────────┘ │ │ │
│ └─────────────┘ │ │ ┌─────────────┐ │ │ │
│                 │ │ │ Chart       │ │ │ │
│                 │ │ │ Layer       │ │ │ │
│                 │ │ └─────────────┘ │ │ │
│                 │ └─────────────────┘ │ │
│                 └─────────────────────┘ │
└─────────────────────────────────────────┘
```

### Data Flow

Understanding the data flow is crucial for effective integration:

```
1. External Data → ChartDescriptor (Immutable)
2. ChartDescriptor → Node[] (Internal Representation)
3. Node[] → Screen Coordinates (Rendering)
4. User Interaction → Node Updates
5. Node Updates → ChartEdit (Immutable)
6. ChartEdit → External Data (Via Events)
```

### Event System Architecture

The event system uses a hierarchical dispatch pattern:

```actionscript
// Low-level component events
LineChartLayer → SelectionEvent/ChartEditEvent
     ↓
// Mid-level aggregation
Nodal → Redispatch with context
     ↓
// Application-level handling
Your Application → Business Logic
```

---
See also the [Complete API documentation](API_REFERENCE.md).
