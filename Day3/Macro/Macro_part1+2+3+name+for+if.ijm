run("Close All");
print("\\Clear");

directory = "D:/DATA/Simon/Imaging_FiJi_course 2025"
filelist = getFileList(directory);

for (i=0; i < lengthOf(filelist); i++){
	filepath = directory+File.separator+filelist[i];
	if (endsWith(filepath, "tif")){
		// First part - Zproj and visualization
		run("Bio-Formats Importer", "open=["+filepath+"] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
		ori_name = getTitle();
		run("Z Project...", "projection=[Max Intensity]");
		rename("ZProj");
		
		run("Cyan");
		//run("Brightness/Contrast...");
		run("Enhance Contrast", "saturated=0.35");
		run("Next Slice [>]");
		run("Enhance Contrast", "saturated=0.35");
		run("Yellow");
		run("Next Slice [>]");
		run("Enhance Contrast", "saturated=0.35");
		run("Grays");
		run("Next Slice [>]");
		run("Enhance Contrast", "saturated=0.35");
		run("Green");
		run("Next Slice [>]");
		run("Enhance Contrast", "saturated=0.35");
		run("Magenta");

			
		// Second part - Merge and Scale bar
		//run("Channels Tool...");
		Stack.setDisplayMode("composite");
		Stack.setActiveChannels("11011");
		run("Stack to RGB");
		run("Scale Bar...", "width=15 height=7 thickness=6 font=20 bold");
		rename("merge");
		
		// third part - Fuse both image and Make montage
		selectImage("ZProj");
		run("RGB Stack");
		run("Add Slice");
		selectImage("merge");
		run("Copy");
		selectImage("ZProj");
		run("Paste");
		run("Make Montage...", "columns=3 rows=2 scale=1");
		saveAs("PNG", directory+File.separator+replace(ori_name, "tif", "png"));
		run("Close All");
	}
	else {
		print(filepath+" not a tif image");
	}
}