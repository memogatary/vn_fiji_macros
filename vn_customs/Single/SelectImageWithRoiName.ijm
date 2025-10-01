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

// Usage:

selectImageFromROIName();
