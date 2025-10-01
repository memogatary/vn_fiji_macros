// Get a list of all open images and temporarily rename them
originalNames = newArray();
temporaryNames = newArray();
numberOfImages = nImages;

// Store original names and assign temporary names for blind analysis
for (i = 1; i <= numberOfImages; i++) {
    selectImage(i);
    originalNames[i-1] = getTitle();
    tempName = "Temp_Image_" + i;
    temporaryNames[i-1] = tempName;
    rename(tempName);
}

// Wait for user to complete the analysis
waitForUser("Click OK when done with blind analysis...");

// Restore original names by selecting images using temporary names
for (i = 0; i < temporaryNames.length; i++) {
    selectImage(temporaryNames[i]);
    rename(originalNames[i]);
}

print("Images have been renamed back to their original names.");
