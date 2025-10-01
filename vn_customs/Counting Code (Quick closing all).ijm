print("\\Clear");
roiManager("reset");

CloseCountTable = 1;
CountDivision = 1;

print("Conversion: 1 Count is divided by " + CountDivision);

for (j = 1; j <= nImages; j++) {
            selectImage(j);
            run("Point Tool...", "type=Circle color=Yellow size=XXXL label show counter=0");
        }
run("Point Tool...", "type=Circle color=Yellow size=XXXL label show counter=0");
waitForUser("Click Ok when done counting 0");

// Initialize the counter
count = 1; // Counter starts at 1

while (true) {
    // Ask the user if they want to increase the counter
    Dialog.create("Increase Counter?");
    Dialog.addMessage("Increase counter to " + count + "?");
    Dialog.addMessage("Yes: Continue Counting \nNo: Save ROIs & get results \nCancel: Stop");
    Dialog.addChoice("Selections", newArray("Yes", "No"));
    Dialog.show();
    response = Dialog.getChoice();

    if (response == "Yes") {
        // Apply the increased counter to all images
        for (j = 1; j <= nImages; j++) {
            selectImage(j);
            run("Point Tool...", "type=Circle color=Yellow size=XXXL label show counter=" + count);
        }
        waitForUser("Click Ok when done counting "+count);
        count = count + 1; // Increase the counter
    } else {
        // Exit the loop if "No" is selected
        break;
    }
}

waitForUser("Save ROIs with same name");
for (j=1; j<=nImages; j++) {
	selectImage(j);
	// "selection.size" will give the count number (0, 1, 2, etc.)
	if(getValue("selection.size") != 0) {
		roiCount=roiManager("count");roiManager("Add");
		roiManager("Select",roiCount);roiManager("Rename", getTitle());
	}
}

waitForUser("Loop through all ROIs, matching corresponding Image, and Export Count Result");
for (j=0; j <roiManager("count"); j++) {
	roiManager("select", j); roiName = Roi.getName();
	selectImage(roiName);
	roiManager("Select", j);
	run("Properties... ", "show");  
}

CountNum = getNumber("Enter Max Counter Number (Default: 5)", 5);

roiarray = getROIarray();
a = newArray("Label");
for (k=0; k <= CountNum; k++) {
	a = Array.concat(a,"Ctr " + k);
}
Array.print(a);

for (j = 1; j <= nImages; j++) {
	selectImage(j);
	imgName = getTitle();
	a = newArray(imgName);
	match = 0;
	i = 0;
	rR = lengthOf(roiarray);
	while (match == 0 && i < rR) {
		if (imgName == roiarray[i]) {
			match = 1;
			roiManager("select", i);
			for (k=0; k <= CountNum; k++) {
				selectWindow("Counts_"+imgName);	
				a = Array.concat(a,Table.get("Ctr " + k,1)/CountDivision);
			}
			Array.print(a);
			if (CloseCountTable == 1) {
				close("Counts_"+imgName);
			}
		}
		i++;
	}
	if (match == 0) {
		for (k=0; k <= CountNum; k++) {
				a = Array.concat(a,0);
		}
		Array.print(a);
	}
}

function getROIarray() {
	rC = roiManager("count");
	roiArray = newArray();
	for (i = 0; i < rC; i++) {
		roiManager("select", i);
		rName = Roi.getName;
		roiArray = Array.concat(roiArray,rName);
	}
	print("Added ROI Array length = " + lengthOf(roiArray));
	return roiArray;
}