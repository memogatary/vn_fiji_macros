macro "===Log===" {	
}

macro "+++Helpful Built-in Functions+++" {	
	// Get Image Direction (including image name)
	print(getDirectory("image") + getTitle());

	//Select Channel
	setSlice(slincenumber);

}

/// Log Date/Times/ImageDir/ImageSize
function LogTimeAndImageInfo() {
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

function LoopThroughEachImage {
	for (j = 1; j <= nImages; j++) {
		// Code
	}
}

///MakeCustomSelection based on an automatic algorithm
function MakeSelectionAuto(Channel, method) {
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

///MakeCustomSelection based on min max
function MakeSelectionManual(Channel, min, max) {
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

/// ROI FUNCTIONS
function AddROIWithSuffixAsRoi_c() {
	if (selectionType() != -1) {
		roiCount = roiManager("count");
		roiManager("Add");
		roiManager("Select", roiCount);
		baseName = File.getNameWithoutExtension(getTitle());
		CropName = baseName + "_Roi_1";
		suffix = 2;
		// Use a for loop to iterate over existing ROIs
		for (i = 0; i < roiCount; i++) {
			roiManager("Select", i);
			roiName = Roi.getName();
			// Check if the current ROI name matches the CropName
			if (roiName == CropName) {
				// If there's a match, generate a new name by adding a suffix
				CropName = baseName + "_Roi_" + suffix;
				suffix++;
				// Reset the loop to start checking again from the first ROI
				i = -1;  // i will become 0 after the increment, restarting the loop
			}
		}
		// Finally, rename the ROI to the new unique name
		roiManager("Select", roiCount);
		roiManager("Rename", CropName);
		return CropName;
	};
		else {
		print("No selection found");
		return "";
	}
}

function AddROIWithPrefix(prefix, roiname) {
	if (selectionType() != -1) {
		roiCount = roiManager("count");
		roiManager("Add");
		roiManager("Select", roiCount);
		name = prefix + roiname;
		roiManager("Rename", name);
		return name;
	};
	else {
		print("No selection found");
		return "";
	}
}

// function getROIarray() {
	rC = roiManager("count");
	roiArray = newArray();
	for (i = 0; i < rC; i++) {
		roiManager("select", i);
		rName = Roi.getName;
		roiArray = Array.concat(roiArray, rName);
	}
	print("Added ROI Array length = " + lengthOf(roiArray));
	return roiArray;
}

function selectRoiName(roiName) {
	nR = roiManager("Count");

	for (i = 0; i < nR; i++) {
		roiManager("Select", i);
		rName = Roi.getName();
		if (matches(rName, roiName)) {
			return i;
		}
	}
	return -1;
}

function measureWithRoiLabel() {
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

function selectRoiName(roiName) {
	nR = roiManager("Count");
	for (i = 0; i < nR; i++) {
		// Temporarily select each ROI in the manager...
		roiManager("Select", i);
		rName = Roi.getName();
		// ...then check if it matches the ROI name we want
		if (matches(rName, roiName)) {
			return i; // Found the matching ROI, return its index
		}
	}
	return -1; // If we get here, no ROI matched
}

function selectImageFromROIName() {
	// Get the current ROI name
	roiName = Roi.getName();
	// Grab a list of all open image titles
	titles = getList("image.titles");

	found = false;

	// Loop from full length of roiName down to 1
	for (subLen = lengthOf(roiName); subLen > 0; subLen--) {
		testName = substring(roiName, 0, subLen);

		// Check each open image title
		for (i = 0; i < titles.length; i++) {
			if (testName == titles[i]) {
				selectWindow(titles[i]);
				found = true;
				break;
			}
		}
		// If found, no need to keep searching
		if (found)
			break;
	}

	// If no match is found, print a message
	if (!found) {
		print("No matching window found for ROI name: " + roiName);
	}
	else {
		selectRoiName(roiName);
	}
}

function RoiAlignedTopLeftRoi() {
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


function saveAllImagesAsTif() {
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