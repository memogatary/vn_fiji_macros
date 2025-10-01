// Save Selected ROIs
path = getDirectory("image");
originalImage = getTitle();
roiCount=roiManager("count");
roiManager("Add");
roiManager("Select",roiCount);
roiManager("Rename", ImageName);
run("Duplicate...", "duplicate");
// Subtract Background
run("Subtract Background...", "rolling=50 stack");
DupImageName = getTitle();
ImageNameFulArray = split(DupImageName,".");
ImageName = ImageNameFulArray[0];
// Open trackmate
run("TrackMate");


///// Manual Runs - Wait //////
waitForUser("Wait until finish manual TrackMate Running");

// Continue
run("Split Channels");
close("TrackMate capture of " + ImageName + " (blue)");
close("TrackMate capture of " + ImageName + " (green)");
selectImage("TrackMate capture of " + ImageName + " (red)");
run("Local Thickness (masked, calibrated, silent)");
//setThreshold(-1000000000000000000000000000000.0000, 1000000000000000000000000000000.0000); // Only 0 is background
rename(ImageName+"Local Thickness");

run("Measure");
saveAs("tiff", path+"LocalThickness" + File.separator + ImageName);
close("TrackMate capture of " + ImageName + " (red)");
close(ImageName);
close(DupImageName);
close(originalImage);
//waitForUser("Wait until Ready to close all");
//run("Close All");