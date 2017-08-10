# cancer-classifier
A classifier built to detect cancerous  pixels in large, microscopic tissue images.
This directory consists of the following information:

-batchscript: 
An example of a batch script to run script on the CCR may be useful to graduate students.

-Bayes: 
Script for Naive Bayes classification of tissue images with crossvalidation and ROC validation/evaluation.
	-Main script is "bayesdetecionperf.m"
	-mRMR_0.9_compiled: 
	Directory for feature selection function (mrmr_mid_d.m)

-Feature_extractions: 
Images of 156 texture feature extractions from Case_3, Image 1 (S15-5979-A1-01.tif)

-Segmentation_methods:
Contains all segmentation methods researched. 
	-Bipartite_script:
	Contains all directories needed for script to work as well as three functions...
		-createpatches.m:
		Script used to split image into patches, segment patches and sew back segmented patches into orgininal image size.
		-demo_SAS_BSDS.m: 
		Segmentation algorithm used in createpatches.m. Need to add Bipartite_script directory to path.
		-fullimageseg.m:
		Used to segemnt full images which is needed to compare against patch based method segmentation.
				
-Contour_detection:
	-BSR_code:
		use example.m located in 'grouping' directory.
		
-Contourresults: 
		2 images with segementation results from two patches shown in 'data' directory (image S15-6200-D2-01A)

-Original_methods: 
	Contains original, untainted, segmentation scripts.
		
-RegionScalableEnergy, Bipartite_code.zip, and Contour_detection_code.zip: 
		Original scripts. The original script for chan vese is located on the server. I did not get to implement the code in RegionScalableEnergy. 

-sfm_local_chanvese:
	-chanveseresults:
		Two images of chanveseresults.. Chanvese method requires mask image to approximate segmentation region.

-Main function is sfm_local_chanvese.m. 
		

If you have questions you may contact me at any time by email: smschnei@buffalo.edu or telephone : 518-728-1071.
