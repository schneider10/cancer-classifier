function Ml = posex(mask_train,Factor)

%Masks are used to index annotated pixels that are cancer cells.
%First extract logical array of 1's and 0's for each pixel in each image where 1 is cancer region:

fprintf(1, 'Now reading %s\n', mask_train);

M = imread(mask_train);
Mr = imresize(M,Factor); %resizes mask to .05 of original mask to match the resolution of the original.

Ml = logical(Mr);  %converts white region of mask to 1's and the rest to 0's
%x = strcat(R, filesep, tiflabel{k}(i),'_Binary_Mask.jpg');
%imwrite(Ml{k}{i},x{1});

end