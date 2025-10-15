===================================
macro "____HELPFUL ROUTINES____" {}
===================================

Trigger Auto-completion dialog: Ctrl + Space

macro "-LOOP: Quick images & ROIs" {}

for (j=1; j<=nImages; j++) {selectImage(j);run("Measure");}; // Measure
for (j=1; j<=nImages; j++) {selectImage(j);setAutoThreshold("Huang dark");}; //Set Threshold
for (j=1; j<=nImages; j++) {selectImage(j);resetThreshold();}; // Reset Threshold

roiCount=roiManager("count");roiManager("Select",roiCount-1);roiManager("Rename", getTitle()); // Rename lastest ROI with image name

Match Image name and ROI
for (j=1; j<=nImages; j++) {selectImage(j);imageName = getTitle(); roiCount = roiManager("count"); for (i = 0; i < roiCount; i++) { roiManager("Select", i); roiName = Roi.getName(); if (roiName == imageName) { break;}}};

macro "-TEXT: create textbox as overlay" {
	insertedtext = "any thing";
	setFont("SansSerif", 50, " antialiased");
	makeText(insertedtext, 1150, 350); // Create textbox with text at (x,y) (will disappear with clicking anywhere)
	run("Add Selection...", "stroke=yellow"); // Turn text into overlay (stay shown unless deleted)
	run("Select None");
}

macro "-SLIDE-COMPOSITE: selection & displaymode" {}

setSlice(1)
for (j=1; j<=nImages; j++) {selectImage(j);setSlice(1);};
Stack.setDisplayMode("composite");
Stack.setDisplayMode("color");

===================================
macro "____CUSTOMED FUNCTIONS____" {}
===================================

function LOG_TimeAndImageInfo() {
	// Date and Times
	MonthNames = newArray("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");
	DayNames = newArray("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat");
	getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
	TimeString = DayNames[dayOfWeek] + " ";
	if (dayOfMonth < 10) { TimeString = TimeString + "0"; }
	TimeString = TimeString + dayOfMonth + "-" + MonthNames[month] + "-" + year + ", ";
	if (hour < 10) { TimeString = TimeString + "0"; }
	TimeString = TimeString + hour + ":";
	if (minute < 10) { TimeString = TimeString + "0"; }
	TimeString = TimeString + minute + ":";
	if (second < 10) { TimeString = TimeString + "0"; }
	TimeString = TimeString + second;
	print("____ " + TimeString);

	// Image Directory&Size
	print(getDirectory("image") + getTitle());
	getPixelSize(unit, pxW, pxH);
	print("Pixel Width = " + pxW + ", Height = " + pxH + " " + unit);
}

function BG_SUBSTRACT_mode(channel, smooth) {
	Stack.setDisplayMode("color");
	setSlice(channel);
	// run("Select None"); // only apply to selections
	mode = getValue("Mode");
	if (mode>120) {
		print("mode = " + mode + "in image: " + getTitle());
	}
	run("Subtract...", "value="+mode);
	if (smooth) {
		run("Smooth", "slice");
	}
	// run("Restore Selection");
}

function SELECTION_AutoThreshold(Channel, method) {
	ori_image = getImageID();
	if (selectionType() != -1) {
		print("Threshold with " + method + " on channel " + Channel);
		nR = roiManager("count");
		roiManager("add"); // nR - 1
		run("Select None");
		run("Duplicate...", "title=Temporary duplicate channels=" + Channel);
		roiManager("Select", nR); //1
		setAutoThreshold(method + " dark");
		run("Create Selection");
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
}

function SELECTION_ManualMinMaxThreshold(Channel, min, max) {
	ori_image = getImageID();
	if (selectionType() != -1) {
		print("Threshold with min = " + min + " , max = " + max + " on channel " + Channel);
		roiCount = roiManager("count");
		roiManager("add");
		run("Select None");
		run("Duplicate...", "title=Temporary duplicate channels=" + Channel);
		run("Restore Selection");
		setThreshold(min, max);
		run("Create Selection");
		if (selectionType() != -1) {
			roiManager("add");
			roiManager("deselect");
			roiManager("Select", newArray(roiCount, roiCount + 1));
			roiManager("AND");
			roiManager("add");
			roiManager("delete");
			close("Temporary");
			selectImage(ori_image);
			roiCount = roiManager("count");
			roiManager("Select", roiCount - 1);
			roiManager("delete");
		}
		else {
			close("Temporary");
			roiManager("Select", roiCount);
			roiManager("delete");
			selectImage(ori_image);
			run("Select None");
			print("No region detected.");
		}
	}
}

function SELECTION_PercentileAutoThreshold(Channel, method, low, high) {
	ori_image = getImageID();
	if (selectionType() != -1) {
		print("Threshold with " + method + " on channel " + Channel + " using Low/High percentile of " + low + "/" + high);
		nR = roiManager("count");
		roiManager("add"); // nR - 1
		run("Select None");
		run("Duplicate...", "title=Temporary duplicate channels=" + Channel);
		roiManager("Select", nR); //1

		pLo = percentileFromRaw(low);
		pHi = percentileFromRaw(high);
		setMinAndMax(pLo, pHi);

		setAutoThreshold(method + " dark");
		run("Create Selection");
//		run("Enlarge...", "enlarge=0.5"); // By default is calibrated unit (like micron)
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

macro "—————————" {}

// StartNumber = minimal roi number. If start number is present, will add at least startnumber +1 if available
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

function ROI_GetROIarray() {
	rC = roiManager("count");
	roiArray = newArray();
	for (i = 0; i < rC; i++) {
		roiManager("select", i);
		rName = Roi.getName;
		roiArray = Array.concat(roiArray, rName);
	}
	print("Added ROI Array length = " + lengthOf(roiArray));
	Array.print(roiArray)
	return roiArray;
}

function ROI_SelectImageFromROI_Current(extLen, extType) {
    // Must have an active ROI (click one in ROI Manager first)
    if (selectionType() == -1) {
        print("No active ROI. Select an ROI in the ROI Manager first.");
        return 0; // failure
    }

    // Normalize extType to start with '.'
    if (lengthOf(extType) > 0 && substring(extType, 0, 1) != ".")
        extType = "." + extType;

    roiName = Roi.getName();  // e.g., "Sample.tif_Roi_7" or "Sample_Roi_7"

    // Guard against bad extLen
    if (extLen < 0) extLen = 0;
    if (extLen > lengthOf(roiName)) {
        print("extLen longer than ROI name: " + roiName);
        return 0;
    }

    // Base image name = roiName without the last extLen chars
    base = substring(roiName, 0, lengthOf(roiName) - extLen);

    // If base has no dot, add extension
    if (indexOf(base, ".") < 0)
        imgNameFull = base + extType;
    else
        imgNameFull = base;

    // If that image is open, activate it
    if (isOpen(imgNameFull)) {
        selectImage(imgNameFull);
        // ROI remains selected in ROI Manager and will show on this image
        print("Selected image \"" + imgNameFull + "\" for ROI \"" + roiName + "\"");
        return 1; // success
    } else {
        print("Image not open for ROI \"" + roiName + "\" (wanted \"" + imgNameFull + "\")");
        return 0; // failure
    }
}

function ROI_SelectImageFromROI_LoopAllROIs(extLen, extType) {
    rC = roiManager("count");
    if (rC == 0) {
        print("No ROIs in manager.");
        return;
    }

    // Optional: normalize extType to start with a dot.
    if (lengthOf(extType) > 0 && substring(extType, 0, 1) != ".")
        extType = "." + extType;

    for (i = 0; i < rC; i++) {
    	wait(100);
        roiManager("Select", i);
        roiName = Roi.getName();  // full ROI name

        // Guard: if extLen is longer than roiName, skip safely
        if (extLen < 0) extLen = 0;
        if (extLen > lengthOf(roiName)) {
            print("Skip (extLen longer than ROI name): " + roiName);
            continue;ROI_LoopAndSelectAllROIs
        }

        // Strip the ROI suffix (last extLen characters) to get the image name part
        imgName = substring(roiName, 0, lengthOf(roiName) - extLen);

        // If there is no dot, add extension; else use as-is
        if (indexOf(imgName, ".") < 0)
            imgNameFull = imgName + extType;
        else
            imgNameFull = imgName;

        // Only select if that image is open (avoid exceptions)
        if (isOpen(imgNameFull)) {
            selectImage(imgNameFull);   // activate the image window
            // ROI is already selected in the ROI Manager; it now applies to the active image
            print("Matched ROI: \"" + roiName + "\"  ->  \"" + imgNameFull + "\"");
            
			/// Whatever function code
            /// will be ran here 
			/// E.g., run("Measure");

        } else {
            print("Image NOT open for ROI: \"" + roiName + "\" (wanted \"" + imgNameFull + "\")");
        }
    }
}

function ROI_MoveCurrentRoiToTopLeft() {
	Roi.getCoordinates(xpoints, ypoints);
	Array.getStatistics(xpoints, xmin, xmax, xmean, xstdDev);
	Array.getStatistics(ypoints, ymin, ymax, ymean, ystdDev);
	rC1 = roiManager("count");
	RoiType = Roi.getType;
	if (RoiType != "composite") {
		for (i = 0; i < xpoints.length; i++) {
			xpoints[i] = xpoints[i] - xmin;
		}
		for (i = 0; i < ypoints.length; i++) {
			ypoints[i] = ypoints[i] - ymin;
		}
		makeSelection("freehand", xpoints, ypoints);
	}
	else {
		roiManager("split");
		rC2 = roiManager("count");
		nRoi = rC2 - rC1;
		roiArray = newArray(nRoi);
		for (i = 0; i < nRoi; i++) {
			RoiIndex = rC1 + i;
			roiManager("select", RoiIndex);
			roiArray[i] = RoiIndex;
			print("RoiIndex = " + RoiIndex);
			Roi.getCoordinates(xpoints, ypoints);
			for (j = 0; j < xpoints.length; j++) {
				xpoints[j] = xpoints[j] - xmin;
			}
			for (j = 0; j < ypoints.length; j++) {
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

function MEASURE_AddROILabelColumn() {
	// Determine whether a ROI is selected
	if (selectionType() == -1) {
		roiLabel = "Whole Image";
	} else {
		roiLabel = Roi.getName();
		if (roiLabel == "") {
			// If somehow no name was assigned to the ROI
			roiLabel = "Unnamed ROI";
		}
	}

	// Count how many rows currently exist in the Results table
	rowCountBefore = nResults;

	// Run the measurement
	run("Measure");

	// The new measurement will be placed at the last row: nResults - 1
	newRowIndex = nResults - 1;

	// Insert an extra column named "Roi"
	setResult("Roi", newRowIndex, roiLabel);

	// (Optional) Update the Results window display
	updateResults();
}

function HISTOGRAM_SelectFromPercentile(p) {
    // p in [0,100], returns intensity at percentile p from RAW histogram
    getRawStatistics(n, mean, minv, maxv, std, hist); // hist: 256 bins over RAW min..max
    total = 0; for (i=0; i<hist.length; i++) total += hist[i];
    target = total * p/100.0;
    acc = 0;
    for (i=0; i<hist.length; i++) { acc += hist[i]; if (acc >= target) break; }
    // map bin -> intensity
    return minv + (maxv - minv) * (i + 0.5)/hist.length;
}

macro "—————————" {}


function OPEN_OnlySelectedFilesFromArray() {
	path = getDirectory("Choose the folder");
	// Manually create a fileArray which contained files to be opened
	// Below is an example
	fileArray = newArray("File1.tif", "File2.tif", "FineN.tif");

	for (j=0; j<fileArray.length; j++) {
		filepath = path + fileArray[j];
		open(filepath);
	}
}

function FILES_GetAllPathsFromFolder(folderpath) {
	FileNameArray = getFileList(folderpath);
	FileFullPathArray = newArray(lengthOf(FileNameArray));
	for (i = 0; i < lengthOf(FileNameArray); i++) {
	    name = FileNameArray[i];
	    FileFullPathArray[i] = folderpath + name;
	}
	return FileFullPathArray;
}

function SAVE_AllCurrentImagesToSelectedFolderAsTif() {
	// Prompt the user to select a directory
	outputDir = getDirectory("Choose a directory to save all images as .tif");

	// Check if the directory is valid
	if (outputDir == 0) {
		print("No directory selected. Exiting.");
		return;
	}

	// Get the list of open images
	imageIDs = getList("image.titles");

	// Loop through all open images
	for (i = 0; i < imageIDs.length; i++) {
		// Get the title of the current image
		selectImage(imageIDs[i]);
		imageTitle = getTitle();

		// Construct the full file path
		savePath = outputDir + imageTitle + ".tif";

		// Save the image as a .tif
		saveAs("Tiff", savePath);
	}
}


function STACK_ClearOutSideWith3DROI() {
	nR = roiManager("count");
	for (i = 0; i < nR; i++) {
		roiManager("select", i);
		run("Clear Outside", "slice");
	}
}

function ARRAY_FilterItemsWithSpecifiedEnding(files, ending) {
	// for an array of file names, return a new array of those with specified ending
	ArrayWithEnding = newArray(0);
	for (i = 0; i < files.length; i++) {
		file = files[i];
		if (endsWith(file, ending)) {
			f = newArray(1);
			f[0] = file;
			ArrayWithEnding = Array.concat(ArrayWithEnding, f);
		}
	}
	return ArrayWithEnding;
}

function RANDOMIZE_CreateTableForOpenImages(NumOfOpenImages) {
	OpenImages = getList("image.titles");
	IndexArray = newArray(NumOfOpenImages);
	for (i = 0; i < NumOfOpenImages; i++) {
		IndexArray[i] = i;
	}

	// Randomize IndexArray
	for (i = 0; i < NumOfOpenImages; i++) {
		RandomIndex = floor(random * NumOfOpenImages);
		temp = IndexArray[i];
		IndexArray[i] = IndexArray[RandomIndex];
		IndexArray[RandomIndex] = temp;
	}
	Table.create("RandomizedMap");
	selectWindow("RandomizedMap");
	for (i = 0; i < NumOfOpenImages; i++) {
		nRow = Table.size;
		Table.set("OldImageNumber", i, i);
		Table.set("NewImageNumber", i, IndexArray[i]);
		Table.set("ImageName", i, OpenImages[IndexArray[i]]);
	}
	return IndexArray;
}

===================================
macro "____BUILT-IN FUNCTIONS____" {}
===================================

macro "IMAGE_PROCESSING" {}
run("Subtract...", "value="+Number); // e.g, Number = getValue("Mode");

macro "THRESHOLD" {}
resetMinAndMax(); // Important! Because AuthThreshold apply to current displayed image, not raw intensity
setAutoThreshold("Huang dark"); //Set Threshold
resetThreshold(); // Reset Threshold

macro "ARRAY_&_STRING" {}
getTitle(); // get current image's name;
getList("image.titles"); // Get all images in an array list
getList("window.titles"); // Get all opening window titles
getDirectory("image") + getTitle(); // Get Image Directory (including image name)
substring(filename, 0, lastIndexOf(filename, ".")); // Get name without extension.
endsWith(file, ending); // Return 1 if the "file" ends with "ending"

macro "TABLE" {}
getResult("Column", row): // NUMERIC result. 0 <= row < nResults. lastRow = nResults-1
getResultString("Column", row): // STRING result.
getResultLabel(row): // column label Columns
setResult("Column", row, value) // for NUMBER
setResult("Label", row, string) // for STRING
Table.deleteRows(nResults-1, nResults-1); // DELETE THE LAST ROW (from nResults-1 to nResults-1)
getValue("results.count"): // number of counts in a table. WORK WITH TABLES NOT NAMED "Results"

IJ.renameResults("Results","Temp Results"); // Rename Table "Results" to "Temp Results"
IJ.renameResults("Temp Results","Results"); // Rename Table "Temp Results" to "Results"

macro "OTHERS" {}
close("\\Others"); // Closes all images except for the front image.

===================================
macro "____TO BE ORGANIZED____" {}
===================================

function printStatistics() {
	getRawStatistics(nPixels, mean, min, max, std, histogram);
	print("nPixels: " + nPixels);
	print("Min - Mean - Max: " + min + " - " + mean + " - " + max);
	print("Sd: " + std);
}

function UnDone_RANDOMIZE_SelectImageFromRandomizedMap() {

	windowlist = getList("window.titles");
	SuffleTable = "RandomizedMap";
	tableexist = false;
	for (i = 0; i < windowlist.length; i++) {
		if (windowlist[i] == SuffleTable) {
			tableexist = true;
			break;
		}
	}
	if (tableexist == false) {
		Dialog.create("Error");
		Dialog.addMessage("Please use function RandomOpenImages to make RandomizedMap table first");
		Dialog.show();
	}
	function indexOfArray(array, value) {
		for (i = 0; i < lengthOf(array); i++) {
			if (array[i] == value) return i;
		}
		return -1;
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