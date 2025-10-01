// Open all images - hit Run to save all of them into different channel-folders

print("=======");

// Paths
path = getDirectory("image");
print("Master Folder Path: " + path);
numImages = nImages;


Dialog.createNonBlocking("Number of channels");
Dialog.addString("Number of channels", 3);
Dialog.show();
nChannels = Dialog.getString();
patharray = newArray(nChannels);

print("Child Folder Paths:");
for (i = 1; i <= nChannels; i++) {
	patharray[i-1] = path + "Channel_" + i;
	print(patharray[i-1]);
	if (File.exists(patharray[i-1]) !=1){
		File.makeDirectory(patharray[i-1]);
	};
};

ImageNameArray = getList("image.titles");
// Store original names and assign temporary names for blind analysis
setBatchMode("hide");
for (i = 0; i < numImages; i++) {
	print("i = " + i + ", nImages = " + numImages);
	selectImage(ImageNameArray[i]);
	run("Split Channels");
	for (j = 0; j < nChannels; j++) {
		channelname = "C"+ (j+1) +"-"+ImageNameArray[i];
		selectImage(channelname);
//		print(patharray[j]);
		savepath=patharray[j] + File.separator + channelname;
//		print(savepath);
		saveAs("tiff", savepath);
		print("Saved Successfully: " + savepath);
		close(channelname);
	}
}
setBatchMode("show");

print("Extracting Done");

