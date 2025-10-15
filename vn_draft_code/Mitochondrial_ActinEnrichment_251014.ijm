// ========= NOTES =============
//In the Results Table:
//- Each row is one measure from channel 2 (Actin channel), using MitoMaskArea So:
//	+ Intensity related, e.g., Mean: is from Actin
//	+ Morphology related, e.g., Area: is from Mitochondria
//  + Image WILL BE MODIFED after each run => DON"T RUN SEVERAL ROI in ONE SINGLE OPENING IMAGE

// ========= MAIN =============
setBatchMode("hide");
// 0. ROI same
ROI_AddImageNameWithSuffix("_1-CellMask",1);

// 1. Preprocess Actin Channel
BG_SUBSTRACT_mode_MOD(2,1);

// 2. Make Mitochondria Mask
SELECTION_PercentileAutoThreshold_MOD(3, "Moments", 1.0, 99.0, 0.5);
Stack.setDisplayMode("composite");
ROI_AddImageNameWithSuffix("_2-MitoMask",1);

// MEASURSE: MITO MASK
setSlice(2);
run("Measure");
MitoMaskArea = getValue("Area");
GroupName ="MitoMeasure_" + substring(getTitle(), 0, 3); // Get name without extension.
GroupNameLength = lengthOf(GroupName);
setResult("Group (len="+GroupNameLength+")", nResults-1, GroupName); // for STRING

// MEASURE MitoActinArea
rC = roiManager("count");
roiManager("Select", rC-2); // Selecting CellMask
SELECTION_PercentileAutoThreshold_MOD(2, "Moments", 1.0, 99.0, 0); // Actin Mask Selection
ROI_AddImageNameWithSuffix("_3-ActinMask",1);

rC = roiManager("count");
roiManager("Select", newArray(rC-1,rC-2));
roiManager("AND");
if (selectionType() == -1) {
	MitoActinArea = 0;
}
else {
	MitoActinArea = getValue("Area");
}
setResult("MitoActinOverlapArea", nResults-1, MitoActinArea); 
setResult("Fraction", nResults-1, MitoActinArea/MitoMaskArea);  


setBatchMode("show");

// =============== FUNCTIONS ======================


// 0. ROI same
function ROI_AddImageNameWithSuffix(suffix, startnumber) {
    if (selectionType() == -1) {
        print("No selection found");
        return "";
    }

    roiCount = roiManager("count");
    roiManager("Add");
    roiManager("Select", roiCount);

    baseName = File.getNameWithoutExtension(getTitle());
    prefix   = baseName + suffix;

    // Start from requested number
    count = startnumber;
    CropName = prefix + count;

    // Keep incrementing until unique
    unique = false;
    while (!unique) {
        unique = true;
        for (i = 0; i < roiCount; i++) {
            roiManager("Select", i);
            roiName = Roi.getName();
            if (roiName == CropName) {
                count++;
                CropName = prefix + count;
                unique = false;
                break; // restart while loop
            }
        }
    }

    roiManager("Select", roiCount);
    roiManager("Rename", CropName);
    return CropName;
}


// 1. MOD: subtract by ignoring selection
function BG_SUBSTRACT_mode_MOD(channel, smooth) {
	Stack.setDisplayMode("color");
	setSlice(channel);
	run("Select None"); // MOD
	mode = getValue("Mode");
	if (mode>120) {
		print("mode = " + mode + "in image: " + getTitle());
	}
	run("Subtract...", "value="+mode);
	if (smooth) {
		run("Smooth", "slice");
	}
	run("Restore Selection"); // MOD
}

// 2.
function SELECTION_PercentileAutoThreshold_MOD(Channel, method, low, high, enlarge) {
	ori_image = getImageID();
	if (selectionType() != -1) {
		print("Threshold with " + method + " on channel " + Channel + " using Low/High percentile of " + low + "/" + high);
		nR = roiManager("count");
		roiManager("add"); // nR - 1
		run("Select None");
		run("Duplicate...", "title=Temporary duplicate channels=" + Channel);
		roiManager("Select", nR); //1
		
		
		run("Smooth");
		pLo = percentileFromRaw(low);
		pHi = percentileFromRaw(high);
		setMinAndMax(pLo, pHi);

		setAutoThreshold(method + " dark");
		run("Create Selection");
		
		run("Enlarge...", "enlarge=" + enlarge); // By default is calibrated unit (like micron)
		if (selectionType() != -1) {
			nR = roiManager("count"); // Reset nR
			roiManager("add"); // nR
			roiManager("Select", newArray(nR, nR - 1));
			roiManager("AND");
			roiManager("add"); // Rest nR
			close("Temporary");
			selectImage(ori_image);
			nR = roiManager("count");
			roiManager("deselect");
			roiManager("Select", nR - 3);
			roiManager("delete");
			roiManager("Select", nR - 3);
			roiManager("delete");
			roiManager("Select", nR - 3); // Overlap ROI
			roiManager("delete");
		}
		else {
			close("Temporary");
			roiManager("delete");
			selectImage(ori_image);
			run("Select None");
			print("No region detected.");
		}
	}
	function percentileFromRaw(p) {
    // p in [0,100], returns intensity at percentile p from RAW histogram
    getRawStatistics(n, mean, minv, maxv, std, hist); // hist: 256 bins over RAW min..max
    total = 0; for (i=0; i<hist.length; i++) total += hist[i];
    target = total * p/100.0;
    acc = 0;
    for (i=0; i<hist.length; i++) { acc += hist[i]; if (acc >= target) break; }
    // map bin -> intensity
    return minv + (maxv - minv) * (i + 0.5)/hist.length;
}
}