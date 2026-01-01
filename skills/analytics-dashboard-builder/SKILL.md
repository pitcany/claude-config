---
name: analytics-dashboard-builder
description: Use when building dashboards, creating charts, or visualizing data insights. Provides matplotlib, plotly, seaborn patterns for Python and Chart.js/D3.js for JavaScript. Covers chart selection, color palettes, and interactive dashboard creation.
---

# Analytics Dashboard Builder

## Overview

Build professional data visualizations with emphasis on clarity, interactivity, and performance. Covers both Python (matplotlib, seaborn, plotly) and JavaScript (Chart.js, D3.js) visualization stacks.

## When to Use

- Creating charts and visualizations
- Building interactive dashboards
- Choosing the right chart type for data
- Designing professional color schemes

## Quick Reference

| Data Question | Chart Type | Python | JavaScript |
|---------------|------------|--------|------------|
| Compare values | Bar/Column | `plt.bar()` | `Chart.js Bar` |
| Show distribution | Histogram | `plt.hist()` | `D3 histogram` |
| Show relationship | Scatter | `plt.scatter()` | `Plotly Scatter` |
| Track over time | Line | `plt.plot()` | `Chart.js Line` |
| Part of whole | Pie/Donut | `plt.pie()` | `Chart.js Doughnut` |
| Correlation | Heatmap | `sns.heatmap()` | `Plotly Heatmap` |
| Multiple series | Stacked Bar | `plt.bar(bottom=)` | `Chart.js stacked` |

## Visualization Stack

**Python**: Matplotlib, Seaborn, Plotly
**JavaScript**: Chart.js, D3.js, Recharts, Plotly.js

## Chart Selection Guide

- **Comparison**: Bar/Column charts
- **Distribution**: Histogram, Box plot, Violin plot
- **Relationship**: Scatter plot, Heatmap
- **Composition**: Stacked bar, Treemap
- **Trend**: Line chart, Area chart
- **Geographic**: Choropleth, Heat map

## Matplotlib Best Practices

```python
import matplotlib.pyplot as plt
import seaborn as sns

plt.style.use('seaborn-v0_8-darkgrid')
fig, ax = plt.subplots(figsize=(10, 6), dpi=100)

ax.plot(x, y, linewidth=2, alpha=0.8, label='Data')
ax.set_xlabel('X Label', fontsize=12, fontweight='bold')
ax.set_ylabel('Y Label', fontsize=12, fontweight='bold')
ax.set_title('Chart Title', fontsize=14, fontweight='bold', pad=20)
ax.grid(True, alpha=0.3)
ax.legend(loc='best')

plt.tight_layout()
plt.savefig('output.png', dpi=300, bbox_inches='tight')
```

## Plotly Interactive Dashboards

```python
import plotly.graph_objects as go

fig = go.Figure()
fig.add_trace(go.Scatter(x=x, y=y, mode='lines+markers'))
fig.update_layout(
    title='Interactive Chart',
    xaxis_title='X Axis',
    yaxis_title='Y Axis',
    hovermode='closest'
)
fig.write_html('dashboard.html')
```

## React Chart Components

```javascript
import { Line } from 'react-chartjs-2';

const SalesChart = ({ data }) => {
  const chartData = {
    labels: data.map(d => d.date),
    datasets: [{
      label: 'Sales',
      data: data.map(d => d.value),
      borderColor: 'rgb(46, 134, 171)',
      backgroundColor: 'rgba(46, 134, 171, 0.1)',
    }]
  };

  return <Line data={chartData} options={options} />;
};
```

## Professional Color Palettes

```python
CORPORATE = ['#2E86AB', '#A23B72', '#F24236', '#F18F01', '#C73E1D']
PASTEL = ['#B4D5EF', '#E5B3CF', '#FFC2C7', '#FFE5B9', '#FFD9B7']
VIBRANT = ['#FF6B6B', '#4ECDC4', '#45B7D1', '#FFA07A', '#98D8C8']
```

## Common Mistakes

| Mistake | Problem | Fix |
|---------|---------|-----|
| Too many colors | Cognitive overload | Limit to 5-7 colors max |
| No axis labels | Chart is unreadable | Always add `xlabel`, `ylabel` |
| 3D charts | Distorts perception | Use 2D; 3D only for actual 3D data |
| Pie with many slices | Hard to compare | Use bar chart for >5 categories |
| Missing `tight_layout()` | Labels cut off | Always call before `savefig()` |
| Low DPI export | Blurry images | Use `dpi=300` for print quality |
| Rainbow colormaps | Not colorblind-safe | Use `viridis`, `plasma`, or sequential |

## Related Skills

- **data-analysis-workflow** - Preparing data for visualization with pandas
- **r-statistical-computing** - ggplot2 visualization patterns
- **postgresql-data-ops** - Querying data for dashboards
