% Shared variance between unconstrained behavior and features
% February 2020
% revised to use new variance partitioning

load('/Volumes/etna/Scholarship/Michelle Greene/Faculty/encodeDecode/rSquare750_VariancePartition.mat')
fid = fopen('finalSharedVarianceStats750.csv','a');
shared2 = squeeze(mean(shared,3));
feature2 = squeeze(mean(featureAlone,3));

for f = 1:9
    thisShared = squeeze(shared2(f,:,:)); %13x850
    thisFeature = squeeze(feature2(f,:,:));
    
    % jackknife
    for s = 1:13
        thisShareCopy = thisShared;
        thisShareCopy(s,:) = []; %12x850
        
        thisFeatureCopy = thisFeature;
        thisFeatureCopy(s,:) = [];
        
        % find max
        x1 = mean(thisShareCopy,1);
        thisMaxS = max(x1);
        x2 = mean(thisFeatureCopy,1);
        thisMaxF = max(x2);
        
        % find latency at max
        thisLatS = find(x1==thisMaxS);
        thisLatS = thisLatS - 100;
        thisLatF = find(x2==thisMaxF);
        thisLatF = thisLatF - 100;
        
        % save the data
        fprintf(fid,'%s, %s, %s, %s, %s, %s \n', num2str(s), num2str(f), num2str(thisMaxS), num2str(thisLatS), num2str(thisMaxF), num2str(thisLatF));
    end
end

fclose('all')
