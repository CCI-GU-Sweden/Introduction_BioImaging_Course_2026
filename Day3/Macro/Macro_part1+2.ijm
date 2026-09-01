// First part - Zproj and visualization
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


