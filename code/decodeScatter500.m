% decode electrode scatter figure
% michelle greene
% august 19 2019

dataDir = '/Volumes/etna/Scholarship/Michelle Greene/Faculty/encodeDecode/SDE_500ms_DecodingAccuracies/';
cd(dataDir)

list = dir('*.mat');

for i = 1:length(list)
    load(list(i).name);
    
    for j = 1:256
        thisData = ACC_NET(j,:);
        thisFP = mean(thisData(101:104));
        thisData = thisData - thisFP;
        thisMax(i,j) = max(thisData);
        lat = find(thisData == max(thisData));
        thisLat(i,j) = lat-100;
    end
end

meanLat = mean(thisLat, 1);
meanMax = mean(thisMax, 1);

%cd ..
load electrodes.mat

scatter(meanLat, meanMax, [], electrodes,'filled'); colorbar
axis([100 400 5 12])
xlabel('Latency of Maximum Decoding Accuracy (ms)')
ylabel('Maximum Decoding Accuracy (% Above Baseline)')

%%%%%%
% Statistics
%%%%%%%

for i = 1:15
    [r,p] = corrcoef(thisLat(i,:), thisMax(i,:));
    thisCorr(i) = r(2);
end