% compute noise ceiling for 500 msec EEG data
% michelle greene
% may 2017

% edited december 2019 to have a different ceiling for each time point.

subjects = {'002' '004' '005' '006' '007' '010' '011' '012' '013' '016' '017' '018' '019' '020' '021'};
numSub = length(subjects);
cd('/Users/mgreene2/Dropbox/work/functionEEG/encodeDecodeALL/data/')
load order;

% pre-allocate memory
allRDM = zeros(length(subjects), 600, 435);

% folder with data
dataDir = '/Volumes/etna/Scholarship/Michelle Greene/Faculty/encodeDecode/500data/';
cd(dataDir);

% step 1: collate all RDMs
for s = 1:numSub
    thisSub = strcat('SDE2_',subjects{s},'_PreProcessed_FullDataset_BTSD.mat');
    eval(['load ',thisSub]);
    
    % build normalized matrix
    for a = 1:30
        x = getfield(BTSD_TRIALS,order{a});
        y = mean(x,3);
        dataMat(:,:,a) = y;
    end
    
    for i = 1:30
        x = dataMat(:,:,i);
        x = squeeze(x);
        y = zscore(x');
        normMat(:,:,i) = y';
    end
    
    % loop over time points
    for t = 1:600
        thisData = squeeze(normMat(:, t, :));
        d = pdist(thisData', 'correlation');
        allRDM(s, t, :) = d;
    end
    
    clear dataMat normMat BTSD_TRIALS x y
    s
end

% step 2: find upper bound
meanRDM = squeeze(mean(allRDM,1)); %850x435

for s = 1:numSub
    for t = 1:600
        [r,p] = corrcoef(meanRDM(t,:), squeeze(allRDM(s,t,:)));
        theseCors(s,t) = r(2);
    end
end
upperBound = mean(theseCors,1);
upperBound = upperBound .^2;

% step 3: find lower bound
for s = 1:numSub
    for t = 1:600
        thisRDM = squeeze(allRDM(:,t,:)); %13x435
        thisRDM(s,:) = [];
        thisRDMmean = mean(thisRDM,1);
        [r,p] = corrcoef(squeeze(allRDM(s,t,:)),thisRDMmean);
        theseCors2(s,t) = r(2);
    end
end
lowerBound = mean(theseCors2, 1);
lowerBound = lowerBound .^2;

cd('/Users/mgreene2/Dropbox/work/functionEEG/encodeDecodeALL/data/')
save noiseCeiling500.mat upperBound lowerBound