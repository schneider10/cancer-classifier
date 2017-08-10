function histim(textfeat,whiteim,Pos,Neg,Back,feats,R,tiflabel)

for k = 1:length(whiteim)
    for i = 1:length(whiteim{k})
        [m,n,f]=size(textfeat{k}{i});
        image{k}{i}=reshape(whiteim{k}{i},[m n f]);   %reshapes into whitened image the same size as texture extraction.
        for ii=feats{k}     %Images of each feature as well as histograms of pos, neg and background pixels are shown
            figure;
            subplot (3,2,[1,3,5]);  %splits one figure into four different regions. One big region on left for picture and three on the right for histograms.
            imshow(image{k}{i}(:,:,ii));
            title(strcat(tiflabel{k}(i), ' Feature: ', num2str(ii)));
            ax1 = subplot(3,2,2);
            histfit(Pos{k}{i}(:,ii));   %fits a normalized histogram to the positive pixel data.
            xlabel('Positive');
            ax2 = subplot(3,2,4);
            histfit(Neg{k}{i}(:,ii));
            xlabel('Negative');
            ax3 = subplot(3,2,6);
            histfit(Back{k}{i}(:,ii));
            xlabel('Background');
            linkaxes([ax1,ax2,ax3],'x');  %makes all x-axis the same range. change 'x' to 'off' in order to remove this.
            x = strcat(R{k}{1}, filesep, tiflabel{k}(i), '_Feat', num2str(ii), '.jpg'); 
            saveas(gcf,x{1}); %save figs to folder.
        end
    end
end


end
