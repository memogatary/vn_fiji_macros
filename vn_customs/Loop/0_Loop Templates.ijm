macro "Loop through all images" // Image Indexes from 1 to nImages
{
for (j=1; j<=nImages; j++) {
selectImage(j);
// Code Here
}
}

macro "Loop through all ROIs" // Roi Indexes from 0 to roiCount - 1
{
roiCount = roiManager("count");
for (i = 0; i < roiCount; i++) {
    roiManager("Select", i);
    roiName = Roi.getName();
    // Code Here
    
}
}

macro "Loops all images, Match all ROIs, Measure and add RoiName to table" {
roiCount = roiManager("count");
for (j = 1; j <= nImages; j++) {
	selectImage(j);
	baseName = getTitle();
	for (i = 0; i < roiCount; i++) {
	    roiManager("Select", i);
	    roiName = Roi.getName();
	    if (indexOf(roiName, baseName) == 0) {
		// Do the Code here
		run("Measure");
		// Add Roiname to Result Table
		setResult("RoiName", nResults-1, roiName);
	    }
		else {
		Roi.selectNone;
		}
	}
}
}