imageCount = nImages;
path = getDirectory("image");
SaveFolderpath = path + File.separator + "Individual Cropped";

if (File.exists(SaveFolderpath) !=1){
	File.makeDirectory(SaveFolderpath);
}

for (j=1; j<=imageCount; j++) {
	selectImage(j);
	imageName = getTitle(); 
	roiCount = roiManager("count");
	nROIs = 0;
	for (i = 0; i < roiCount; i++) {
		roiManager("Select", i); 
		roiName = Roi.getName(); 
		if (indexOf(roiName, imageName) == 0) {
			nROIs++;
			run("Duplicate...", "duplicate");
			Savepath = SaveFolderpath + File.separator + roiName;
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

// a = "Image";
// b = "Image_ROI"
// m = indexOf(b, a);
// print(m); // m = 0
// n = indexOf(a, b);
// print(n); // n = -1


a = getList("image.titles")
Array.print(a);
