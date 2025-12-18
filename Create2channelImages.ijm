// --- Params ---
width  = 256;
height = 256;

// ---------- Red (left→right) ----------
newImage("Red", "8-bit black", width, height, 1);
selectWindow("Red");
for (y = 0; y < height; y++) {
    for (x = 0; x < width; x++) {
        v = round(255 * x / (width - 1)); // 0 → 255 left→right
        setPixel(x, y, v);
    }
}
run("Enhance Contrast", "saturated=0"); // display only

// ---------- Green (bottom→top) ----------
newImage("Green", "8-bit black", width, height, 1);
selectWindow("Green");
for (y = 0; y < height; y++) {
    // bottom→top means y=height-1 should be bright; invert y
    yy = (height - 1) - y;
    for (x = 0; x < width; x++) {
        v = round(255 * yy / (height - 1)); // 0 → 255 bottom→top
        setPixel(x, y, v);
    }
}
run("Enhance Contrast", "saturated=0"); // display only

// ---------- Merge (C1=Red, C2=Green) ----------
run("Merge Channels...", "c1=Red c2=Green create");
rename("Gradient_RedLeft_GreenTop");
