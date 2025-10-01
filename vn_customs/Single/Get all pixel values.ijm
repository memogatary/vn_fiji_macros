width = getWidth();
height = getHeight();

setSlice(1);
StoredArray1 = newArray(width * height);

for (y = 0; y < height; y++) {
    for (x = 0; x < width; x++) {
        pixelValue = getPixel(x, y);
        StoredArray1[y * width + x] += pixelValue;
    }
}
Array.show(StoredArray1);



setSlice(2);
StoredArray2 = newArray(width * height);

for (y = 0; y < height; y++) {
    for (x = 0; x < width; x++) {
        pixelValue = getPixel(x, y);
        StoredArray2[y * width + x] += pixelValue;
    }
}
Array.show(StoredArray2);

