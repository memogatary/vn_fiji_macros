
// Call the function
saveAllImagesAsTif();

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
        savePath = outputDir + imageTitle;

        // Save the image as a .tif
        saveAs("Tiff", savePath);
    }
}

