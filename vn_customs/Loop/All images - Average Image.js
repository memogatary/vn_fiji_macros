// Get a list of all open images
Dialog.create("Name the averaged image")
Dialog.addString("Averaged Image - ....?", "Ex: Ctrl")
Dialog.show();
response = Dialog.getString();


numImages = nImages;
if (numImages < 2) {
    exit("At least two images need to be open to calculate an average.");
}

// Get the dimensions and bit depth of the images (assuming all images are the same size and type)
selectImage(1);
width = getWidth();
height = getHeight();
numChannels = nSlices; // Number of channels, assuming each slice corresponds to a different channel

// Initialize arrays to hold the sum of pixel values for each channel
sumArray1 = newArray(width * height);
sumArray2 = newArray(width * height);

// The ImageJ macro language does not directly support 2D arrays. 
// As a work around, either create a blank image and use setPixel() and getPixel(), 
// or create a 1D array using a=newArray(xmax*ymax) and do your own indexing 
// (e.g., value=a[x+y*xmax]).

// Loop through all images to sum their pixel values for each channel
for (i = 1; i <= numImages; i++) {
    selectImage(i);
    
    // Loop through each channel
    for (ch = 1; ch <= numChannels; ch++) {
        setSlice(ch);
        
        // Loop through each pixel and sum the values
        for (y = 0; y < height; y++) {
            for (x = 0; x < width; x++) {
                pixelValue = getPixel(x, y);
                
                if (ch == 1) {
                    // Sum for the first channel
                    sumArray1[y * width + x] += pixelValue;
                } else if (ch == 2) {
                    // Sum for the second channel
                    sumArray2[y * width + x] += pixelValue;
                }
            }
        }
    }
}
// Create a new image for the average
newImage("Averaged Image - " + response, "16-bit composite-mode", width, height, numChannels);

// Calculate the average for each channel and update the corresponding slice
for (ch = 1; ch <= numChannels; ch++) {
    setSlice(ch); // Select the correct slice in the new image
    
    // Loop through each pixel to calculate the average and set the pixel values
    for (y = 0; y < height; y++) {
        for (x = 0; x < width; x++) {
            index = y * width + x;
            
            if (ch == 1) {
                averageValue = sumArray1[index] / numImages;
                setPixel(x, y, averageValue);
            } else if (ch == 2) {
                averageValue = sumArray2[index] / numImages;
                setPixel(x, y, averageValue);
            }
        }
    }
}
run("Make Composite");
setSlice(1);
run("Green");
setSlice(2);
run("Red");
// Update the display to show the averaged image
updateDisplay();
