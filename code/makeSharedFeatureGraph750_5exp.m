% make figure for feature alone and feature shared with unconstrained
% behavior
% february 2020

%load('/Volumes/etna/Scholarship/Michelle Greene/Faculty/encodeDecode/rSquare750_VariancePartition5Exp.mat')

% define colors
sharedColor = [0 76 109]/255;
x = -100:749;
count = 0;

numExp = 5;
numFeat = 9;

for exp = 1:5
    shared2 = squeeze(shared(exp, :, :, :, :));
    
    for f = 1:9
        count = count + 1;
        thisShared = squeeze(shared2(f,:,:,:));
        thisShared = squeeze(mean(thisShared,2));
        yS = mean(thisShared,1);
        
        for t = 1:850
            thisYS = yS(t);
            sds = std(thisShared(:,t));
            confidenceIntervalS(1,t) = thisYS - 1.96*sds/sqrt(13);
            confidenceIntervalS(2,t) = thisYS + 1.96*sds/sqrt(13);
        end
        
        subplot(numExp, numFeat, count)
        %figure;
        myCol = sharedColor;
        fill([x fliplr(x)],[confidenceIntervalS(2,:) fliplr(confidenceIntervalS(1,:))],myCol,'linestyle','none'); alpha(.20); hold all;
        axis([-100 750 0 0.007]);
        h = line([0 0],[0 .007]); set(h,'Color',[.75 .75 .75],'LineWidth',2); hold on;
        h = plot(x, yS); set(h,'Color',myCol,'LineWidth',3); hold on;
        ylabel('Shared R^{2}')
        xlabel('Time in ms')
    end
    
end
