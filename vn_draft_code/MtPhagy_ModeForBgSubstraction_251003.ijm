modearray = newArray(nImages);
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
	setAutoThreshold("Moments dark no-reset");
	run("Create Selection");
//	run("Select All");
	run("Measure");
}
print("Mode Array: ");Array.print(modearray);
