// Open all images - hit Run to downsampling and save the same place (overwrite)

print("=======");

// Paths
path = getDirectory("image");


Dialog.createNonBlocking("Width/Height = ");
Dialog.addString("Width/Height = ", 512);
Dialog.show();
FinalSize = Dialog.getString();

numImages = nImages;
count = 0;
for (i = 1; i <= numImages; i++) {
	imageName = getTitle();
	selectWindow(imageName);
	run("Size...", "width=" + FinalSize + " height=" + FinalSize+ " depth=1 constrain average interpolation=Bilinear");
	savepath= path + imageName;
	saveAs("tiff", savepath);
	print("Saved Successfully: " + savepath);
	close(imageName);
	wait(10);
	count++;
}
print("DownSampling " + count + " images Done");
