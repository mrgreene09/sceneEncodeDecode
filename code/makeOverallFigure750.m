% overall figure for 750 ms data, all encoding models
% edited January 2020 for new noise ceiling

cd('/Users/mgreene2/Dropbox/work/functionEEG/encodeDecodeALL/data/');
%load uniqueVarExp500CNN.mat;
%load rSquare500_8model.mat;
load('rSquare750_allFinalPruned.mat')
load('noiseCeiling750.mat')

% average over electrodes
data = prunedData; %squeeze(mean(regressionRsquare,2));

% compute jackknife onset, max, latency of max
stats = zeros(13,850);
for i = 1:13
    thisData = data;
    thisData(i,:) = [];
    
    thisBase = thisData(:,1:100);
    thisY = mean(thisBase,1);
    allY = mean(thisData,1);
    ci(1,:) = thisY - 1.96*(std(thisBase,0,1)/sqrt(11));
    ci(2,:) = thisY + 1.96*(std(thisBase,0,1)/sqrt(11));
    thisThresh = max(ci(2,:));
    a = find(allY>thisThresh);
    stats(i, a-100) = 1;
    onset(i) = a(1)-100;
    maxx(i) = max(allY);
    l = find(allY==max(allY));
    latency(i) = l-100;
end
stats = sum(stats,1);
logStats = find(stats>6);

% plot it!
x = -100:749;
y = mean(data,1);
CI(1,:) = y - 1.96*(std(data,0,1)/sqrt(12));
CI(2,:) = y + 1.96*(std(data,0,1)/sqrt(12));
myCol = [0 0 1];
gray = [.5 .5 .5];
fill([x fliplr(x)],[CI(2,:) fliplr(CI(1,:))],myCol,'linestyle','none'); alpha(.35); hold all;
fill([x fliplr(x)],[upperBound fliplr(lowerBound)],gray,'linestyle','none'); alpha(.25); hold all;
h=plot(x,y); set(h,'Color',myCol, 'LineWidth',2); hold on;
plot(logStats,repmat(.23,[length(logStats),1]),'k*');
xlabel('Time (ms)','FontSize',11)
ylabel('R^{2}','FontSize',11)
h = line([0 0],[0 .25]); set(h,'Color',[.5 .5 .5])
axis([-100 750 0, .25]); hold on;

% do electrode by electrode for scatterplot
% data = squeeze(mean(regressionRsquare,1)); % average across subjects
% for i = 1:256
%     thisData = data(i,:);
%     thisMax(i) = max(thisData);
%     l = find(thisData==thisMax(i));
%     thisLat(i) = l-100;
% end
% load('electrodes.mat')
% 
% figure;
% scatter(thisLat, thisMax, [], electrodes,'filled'); colorbar;
% xlabel('Latency of Maximum R^{2} (ms)')
% ylabel('Maximum R^{2}')


