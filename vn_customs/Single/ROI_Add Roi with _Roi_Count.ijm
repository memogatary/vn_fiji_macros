macro "Rename ROI with _Roi_Count [n.]" 
{
// Save and Measure Selected ROIs
roiCount = roiManager("count");
roiManager("Add");
roiManager("Select", roiCount);
baseName = getTitle();
newName = baseName + "_Roi_1";
suffix = 2;
// Use a for loop to iterate over existing ROIs
for (i = 0; i < roiCount; i++) {
    roiManager("Select", i);
    roiName = Roi.getName();
    // Check if the current ROI name matches the newName
    if (roiName == newName) {
        // If there's a match, generate a new name by adding a suffix
        newName = baseName + "_Roi_" + suffix;
        suffix++;
        // Reset the loop to start checking again from the first ROI
        i = -1;  // i will become 0 after the increment, restarting the loop
    }
}
// Finally, rename the ROI to the new unique name
roiManager("Select", roiCount);
roiManager("Rename", newName);
}