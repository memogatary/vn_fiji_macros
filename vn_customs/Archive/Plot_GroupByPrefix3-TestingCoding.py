from ij.gui import GenericDialog, Plot
from ij.measure import ResultsTable
from java.awt import Color
import random

print("++++")

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
    CheckBoxValues.append(1) #Default will select everything
CheckBoxValues[0] = 0   # Label/1st Column is often group names 
print(headingArray)



#Prompt user to select the column to plot
gd = GenericDialog("Select Columns and Number of Groups")
gd.addMessage("Select Columns to Display")
gd.addCheckboxGroup(4, hds_length, headingArray, CheckBoxValues)
gd.showDialog()
#

selected = [gd.getNextBoolean() for _ in headingArray]   # [False, True, …]
print(selected)

for iteration, checkvalue in enumerate(selected):
	if checkvalue:
		