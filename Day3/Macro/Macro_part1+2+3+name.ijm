// First part - Zproj and visualization
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
selectImage("merge")
run("Copy");
selectImage("ZProj");
run("Paste");
run("Make Montage...", "columns=3 rows=2 scale=1");
saveAs("PNG", replace(ori_name, "tif", "png"));

