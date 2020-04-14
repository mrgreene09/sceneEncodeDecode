folderList = dir;
count = 0;

for i = 4:length(folderList)
    count = count+1;
    cd(folderList(i).name);
    imageList = dir('*.jpg');
    
    for j = 1:length(imageList)
        thisIm = double(imread(imageList(j).name));
        thisIm = imresize(thisIm,[32 32],'bilinear');
        tmpFeatures(:,j) = thisIm(:);
    end
    
    allFeatures(:,count) = mean(tmpFeatures,2);
    cd ..
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:length(labels)
    thisLabel = labels{i};
    labLength = length(thisLabel);
    
    a = find(strncmpi(thisLabel,images,labLength));
    
    theseFeatures = labels_cv(a,:);
    allFeatures(:,i) = mean(theseFeatures,1);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
folderList = dir;
count = 0;

for i = 4:length(folderList)
    count = count+1;
    cd(folderList(i).name);
    imageList = dir('*.jpg');
    
    for j = 1:length(imageList)
        im0 = double(imread(imageList(j).name));
        im0 = imresize(im0,[256 256],'bilinear');
        %im0 = mean(im0,3);
        [ny,nx,cols] = size(im0);
        Nsc = 3; % Number of scales
        Nor = 4; % Number of orientations
        Na = 7;  % Spatial neighborhood is Na x Na coefficients
        % It must be an odd number!
        
        params = textureColorAnalysis(im0, Nsc, Nor, Na);
        tmpParams(j,:) = cat(1,params.pixelStats(:), params.pixelStatsPCA(:),...
            params.pixelLPStats(:), params.autoCorrReal(:), params.autoCorrMag(:),...
            params.magMeans(:), params.cousinMagCorr(:), params.parentMagCorr(:),...
            params.cousinRealCorr(:), params.parentRealCorr(:), params.varianceHPR(:),...
            params.colorCorr(:));

    end
    allTextureParams(:,i) = mean(tmpParams,1);
    cd ..
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
root = cd;
folderList = dir;
count = 0;
for i = 4:length(folderList)
    if strcmp(folderList(i).name, 'hmaxMatlab')
        continue
    end
    cd(folderList(i).name);
    imageList = dir('*.jpg');
    
    for j = 1:length(imageList)
        count = count + 1;
        allEEGIms{count} = [root '/' folderList(i).name '/' imageList(j).name];
    end
    cd ..
end
