setBatchMode("hide");

/// ==== FILE PATHS ==== 

dir1 = "C:/Users/Shaw lab/Box/Shaw Lab/Vu/Thesis Work/Vu_2 (Imaging)/mtPHAGY  (Dojinjo)/3- G2R HEK_DyeBeforeTransfection/Tiff/Baseline/";
a1 = FullPathForImagesInFolder(dir1);
dir2 = "C:/Users/Shaw lab/Box/Shaw Lab/Vu/Thesis Work/Vu_2 (Imaging)/mtPHAGY  (Dojinjo)/3- G2R HEK_DyeBeforeTransfection #4/tiff/";
a2 = FullPathForImagesInFolder(dir2);
dir3 = "C:/Users/Shaw lab/Box/Shaw Lab/Vu/Thesis Work/Vu_2 (Imaging)/mtPHAGY  (Dojinjo)/3- G2R HEK_DyeBeforeTransfection #5/tiff/";
a3 = FullPathForImagesInFolder(dir3);
a = Array.concat(a1,a2,a3);
print("Len A1: " + lengthOf(a1));
print("Len A2: " + lengthOf(a2));
print("Len A3: " + lengthOf(a3));
print("Len A: " + lengthOf(a));


/// ==== MAIN ==== 
for (j = 0; j < lengthOf(a); j++) {
	open(a[j]);
	if (nSlices > 1) {
	    Stack.setDisplayMode("color");
	    setSlice(2);
	}
	mode = getValue("Mode");
//	modearray[j-1] = mode;
	
	if (mode>120) {
		print("mode = " + mode + "in image: " + getTitle());
	}

	run("Subtract...", "value="+mode);
	run("Smooth", "slice");
//	resetMinAndMax;
//
    pLo = percentileFromRaw(0.5);
    pHi = percentileFromRaw(99.5);
    setMinAndMax(pLo, pHi);
//	run("Enhance Contrast", "saturated=0.10");
    setAutoThreshold("Moments dark no-reset");
	run("Measure");
}

setBatchMode("show");


// =========== FUNCTIONs ===============
function FullPathForImagesInFolder (folderpath) {
	FileNameArray = getFileList(folderpath);
	FileFullPathArray = newArray(lengthOf(FileNameArray));
	for (i = 0; i < lengthOf(FileNameArray); i++) {
	    name = FileNameArray[i];
	    FileFullPathArray[i] = folderpath + name;
	}
	return FileFullPathArray;
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