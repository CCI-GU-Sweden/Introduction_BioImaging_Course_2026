close("*");

// Run this algorithm for all images in the folder - lets do some batch processing


data_folder = "C:/Users/xcamra/Desktop/Day4-Data";
out_dir = data_folder + File.separator + "out";


filelist = getFileList(data_folder) 
for (i = 0; i < lengthOf(filelist); i++) {
    if (endsWith(filelist[i], ".tif")) { 
        tif2load = filelist[i];
        run("Bio-Formats Importer", "open="+data_folder + File.separator + tif2load +
		" autoscale color_mode=Composite rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
		
		input = getTitle();


		run("Grays");
		//run("Brightness/Contrast...");
		run("Enhance Contrast", "saturated=0.35");
		
		seg_out = segmentBacteria(input);
		
		selectWindow(seg_out);
		
		roiManager("reset");
		run("Analyze Particles...", "exclude add");
		selectImage(input);
		roiManager("Show None");
		roiManager("Show All");
		
		run("Duplicate...", "title=RGB");
		selectWindow("RGB");
		roiManager("Set Color", "green");
		setForegroundColor(0, 255, 0);
		run("RGB Color");
		roiManager("Draw");
		rename("RGB");

		saveAs("tiff", out_dir + File.separator + "RGB_"+ tif2load);
		close("*");
	
    } 
}




function segmentBacteria(input_window) { 
// bacteria segmentation - rafa version, yours can look different
	selectWindow(input_window);
	run("Duplicate...", "title=gaus");
	run("Gaussian Blur...", "sigma=1");
	
	//Add here your own algorithm to segment the bacteria cells
	lap_rad = 4.0;
	min_area = 40;
	run("FeatureJ Laplacian", "compute smoothing=" + lap_rad);
	rename("lap");
	run("Duplicate...", "title=lap-seg");
	
	setAutoThreshold("RenyiEntropy no-reset");
	setOption("BlackBackground", true);
	run("Convert to Mask");
	
	run("Area Opening", "pixel=" + min_area);
	rename("segmented_bacteria");
	
	return "segmented_bacteria"
}