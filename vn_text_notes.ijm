===================================
macro "===HELPFUL===" {}
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
macro "===BUILT-IN FUNCTIONS===" {}
===================================
close("\\Others"); // Closes all images except for the front image.

getTitle(); // get current image's name;
getList("image.titles"); // Get all images in an array list

	
getDirectory("image") + getTitle(); // Get Image Directory (including image name)

setAutoThreshold("Huang dark"); //Set Threshold
resetThreshold();}; // Reset Threshold



macro "-TABLE: Quick images & ROIs" {}

getResult("Column", row): // NUMERIC result. 0 <= row < nResults. lastRow = nResults-1
getResultString("Column", row): // STRING result.
getResultLabel(row): // column label Columns

setResult("Column", row, value) // for NUMBER
setResult("Label", row, string) // for STRING

Table.deleteRows(nResults-1, nResults-1); // DELETE THE LAST ROW (from nResults-1 to nResults-1)

getValue("results.count"): // number of counts in a table. WORK WITH TABLES NOT NAMED "Results"

===================================
macro "===CUSTOMIZED FUNCTIONS===" {}
===================================

// a = RandomizeOpeningImages(nImages);
function RandomizeOpeningImages(NumOfOpenImages) {
	OpenImages = getList("image.titles");
	IndexArray = newArray(NumOfOpenImages);
	for (i = 0; i < NumOfOpenImages; i++) {
		IndexArray[i] = i;
	}
	// Randomize IndexArray
	for (i = 0; i < NumOfOpenImages; i++) {
		RandomIndex = floor(random*NumOfOpenImages);
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



function InitialLog() {
	// Date and Times
	MonthNames = newArray("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec");
	DayNames = newArray("Sun", "Mon","Tue","Wed","Thu","Fri","Sat");
	getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
	TimeString =DayNames[dayOfWeek]+" ";
	if (dayOfMonth<10) {TimeString = TimeString+"0";}
	TimeString = TimeString+dayOfMonth+"-"+MonthNames[month]+"-"+year+", ";
	if (hour<10) {TimeString = TimeString+"0";}
	TimeString = TimeString+hour+":";
	if (minute<10) {TimeString = TimeString+"0";}
	TimeString = TimeString+minute+":";
	if (second<10) {TimeString = TimeString+"0";}
	TimeString = TimeString+second;
	print("=== " + TimeString);
	
	// Image infomation
	print(getDirectory("image")+getTitle());
	getPixelSize(unit, pxW, pxH);
	print("Pixel Width = " + pxW + ", Height = " + pxH + " " + unit);	
}