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

// Example usage
measureWithRoiLabel();
