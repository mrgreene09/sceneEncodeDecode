% make figure for unconstrained shared variance 750 ms
% february 2020

%load('/Volumes/etna/Scholarship/Michelle Greene/Faculty/encodeDecode/rSquare500_VariancePartition.mat')

% define colors
sharedColor = [0 76 109]/255;
x = -100:499;

shared2 = squeeze(mean(shared,3));

for f = 1:9
    thisShared = squeeze(shared2(f, :, :)); %13x850
    yS = mean(thisShared,1);
    
    % compute confidende interval
    for t = 1:600
        thisYS = yS(t);
        sds = std(thisShared(:,t));
        confidenceIntervalS(1,t) = thisYS - 1.96*sds/sqrt(15);
        confidenceIntervalS(2,t) = thisYS + 1.96*sds/sqrt(15);
    end
    
    % plot the data
    subplot(3, 3, f)
    myCol = sharedColor;
    fill([x fliplr(x)],[confidenceIntervalS(2,:) fliplr(confidenceIntervalS(1,:))],myCol,'linestyle','none'); alpha(.20); hold all;
    axis([-100 500 0 0.009]);
    h = line([0 0],[0 .009]); set(h,'Color',[.75 .75 .75],'LineWidth',2); hold on;
    h = plot(x, yS); set(h,'Color',myCol,'LineWidth',3); hold on;
    ylabel('Shared R^{2}')
    xlabel('Time in ms')
end