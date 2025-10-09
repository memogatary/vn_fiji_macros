modearray = newArray(nImages);
areaarray = newArray(nImages);

/// ==== Individual Min Max ==== 
for (j = 1; j <= nImages; j++) {
	selectImage(j);
	if (nSlices > 1) {
	    Stack.setDisplayMode("color");
	    setSlice(2);
	}
	mode = getValue("Mode");
	

	modearray[j-1] = mode;
	
	if (mode>120) {
		print("mode = " + mode + "in image: " + getTitle());
	}

	run("Subtract...", "value="+mode);
//	run("Subtract Background...", "rolling=150");
	run("Smooth", "slice");

//	run("Select All");

    pLo = percentileFromRaw(0.5);
    pHi = percentileFromRaw(99.5);
    setMinAndMax(pLo, pHi);
    setAutoThreshold("Otsu dark no-reset");
    	
    run("Create Selection");
	area = getValue("Area");
	areaarray[j-1] = area;
    
	run("Measure");
}
print("Mode Array: ");Array.print(modearray);
print("Area Array: ");Array.print(areaarray);

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
// ==== Global Min Max =======
modearray = newArray(nImages);
areaarray = newArray(nImages);

setSlice(2);
globalMin = getValue("Min");
globalMax = getValue("Max");

for (j = 1; j <= nImages; j++) {
	selectImage(j);
	if (nSlices > 1) {
	    Stack.setDisplayMode("color");
	    setSlice(2);
	}
	mode = getValue("Mode");
	

	modearray[j-1] = mode;
	
	if (mode>120) {
		print("mode = " + mode + "in image: " + getTitle());
	}

	run("Subtract...", "value="+mode);
	run("Smooth", "slice");
	min = getValue("Min");
	max = getValue("Max");
	if (min < globalMin) {
		globalMin = min;
	}
	if (max > globalMax) {
		globalMax = max;
	}
	print("Min-Max: " + globalMin + ", " + globalMax);
};

for (j = 1; j <= nImages; j++) {
	selectImage(j);
	if (nSlices > 1) {
	    Stack.setDisplayMode("color");
	    setSlice(2);
	}
	setMinAndMax(globalMin, globalMax);
    setAutoThreshold("Otsu dark no-reset"); // pick your method
	run("Create Selection");
    run("Measure");
};

// ==== Global Percentile Up and Lo =======
modearray = newArray(nImages);
areaarray = newArray(nImages);

setSlice(2);

globalMin = percentileFromRaw(0.5);
globalMax = percentileFromRaw(99.5);

for (j = 1; j <= nImages; j++) {
	selectImage(j);
	if (nSlices > 1) {
	    Stack.setDisplayMode("color");
	    setSlice(2);
	}
	mode = getValue("Mode");
	

	modearray[j-1] = mode;
	
	if (mode>120) {
		print("mode = " + mode + "in image: " + getTitle());
	}

	run("Subtract...", "value="+mode);
	run("Smooth", "slice");
	min = percentileFromRaw(0.5);
	max = percentileFromRaw(99.5);

	if (min < globalMin) {
		globalMin = min;
	}
	if (max > globalMax) {
		globalMax = max;
	}
	print("Min-Max: " + globalMin + ", " + globalMax);
};

for (j = 1; j <= nImages; j++) {
	selectImage(j);
	if (nSlices > 1) {
	    Stack.setDisplayMode("color");
	    setSlice(2);
	}
	setMinAndMax(globalMin, globalMax);
    setAutoThreshold("Otsu dark no-reset"); // pick your method
	run("Create Selection");
    run("Measure");
};


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

//===== HELPFUL

// PARTICLE ANALYSIS



selectWindow("Results");
selectWindow("Log");

mode = getValue("Mode");
run("Subtract...", "value="+mode);
setAutoThreshold("Moments dark no-reset");


nImages;