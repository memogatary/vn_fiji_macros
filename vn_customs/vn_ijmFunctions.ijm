===================================
macro "===CUSTOMED FUNCTIONS===" {}
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
	print("=== " + TimeString);

	// Image Directory&Size
	print(getDirectory("image") + getTitle());
	getPixelSize(unit, pxW, pxH);
	print("Pixel Width = " + pxW + ", Height = " + pxH + " " + unit);
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

function StackClearOutside() {
	nR = roiManager("count");
	for (i = 0; i < nR; i++) {
		roiManager("select", i);
		run("Clear Outside", "slice");
	}
}


// a = RandomOpenImages(nImages);
function RandomOpenImages(NumOfOpenImages) {
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
		Table.set("PreRan", i, i);
		Table.set("PostRan", i, IndexArray[i]);
		Table.set("ImageName", i, OpenImages[IndexArray[i]]);
	}
	return IndexArray;
}

printStatistics();
function printStatistics() {
	getRawStatistics(nPixels, mean, min, max, std, histogram);
	print("nPixels: " + nPixels);
	print("Min - Mean - Max: " + min + " - " + mean + " - " + max);
	print("Sd: " + std);
}

function selectEnding(files, ending) {
	// for an array of file names, return a new array of those with specified ending
	withEnding = newArray(0);
	for (i = 0; i < files.length; i++) {
		file = files[i];
		if (endsWith(file, ending)) {
			f = newArray(1);
			f[0] = file;
			withEnding = Array.concat(withEnding, f);
		}
	}
	return withEnding;
}

function baseName(filename) {
	// return filename string without extension
	return substring(filename, 0, lastIndexOf(filename, "."));
}


macro "Macro Next Ran Image from RandomizedMap [0]" {

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