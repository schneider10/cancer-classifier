function [Pos,Neg,back_ind] = posnegbackex(mask_train,Factor,feat_im,resized_im,Threshval)

Ml = posex(mask_train,Factor);  %extracts positively labeled pixels

Igray=rgb2gray(resized_im);
clear resized_im
% imhist(I1gray);figure;imhist(I2gray);figure;imhist(I3gray);figure;imhist(I4gray);
%  a. observe range of background pixels= 233-244...
%  b. extract pixels only from this range by first indexing the background
%  into a logical array.

ind = im2bw(Igray,Threshval); %indexes logical matrix where "true" values are equal to 1 and the rest 0.
addup = Ml + double(ind); %adds mask and background logical matrixes to make overlap=2.
olap = [addup==2];%creates matrix where overlapping pixels are made 1
ind(olap) = 1; %All overlapping pixels are made equal to 1.
Ml(olap) = 0;

[p,q] = size(Ml);  %counts rows and columns of mask region for reshaping.
Bl = reshape(Ml,p*q,1);   %reshapes matrix to a linear matrix for linear indexing.

[m,n] = size(ind);%counts rows and columns of ind1
back_ind = reshape(ind,m*n,1);  %reshapes ind to a vector for indexing.

%Back = feat_im(indr,:); % extracts background from image
Pos = feat_im(Bl,:);
Neg = feat_im(~back_ind & ~Bl,:);  %Extract pixels from non-cancer region only. Index ~background and ~pos.

end
