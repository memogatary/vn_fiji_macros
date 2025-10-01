RoiAlignedTopLeftRoi();


function RoiAlignedTopLeftRoi() {
	Roi.getCoordinates(xpoints, ypoints);
	Array.getStatistics(xpoints, xmin, xmax, xmean, xstdDev);
	Array.getStatistics(ypoints, ymin, ymax, ymean, ystdDev);
	rC1 = roiManager("count");
	RoiType = Roi.getType;
	if (RoiType != "composite") {
		for (i=0; i<xpoints.length; i++) {
			xpoints[i] = xpoints[i] - xmin;
		}
		for (i=0; i<ypoints.length; i++) {
			ypoints[i] = ypoints[i] - ymin;
		}
		makeSelection("freehand", xpoints, ypoints);
	}
	else {
		roiManager("split");
		rC2 = roiManager("count");
		nRoi = rC2 - rC1;
		roiArray = newArray(nRoi);
		for (i=0; i<nRoi; i++) {
			RoiIndex = rC1 + i;
			roiManager("select", RoiIndex);
			roiArray[i] = RoiIndex;
			print("RoiIndex = " + RoiIndex);
			Roi.getCoordinates(xpoints, ypoints);
			for (j=0; j<xpoints.length; j++) {
				xpoints[j] = xpoints[j] - xmin;
			}
			for (j=0; j<ypoints.length; j++) {
				ypoints[j] = ypoints[j] - ymin;
			}
			makeSelection("freehand", xpoints, ypoints);
			roiManager("update");
		}
		roiManager("deselect");
		Array.print(roiArray);
		roiManager("select", roiArray);
		roiManager("combine");
		roiManager("Add");
		roiManager("select", roiArray);
		roiManager("delete");
		roiManager("select", rC1);
		roiManager("delete");
	}
}