from ij.gui import GenericDialog, Plot
from ij.measure import ResultsTable
from java.awt import Color
import random

# Function to generate a random color
def random_color():
    r = random.randint(0, 199)
    g = random.randint(0, 199)
    b = random.randint(0, 199)
    return Color(r, g, b)

# Get the ResultsTable
rt = ResultsTable.getResultsTable()

# Prompt user to select the column to plot
gd = GenericDialog("Select Columns and Number of Groups")
gd.addChoice("Select Y-axis column:", rt.getHeadings(), "Area")
gd.addNumericField("Number of groups:", 2, 0)
gd.addNumericField("Number of default prefix character:", 3, 0)
gd.showDialog()

if gd.wasCanceled():
    print("Script canceled by user.")
    exit()

y_column_name = gd.getNextChoice()
num_groups = int(gd.getNextNumber())
num_character = int(gd.getNextNumber())

# Multiple input prompt for group prefixes
gd_groups = GenericDialog("Group Prefixes")
entered_prefixes = []
step_size = max(1, rt.size() // num_groups)

for i in range(num_groups):
    row_index = i * step_size
    first_label = rt.getStringValue("Label", row_index)
    default_prefix = first_label[:num_character] if len(first_label) >= num_character else ""
    gd_groups.addStringField("Prefix for group %d:" % (i + 1), default_prefix, 20)
gd_groups.showDialog()

if gd_groups.wasCanceled():
    print("Script canceled by user.")
    exit()

# Collect unique prefixes only
for i in range(num_groups):
    prefix = gd_groups.getNextString()
    if prefix not in entered_prefixes:
        entered_prefixes.append(prefix)

group_prefixes = entered_prefixes

# Create empty lists to store the grouped data
grouped_data = {prefix: [] for prefix in group_prefixes}

# Group data based on prefixes
for i in range(rt.size()):
    label = rt.getStringValue("Label", i)
    y_value = rt.getValue(y_column_name, i)

    for prefix in group_prefixes:
        if label.startswith(prefix):
            grouped_data[prefix].append(y_value)

# Prepare to plot
x_labels = ["%s (%d)" % (prefix, len(grouped_data[prefix])) for prefix in group_prefixes]
plot = Plot(y_column_name + " Comparison", " vs ".join(x_labels), y_column_name)

# Calculate x values based on the group positions with a smaller range
group_spacing = 1000
x_range = 400

for i, prefix in enumerate(group_prefixes):
    group_data = grouped_data[prefix]
    base_x = (i + 1) * group_spacing
    if group_data:  # Only if there are data points for this group
        x_values = [base_x - x_range/2 + (j * x_range) / max(1, len(group_data) - 1) for j in range(len(group_data))]
        plot.setColor(random_color())  # Set random color for the group
        plot.addPoints(x_values, group_data, Plot.CIRCLE)

# Set x-axis limits and show the plot
minY = min(min(grouped_data[prefix]) for prefix in group_prefixes if grouped_data[prefix])
maxY = max(max(grouped_data[prefix]) for prefix in group_prefixes if grouped_data[prefix])

# Adjust minY and maxY for padding
padding = 0.1 * (maxY - minY)
minY = min(0, minY - padding) if minY < 0 else 0
maxY += padding

plot.setLimits(0, (len(group_prefixes) + 1) * group_spacing, minY, maxY)
plot.show()

# Display completion message
print("Script completed.")
