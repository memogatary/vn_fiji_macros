StackClearOutside();

function StackClearOutside() {
	nR = roiManager("count");
	for (i = 0; i < nR; i++) {
		roiManager("select", i);
		run("Clear Outside", "slice");
	}
}
