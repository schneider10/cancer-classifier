function [mask_tif_name] = create_tif_lists(Mask_paths)


% lists tifs in all case folders

for j = 1:length(Mask_paths)
	tifFilesM{j} = dir(fullfile(Mask_paths{j},'*.tif')); 
	for n = 1:length(tifFilesM{j})
		mask_tif_name{j}{n} = tifFilesM{j}(n).name;
	end
end


end
