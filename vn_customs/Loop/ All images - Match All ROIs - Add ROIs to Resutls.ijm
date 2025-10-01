macro "Loops all images, Match all ROIs" {
roiCount = roiManager("count");
for (j = 1; j <= nImages; j++) {
	selectImage(j);
	baseName = getTitle();
	for (i = 0; i < roiCount; i++) {
	    roiManager("Select", i);
	    roiName = Roi.getName();
	    if (indexOf(roiName,baseName) == 0) {
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