%function bayesdetectionperf(Factor,featamt,Threshval)

% clear all; close all;
mat_dir = '/projects/academic/scottdoy/code';
m1 = [mat_dir filesep 'quant_risk_steve'];
m2 = [mat_dir filesep 'quant_risk_old'];
addpath(genpath(m1));    %add MRMR, feat extraction and images needed to path.
addpath(genpath(m2)); 
cd(mat_dir)

%% Constants

Factor = 1;  %must select factor to decrease image size.
featamt = 10; % must select amount of features to select.
Threshval = .8;

%% Selects Cases

casename = {'Case 2 S14-39636' 'Case 3 S15-5979' 'Case 4 S15-6200'};
casenum = [2,3,4];
num_folds = 3;   %selects number of folds done in crossvalidation.


TrainImageFolder = '/projects/academic/scottdoy/code/quant_risk_old/data';

%% Create Output Directory

R = '/projects/academic/scottdoy/code/quant_risk_steve/Output/newfeatext';

%% Label dirs where selected case mask and original images are stored

%mask dir
Mask_paths = fullfile(TrainImageFolder,casename,'mask');     
%original dir
Original_paths = fullfile(TrainImageFolder,casename,'orig'); 


%% Extracts image file names from Input dir names

[mask_tif_files,original_tif_files,~] = extractimages(Original_paths,Mask_paths);

mask_tif_files{1} = mask_tif_files{1}(1:3);
original_tif_files{1} = original_tif_files{1}(1:3);

%% Reads images and checks for textfeat.mat, extracts features if missing.
%saves and clears Im and textfeat variables after each loop to save RAM
%saves into the "Results" folder R.

% run this if texture features have not been extracted yet.
%[resized_im_loc,text_feat_loc] = read_feat_ext1(original_tif_files,Factor,R,casenum);

[resized_im_loc,text_feat_loc] = read_feat_ext2(original_tif_files,Factor,R,casenum);


%% Split file names into training, validation and testing sets

% Concatenates all files in all cases to create list of all files
text_feat_list = horzcat(text_feat_loc{:})'; %lists all feature extractions
mask_list = horzcat(mask_tif_files{:})'; %lists all masks
resized_list = horzcat(resized_im_loc{:})'; %lists all resized images

num_ims = length(text_feat_list);   %counts total number of images for tr/te

% Create patient-level cross-validation indices
im_cvidx = crossvalind('Kfold',num_ims,num_folds);

for fold_idx = 1:num_folds

    %% Create output folder for each fold
    cd(R)
    mkdir(['Fold_' num2str(fold_idx)])
    R_fold{fold_idx} = [R filesep 'Fold_' num2str(fold_idx)];
    cd(R_fold{fold_idx}) 
    mkdir(['Selected_Feature_Images'])
    R_feat_ims{fold_idx} = [R_fold{fold_idx} filesep 'Selected_Feature_Images'];
    
    %% Non-Testing Set
    notest_feat = text_feat_list(im_cvidx~=fold_idx);  %pulls out training feats
    notest_mask = mask_list(im_cvidx~=fold_idx); %pulls out masks for training ims
    notest_resized_im = resized_list(im_cvidx~=fold_idx); %pulls out resized training ims
  
    num_tr_ims = length(notest_feat);
    im_tridx = crossvalind('HoldOut',num_tr_ims,0.8);  %selects 80% of the ims 
    
    X_train = []; Y_train = []; X_valid =[]; Y_valid = []; X_test = []; Y_test = []; totalscore = [];
    
    %% Create training set data w/ labels from file names
    
    %Training Set (80% of Non-testing)
    feat_train = notest_feat(~im_tridx);
    mask_train = notest_mask(~im_tridx);
    resized_im_train = notest_resized_im(~im_tridx);


    for im_idx = 1:length(feat_train)
       
        % Loads training features and images
        load(feat_train{im_idx}) 
        feat_im = Im; clear Im;
        load(resized_im_train{im_idx})
        resized_im = Ir; clear Ir;
        % Extracts positive and negative region from tissue region
        [Pos,Neg,~] = posnegbackex(mask_train{im_idx},Factor,feat_im,resized_im,Threshval);
  
        % Labels pos as 1's and neg as 0s in X for Y...
        X_im =[Pos;Neg];
        Y_im =[ones(size(Pos,1),1);zeros(size(Neg,1),1)];
    
        X_train = [X_train;X_im];
        Y_train = [Y_train;Y_im];
        
        clear X_im Y_im Pos Neg
    end
    
    %% Create validation set data w/ labels from file names
    
	%Validation Set (20% of Non-testing)
    feat_valid = notest_feat(im_tridx);
    mask_valid = notest_mask(im_tridx);
    resized_im_valid = notest_resized_im(im_tridx);
      
    for im_idx = 1:length(feat_valid)
       
        %Loads training features and images
        load(feat_valid{im_idx})
        feat_im = Im; clear Im;
        load(resized_im_valid{im_idx})
        resized_im = Ir; clear Ir;
        % Extracts positive and negative region from tissue region
        [Pos,Neg,~] = posnegbackex(mask_valid{im_idx},Factor,feat_im,resized_im,Threshval);
  
        % Labels pos as 1's and neg as 0s in X for Y...
        X_im =[Pos;Neg];
        Y_im =[ones(size(Pos,1),1);zeros(size(Neg,1),1)];
    
        X_valid = [X_valid;X_im];
        Y_valid = [Y_valid;Y_im];
        
        clear X_im Y_im Pos Neg
    end     
      
    %Image Whitening for training/validation
    
    %Images are whitened/normalized so that mean=0 and std=1.
    [whitened_training,whitened_valid,overall_avg,overall_std] = whiten_image(X_train,X_valid);
    
    clear X_valid X_train
    
    
    %% Use MRMR to find 10 least correlated features for each image
    
     npfeats = mrmr_mid_d(double(whitened_training),Y_train,featamt);
 
    %% Save feature images for first training image
    load(feat_train{1})
    [~,im_name,~] = fileparts(feat_train{1});
    load(resized_im_train{1})
    Imre = reshape(Im,pix_row,pix_col,156);
    for featnum = 1:length(npfeats)
        imwrite(Imre(:,:,npfeats(featnum)),[R_feat_ims{fold_idx} filesep im_name '_Feature_' num2str(npfeats(featnum)) '.jpg']);
    end
    clear im_name Ir Im pix_row pix_col
	
    %% Naive Bayes Classifier Threshold Optimization using Validation Data
    
    [trained_model,score] = cv_perf(whitened_training(:,npfeats),Y_train,whitened_valid(:,npfeats),Y_valid,R_fold,fold_idx);
    
  
    %% Create Testing/Evaluation Set
     
    %Test Set
    feat_test = text_feat_list(im_cvidx==fold_idx);    %test im strings
    mask_test = mask_list(im_cvidx==fold_idx); %mask for testing images
    resized_im_test = resized_list(im_cvidx==fold_idx); %resized testing images
    
    for im_idx = 1:length(feat_test)
        % Loads testing features and images
        load(feat_test{im_idx})
        feat_im = Im; clear Im;
        [~,test_name,~] = fileparts(feat_test{im_idx}); test_name = test_name(4:end); %gets testing im name
        load(resized_im_test{im_idx})
        resized_im = Ir; clear Ir;
        [m,n,~] = size(resized_im);
        % Extracts positive and negative region from tissue region
        [Pos,Neg,back_ind] = posnegbackex(mask_test{im_idx},Factor,feat_im,resized_im,Threshval);
        Backsize = size(find(back_ind));

        %whitens testing images
        whiten_test = [];
        
        for feat_size = 1:size(feat_im,2)
            whitentemp = bsxfun(@rdivide,bsxfun(@minus,feat_im(:,feat_size),overall_avg(feat_size)),overall_std(feat_size));
            whiten_test = [whiten_test,whitentemp];
        end
        
        %% Naive Bayes Classification of Testing Data using optimal threshold
        [predict_eval,score_eval] = predict(trained_model, whiten_test(:,npfeats)); %predicts cancer regions in 
        
        score = score_eval(:,1); %select positive predictor score (positive region)

        score(back_ind) = 0;   %set background indices equal to 0.
        save([R_fold{fold_idx} filesep 'Fold_' num2str(fold_idx) '_' test_name '.mat'],'score','m','n','mask_test','-v7.3');

        heatresults = reshape(score,m,n);
        groundtruthim = imread(mask_test{im_idx});
        %newmap = colormap(jet);
                
        imwrite(heatresults,[R_fold{fold_idx} filesep 'Heatmap_' test_name '.tif']);
        imwrite(groundtruthim,[R_fold{fold_idx} filesep 'Groundtruth_' test_name '.tif']);
    
        %For evaluation:
        totalscore = [totalscore;score_eval(:,1)];

        %Labels pos as 1's and neg as 0s in X for Y...
        X_im =[Pos;Neg];
        Y_im =[ones(size(Pos,1),1);zeros(size(Neg,1),1);zeros(Backsize)]; 
                          
        Y_test = [Y_test;Y_im];
                
        clear X_im Y_im feat_im resized_im Pos Neg whiten_test
    end


    %% Final perfcurve for evaluation...
    
    % Labels of testing images are used for evaluation
	Y_test_labels = num2cell(num2str(Y_test));
    clear Y_test

	% Testing image lables and totalscore used to find optimal reciever operating characteristic with perfcurve
    [I,J,T,AUC,OPTROCPT] = perfcurve(Y_test_labels,totalscore,'1');
    
    save([R filesep 'ForAcc.mat'],'score','totalscore','Y_test_labels','-v7.3');
       
    ans4 = ['Second OPTROCPT from fold_' num2str(fold_idx) ' is (' num2str(OPTROCPT(1)) ',' num2str(OPTROCPT(2)) ')'];
    ans5 = ['Second AUC from fold_' num2str(fold_idx) ' is ' num2str(AUC)];
    figure;
    plot(I,J)
    hold on
    plot(OPTROCPT(1),OPTROCPT(2),'ro')
    xlabel('False positive rate')
    ylabel('True positive rate')
    title(['ROC for Bayesian Classifier Fold_' num2str(fold_idx)])
    hold off
    saveas(gcf,[R_fold{fold_idx} filesep 'Secondperf.jpg']);
    disp(ans4);
    disp(ans5);
    optimal_threshold = T((I==OPTROCPT(1)) & (J==OPTROCPT(2)));
    
    
    T3 = table(I,J,'VariableNames',{'False_Positive_Rate' 'True_Positive_Rate'});
    writetable(T3,[R_fold{fold_idx} filesep 'eval_data1.csv'])
    T4 = table(optimal_threshold,AUC,OPTROCPT(1),OPTROCPT(2),'VariableNames',{'Optimal_Threshold' 'Area_Under_Curve' 'OPTROCPT_FPR' 'OPTROCPT_TPR'});
    writetable(T4,[R_fold{fold_idx} filesep 'eval_data2.csv'])
          
end 


clear score_eval totalscore Y_test_labels trained_model whitened_training whitened_testing whitened_valid

%=====================================================================
%MRMR citation:
%Hanchuan Peng, Fuhui Long, and Chris Ding, "Feature selection
% based on mutual information: criteria of max-dependency,
% max-relevance, and min-redundancy," IEEE Transactions on
% Pattern Analysis and Machine Intelligence, Vol. 27, No. 8,
% pp.1226-1238, 2005.
%======================================================================
%Display feature images and histograms.
%histim(textfeat,whiteim,Pos,Neg,Back,tbfeats,OutFolder1A,tiflabel);  %images/histograms for Tissue/Background selected feats.
%histim(textfeat,whiteim,Pos,Neg,Back,npfeats,OutFolder2A,tiflabel);  %images/histograms for Negative/Positive selected feats.

%end
