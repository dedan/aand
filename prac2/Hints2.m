% Hints for exercise 2 of AAND

%%
% author: Paula Kuokkanen
% date: 24 April 2009


% NAME: Gabler's Stephan
% Student ID number:
% I co-operated with: (please send each your own solution though)
% I used some ____ hours doing this exercise



%% Part 1: Trial-Averaged firing rates

% SpikeTimes.mat contains a matrix of spike times ([m x n], where n is the
% number of trials and m is the maximum spike time index), obtained from
% 100 presentations of a stimulus of 1 second length. The temporal precision
% of the spike times is 0.1\,ms.

% Try re-using your (modified) code from the last time here. You can also modify the
% example solution of the exercise #1 if you want to.


%%
load SpikeTimes    % load spike time data
SpikeTimes = SpikeTimes';
T = 1000;
res = 0.1;
windows = [1 5 10];
time = 0:res:T-res;

rectf = @(t, sig) ones(1, length(find(t<sig))) * 1/sig;
average = zeros(length(windows), length(time));
N = size(SpikeTimes,2);         % number of trials

figure(1);
for i = 1:length(windows)
    subplot(3,1,i);
    for j = 1:N;
        % create spiketrain
        valid           = SpikeTimes(j, ~isnan(SpikeTimes(j,:)));
        spiketrain      = zeros(T/res, 1);
        spiketrain(int16(valid/res)) = 1;
        kernel          = rectf(time, windows(i));
        kernel          = kernel/sum(kernel);
        size(conv(spiketrain, kernel, 'same'))
        size(average(i,:))
        average(i,:)    = average(i,:) + conv(spiketrain, kernel, 'same')';
    end
    average(i,:) = average(i,:) / N;
    plot(average(i,:));
end




%%
% compute and plot different window functions
for i=1:length(delta_ts)
    figure
    subplot(length(delta_ts)+1, 1, 1)
    plot(spiketrain);
    title(['delta t: ' num2str(delta_ts(i))]);
    
    for j=1:length(kernelfs)
        kernel      = kernelfs{j}(time, delta_ts(i));
        kernel      = kernel/sum(kernel);
        smoothed    = conv(spiketrain, kernel);
        
        % plot convolved spiketrain
        subplot(length(delta_ts)+1, 1, j+1);
        plotrange   = floor(length(kernel)/2):length(smoothed)-(floor(length(kernel)/2))+1;
        plot(time, 10000 * smoothed(plotrange(1:length(time))));
        xlabel('t [ms]');
        ylabel('f [Hz]');
    end
end

% Plese also take a look at the raw data. This means: make a break point here
% and see for the variables in "workspace". If you double click one of them
% (there might be only one) a window should open above your command line
% showing how the data in the variable is organized and the value(s) it has.



% * Calculate the trial-averaged firing rate, using a sliding rectangular
% window function with a width of 1, 5, and 10 ms.



% * Include different numbers of trials (10, 50 and 100), and see how it
% affects your results.



% * use "handles(1)", "handles(2)" and "handles(3)" to asses the sub-figures
% to plot the different numbers of trials used in averaging.





%% Part 2, spike-train statistics

%% 2 a) ISI distribution

ISIs = diff(SpikeTimes);
% calculates ISIs - differences between spike times, remember to check that
% calculations go along the right matrix dimension

ISIs = reshape(ISIs,1,[]);  % this use of reshape converts the matrix into a vector
ISIs = ISIs(~isnan(ISIs));   % remove NaNs

% construct histogram

% plot
set(gcf,'CurrentAxes',handles(4));

%% 2 b) CV


%% 2 c) Fano factor


%% Part 3, spike-triggered average

% Download Stim_Spikes_forSTA.mat from the course website. It contains
% the Stimulus vector, the corresponding Time vector with time in ms, and
% the SpikeTimes obtained from 100 presentations of the stimulus to a model
% neuron. Calculate the spike-triggered average.

% Hint 1: See how the matlab function xcorr is related to the equations
% given in the exercise sheet.

% Hint 2: dividing by the total number of spikes is equivalent to first
% dividing by the number of trials to generate the trial-averaged neuronal
% response function, and then dividing by the average number of spikes per
% trial when calculating the STA.

load Stim_Spikes_forSTA;



% plot
set(gcf,'CurrentAxes',handles(5));

