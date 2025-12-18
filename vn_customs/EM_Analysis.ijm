// == DATA INTEPRETATIONS ==
// - Mitochondria Area = "Area" from C1/C3 (Pre-threshold)
// - Mitochondria Matrix Content = 
//		> "Mean" 
//		> "%Area" from C2/C4 (Post-threshold) 
//		> "Solidity" from C2/C4 (Post-threshold) 
// - Mitochondria Elongation = "AR" from C1/C3 (Pre-threshold)
// - Mitochondria Circulation = "Cir" or "Round" from C1/C3 (Pre-threshold)


// == HELPFUL ==
// - Install Macro (EVERYTIME): Plugins -> Macro -> Install...
// - Install Macro (PERMENANT): Save the script into Startup Macro (Plugins -> Macro -> Startup Macro)
// - Script Editor: File -> New -> Script...
// - ImageJ Macro Functions: https://wsr.imagej.net/developer/macro/functions.html
// - Measurements Explaination: https://imagej.net/ij/docs/menus/analyze.html#measure
// - Auto Threshold Algorithm: https://imagej.net/plugins/auto-threshold
// - Recorder Window: Ctrl + U
// - Run Full code: hit "Run"
// - Run Specific code: Highlight the code => Ctrl + Shift + R
// - Selection Brush Tool: 
// 		- Right click at Oval selection -> Brush Tool
// 		- Double click at Brush Tool -> Adjust size 
// 		- Hold Shift + click: Select multiple ROIs
//		- Hold Alt + click: Remove select
//		- Ctrl + Shift + A: Deselect all

macro "Mitochondria TEM Analysis [F6]" {
	// === DUPLICATE ROIs (to avoid changing raw image) ===
	run("Duplicate...", " ");
	
	// Invert intensity => Background becomes dark/low grey values
	run("Select None");
	run("Invert");
	run("Restore Selection");
	
	// MEASURE 1. Raw Measurements of ROI
	run("Set Measurements...", "area mean min shape area_fraction limit display redirect=None decimal=4");
	run("Measure");
	setResult("Class", nResults-1, "1_RawROI");
	
	// MEASURE 2. Raw Measurements of ROI_Limited to thresholded areas only
	setAutoThreshold("Default dark no-reset");
	run("Measure");
	setResult("Class", nResults-1, "2_RawROI_ThresholdedAreaOnly");
	resetThreshold;
	
	// PROCESS: Subtract background
	run("Subtract Background...", "rolling=50");
	
	// MEASURE 3. Post-BgSub Measurements 
	run("Measure");
	setResult("Class", nResults-1, "3_Post-BgSub");
	
	// MEASURE 4. Post-BgSub Measurements_Limited to thresholded areas only
	setAutoThreshold("Default dark no-reset");
	run("Measure");
	setResult("Class", nResults-1, "4_Post-BgSub_ThresholdedAreaOnly");
	resetThreshold;
	
	close;
}
