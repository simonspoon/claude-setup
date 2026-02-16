# Tool Wrapper Pattern

For skills that wrap libraries, APIs, or command-line tools.

## Structure

```
skill-name/
├── SKILL.md (frontmatter + common operations + navigation)
├── REFERENCE.md (detailed API/command reference)
└── ADVANCED.md (optional: advanced usage patterns)
```

## When to Use

- Wrapping a specific library, API, or tool
- Need API reference documentation
- Multiple related operations on the same tool
- Common patterns can be demonstrated
- Users need both quick examples and detailed reference

## Template

```markdown
---
name: tool-name
description: [What it does]. Use when [trigger conditions mentioning the tool, library, or use case].
---

# Tool Name

## Quick Start

[Simplest example showing basic usage - typically <10 lines]

## Common Operations

### [Operation 1]
[Instructions + code example]

### [Operation 2]
[Instructions + code example]

### [Operation 3]
[Instructions + code example]

## Complete Examples

### Example 1: [Use Case]
[Full working example with context]

### Example 2: [Use Case]
[Full working example with context]

## Reference

See [REFERENCE.md](REFERENCE.md) for complete API documentation.

## Advanced Usage

See [ADVANCED.md](ADVANCED.md) for:
- [Advanced topic 1]
- [Advanced topic 2]
- [Advanced topic 3]
```

## Complete Example: Data Analysis Skill

**SKILL.md:**
```markdown
---
name: data-analysis
description: Analyze datasets using pandas and generate visualizations with matplotlib. Use when user needs data analysis, mentions CSV/Excel files, requests charts/statistics, or mentions pandas.
---

# Data Analysis with Pandas

Analyze datasets and create visualizations using pandas and matplotlib.

## Quick Start

```python
import pandas as pd

df = pd.read_csv("data.csv")
summary = df.describe()
print(summary)
```

## Common Operations

### Load Data

```python
import pandas as pd

# CSV files
df = pd.read_csv("data.csv")

# Excel files
df = pd.read_excel("data.xlsx", sheet_name="Sheet1")

# JSON files
df = pd.read_json("data.json")
```

### Clean Data

```python
# Remove duplicates
df = df.drop_duplicates()

# Handle missing values
df = df.fillna(0)  # Replace with 0
df = df.dropna()   # Remove rows with missing values

# Filter rows
df_filtered = df[df["column"] > 100]
```

### Analyze Data

```python
# Descriptive statistics
summary = df.describe()

# Group by operations
grouped = df.groupby("category")["value"].sum()

# Calculate correlations
correlation = df.corr()
```

### Visualize Results

```python
import matplotlib.pyplot as plt

# Bar chart
df.plot(kind="bar")
plt.savefig("chart.png")

# Line plot
df.plot(x="date", y="value", kind="line")
plt.savefig("trend.png")
```

## Complete Examples

### Example 1: Sales Analysis

```python
import pandas as pd
import matplotlib.pyplot as plt

# Load sales data
df = pd.read_csv("sales.csv")

# Calculate revenue by region
revenue_by_region = df.groupby("region")["revenue"].sum()

# Create visualization
revenue_by_region.plot(kind="bar", title="Revenue by Region")
plt.xlabel("Region")
plt.ylabel("Revenue ($)")
plt.savefig("revenue_analysis.png")

# Summary statistics
print(df.describe())
print(f"Total revenue: ${revenue_by_region.sum():,.2f}")
```

### Example 2: Data Cleaning Pipeline

```python
import pandas as pd

# Load data with issues
df = pd.read_csv("raw_data.csv")

# Remove duplicates
df = df.drop_duplicates()

# Handle missing values
df["age"] = df["age"].fillna(df["age"].median())
df["city"] = df["city"].fillna("Unknown")

# Remove outliers (values > 3 standard deviations)
df = df[df["value"] < (df["value"].mean() + 3 * df["value"].std())]

# Save cleaned data
df.to_csv("cleaned_data.csv", index=False)
print(f"Cleaned {len(df)} records")
```

## Reference

See [REFERENCE.md](REFERENCE.md) for:
- Complete pandas API reference
- All available plot types
- Data transformation methods
- Performance optimization tips

## Advanced Usage

See [ADVANCED.md](ADVANCED.md) for:
- Custom aggregations
- Multi-level indexing
- Time series analysis
- Large dataset handling
```

**REFERENCE.md:**
```markdown
# Pandas Reference

Complete API reference for common pandas operations.

## DataFrame Creation

```python
# From dictionary
df = pd.DataFrame({"col1": [1, 2], "col2": [3, 4]})

# From CSV with options
df = pd.read_csv("file.csv", sep=",", header=0, index_col=0)

# From Excel
df = pd.read_excel("file.xlsx", sheet_name="Sheet1")
```

## Data Selection

```python
# Select column
df["column_name"]
df.column_name

# Select multiple columns
df[["col1", "col2"]]

# Select rows by condition
df[df["age"] > 30]

# Select by position
df.iloc[0:5]  # First 5 rows

# Select by label
df.loc[df["name"] == "John"]
```

## Aggregation Methods

```python
# Basic statistics
df.mean()      # Mean of each column
df.sum()       # Sum of each column
df.count()     # Count non-null values
df.min()       # Minimum value
df.max()       # Maximum value
df.std()       # Standard deviation

# Group by aggregation
df.groupby("category").agg({
    "revenue": "sum",
    "count": "count",
    "price": "mean"
})
```

## Data Transformation

```python
# Apply function to column
df["new_col"] = df["old_col"].apply(lambda x: x * 2)

# Replace values
df.replace({"old_value": "new_value"})

# Rename columns
df.rename(columns={"old_name": "new_name"})

# Sort values
df.sort_values("column", ascending=False)
```

## Visualization Options

```python
# Plot types
df.plot(kind="line")      # Line plot
df.plot(kind="bar")       # Bar chart
df.plot(kind="barh")      # Horizontal bar
df.plot(kind="hist")      # Histogram
df.plot(kind="box")       # Box plot
df.plot(kind="scatter", x="col1", y="col2")  # Scatter plot
df.plot(kind="pie", y="column")              # Pie chart
```
```

## Key Characteristics

- **Tool-focused**: Centers on specific library or tool
- **Quick reference**: Common operations easily accessible
- **Progressive detail**: Basic → Advanced
- **Complete API reference**: Separate file for detailed docs
- **Working examples**: Show real-world usage

## Validation Checklist

Before finalizing:
- [ ] SKILL.md has common operations section
- [ ] At least 2 complete working examples
- [ ] REFERENCE.md has comprehensive API coverage
- [ ] Description mentions the tool/library name
- [ ] Examples show input and output
- [ ] Advanced topics in separate file (if needed)
