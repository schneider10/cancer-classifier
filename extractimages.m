function [mask_tif_files,original_tif_files,original_tif_name] = extractimages(Original_paths,Mask_paths)

%creates n x m matrix of mask tifs where n = case numbers and m = image numbers.
mask_tif_name = create_tif_lists(Mask_paths);

%replaces _mask at the end of the strings with an empty space.

for k = 1:length(mask_tif_name)
	remove_mask{k} = regexprep(mask_tif_name{k},'_mask','');  
end

%creates n x m matrix of original tifs where n = case numbers and m = image numbers.

original_tif_name_full = create_tif_lists(Original_paths);

for k = 1:length(original_tif_name_full)
	
	%labels all members of equal values as 1's, the rest 0's
	mask_index = ismember(original_tif_name_full{k},remove_mask{k});
		
	%selects originals with matching masks.
	original_tif_name{k} = original_tif_name_full{k}(mask_index);

	%creates fullfile name from matching tif images.
	for n = 1:length(mask_tif_name{k})
		mask_tif_files{k}{n} = fullfile(Mask_paths{k},mask_tif_name{k}{n});
		original_tif_files{k}{n} = fullfile(Original_paths{k},original_tif_name{k}{n});

		%Error message if Case Folder has no image pairs'
		if isempty(original_tif_files{k})
		   errorMessage = strcat('Error: There are no Image Pairs in _', Original_paths{k});
	       error(errorMessage)
		end
	end
end


end
