% create decoding accuracy script
% averaged across all electrodes
% michelle greene

% july 4 2019

cd('/Users/mgreene2/Dropbox/work/functionEEG/encodeDecodeALL/data/750msec_40msWIN_ACCnet/')
list = dir('*.mat');

for i = 1:length(list)
    load(list(i).name)
    ACC_NET = mean(ACC_NET,1);
    allDecode(i,:) = ACC_NET;
end

x = -100:2:749;
y = mean(allDecode,1);

% subtract baseline
a = find(y~=0);
xx = y(a);
xx = xx(1:5);
baseline = mean(xx);
y = y-baseline;
allDecode = allDecode - baseline;

CI(1,:) = y - 1.96*(std(allDecode,0,1)/sqrt(12));
CI(2,:) = y + 1.96*(std(allDecode,0,1)/sqrt(12));

% calculate the statistical onset
stats = zeros(13, 425);
for i = 1:13
    thisData = allDecode;
    thisData(i,:) = [];
    thisBase = thisData(:,50:55);
    thisY = mean(thisBase,1);
    allY = mean(thisData,1);
    ci(1,:) = thisY - 1.96*(std(thisBase,0,1)/sqrt(11));
    ci(2,:) = thisY + 1.96*(std(thisBase,0,1)/sqrt(11));
    thisThresh = max(ci(2,:));
    a = find(allY>thisThresh);
    s = x(a);
    stats(i,s) = 1;
    if ~isempty(a)
        onset(i) = x(a(1));
    else
        onset(i) = NaN;
    end
    b = find(allY==max(allY));
    maxLat(i) = x(b); %b(1)-100;
end
[min(onset) mean(onset) max(onset)]
[min(maxLat) mean(maxLat) max(maxLat)]
stats = sum(stats,1);
logStats = find(stats>6);
%logStats = x(logStats);

% plot it!
myCol = [.5 .5 .5];
fill([x fliplr(x)],[CI(2,:) fliplr(CI(1,:))],myCol,'linestyle','none'); alpha(.35); hold all;
h=plot(x,y); set(h,'Color',myCol, 'LineWidth',2); hold on;
plot(logStats,repmat(3.5,[length(logStats),1]),'k*');
xlabel('Time (ms)','FontSize',11)
ylabel('Decoding Accuracy (% correct)','FontSize',11)
h = line([0 0],[0 3.7]); set(h,'Color',[.5 .5 .5])
axis([-100 750 0 3.7]); hold on;