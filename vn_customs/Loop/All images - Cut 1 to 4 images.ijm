// ImageJ Macro to cut images into 4 equal parts and save them with suffixes
setBatchMode("hide");
// Prompt user to select the directory containing images
dir = getDirectory("Choose image folder");
outputDir = File.getParent(dir) + File.separator + "Cut to 4 images/";
File.makeDirectory(outputDir);
print("===");
// Get list of all files in the directory
list = getFileList(dir);
NumberOfImages = list.length - 1;
// Loop over each file in the directory
for (i = 0; i < list.length; i++) {
// Process only .tif or .nd2 files
if (endsWith(list[i], ".tif") || endsWith(list[i], ".nd2")) {
open(dir + list[i]);
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

// Close the original image
close();
}

print(i + "/" + NumberOfImages + " images done.");

}

// Function to strip the file extension
function stripExtension(filename) {
dot = lastIndexOf(filename, ".");
if (dot > -1)
return substring(filename, 0, dot);
else
return filename;
}