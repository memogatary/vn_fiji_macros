// Save and Measure Selected ROIs
roiCount = roiManager("count");
roiManager("Add");
roiManager("Select", roiCount);
baseName = getTitle();
newName = baseName;
suffix = 2;
// Use a for loop to iterate over existing ROIs
for (i = 0; i < roiCount; i++) {
    roiManager("Select", i);
    roiName = Roi.getName();
    // Check if the current ROI name matches the newName
    if (roiName == newName) {
        // If there's a match, generate a new name by adding a suffix
        newName = baseName + "_" + suffix;
        suffix++;
        // Reset the loop to start checking again from the first ROI
        i = -1;  // i will become 0 after the increment, restarting the loop
    }
}
// Finally, rename the ROI to the new unique name
roiManager("Select", roiCount);
roiManager("Rename", newName);
run("Measure");
Area = getResult("Area", nResults-1);
IJ.renameResults("Results","Temp Results");
// Duplicate selected area (ROIs), channel 2 (actin) only, work on this duplicated image
getLocationAndSize(x, y, width, height);
run("Duplicate...", "duplicate channels=2");
setLocation(x+width, y, width, height);
getLocationAndSize(x, y, width, height);
// Clear Outside, Subtract Background, Analyze Particles, Reposition
run("Make Inverse");
run("Clear", "slice");
run("Make Inverse");
run("Subtract Background...", "rolling=5 slice");
setAutoThreshold("Default dark");
run("Analyze Particles...", "size=0.03-0.58 circularity=0.40-1.00 show=Masks include summarize");
selectImage(nImages);
setLocation(x+width, y, width, height);
// Get result and rename tables
IJ.renameResults("Summary","Results");
Count = getResult("Count", nResults-1);
IJ.renameResults("Results","Summary");
IJ.renameResults("Temp Results","Results");
setResult("Count", nResults-1, Count);
setResult("Count/Area", nResults-1, Count/Area);
setResult("Count/Area X 100", nResults-1, Count/Area*100);
selectWindow("Summary");
Table.setLocationAndSize(0, screenHeight*0.5, screenWidth, screenHeight*0.25);
selectWindow("Results");
Table.setLocationAndSize(0, screenHeight*0.6, screenWidth, screenHeight*0.38);
