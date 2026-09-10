close("*");
print("\\Clear");

// modify this code so you can use bio-formats importer to open one image from the dataset
// change the LUT to grays, adjust brightness and contrast.
// then find a segmentation algorithm to segment the bacteria cells using the macro recorder.

data_folder = "C:/Users/xcamra/Documents/Introduction_BioImaging_Course_2026/Day4/data";
tif2load = "rounding_assay0020.tif";
tif_path = data_folder + File.separator + tif2load;

// open image with bio formats
run("Bio-Formats Importer", 
	"open=["+ tif_path +"] autoscale color_mode=Composite rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
// the image opens in red
run("Grays");
run("Enhance Contrast", "saturated=0.35");

input_window = getTitle();
bacteria_mask = segmentBacteria(input_window);

print("my segmentation is on window: " + bacteria_mask);

min_bact_size = 50;
// clears info currntly in the ROImanager
roiManager("reset");
// I dont want to measure anything
run("Set Measurements...", "  redirect=None decimal=3");
// get my "particles"
selectWindow(bacteria_mask);
run("Analyze Particles...", "size="+min_bact_size+"-Infinity exclude add");
// see ROIs in the original image
selectImage(input_window);
roiManager("Show None");
roiManager("Show All");

n = roiManager("count");
run("Clear Results");
run("Set Measurements...", "shape redirect=None decimal=3");
for (i = 0; i < n; i++) {
    roiManager("select", i);
    roiManager("Measure");
    // process roi here
    // try to print the circularity to the log
    current_round = getResult("Round");
    im_round = "NaN";
    if (current_round>0.7) {
    	// you are round!
    	im_round = "YES";
    }else {
    	im_round = "NO";
    }
    
    print("the value is: " + current_round + im_round);
}






function segmentBacteria(input_img) { 
// input_img is a title of a window
	selectWindow(input_img);
	// USER INPUT
	// name of the segmented mask
	seg_mask = "mask";
	gaus_sigma = 1;
	lap_rad = 4;

	// Segmentation algo
	run("Duplicate...", "title=" + seg_mask);
	// some filtering
	run("Gaussian Blur...", "sigma=" + gaus_sigma);
	//Add here your own algorithm to segment the bacteria cells
	selectWindow(seg_mask);
	
	filtered = "filtered_image"
	// this creates a new image!
	run("FeatureJ Laplacian", "compute smoothing=" + lap_rad);
	rename(filtered);
	setAutoThreshold("Otsu no-reset");
	run("Convert to Mask");
	close(seg_mask);
	return filtered;
}