% Shared variance between five behavior experiments and features
% February 2020
% revised to use new variance partitioning

%load('/Volumes/etna/Scholarship/Michelle Greene/Faculty/encodeDecode/rSquare500_VariancePartition5Exp.mat')
fid = fopen('finalSharedVariance5ExpStats500.csv','a');

for exp = 1:5

    sharedExp = squeeze(shared(exp, :, :, :, :));
    featureExp = squeeze(featureAlone(exp, :, :, :, :));
    shared2 = squeeze(mean(sharedExp, 3));
    feature2 = squeeze(mean(featureExp, 3));
    
    for f = 1:9
        thisShared = squeeze(shared2(f,:,:)); %13x850
        thisFeature = squeeze(feature2(f,:,:));
        
        % jackknife
        for s = 1:15
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
            thisLatS = thisLatS(1);
            thisLatS = thisLatS - 100;
            thisLatF = find(x2==thisMaxF);
            thisLatF = thisLatF(1);
            thisLatF = thisLatF - 100;
            
            % save the data
            fprintf(fid,'%s, %s, %s, %s, %s, %s, %s \n', num2str(s), num2str(exp), num2str(f), num2str(thisMaxS), num2str(thisLatS), num2str(thisMaxF), num2str(thisLatF));
        end
    end
    exp
end

fclose('all')
