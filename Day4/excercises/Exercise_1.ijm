close("*");

// modify this code so you can use bio-formats importer to open one image from the dataset
// change the LUT to grays, adjust brightness and contrast.
// then find a segmentation algorithm to segment the bacteria cells using the macro recorder.

data_folder = "";
tif2load = "";

run("Bio-Formats Importer", "open=C:/Users/xcamra/Desktop/Day4-Data/rounding_assay0000.tif autoscale color_mode=Composite rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
run("Grays");
//run("Brightness/Contrast...");
run("Enhance Contrast", "saturated=0.35");


//Add here your own algorithm to segment the bacteria cells