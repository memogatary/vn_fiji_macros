
path = getDirectory("Choose the folder");
fileArray = newArray("File1.tif", "File2.tif", "FineN.tif");

for (j=0; j<fileArray.length; j++) {
	filepath = path + fileArray[j];
	open(filepath);
}
