// run all the scripts provided in plugins/Scripts/Plugins/AutoRun/
autoRunDirectory = getDirectory("imagej") + "/plugins/Scripts/Plugins/AutoRun/";
if (File.isDirectory(autoRunDirectory)) {
    list = getFileList(autoRunDirectory);
    // make sure startup order is consistent
    Array.sort(list);
    for (i = 0; i < list.length; i++) {
        runMacro(autoRunDirectory + list[i]);
    }
}



run("Record...");
selectWindow("Recorder");
setLocation(0,screenHeight*0.7);

run("ROI Manager...");
selectWindow("ROI Manager");
setLocation(0,screenHeight*0.35);

wait(2000);

imjdir = getDirectory("imagej");
// vntextfile = imjdir + "macros/vn_text_notes.ijm";
vnimagj = imjdir + "macros/vn_customs/vn_ijmFunctions.ijm";

open(vnimagj);
// open(vntextfile);


