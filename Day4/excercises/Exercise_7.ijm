close("*");

// Now let us combine the batch processing, together with the RGB saving
// to get a video that shows how the cells change from "normal" to "round"


data_folder = "C:/Users/xcamra/Desktop/Day4-Data";
out_dir = data_folder + File.separator + "out";
tif2load = "rounding_assay0020.tif";

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

run("Set Measurements...", "area shape redirect=None decimal=3");
run("Clear Results");

run("Duplicate...", "title=RGB");
run("RGB Color");
rename("RGB");


n = roiManager("count");
for (i = 0; i < n; i++) {
    roiManager("select", i);
    roiManager("Measure");
    
    roundness = getResult("Round", i);    
    if (roundness > 0.8) {
    	print("cell "+ i + "is round");
    	setForegroundColor(255, 0, 0);
    	roiManager("Draw");
    	
    }else {
    	print("cell "+ i + "is not round");
		setForegroundColor(0, 255, 0);
		roiManager("Draw");
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