cd('/Volumes/etna/Scholarship/Michelle Greene/Faculty/encodeDecode/');
%load uniqueVarExp500CNN.mat;
%load rSquare500_8model.mat;
load('rSquare500winGlobal.mat')

% average over electrodes
data = squeeze(mean(regressionRsquare,2));

% compute jackknife onset, max, latency of max
stats = zeros(15,600);
for i = 1:15
    thisData = data;
    thisData(i,:) = [];
    
    thisBase = thisData(:,1:100);
    thisY = mean(thisBase,1);
    allY = mean(thisData,1);
    ci(1,:) = thisY - 1.96*(std(thisBase,0,1)/sqrt(13));
    ci(2,:) = thisY + 1.96*(std(thisBase,0,1)/sqrt(13));
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
x = -100:499;
y = mean(data,1);
CI(1,:) = y - 1.96*(std(data,0,1)/sqrt(14));
CI(2,:) = y + 1.96*(std(data,0,1)/sqrt(14));
myCol = [.5 .5 .5];
fill([x fliplr(x)],[CI(2,:) fliplr(CI(1,:))],myCol,'linestyle','none'); alpha(.35); hold all;
h=plot(x,y); set(h,'Color',myCol, 'LineWidth',2); hold on;
plot(logStats,repmat(.135,[length(logStats),1]),'k*');
xlabel('Time (ms)','FontSize',11)
ylabel('R^{2}','FontSize',11)
h = line([0 0],[0 .14]); set(h,'Color',[.5 .5 .5])
axis([-100 500 0, .14]); hold on;

% do electrode by electrode for scatterplot
data = squeeze(mean(regressionRsquare,1)); % average across subjects
for i = 1:256
    thisData = data(i,:);
    thisMax(i) = max(thisData);
    l = find(thisData==thisMax(i));
    thisLat(i) = l-100;
end
load('electrodes.mat')

figure;
scatter(thisLat, thisMax, [], electrodes,'filled'); colorbar;
xlabel('Latency of Maximum R^{2} (ms)')
ylabel('Maximum R^{2}')


