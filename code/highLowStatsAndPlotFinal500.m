cd('/Users/mgreene2/Dropbox/work/functionEEG/encodeDecodeALL/data/')
load('rSquare500highLow.mat')

highData = squeeze(mean(regressionRsquareHigh,2)); %15x600
lowData = squeeze(mean(regressionRsquareLow,2));

%fid = fopen('highLowStatsFinal500.csv','a');
% compute jackknife stats
highStats = zeros(600,1);
lowStats = zeros(600,1);

for i = 1:15
    highData2 = highData;
    lowData2 = lowData;
    highData2(i,:) = [];
    lowData2(i,:) = [];
    
    highBase = highData2(:,1:100);
    lowBase = lowData2(:,1:100);
    thisYhigh = mean(highBase,1);
    thisYlow = mean(lowBase,1);
    allYhigh = mean(highData,1);
    allYlow = mean(lowData,1);
    
    highCI(1,:) = thisYhigh - 1.96*(std(highBase,0,1)/sqrt(13));
    highCI(2,:) = thisYhigh + 1.96*(std(highBase,0,1)/sqrt(13));
    lowCI(1,:) = thisYlow - 1.96*(std(lowBase,0,1)/sqrt(13));
    lowCI(2,:) = thisYlow + 1.96*(std(lowBase,0,1)/sqrt(13));% 
    
    % onset
    highThresh = max(highCI(2,:));
    lowThresh = max(lowCI(2,:));
    a = find(allYhigh>highThresh);
    b = find(allYlow>lowThresh);
    highStats(a) = highStats(a)+1;
    lowStats(b) = lowStats(b)+1;
    highOnset = a(1)-100;
    lowOnset = b(1)-100;
    
    % max
    highMax = max(allYhigh);
    lowMax = max(allYlow);
    
    % mat lat
    h = find(allYhigh==max(allYhigh));
    l = find(allYlow==max(allYlow));
    maxLatHigh = h-100;
    maxLatLow = l-100;
    
    % print the data
%      fprintf(fid,'%s, %s, %s, %s, %s, %s, %s \n', num2str(i), num2str(highOnset), ...
%          num2str(lowOnset), num2str(highMax), num2str(lowMax), num2str(maxLatHigh),...
%          num2str(maxLatLow));
end
% fclose(fid);
highStatsFinal = find(highStats>6);
lowStatsFinal = find(lowStats>6);
highStatsFinal = highStatsFinal-100;
lowStatsFinal = lowStatsFinal-100;

% plot the data
x = -100:499;
colorLow = [59 103 188]/255;
colorHigh = [237 125 49]/255;

allYhigh = mean(highData,1);
allYlow = mean(lowData,1);
clear highCI lowCI
highCI(1,:) = allYhigh - 2.04*(std(highData,0,1)/sqrt(14));
highCI(2,:) = allYhigh + 2.04*(std(highData,0,1)/sqrt(14));
lowCI(1,:) = allYlow - 2.04*(std(lowData,0,1)/sqrt(14));
lowCI(2,:) = allYlow + 2.04*(std(lowData,0,1)/sqrt(14));


fill([x fliplr(x)],[highCI(2,:) fliplr(highCI(1,:))],colorHigh,'linestyle','none'); alpha(.35); hold all;
h=plot(x,allYhigh); set(h,'Color',colorHigh, 'LineWidth',2); hold on;
fill([x fliplr(x)],[lowCI(2,:) fliplr(lowCI(1,:))],colorLow,'linestyle','none'); alpha(.35); hold all;
h=plot(x,allYlow); set(h,'Color',colorLow, 'LineWidth',2); hold on;
h2 = plot(lowStatsFinal,repmat(.075,[length(lowStatsFinal),1]),'*'); set(h2,'Color',colorLow);
h2 = plot(highStatsFinal,repmat(.072,[length(highStatsFinal),1]),'*'); set(h2,'Color',colorHigh);
xlabel('Time (ms)','FontSize',11)
ylabel('R^{2}','FontSize',11)
h = line([0 0],[0 .078]); set(h,'Color',[.5 .5 .5])
axis([-100 500 0 .078]); hold on;
