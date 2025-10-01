macro "All image channel 2 contrast" {
	for (j=1; j<=nImages; j++) {
		selectImage(j);Stack.setDisplayMode("color");
		setSlice(2);
		run("Enhance Contrast", "saturated=0.4");
	}
}
