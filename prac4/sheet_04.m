clc    
clear all
close all

load('c1p8.mat')    

% 1. Spike-Triggered Average

dt = 2;
Time = 0:1200000/dt;

spikeTimes = find(rho==1);

AvgNeuralRespF = hist(spikeTimes, Time);

C = xcorr(stim, AvgNeuralRespF, 300/dt)/length(spikeTimes); % cross-correlation
figure
set(gcf, 'pos', [100 100 1200 800])
plot(C,'k', 'LineWidth', 2)
axis([0 150 -5 30])
set(gca,'XTick',[0 50 100 150]);
set(gca,'XTickLabel',[300 200 100 0])
xlabel('Time before spike [ms]', 'FontSize', 14)
ylabel('Average stimulus', 'FontSize', 14)
title('Spike-Triggered Average', 'FontSize', 16)

% 2. Linear kernel D

len = length(C);
C = C(-(-len:-1));

D = zeros(1, 300);
firingRate = length(spikeTimes)/1200;
stimVar = var(stim)*dt;

for i = 1:300
    D(i) = firingRate * C(i) / stimVar;
end

% 3. Linear estimate of the firing rate

rEST = dt * conv(D, stim);
rEST = rEST(floor(length(D)/2):length(rEST)-floor(length(D)/2));
rZero = firingRate - mean(rEST);
rEST = rEST + rZero;

width  = 20;
kernel = ones(1, width);
rREAL  = conv(kernel, rho);
rREAL  = rREAL(length(kernel)/2:length(rREAL)-length(kernel)/2);
rREAL  = rREAL * width * dt;

figure
set(gcf, 'pos', [100 100 1200 800])
plot(1:1000/dt, rEST(10000/dt+1:11000/dt), 'LineWidth', 2)
hold on
plot(1:1000/dt, rREAL(10000/dt+1:11000/dt), 'r', 'LineWidth', 2)
set(gca, 'XTick', [0 125 250 375 500])
set(gca, 'XTickLabel', [10.0 10.25 10.5 10.75 11.0])
legend('rEST', 'rREAL', 'Location', 'Best')
xlabel('Time [s]', 'FontSize', 14)
ylabel('Estimated Firing Rate', 'FontSize', 14)
title('Linear estimate rEST of the firing rate', 'FontSize', 16)

% 4. Comparison of the actual spike train with a Poisson spike train

poissonSpikes = generatePoissonTrains(rEST, length(spikeTimes));
poissonSpikes = poissonSpikes/max(poissonSpikes) * 1200*1000;
% spikeTimes = spikeTimes*dt;

figure
set(gcf, 'pos', [100 100 1200 800])
subplot(211)

hold on
for i=1:1000
    plot([spikeTimes(i) spikeTimes(i)],[0.1 0.9],'k');  % plot spike train
end
axis([0 1000 0 1])
xlabel('Time [ms]', 'FontSize', 14)
title('Actual Spike Train', 'FontSize', 16)

subplot(212)

hold on
for i=1:1000
    plot([poissonSpikes(i) poissonSpikes(i)],[0.1 0.9],'k');  % plot spike train
end
axis([0 1000 0 1])
xlabel('Time [ms]', 'FontSize', 14)
title('Poisson Spike Train', 'FontSize', 16)

% Describe how are they similar and how do they differ:
% The poisson spike train is much more regular than the actual spike train.
% This is obvious, as a real spike train is not possoinian: spike time
% depend on each other.

%%% Autocorrelograms %%%

n = size(spikeTimes,1);
T = spikeTimes(n);
Time = 0:dt:T;
train = zeros(length(Time),1);
spikeIndx = ceil(spikeTimes/dt);
train(spikeIndx) = 1;
AC = (xcorr(train, train, 100) - (n*n*dt/T))/T; % AC actual spike train

figure
set(gcf, 'pos', [100 100 1200 800])
subplot(211)
plot(AC, 'LineWidth', 2)
xlim([0 200])
set(gca, 'XTick', [0 50 100 150 200])
set(gca, 'XTickLabel', [-100 -50 0 50 100])
title('Autocorrelogram of the Actual Spike Train', 'FontSize', 16)
xlabel('ISI [ms]', 'FontSize', 14)

n = size(poissonSpikes,1);
T = poissonSpikes(n);
Time = 0:dt:T;
train = zeros(length(Time),1);
spikeIndx = ceil(poissonSpikes/dt);
train(spikeIndx) = 1;
AC = (xcorr(train, train, 100) - (n*n*dt/T))/T; % AC poisson spike train

subplot(212)
plot(AC, 'LineWidth', 2)
xlim([0 200])
set(gca, 'XTick', [0 50 100 150 200])
set(gca, 'XTickLabel', [-100 -50 0 50 100])
title('ISI Distribution of the Poisson Spike Train', 'FontSize', 16)
xlabel('ISI [ms]', 'FontSize', 14)

% Why is there a dip at a lag of 2 ms in the autocorrelation of the
% actual spike train? Is there a dip for the synthetic train too?
% The synthetic train doas not have a dip at 2 ms. In the actual spike
% train this corresponds to the refractory period of the neuron, which is
% not present in a poissonian train.

%%% ISI Distributions %%%

ISIs = diff(spikeTimes);
CV2 = std(ISIs)/mean(ISIs);

binWidth = 1;                   % 1 ms bins, center values for the histogram bins
binVec = 0:binWidth:max(ISIs);
ISI_hist = histc(ISIs, binVec); % construct histogram

figure
set(gcf, 'pos', [100 100 1200 800])
subplot(211)
bar(binVec, ISI_hist, 'histc');   % plot the histogram, bar plot
xlabel('ISI [ms]', 'FontSize', 14)
ylabel('# of occurrence', 'FontSize', 14)
xlim([0 100])
text(60,10000,sprintf('CV = %f',CV2), 'EdgeColor', 'red','FontSize', 14)
title('ISI Distribution of the Actual Spike Train', 'FontSize', 16)

subplot(212)
ISIs = diff(poissonSpikes);
CV2 = std(ISIs)/mean(ISIs);

binWidth = 1;                   % 1 ms bins, center values for the histogram bins
binVec = 0:binWidth:max(ISIs);
ISI_hist = histc(ISIs, binVec); % construct histogram
bar(binVec, ISI_hist, 'histc'); % plot the histogram, bar plot
xlabel('ISI [ms]', 'FontSize', 14)
ylabel('# of occurrence', 'FontSize', 14)
xlim([0 100])
text(60,2000,sprintf('CV = %f',CV2), 'EdgeColor', 'red', 'FontSize', 14)
title('ISI Distribution of the Poisson Spike Train', 'FontSize', 16)



