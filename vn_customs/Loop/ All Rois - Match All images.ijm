macro "Loops all Rois - Match all images" {
roiCount = roiManager("count");
for (j = 1; j <= nImages; j++) {
	selectImage(j);
	baseName = getTitle();
	for (i = 0; i < roiCount; i++) {
	    roiManager("Select", i);
	    roiName = Roi.getName();
	    if (indexOf(roiName, baseName) == 0) {
		break;
	    }
		else {
		Roi.selectNone;
		}
	}
}
}