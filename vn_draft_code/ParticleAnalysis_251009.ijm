run("Measure");
Area = getResult("Area", nResults-1); // = SELECTION AREA, or Full Area if No selection
IJ.renameResults("Results","Temp Results"); // Rename "Results" table to "Temp Results" table

// Duplicate selected area (ROIs), channel 2 (actin) only, work on this duplicated image
getLocationAndSize(x, y, width, height); // Just get location of image WINDOW (not selection)

run("Duplicate...", "duplicate channels=2"); // CHANNEL TO BE RAN WITH PARTICLE ANALYSIS
setLocation(x+width, y, width, height);
getLocationAndSize(x, y, width, height);


//run("Subtract Background...", "rolling=5 slice");
run("Select None");
mode = getValue("Mode");
run("Subtract...", "value="+mode);
run("Restore Selection");

// CLEAR OUTSIDE,
run("Make Inverse");
run("Clear", "slice");
run("Make Inverse");



// MUST HAVE THRESHOLD IMAGE BEFORE PARTICLE ANALYSIS
setAutoThreshold("Default dark");

// Ver1: No Single Results in Results Table
run("Analyze Particles...", "size=0.0-0.58 circularity=0.40-1.00 show=Masks include summarize");

// Ver2:   With all Single Results in Results Table
//run("Analyze Particles...", "size=0.00-0.58 circularity=0.40-1.00 show=Masks display include summarize");


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
