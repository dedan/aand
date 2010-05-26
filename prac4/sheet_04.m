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

D = zeros(1, 300/dt);
firingRate = length(spikeTimes)/length(rho)*100;
stimVar = var(stim)*dt;

for i = 1:300/dt+1
    D(i) = firingRate * C(i) / stimVar;
end

hold on
plot(1:300/dt+1,D)
% 3. Linear estimate of the firing rate
rEST = dt * conv(D, stim);

rZero = firingRate - mean(rEST);
rEST = rEST + rZero;

width = 20/dt;
kernel = ones(1, width);
rREAL  = conv(kernel, rho);
rREAL = rREAL * width;

figure
plot(1:1000/dt, rEST(10000/dt+1:11000/dt))
hold on
plot(1:1000/dt, rREAL(10000/dt+1:11000/dt), 'r')
legend('rEST', 'rREAL')



