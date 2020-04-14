% make figure for feature alone and feature shared with unconstrained
% behavior
% february 2020

load('/Volumes/etna/Scholarship/Michelle Greene/Faculty/encodeDecode/rSquare750_VariancePartition.mat')

% define colors
sharedColor = [0 76 109]/255;
featureColor = [193 231 255]/255;
x = -100:749;

for f = 1:9
    thisFeature = squeeze(featureAlone(f,:,:,:));
    thisShared = squeeze(shared(f,:,:,:));
    thisFeature = squeeze(mean(thisFeature,2));
    thisShared = squeeze(mean(thisShared,2));
    
    yS = mean(thisShared,1);
    yF = mean(thisFeature,1);
    
    % calculate confidence interval
    for t = 1:850
        thisYS = yS(t);
        thisYF = yF(t);
        sds = std(thisShared(:,t));
        sdf = std(thisFeature(:,t));
        confidenceIntervalS(1,t) = thisYS - 1.96*sds/sqrt(13);
        confidenceIntervalS(2,t) = thisYS + 1.96*sds/sqrt(13);
        confidenceIntervalF(1,t) = thisYF - 1.96*sdf/sqrt(13);
        confidenceIntervalF(2,t) = thisYF + 1.96*sdf/sqrt(13);
    end
    
    % plot it
    figure;
    % part 1, plot shared
    myCol = sharedColor;
    fill([x fliplr(x)],[confidenceIntervalS(2,:) fliplr(confidenceIntervalS(1,:))],myCol,'linestyle','none'); alpha(.20); hold all;
    axis([-100 800 0 0.02]);
    h = line([0 0],[0 .02]); set(h,'Color',[.75 .75 .75],'LineWidth',2); hold on;
    h = plot(x, yS); set(h,'Color',myCol,'LineWidth',3); hold on;
    ylabel('Shared R^{2}')
    xlabel('Time in ms')
    hold on;
    
    % part 2, plot feature alone
    myCol = featureColor;
    fill([x fliplr(x)],[confidenceIntervalF(2,:) fliplr(confidenceIntervalF(1,:))],myCol,'linestyle','none'); alpha(.20); hold all;
    axis([-100 800 0 0.02]);
    h = line([0 0],[0 .02]); set(h,'Color',[.75 .75 .75],'LineWidth',2); hold on;
    h = plot(x, yF); set(h,'Color',myCol,'LineWidth',3); hold on;
    ylabel('Shared R^{2}')
    xlabel('Time in ms')
    [max(confidenceIntervalS(:)) max(confidenceIntervalF(:))]
end