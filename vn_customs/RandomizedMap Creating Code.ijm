a = RandomOpenImages(nImages);

// a = RandomOpenImages(nImages);
function RandomOpenImages(NumOfOpenImages) {
	OpenImages = getList("image.titles");
	IndexArray = newArray(NumOfOpenImages);
	for (i = 0; i < NumOfOpenImages; i++) {
		IndexArray[i] = i;
	}

	// Randomize IndexArray
	for (i = 0; i < NumOfOpenImages; i++) {
		RandomIndex = floor(random*NumOfOpenImages);
		temp = IndexArray[i];
		IndexArray[i] = IndexArray[RandomIndex];
		IndexArray[RandomIndex] = temp;
	}
	Table.create("RandomizedMap");
	selectWindow("RandomizedMap");
	for (i = 0; i < NumOfOpenImages; i++) {
		nRow = Table.size;
		Table.set("Index", i, i);
		Table.set("PostRan", i, IndexArray[i]);
		Table.set("ImageName", i, OpenImages[IndexArray[i]]);
	}
	return IndexArray;
}
