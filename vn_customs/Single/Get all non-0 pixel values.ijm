// Get image dimensions
width = getWidth();
height = getHeight();

// Initialize the array to store non-zero pixel values
StoredArray = newArray();

// Initialize a counter for non-zero pixels
count = 0;

// Loop through all pixels in the image
for (y = 0; y < height; y++) {
    for (x = 0; x < width; x++) {
        pixelValue = getPixel(x, y);
        if (pixelValue != 0) {
            // If pixel value is not zero, add it to StoredArray
            StoredArray[count] = pixelValue;
            count++;
        }
    }
}

// Show StoredArray (array with non-zero pixel values)
Array.show(StoredArray);

// Initialize arrays to count occurrences of unique values
UniqueValues = newArray();
Occurrences = newArray();

// Function to find index of a value in an array
function findIndex(array, value) {
    for (i = 0; i < array.length; i++) {
        if (array[i] == value) {
            return i;
        }
    }
    return -1;
}

// Count occurrences of each unique value
for (i = 0; i < StoredArray.length; i++) {
    value = StoredArray[i];
    index = findIndex(UniqueValues, value);
    
    if (index == -1) {
        // If value is not found in UniqueValues, add it
        UniqueValues = Array.concat(UniqueValues, value);
        Occurrences = Array.concat(Occurrences, 1);
    } else {
        // If value is found, increment its occurrence count
        Occurrences[index]++;
    }
}

// Show the array with unique values and their counts
print("Unique Values, Occurrences:");
Array.print(UniqueValues);
Array.print(Occurrences);
