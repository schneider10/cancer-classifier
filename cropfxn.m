%function cropfxn
% Function will crop images of chosen dir and then send them to a new dir
% created on the desktop. Cropping parameters can be adjusted
clear all; close all;
choose_dir = uigetdir('C:/Users/smschnei/Desktop','Select Directory to Images'); % asks for image directory
R = 'C:/Users/smschnei/Desktop/Output';

jpgims = dir(fullfile(choose_dir,'*.tif'));
Factor = [1 .8 .75 .5 .35 .25];

for patch = 1:5
    for Facind = 1:length(Factor)
        for k = 1:length(jpgims)
            jpgimfin = jpgims(k).name;
            filename= fullfile(choose_dir,jpgimfin);
            I = imread(filename);
            Ir{k} = imresize(I,Factor(Facind));%reads every image
            clear I filename jpgimfin
        end
        F10 = Factor(Facind) * 100;
        [Im{1},rect] = imcrop(Ir{1});   %outputs the rectangle that you crop from the image that also outputs.
        imwrite(Im{1},[R filesep jpgims(1).name num2str(F10) '_patch_' num2str(patch) '.tif']);
        for k = 2:length(Ir)
            Im{k} = imcrop(Ir{k},rect);    %crops these images by the same rectangle that was output from manual crop.
            imwrite(Im{k},[R filesep jpgims(k).name num2str(F10) '_patch_' num2str(patch) '.tif']);
        end
        
        clear Im rect Ir I
    end
end

%end


