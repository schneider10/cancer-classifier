function [whitened_training,whitened_valid,overall_avg,overall_std] = whiten_image(X_train,X_valid)
%% Find average and standard deviation of every pixel's feature values. 
% You must subtract the average pixel value of feature x from the feature x
% image pixels and then divide this by the std value of feature x. 

whitened_training = []; whitened_valid = []; overall_avg = []; overall_std = [];

for pixel_feat = 1:length(X_train(1,:))  
    
    %Get mean and std of feat x for all images
    avgtemp = mean(X_train(:,pixel_feat));  
    stdtemp = std(X_train(:,pixel_feat));    
    %{ 
    Normalization of training data:
    1. Use bsxfun to subtract mean of all pixels in feat x from all the pixels of feat x. 
    2. Divide std of all pixels in feat x from all pixels of feat x. 
    %}
    trtemp = bsxfun(@rdivide,bsxfun(@minus,X_train(:,pixel_feat),avgtemp),stdtemp); 
    whitened_training = [whitened_training,trtemp]; clear trtemp
    
    valtemp = bsxfun(@rdivide,bsxfun(@minus,X_valid(:,pixel_feat),avgtemp),stdtemp);
    whitened_valid = [whitened_valid,valtemp]; clear valtemp
    
    overall_avg = [overall_avg;avgtemp]; clear avgtemp
    overall_std = [overall_std;stdtemp]; clear stdtemp
        
end

end