This directory (Steve_Final) consists of the following information:

-batchscript: 
An example of a batch script to run script on the CCR may be useful to graduate students.

-Bayes: 
Script for Naive Bayes classification of tissue images with crossvalidation and ROC validation/evaluation.
	-Main script is "bayesdetecionperf.m"
	-mRMR_0.9_compiled: 
	Directory for feature selection function (mrmr_mid_d.m)

	-trunk: 
	Directory for feature extraction function (get_texture_features.m located in '.../trunk/feature_extraction/texture')

	-Bayes_results: 
	Consists of example results for classifier. Each testing fold is separated by directory.The images tested in each fold begin with the word "Heatmap" and are located each each "Fold x" directory. All other images (not tested in Fold x) are the training images used. Validation and evalution results are saved in 'eval_data' and 'valid_data' .csv files.
		-Selected_Feature_Images (inside Fold_x): 
		Contains the images (from the first training image) of the selected feature extractions that were used in classification for each fold.

-Feature_extractions: 
Images of 156 texture feature extractions from Case_3, Image 1 (S15-5979-A1-01.tif)

-Presentations: 
All presentations given...Supervised Learning, ANNs, Bayes Classification

-S14-396-I9-01_Patches: 
256 x 256 patches taken from region in S14-39636-I9-01.tif (image of region is included here).

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
		
		-Bipartite_results:
			-Annotations: 
			contains 3 images to use in segmentation along with corresponding annotations (taken by me using GIMP).
				-difficult_regions:
				contains 3 "difficult to segment" (subjectively) regions for segmentation along with correspoinding annotations (also taken by me).
			-cspace:
			Contains examples of colorspace reduction on specific tissue region (see Annotations folder for name).
			-difficult_1-3:
			Contains results of the "difficult to segment" regions. The Segment_X folder contains the patches (with correpsonding segementation results) that correspond to Segment_X. Thresh_X images correspond with how many segmentation results are allowed to overlap (Thresh_1 allows all overlap, etc.).
				-Transforms: 
				Contains the results of "difficult to segment" region number 1 full image at resolution .25 of total with blur of 5, colorspace reduction of 2 and 4 and the orignal full image. This folder also contains "TftoPatch" which contains results of full res region that was blurred prior to patch creation and segmentation. Fullres_Orig.tif contains results of original, full res image (patch based). 
			-S06/S14/S15...orig:
			Contains results of original regions (not difficult to segment). 
		
	-Contour_detection:
		-BSR_code:
		use example.m located in 'grouping' directory.
		
		-Contourresults: 
		2 images with segementation results from two patches shown in 'data' directory (image S15-6200-D2-01A)

	-Original_methods: 
	Contains original, untainted, segmentation scripts.
		-papers:
		Contains segmentation papers corresponding to scirpts, plus some extra.
		-RegionScalableEnergy, Bipartite_code.zip, and Contour_detection_code.zip: 
		Original scripts. The original script for chan vese is located on the server. I did not get to implement the code in RegionScalableEnergy. 

	-sfm_local_chanvese:
		-chanveseresults:
		Two images of chanveseresults.. Chanvese method requires mask image to approximate segmentation region.

		-Main function is sfm_local_chanvese.m. 
		
	-Segmentation_Results.docx:
	Log of SlIC superpixel method results and Bipartite segmentation results with parameters adjusted.


-S15-6200-D2-01A_histograms.docx: Histograms of selected features for image S15-6200-D2-O1A.tif


If you have questions you may contact me at any time by email: smschnei@buffalo.edu or telephone : 518-728-1071.