close("*");

// save your segmentation algorithm into a function suing something like:
// hint, pass as input the title of the image to segment
// give as output the title of the segmented image

//
function doSomething() { 
// function description

}

data_folder = "C:/Users/xcamra/Desktop/Day4-Data";
tif2load = "rounding_assay0020.tif";

run("Bio-Formats Importer", "open="+data_folder + File.separator + tif2load +
	" autoscale color_mode=Composite rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
input = getTitle();


run("Grays");
//run("Brightness/Contrast...");
run("Enhance Contrast", "saturated=0.35");

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

roiManager("reset");
run("Analyze Particles...", "exclude add");
selectImage(input);
roiManager("Show None");
roiManager("Show All");