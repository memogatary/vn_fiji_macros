// "StartupMacros"
// The macros and macro tools in this file ("StartupMacros.txt") are
// automatically installed in the Plugins>Macros submenu and
//  in the tool bar when ImageJ starts up.

//  About the drawing tools.
//
//  This is a set of drawing tools similar to the pencil, paintbrush,
//  eraser and flood fill (paint bucket) tools in NIH Image. The
//  pencil and paintbrush draw in the current foreground color
//  and the eraser draws in the current background color. The
//  flood fill tool fills the selected area using the foreground color.
//  Hold down the alt key to have the pencil and paintbrush draw
//  using the background color or to have the flood fill tool fill
//  using the background color. Set the foreground and background
//  colors by double-clicking on the flood fill tool or on the eye
//  dropper tool.  Double-click on the pencil, paintbrush or eraser
//  tool  to set the drawing width for that tool.
//
// Icons contributed by Tony Collins.

// Global variables
var pencilWidth=1,  eraserWidth=10, leftClick=16, alt=8;
var brushWidth = 10; //call("ij.Prefs.get", "startup.brush", "10");
var floodType =  "8-connected"; //call("ij.Prefs.get", "startup.flood", "8-connected");

// The macro named "AutoRunAndHide" runs when ImageJ starts
// and the file containing it is not displayed when ImageJ opens it.

// macro "AutoRunAndHide" {}

function UseHEFT {
	requires("1.38f");
	state = call("ij.io.Opener.getOpenUsingPlugins");
	if (state=="false") {
		setOption("OpenUsingPlugins", true);
		showStatus("TRUE (images opened by HandleExtraFileTypes)");
	} else {
		setOption("OpenUsingPlugins", false);
		showStatus("FALSE (images opened by ImageJ)");
	}
}

UseHEFT();

// The macro named "AutoRun" runs when ImageJ starts.

macro "AutoRun" {
	// run all the .ijm scripts provided in macros/AutoRun/
	autoRunDirectory = getDirectory("imagej") + "/macros/AutoRun/";
	if (File.isDirectory(autoRunDirectory)) {
		list = getFileList(autoRunDirectory);
		// make sure startup order is consistent
		Array.sort(list);
		for (i = 0; i < list.length; i++) {
			if (endsWith(list[i], ".ijm")) {
				runMacro(autoRunDirectory + list[i]);
			}
		}
	}
}

var pmCmds = newMenu("Popup Menu",
	newArray("Help...", "Rename...", "Duplicate...", "Original Scale",
	"Paste Control...", "-", "Record...", "Capture Screen ", "Monitor Memory...",
	"Find Commands...", "Control Panel...", "Startup Macros...", "Search..."));

macro "Popup Menu" {
	cmd = getArgument();
	if (cmd=="Help...")
		showMessage("About Popup Menu",
			"To customize this menu, edit the line that starts with\n\"var pmCmds\" in ImageJ/macros/StartupMacros.txt.");
	else
		run(cmd);
}

macro "Abort Macro or Plugin (or press Esc key) Action Tool - CbooP51b1f5fbbf5f1b15510T5c10X" {
	setKeyDown("Esc");
}

var xx = requires138b(); // check version at install
function requires138b() {requires("1.38b"); return 0; }

var dCmds = newMenu("Developer Menu Tool",
newArray("ImageJ Website","News", "Documentation", "ImageJ Wiki", "Resources", "Macro Language", "Macros",
	"Macro Functions", "Startup Macros...", "Plugins", "Source Code", "Mailing List Archives", "-", "Record...",
	"Capture Screen ", "Monitor Memory...", "List Commands...", "Control Panel...", "Search...", "Debug Mode"));

macro "Developer Menu Tool - C037T0b11DT7b09eTcb09v" {
	cmd = getArgument();
	if (cmd=="ImageJ Website")
		run("URL...", "url=http://rsbweb.nih.gov/ij/");
	else if (cmd=="News")
		run("URL...", "url=http://rsbweb.nih.gov/ij/notes.html");
	else if (cmd=="Documentation")
		run("URL...", "url=http://rsbweb.nih.gov/ij/docs/");
	else if (cmd=="ImageJ Wiki")
		run("URL...", "url=http://imagejdocu.tudor.lu/imagej-documentation-wiki/");
	else if (cmd=="Resources")
		run("URL...", "url=http://rsbweb.nih.gov/ij/developer/");
	else if (cmd=="Macro Language")
		run("URL...", "url=http://rsbweb.nih.gov/ij/developer/macro/macros.html");
	else if (cmd=="Macros")
		run("URL...", "url=http://rsbweb.nih.gov/ij/macros/");
	else if (cmd=="Macro Functions")
		run("URL...", "url=http://rsbweb.nih.gov/ij/developer/macro/functions.html");
	else if (cmd=="Plugins")
		run("URL...", "url=http://rsbweb.nih.gov/ij/plugins/");
	else if (cmd=="Source Code")
		run("URL...", "url=http://rsbweb.nih.gov/ij/developer/source/");
	else if (cmd=="Mailing List Archives")
		run("URL...", "url=https://list.nih.gov/archives/imagej.html");
	else if (cmd=="Debug Mode")
		setOption("DebugMode", true);
	else if (cmd!="-")
		run(cmd);
}

var sCmds = newMenu("Stacks Menu Tool",
	newArray("Add Slice", "Delete Slice", "Next Slice [>]", "Previous Slice [<]", "Set Slice...", "-",
		"Convert Images to Stack", "Convert Stack to Images", "Make Montage...", "Reslice [/]...", "Z Project...",
		"3D Project...", "Plot Z-axis Profile", "-", "Start Animation", "Stop Animation", "Animation Options...",
		"-", "MRI Stack (528K)"));
macro "Stacks Menu Tool - C037T0b11ST8b09tTcb09k" {
	cmd = getArgument();
	if (cmd!="-") run(cmd);
}

var luts = getLutMenu();
var lCmds = newMenu("LUT Menu Tool", luts);
macro "LUT Menu Tool - C037T0b11LT6b09UTcb09T" {
	cmd = getArgument();
	if (cmd!="-") run(cmd);
}
function getLutMenu() {
	list = getLutList();
	menu = newArray(16+list.length);
	menu[0] = "Invert LUT"; menu[1] = "Apply LUT"; menu[2] = "-";
	menu[3] = "Fire"; menu[4] = "Grays"; menu[5] = "Ice";
	menu[6] = "Spectrum"; menu[7] = "3-3-2 RGB"; menu[8] = "Red";
	menu[9] = "Green"; menu[10] = "Blue"; menu[11] = "Cyan";
	menu[12] = "Magenta"; menu[13] = "Yellow"; menu[14] = "Red/Green";
	menu[15] = "-";
	for (i=0; i<list.length; i++)
		menu[i+16] = list[i];
	return menu;
}

function getLutList() {
	lutdir = getDirectory("luts");
	list = newArray("No LUTs in /ImageJ/luts");
	if (!File.exists(lutdir))
		return list;
	rawlist = getFileList(lutdir);
	if (rawlist.length==0)
		return list;
	count = 0;
	for (i=0; i< rawlist.length; i++)
		if (endsWith(rawlist[i], ".lut")) count++;
	if (count==0)
		return list;
	list = newArray(count);
	index = 0;
	for (i=0; i< rawlist.length; i++) {
		if (endsWith(rawlist[i], ".lut"))
			list[index++] = substring(rawlist[i], 0, lengthOf(rawlist[i])-4);
	}
	return list;
}

macro "Pencil Tool - C037L494fL4990L90b0Lc1c3L82a4Lb58bL7c4fDb4L5a5dL6b6cD7b" {
	getCursorLoc(x, y, z, flags);
	if (flags&alt!=0)
		setColorToBackgound();
	draw(pencilWidth);
}

macro "Paintbrush Tool - C037La077Ld098L6859L4a2fL2f4fL3f99L5e9bL9b98L6888L5e8dL888c" {
	getCursorLoc(x, y, z, flags);
	if (flags&alt!=0)
		setColorToBackgound();
	draw(brushWidth);
}

macro "Flood Fill Tool -C037B21P085373b75d0L4d1aL3135L4050L6166D57D77D68La5adLb6bcD09D94" {
	requires("1.34j");
	setupUndo();
	getCursorLoc(x, y, z, flags);
	if (flags&alt!=0) setColorToBackgound();
	floodFill(x, y, floodType);
}

function draw(width) {
	requires("1.32g");
	setupUndo();
	getCursorLoc(x, y, z, flags);
	setLineWidth(width);
	moveTo(x,y);
	x2=-1; y2=-1;
	while (true) {
		getCursorLoc(x, y, z, flags);
		if (flags&leftClick==0) exit();
		if (x!=x2 || y!=y2)
			lineTo(x,y);
		x2=x; y2 =y;
		wait(10);
	}
}

function setColorToBackgound() {
	savep = getPixel(0, 0);
	makeRectangle(0, 0, 1, 1);
	run("Clear");
	background = getPixel(0, 0);
	run("Select None");
	setPixel(0, 0, savep);
	setColor(background);
}

// Runs when the user double-clicks on the pencil tool icon
macro 'Pencil Tool Options...' {
	pencilWidth = getNumber("Pencil Width (pixels):", pencilWidth);
}

// Runs when the user double-clicks on the paint brush tool icon
macro 'Paintbrush Tool Options...' {
	brushWidth = getNumber("Brush Width (pixels):", brushWidth);
	call("ij.Prefs.set", "startup.brush", brushWidth);
}

// Runs when the user double-clicks on the flood fill tool icon
macro 'Flood Fill Tool Options...' {
	Dialog.create("Flood Fill Tool");
	Dialog.addChoice("Flood Type:", newArray("4-connected", "8-connected"), floodType);
	Dialog.show();
	floodType = Dialog.getChoice();
	call("ij.Prefs.set", "startup.flood", floodType);
}

macro "Set Drawing Color..."{
	run("Color Picker...");
}

macro "-" {} //menu divider

macro "About Startup Macros..." {
	title = "About Startup Macros";
	text = "Macros, such as this one, contained in a file named\n"
		+ "'StartupMacros.txt', located in the 'macros' folder inside the\n"
		+ "Fiji folder, are automatically installed in the Plugins>Macros\n"
		+ "menu when Fiji starts.\n"
		+ "\n"
		+ "More information is available at:\n"
		+ "<http://imagej.nih.gov/ij/developer/macro/macros.html>";
	dummy = call("fiji.FijiTools.openEditor", title, text);
}

macro "Save As JPEG... [j]" {
	quality = call("ij.plugin.JpegWriter.getQuality");
	quality = getNumber("JPEG quality (0-100):", quality);
	run("Input/Output...", "jpeg="+quality);
	saveAs("Jpeg");
}

macro "Save Inverted FITS" {
	run("Flip Vertically");
	run("FITS...", "");
	run("Flip Vertically");
}




macro "-" {} //menu divider VU NGUYEN STARTUP MACROS BEGIN HERE




macro "Bright LUT all Chs & Imgs [Q]" 
{
// This tool works for maximum of 4 channels
for (j=1; j<=nImages; j++) {
selectImage(j);
run("Channels Tool...");
if (is("composite")==0) {
	run("Enhance Contrast", "saturated=0.35");
};
else {

Stack.setDisplayMode("composite");
Stack.setActiveChannels("1111");
Stack.setChannel(1);
run("Enhance Contrast", "saturated=0.35");
Stack.setChannel(2);
run("Enhance Contrast", "saturated=0.35");
Stack.setChannel(3);
run("Enhance Contrast", "saturated=0.35");
Stack.setChannel(4);
run("Enhance Contrast", "saturated=0.35");
}
}

}

macro "Bright LUT all Chs [q]" 
{
// This tool works for maximum of 4 channels
run("Channels Tool...");
Stack.setDisplayMode("composite");
Stack.setActiveChannels("1111");
Stack.setChannel(1);
run("Enhance Contrast", "saturated=0.35");
Stack.setChannel(2);
run("Enhance Contrast", "saturated=0.35");
Stack.setChannel(3);
run("Enhance Contrast", "saturated=0.35");
Stack.setChannel(4);
run("Enhance Contrast", "saturated=0.35");
}

macro "Same LUTs for all images [n0]"
{
setBatchMode("hide");	
// Select one image and set same LUTs for all others
currentImage = getImageID();
selectImage(currentImage);
nChannels = nSlices;
for (i=1; i<=nSlices; i++) {
selectImage(currentImage);
Stack.setChannel(i);
getMinAndMax(min, max);
	for (j=1; j<=nImages; j++) {
		selectImage(j);
		Stack.setChannel(i);
		setMinAndMax(min, max);
	}
}
setBatchMode("exit and display");
}

macro "Reset Luts  [8]" {
	resetMinAndMax;;
}

macro "Widen Contrast by controlled inc [7]" {
    // Get the current minimum and maximum pixel values
    getMinAndMax(min, max);

    // If min and max are equal, set a small difference to avoid 0 increment
    if (min == max) {
        min = min - 1;
        max = max + 1;
    }

    // Calculate the increment for contrast adjustment (widening the gap)
    inc = 1/20 * (max - min);

    // Set new minimum and maximum to widen contrast
    setMinAndMax(min, max + inc);
}

macro "Enhance Contrast by 1/10 max-min [6]" {
    // Get the current minimum and maximum pixel values
    getMinAndMax(min, max);

    // Calculate the increment for contrast adjustment
    inc = 1/20 * (max - min);

    // Set new minimum and maximum to enhance contrast
    setMinAndMax(min, max - inc);
}

macro "All images composite 0111 [n1]" 
{
setBatchMode("hide");
for (j=1; j<=nImages; j++) {
selectImage(j);
run("Channels Tool...");
Stack.setDisplayMode("composite");
Stack.setActiveChannels("0111");
}
setBatchMode("exit and display");
}

macro "All images composite 1011 [n2]" 
{
setBatchMode("hide");
for (j=1; j<=nImages; j++) {
selectImage(j);
run("Channels Tool...");
Stack.setDisplayMode("composite");
Stack.setActiveChannels("1011");
}
setBatchMode("exit and display");
}

macro "All images composite 1101 [n3]" 
{
setBatchMode("hide");
for (j=1; j<=nImages; j++) {
selectImage(j);
run("Channels Tool...");
Stack.setDisplayMode("composite");
Stack.setActiveChannels("1101");
}
setBatchMode("exit and display");
}

macro "All images composite 1110 [n4]" 
{
setBatchMode("hide");
for (j=1; j<=nImages; j++) {
selectImage(j);
run("Channels Tool...");
Stack.setDisplayMode("composite");
Stack.setActiveChannels("1110");
}
setBatchMode("exit and display");
}

macro "All images reset to color channel 1 [n/]" {
	for (j=1; j<=nImages; j++) {
		selectImage(j);Stack.setDisplayMode("color");
		setSlice(1);
	}
}

macro "All images color mode [n*]" {
	for (j=1; j<=nImages; j++) {
		selectImage(j);Stack.setDisplayMode("color");
		CurrentSlice = getSliceNumber;
		if (CurrentSlice < nSlices) {
			CurrentSlice++;
			setSlice(CurrentSlice);
		}
		else {
			setSlice(1);
		} ;
	}
}


macro "-" {} //menu divider

macro "Zoom out all images [n-]" 
{for (j=1; j<=nImages; j++) {selectImage(j);run("Out [-]");}
}

macro "Zoom in all images [n+]" 
{for (j=1; j<=nImages; j++) {selectImage(j);run("In [+]");}
}

//macro "Rename ROI with _Roi_Count [u] version 1" 
//{
//// Save and Measure Selected ROIs
////setBatchMode("hide");
//roiCount = roiManager("count");
//roiManager("Add");
//roiManager("Select", roiCount);
//baseName = getTitle();
//newName = baseName + "_Roi_1";
//suffix = 2;
//// Use a for loop to iterate over existing ROIs
//for (i = 0; i < roiCount; i++) {
//    roiManager("Select", i);
//    roiName = Roi.getName();
//    // Check if the current ROI name matches the newName
//    if (roiName == newName) {
//        // If there's a match, generate a new name by adding a suffix
//        newName = baseName + "_Roi_" + suffix;
//        suffix++;
//        // Reset the loop to start checking again from the first ROI
//        i = -1;  // i will become 0 after the increment, restarting the loop
//    }
//}
//// Finally, rename the ROI to the new unique name
//roiManager("Select", roiCount);
//roiManager("Rename", newName);
////setBatchMode("exit and display");
//}

// Ver 2 below

macro "Rename ROI with _Roi_Count [u] "
{
	// 1. Add the current selection to the ROI Manager
	roiManager("Add");
	newRoiIndex = roiManager("count") - 1; // Get the index of the new ROI
	
	// 2. Prepare for the search
	baseName = getTitle();
	prefix = baseName + "_Roi_";
	maxSuffix = 0; // This will store the highest number found
	
	// 3. Loop ONCE through existing ROIs to find the highest suffix
	// We loop up to 'newRoiIndex' to check only the ROIs that were already there.
	for (i = 0; i < newRoiIndex; i++) {
	    roiManager("Select", i);
	    roiName = Roi.getName();
	
	    // Check if the ROI name matches our naming pattern
	    if (startsWith(roiName, prefix)) {
	        // If it matches, extract the number at the end
	        numberString = replace(roiName, prefix, "");
	        currentSuffix = parseInt(numberString);
	
	        // If this ROI's number is higher than our current max, update it
	        if (currentSuffix > maxSuffix) {
	            maxSuffix = currentSuffix;
	        }
	    }
	}
	
	// 4. Calculate the new unique name
	newSuffix = maxSuffix + 1;
	newName = prefix + newSuffix;
	
	// 5. Select and rename the newly added ROI
	roiManager("Select", newRoiIndex);
	roiManager("Rename", newName);
}
//macro "Rename ROI + 1 [n7]" 
//{
//roiCount=roiManager("count");
//roiManager("Add");
//roiManager("Select",roiCount);
//roiManager("Rename", getTitle() + "_" + "1");
//}
//
//macro "Rename ROI + 2 [n8]" 
//{
//roiCount=roiManager("count");
//roiManager("Add");
//roiManager("Select",roiCount);
//roiManager("Rename", getTitle() + "_" + "2");
//}
//
//macro "Rename ROI + 3 [n9]" 
//{
//roiCount=roiManager("count");
//roiManager("Add");
//roiManager("Select",roiCount);
//roiManager("Rename", getTitle() + "_" + "3");
//}

macro "-" {} //menu divider

macro "Spread all images [n5]"
{
setBatchMode("hide");
selectImage(1);
imgW = getWidth();
imgH = getHeight();
fullArea = imgW * imgH;
n=nImages;
bestRows = 1;
bestCols = n;
bestArea = 1;
    for (rows = 1; rows <= Math.ceil(Math.sqrt(n)); rows++) {
         cols = Math.ceil(n / rows);
	GridW = screenWidth / cols;
	GridH = 0.97 * screenHeight / rows;
	GridA = GridW / GridH;
	ImgA = imgW / imgH;
	if (GridA > ImgA) {imgArea = GridH * GridH * imgW / imgH;};
	else {imgArea = GridW * GridW * imgH / imgW;};
        if (imgArea > bestArea) {
            bestArea = imgArea;
            bestRows = rows;
            bestCols = cols;
        }
    }
 rows = bestRows;
 cols = bestCols;
// Calculate the size of each image
ZoomRatio = sqrt(bestArea / fullArea);
imageWidth = ZoomRatio * imgW;
imageHeight = ZoomRatio * imgH;
for ( j = 1; j <= nImages; j++) {
    selectImage(j);
     col = (j - 1) % cols;
     row = floor((j - 1) / cols);
     x = col * imageWidth;
     y = row * imageHeight;
    setLocation(x, y, imageWidth, imageHeight);
}
setBatchMode("exit and display");
}


macro "Unspread all images [n6]"
{
	setBatchMode("hide");
	imageWidth = screenWidth / 1.1; 
	imageHeight = screenHeight / 1.1;
	for ( j = 1; j <= nImages; j++) 
	{    
		selectImage(j);    
		setLocation(0, 0, imageWidth, imageHeight);
	}
setBatchMode("exit and display");
}


macro "Loops all images, Match all ROIs [n8] " {

// Save and Measure Selected ROIs
roiCount = roiManager("count");
roiManager("Add");
roiManager("Select", roiCount);
baseName = getTitle();
newName = baseName;
suffix = 2;
// Use a for loop to iterate over existing ROIs
for (i = 0; i < roiCount; i++) {
    roiManager("Select", i);
    roiName = Roi.getName();
    // Check if the current ROI name matches the newName
    if (roiName == newName) {
        // If there's a match, generate a new name by adding a suffix
        newName = baseName + "_" + suffix;
        suffix++;
        // Reset the loop to start checking again from the first ROI
        i = -1;  // i will become 0 after the increment, restarting the loop
    }
}
// Finally, rename the ROI to the new unique name
roiManager("Select", roiCount);
roiManager("Rename", newName);
run("Measure");
Area = getResult("Area", nResults-1);
IJ.renameResults("Results","Temp Results");
// Duplicate selected area (ROIs), channel 2 (actin) only, work on this duplicated image
getLocationAndSize(x, y, width, height);
run("Duplicate...", "duplicate channels=2");
setLocation(x+width, y, width, height);
getLocationAndSize(x, y, width, height);
// Clear Outside, Subtract Background, Analyze Particles, Reposition
run("Make Inverse");
run("Clear", "slice");
run("Make Inverse");
run("Subtract Background...", "rolling=50 slice");
setAutoThreshold("Default dark");
run("Analyze Particles...", "size=0.07-4.0 circularity=0.4-1.00 show=Masks exclude include summarize");
selectImage(nImages);
setLocation(x+width, y, width, height);
// Get result and rename tables
IJ.renameResults("Summary","Results");
Count = getResult("Count", nResults-1);
IJ.renameResults("Results","Summary");
IJ.renameResults("Temp Results","Results");
setResult("Count", nResults-1, Count);
setResult("Count/Area", nResults-1, Count/Area);
setResult("Count/Area X 100", nResults-1, Count/Area*100);
selectWindow("Summary");
Table.setLocationAndSize(0, screenHeight*0.5, screenWidth, screenHeight*0.25);
selectWindow("Results");
Table.setLocationAndSize(0, screenHeight*0.6, screenWidth, screenHeight*0.38);

}

macro "Close all images but active one [9] " {
	close("\\Others");
}

macro "Next Ran Image from RandomizedMap [0]" {

windowlist = getList("window.titles");
SuffleTable = "RandomizedMap";
tableexist = false;
for (i = 0; i< windowlist.length; i++) {
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
else {
	// Get the current active window (RandomizedMap)
	CurrentImg = getTitle();
	selectWindow("RandomizedMap");
	StringLength = Table.size;
	RandArray = newArray(StringLength);
	RandImgArray = newArray(StringLength);
	for (i = 0; i < StringLength; i++) {
		RandImgArray[i] = Table.getString("ImageName", i);
		RandArray[i] = Table.get("PostRan", i);
	}	
	currentIndex = indexOfArray(RandImgArray, CurrentImg);
	print("Processed image index (not random) " + currentIndex + "/(0-"+StringLength-1 + ")");
	nextIndex = (currentIndex + 1)%StringLength;
	nextImage = Table.getString("ImageName", nextIndex);
	selectImage(nextImage);
	print("Current actin image index (not random) " + nextIndex);

}
function indexOfArray(array, value) {
    for (i = 0; i < lengthOf(array); i++) {
        if (array[i] == value) return i;
    }
    return -1;
}
}

////////////// TEMPORARY SHORTCUT /////////


macro "Add Selection & Save [F3]" {
	run("Add Selection...");run("Save");
}



macro "Actin Around Mitochondria [F2]" {
	
// Save and Measure Selected ROIs
roiCount = roiManager("count");
roiManager("Add");
roiManager("Select", roiCount-1);
roiName = Roi.getName()
roiManager("Select", roiCount);
newName = roiName + "_Actin";
roiManager("Rename", newName);
	
for (c=1; c<=2; c++) {
    setSlice(c);
    run("Measure");
};
}


macro "Mitochondria [F1]" {
	// Save and Measure Selected ROIs
	roiCount = roiManager("count");
	roiManager("Add");
	roiManager("Select", roiCount);
	baseName = getTitle();
	newName = baseName + "_Roi_1";
	suffix = 2;
	// Use a for loop to iterate over existing ROIs
	for (i = 0; i < roiCount; i++) {
	    roiManager("Select", i);
	    roiName = Roi.getName();
	    // Check if the current ROI name matches the newName
	    if (roiName == newName) {
	        // If there's a match, generate a new name by adding a suffix
	        newName = baseName + "_Roi_" + suffix;
	        suffix++;
	        // Reset the loop to start checking again from the first ROI
	        i = -1;  // i will become 0 after the increment, restarting the loop
	    }
	}
	// Finally, rename the ROI to the new unique name
	roiManager("Select", roiCount);
	roiManager("Rename", newName);
	
	
	
	MakeCustomSelectionAuto(3,"Default");
	run("Measure");

function MakeCustomSelectionAuto(Channel,method) {
	ori_image = getImageID();
	if (selectionType() !=-1) {
		print("Threshold with " + method + " on channel " + Channel);
		nR=roiManager("count");
		roiManager("add"); // nR - 1
		run("Select None");
		run("Duplicate...", "title=Temporary duplicate channels=" + Channel);
		roiManager("Select", nR); //1
		setAutoThreshold(method + " dark");
		run("Create Selection");
		if (selectionType() !=-1) {
			nR=roiManager("count"); // Reset nR
			roiManager("add"); // nR
			roiManager("Select", newArray(nR,nR-1));
			roiManager("AND");
			roiManager("add"); // Rest nR
			close("Temporary");
			selectImage(ori_image);
			nR=roiManager("count");
			roiManager("deselect");
			roiManager("Select", nR-3);
			roiManager("delete");
			roiManager("Select", nR-3);
			roiManager("delete");
			roiManager("Select", nR-3); // Overlap ROI
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
}

