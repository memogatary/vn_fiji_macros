imageCount = nImages;
Savepath = "C:/Users/Shaw lab/Box/Shaw Lab/JCB paper/Individual Folders/Vu/04_GJ Permeability/5- 240822 C33A Batch (15 plates)/to Tiff Crop (from Roiset) to a smaller SAME Roi/";
for (j=1; j<=imageCount; j++) {
	selectImage(j);
	imageName = getTitle(); 
	roiCount = roiManager("count"); 
	for (i = 0; i < roiCount; i++) {
		roiManager("Select", i); 
		roiName = Roi.getName(); 
		if (indexOf(roiName, imageName) == 0) { 
			break;}
	};
	run("Duplicate...", "duplicate");
	saveAs("tiff",Savepath+replace(getTitle(),"-1","_1000x240"));
};