macro "Next Ran Image from RandomizedMap [0]" {

windowlist = getList("window.titles");
SuffleTable = "RandomizedMap";
tableexist = false;
for (i = 0; i< windowlist.length; i++) {
	if (windowlist[i] == SuffleTable) {
		tableexist = true;
		break;
	}
}

if (tableexist == false) {
	Dialog.create("Error");
	Dialog.addMessage("Please use function RandomOpenImages to make RandomizedMap table first");
	Dialog.show();
}
else {
	// Get the current active window (RandomizedMap)
	CurrentImg = getTitle();
	selectWindow("RandomizedMap");
	StringLength = Table.size;
	print(StringLength);
	RandArray = newArray(StringLength);
	RandImgArray = newArray(StringLength);
	for (i = 0; i < StringLength; i++) {
		RandImgArray[i] = Table.getString("ImageName", i);
		RandArray[i] = Table.get("PostRan", i);
	}
	
	currentIndex = indexOfArray(RandImgArray, CurrentImg);
	print("Processed image index (not random) " + currentIndex + "/(0-"+StringLength-1 + ")");
	nextIndex = (currentIndex + 1)%StringLength;
	nextImage = Table.getString("ImageName", nextIndex);
	selectImage(nextImage);
	print("Current actin image index (not random) " + nextIndex);

}

function indexOfArray(array, value) {
    for (i = 0; i < lengthOf(array); i++) {
        if (array[i] == value) return i;
    }
    return -1;
}
}