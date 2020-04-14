% for use with 750 msec data
% does regresses all models with windowed time points

subjects = {'002' '004' '005' '006' '007' '010' '011' '012' '013' '016' '017' '018' '019' '020' '021'};
numSub = length(subjects);
dataDir = '/Volumes/etna/Scholarship/Michelle Greene/Faculty/encodeDecode/500data/';

load order;
load whiteData; %finalFeaturesZ; %allFeatures;
%load humanDist;
%allFeatures = cat(2,ones(435,1),allFeaturesEuclidean);
%load allCNNfeatures; % pca features<t_k>
allFeatures = finalFeaturesZ; %attributesWhite; %cat(1, ones(size(humanDist)), humanDist);

% X is matrix of following models
% 1 offset
% 2 gabors
% 3 gist
% 4 texture
% 5 conv2
% 6 fc6
% 7 functions
% 8 objecs
% 9 attributes
% 10 lexical

numModels = 9;

regressionRsquare = zeros(numSub,256,600);
betas = zeros(numModels+1,numSub,256,600);

windowSize = 40;
%startModel = 1;


for s = 1:numSub
    cd(dataDir);
    % load in subject data
    thisSub = strcat('SDE2_',subjects{s},'_PreProcessed_FullDataset_BTSD.mat');
    eval(['load ',thisSub]);
    cd ..
    
    % build normalized matrix
    for a = 1:30
        x = getfield(BTSD_TRIALS,order{a});
        y = mean(x,3);
        dataMat(:,:,a) = y;
    end
    
   % for i = 1:30
   %     x = dataMat(:,:,i);
   %     x = squeeze(x);
   %     y = zscore(x');
   %     normMat(:,:,i) = y';
   % end
    
   % dataMat = normMat;
    
    % do regression for all 256 electrodes
    for electrode = 1:256
        for timePoint = 1:598
            thisMax = min(timePoint+windowSize/2-1,600);
            thisMin = max(timePoint-windowSize/2,1);
            thisWindow = dataMat(electrode, thisMin:thisMax,:);
            thisWindow = squeeze(thisWindow);
            %thisDist = corr(thisWindow);
            %thisDist = 1-thisDist;
            %thisDist = thisDist./max(thisDist(:));
            %thisDist = squareform(thisDist,'tovector');
            thisDist = pdist(thisWindow','correlation');
            %thisDist = squareform(thisDist,'tovector');
            [b,bint,r,rint,stats] = regress(thisDist',allFeatures);
            regressionRsquare(s,electrode,timePoint) = stats(1);
            betas(:,s,electrode,timePoint) = b;
        end
    end
    
    save -v7.3 rSquare500winGlobal regressionRsquare;
    save -v7.3 betas500winGlobal betas;
    clear BTSD_TRIALS x y dataMat normMat
    s
    
end
