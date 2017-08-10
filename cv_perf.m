function [trained_model,score] = cv_perf(whitened_training,Y_train,whitened_valid,Y_valid,R_fold,fold_idx)

%% Convert 1's and 0's into strings for labeling

Y_train_labels = num2cell(num2str(Y_train));
clear Y_train

Y_valid_labels = num2cell(num2str(Y_valid));
clear Y_valid 

%% Training model: first input is training data and second is its labels.

% 0 represents negative and 1 represents positive
trained_model = fitcnb(whitened_training,Y_train_labels,'ClassNames',{'1','0'});
clear Y_train_labels

%test model with validation data to develop optimal threshold.
[~,score,~] = predict(trained_model, whitened_valid);

%% Perfcurve for threshold optimization
%for perfcurve use labeled truth, prediction scores (column 1 is '1' class), and positive class label ('1');

[I,J,T,AUC,OPTROCPT] = perfcurve(Y_valid_labels,score(:,1),1);
clear Y_valid_labels
ans1 = ['OPTROCPT from fold_' num2str(fold_idx) ' is (' num2str(OPTROCPT(1)) ',' num2str(OPTROCPT(2)) ')'];
ans2 = ['AUC from fold_' num2str(fold_idx) ' is ' num2str(AUC)];
figure;
plot(I,J)
hold on
plot(OPTROCPT(1),OPTROCPT(2),'ro')
xlabel('False positive rate')
ylabel('True positive rate')
title(['ROC for Bayesian Classifier Fold_' num2str(fold_idx)])
hold off
saveas(gcf,[R_fold{fold_idx} filesep 'Firstperf.jpg']);

%% Optimal threshold calculation

optimal_threshold = T((I==OPTROCPT(1)) & (J==OPTROCPT(2)));
ans3 = ['Optimal Threshold for fold_' num2str(fold_idx) ' is ' num2str(optimal_threshold)];
disp(ans1);
disp(ans2);
disp(ans3);

T = table(I,J,T,'VariableNames',{'False_Positive_Rate' 'True_Positive_Rate' 'Thresholds'});
writetable(T,[R_fold{fold_idx} filesep 'valid_data1.csv'])
T2 = table(optimal_threshold,AUC,OPTROCPT(1),OPTROCPT(2),'VariableNames',{'Optimal_Threshold' 'Area_Under_Curve' 'OPTROCPT_FPR' 'OPTROCPT_TPR'});
writetable(T2,[R_fold{fold_idx} filesep 'valid_data2.csv'])

end
