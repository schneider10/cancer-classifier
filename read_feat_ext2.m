function [resized_im_loc,text_feat_loc] = read_feat_ext2(original_tif_files,Factor,R,casenum) 
 
for  k = 1:length(original_tif_files)           %loop through cases
	for  i = 1:length(original_tif_files{k})    %loop through images
		
        %label fullfile names of images with texture features extracted 
        %and resized original images 
        [~,filename,~] = fileparts(original_tif_files{k}{i});
        resized_im_loc{k}{i} = [R filesep 'Ir_Case_' num2str(casenum(k)) '_Im_' filename '.mat'];
        text_feat_loc{k}{i} = [R filesep 'Im_Case_' num2str(casenum(k)) '_Im_' filename '.mat'];
        
%     	check = exist(resized_im_loc{k}{i});
%     	check2 = exist(text_feat_loc{k}{i});
%            
%     	%If textfeat.mat and Im.mat already exists, feature extraction will be skipped   
% 		if check & check2 == 2            
%             %skips image reading and  feature extraction
%  			fprintf(1,'Skipping imread and feature extractions for %s\n', original_tif_files{k}{i}); 
% 	    else    	
% 	    		disp(['Extracting Images...'])
% 	    		%extracts features and saves results with location names;
%         		featext(resized_im_loc{k}{i},text_feat_loc{k}{i},original_tif_files{k}{i},Factor);
%               
%         end
 	end 
end
 			
end
