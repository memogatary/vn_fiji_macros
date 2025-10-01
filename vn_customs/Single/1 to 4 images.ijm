// Prompt user to select the directory to save the output images
outputDir = getDirectory("Choose folder to save the cut images");


// COMMENT OUT this loop IF PROCESS ONLY 1 IMAGE
nI = nImages; 
for (i = 1; i <= nI; i++) {
/////////////////////////////////////

	// Process the active image only
	selectImage(i);
	name = getTitle();
	baseName = stripExtension(name);
	width = getWidth();
	height = getHeight();
	halfWidth = floor(width / 2);
	halfHeight = floor(height / 2);
	
	// Quadrant 1 (top-left)
	makeRectangle(0, 0, halfWidth, halfHeight);
	run("Duplicate...", "duplicate");
	saveAs("Tiff", outputDir + baseName + "_Q1.tif");
	close();
	
	// Quadrant 2 (top-right)
	makeRectangle(halfWidth, 0, width - halfWidth, halfHeight);
	run("Duplicate...", "duplicate");
	saveAs("Tiff", outputDir + baseName + "_Q2.tif");
	close();
	
	// Quadrant 3 (bottom-left)
	makeRectangle(0, halfHeight, halfWidth, height - halfHeight);
	run("Duplicate...", "duplicate");
	saveAs("Tiff", outputDir + baseName + "_Q3.tif");
	close();
	
	// Quadrant 4 (bottom-right)
	makeRectangle(halfWidth, halfHeight, width - halfWidth, height - halfHeight);
	run("Duplicate...", "duplicate");
	saveAs("Tiff", outputDir + baseName + "_Q4.tif");
	close();

}

// Function to strip the file extension
function stripExtension(filename) {
    dot = lastIndexOf(filename, ".");
    if (dot > -1)
        return substring(filename, 0, dot);
    else
        return filename;
}
