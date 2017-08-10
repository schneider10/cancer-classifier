function featext(Irstr,Imstr,original_tif_files,Factor)
        
%read each image file
fprintf(1, 'Now reading %s\n', original_tif_files);    
I = imread(original_tif_files);
   
%resizes all images by a certain factor
       
Ir= imresize(I,Factor);      

%extracts features from resized image to create a matrix 'textfeat'
       
textfeat=get_texture_features(Ir); 
      
%size of images after texture extraction used to reshape images
       
[pix_row,pix_col,f]=size(textfeat);             
      
%reshapes image textfeat results to an nx156 array (x = feat, y = pixel) for indexing
       
Im = reshape(textfeat,pix_row * pix_col,f);      

%save variables "Im" and "Ir" (both created in this function)
%to separate files in the "Results" directory for later use

save(Imstr,'Im','-v7.3');           
save(Irstr,'Ir','pix_row','pix_col','-v7.3'); 
       
clear Im Ir 
       
end    
