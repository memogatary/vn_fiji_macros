nI = nImages;

width = getWidth();
height = getHeight();

GFP = newArray(width * height * nI);
mtPhagy = newArray(width * height * nI);


for (i = 0; i < nI; i++) {
	selectImage(i+1);
	setSlice(1);
	for (y = 0; y < height; y++) {
	    for (x = 0; x < width; x++) {
	        pixelValue = getPixel(x, y);
		    index = i * (width * height) + y * width + x;
		    GFP[index] = pixelValue;
	    }
	}
}


for (i = 0; i < nI; i++) {
	selectImage(i+1);
	setSlice(2);
	for (y = 0; y < height; y++) {
	    for (x = 0; x < width; x++) {
	        pixelValue = getPixel(x, y);
		    index = i * (width * height) + y * width + x;
		    mtPhagy[index] = pixelValue;
	    }
	}
}

Array.show("title", GFP, mtPhagy);

