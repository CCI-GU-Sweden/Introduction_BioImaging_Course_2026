close("*");

// Now let us color the results based on the circularity, so:
// if object is circular we color it red
// if not object is green
// hits: getResult("Round", i), setForegroundColor, roiManager("Draw")


data_folder = "C:/Users/xcamra/Documents/Introduction_BioImaging_Course_2026/Day4/data";
parent_folder = File.getParent(data_folder);
out_dir = parent_folder + File.separator + "out";

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
	
		run("Set Measurements...", "area center shape redirect=None decimal=3");
		run("Clear Results");
		
		run("Duplicate...", "title=RGB");
		run("RGB Color");
		rename("RGB");
		
		
		n = roiManager("count");
		for (j = 0; j < n; j++) {
		    roiManager("select", j);
		    roiManager("Measure");
		    
		    roundness = getResult("Round", j);    
		    if (roundness > 0.8) {
		    	print("cell "+ j + "is round");
		    	setForegroundColor(255, 0, 0);
		    	roiManager("Draw");
		    	
		    }else {
		    	print("cell "+ j + "is not round");
				setForegroundColor(0, 255, 0);
				roiManager("Draw");
		    }		
		}
		saveAs("tiff", out_dir + File.separator + "RGB_"+ tif2load);
		
		saveAs("Results", out_dir + File.separator + "Results_"+ File.getNameWithoutExtension(tif2load) +".csv");
		
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