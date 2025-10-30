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
hds = rt.getHeadings()
hds_length = len(hds)

headingArray = []
CheckBoxValues = []
for i in range(len(hds)):
    headingArray.append(hds[i])
    CheckBoxValues.append(0)  # Default will select everything
CheckBoxValues[0] = 0   # Label/1st Column is often group names

# Prompt user to select the column to plot
gd = GenericDialog("Select Columns and Number of Groups")
# Add input for optional prefix filter
gd.addStringField("Group Column:", "Label", 20)
gd.addMessage("Select Graphs to Display")
gd.addCheckboxGroup(4, hds_length, headingArray, CheckBoxValues)
gd.addNumericField("Number of groups:", 3, 0)
gd.addNumericField("Number of default prefix character:", 5, 0)
# Add input for optional prefix filter
gd.addStringField("Filter prefix (optional):", "", 20)
gd.showDialog()

selected = [gd.getNextBoolean() for _ in headingArray]   # [False, True, …]

if gd.wasCanceled():
    print("Script canceled by user.")
    exit()

num_groups = int(gd.getNextNumber())
num_character = int(gd.getNextNumber())
GroupColumn = gd.getNextString().strip()  # Get the optional prefix string
filter_prefix = gd.getNextString().strip()  # Get the optional prefix string

# Create a set of unique prefixes based on the first 'num_character' characters of the 'Label' column
unique_prefixes = set()
for i in range(rt.size()):
    label = rt.getStringValue(GroupColumn, i)
    prefix = label[:num_character] if len(label) >= num_character else label

    # Apply filter only if filter_prefix is not empty
    if filter_prefix == "" or prefix.startswith(filter_prefix):
        unique_prefixes.add(prefix)

# Sort the prefixes for easier selection
unique_prefixes = sorted(unique_prefixes)

# Create a dropdown selection for group prefixes
gd_groups = GenericDialog("Group Prefixes")
selected_prefixes = []

# Create dropdown menus for each group
for i in range(num_groups):
    default_prefix = unique_prefixes[i] if i < len(
        unique_prefixes) else unique_prefixes[0]
    gd_groups.addChoice("Prefix for group %d:" %
                        (i + 1), unique_prefixes, default_prefix)

gd_groups.showDialog()

if gd_groups.wasCanceled():
    print("Script canceled by user.")
    exit()

# Collect the selected prefixes
for i in range(num_groups):
    selected_prefixes.append(gd_groups.getNextChoice())

# Create empty lists to store the grouped data
grouped_data = {prefix: [] for prefix in selected_prefixes}

######## MAKE PLOT ################
for iteration, checkvalue in enumerate(selected):
    if checkvalue:
        y_column_name = headingArray[iteration]
        
        # RESET for this graph
        grouped_data = {prefix: [] for prefix in selected_prefixes}

        # Group data based on selected prefixes
        for i in range(rt.size()):
            label = rt.getStringValue(GroupColumn, i)
            y_value = rt.getValue(y_column_name, i)

            for prefix in selected_prefixes:
                if label.startswith(prefix):
                    grouped_data[prefix].append(y_value)

        # Prepare to plot
        x_labels = ["%s (%d)" % (prefix, len(grouped_data[prefix]))
                    for prefix in selected_prefixes]
        plot = Plot(y_column_name + " Comparison",
                    " vs ".join(x_labels), y_column_name)

        # Calculate x values based on the group positions with a smaller range
        group_spacing = 1000
        x_range = 400

        for i, prefix in enumerate(selected_prefixes):
            group_data = grouped_data[prefix]
            base_x = (i + 1) * group_spacing
            if group_data:  # Only if there are data points for this group
                x_values = [base_x - x_range / 2 + (j * x_range) / max(
                    1, len(group_data) - 1) for j in range(len(group_data))]
                plot.setColor(random_color())  # Set random color for the group
                plot.addPoints(x_values, group_data, Plot.CIRCLE)

        # Set x-axis limits and show the plot
        minY = min(min(grouped_data[prefix])
                   for prefix in selected_prefixes if grouped_data[prefix])
        maxY = max(max(grouped_data[prefix])
                   for prefix in selected_prefixes if grouped_data[prefix])

        # Adjust minY and maxY for padding
        padding = 0.1 * (maxY - minY)
        minY = min(0, minY - padding) if minY < 0 else 0
        maxY += padding

        plot.setLimits(0, (len(selected_prefixes) + 1)
                       * group_spacing, minY, maxY)
        plot.show()

        # Display completion message
        print("Script completed.")
