ImageList = getList("image.titles");
imageCount = nImages;
roiCount = roiManager("count");
RoiArray = newArray(roiCount);
path = getDirectory("image");
SaveFolderpath = path + File.separator + "Individual Cropped";

if (File.exists(SaveFolderpath) !=1){
	File.makeDirectory(SaveFolderpath);
}

for (r = 0; r < roiCount; r++) {
	roiManager("Select", r); 
	roiName = Roi.getName();
	RoiArray[r]=roiName;
};
print("Roi Array:");Array.print(RoiArray);
print("Image List:");Array.print(ImageList);

for (j=1; j<=imageCount; j++) {
	selectImage(j);
	imageName = getTitle(); 
	nROIs = 0;
	for (i = 0; i < roiCount; i++) {
		if (indexOf(RoiArray[i], imageName) == 0) {
			nROIs++;
			roiManager("Select", i);
			run("Enlarge...", "enlarge=10");
			run("Duplicate...", "duplicate");
			Savepath = SaveFolderpath + File.separator + RoiArray[i];
			while (File.exists(Savepath + ".tif") == 1) {
				Savepath = Savepath + " (1)";
			};
			saveAs("tiff", Savepath);
		close();
		};
	};
	print(imageName);
	print(nROIs);
	if ((nROIs) == 0) {
		run("Select None");
	};
};
