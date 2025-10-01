
path = "C:/Users/Shaw lab/Box/Shaw Lab/JCB paper/Individual Folders/Vu/01_EB1 - Tubulin/JCB_04_240905 C33A/11_Individual Cell Cropped_Enlarged by 10 µm/"
openfiles = newArray("siCtrl_2_100X_001.nd2_Roi_1.tif ","siCtrl_3_100X_002.nd2_Roi_3.tif ","siGJA1_2_100X_003.nd2_Roi_3.tif ","siCtrl_2_100X_003.nd2_Roi_2.tif ","siGJA1_2_100X_003.nd2_Roi_4.tif ","siGJA1_2_100X_004.nd2_Roi_2.tif ","siCtrl_1_100X_002.nd2_Roi_5.tif ","20k_2_100X_004.nd2_Roi_3.tif ","GST_3_100X_001.nd2_Roi_1.tif ","GST_1_100X_005.nd2_Roi_1.tif ","GST_3_100X_005.nd2_Roi_3.tif ","20k_3_100X_004.nd2_Roi_3.tif ","GST_1_100X_003.nd2_Roi_1.tif ","GST_2_100X_002.nd2_Roi_3.tif ","GST_2_100X_003.nd2_Roi_2.tif ","20k_2_100X_003.nd2_Roi_1.tif ","siCtrl_1_100X_001.nd2_Roi_3.tif ","GST_3_100X_004.nd2_Roi_5.tif ","GST_3_100X_002.nd2_Roi_4.tif ","siCtrl_3_100X_005.nd2_Roi_3.tif ","siGJA1_2_100X_005.nd2_Roi_3.tif ","siGJA1_1_100X_004.nd2_Roi_1.tif ","siCtrl_1_100X_001.nd2_Roi_1.tif ","siCtrl_3_100X_004.nd2_Roi_3.tif ","siCtrl_1_100X_001.nd2_Roi_4.tif ","siGJA1_3_100X_001.nd2_Roi_4.tif ","siCtrl_2_100X_001.nd2_Roi_3.tif ","siCtrl_3_100X_002.nd2_Roi_4.tif ","20k_3_100X_004.nd2_Roi_5.tif ","20k_3_100X_005.nd2_Roi_2.tif ","GST_3_100X_002.nd2_Roi_5.tif ","GST_3_100X_004.nd2_Roi_3.tif ","siCtrl_2_100X_003.nd2_Roi_7.tif ","siCtrl_2_100X_004.nd2_Roi_2.tif ","20k_1_100X_005.nd2_Roi_4.tif ","20k_2_100X_001.nd2_Roi_2.tif ","20k_3_100X_002.nd2_Roi_9.tif ","GST_3_100X_005.nd2_Roi_4.tif "
);
for (j=0; j<openfiles.length; j++) {
	filepath = path + openfiles[j];
	open(filepath);
}
