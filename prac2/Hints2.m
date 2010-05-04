% Solution for exercise 2 of AAND

%%
% author: Paula Kuokkanen
% date: 24 April 2009


% NAME: Stephan Gabler
% Student ID number: 329131
% I co-operated with: Mirko Dietricht
% I used some ____ hours doing this exercise



%% Part 1: Trial-Averaged firing rates

clear
load SpikeTimes    % load spike time data
SpikeTimes  = SpikeTimes';
T           = 1000;
res         = 0.1;
windows     = [1 5 10];
n_trials    = [10 100];
time        = 0:res:T-res;

%% a+b) different windows - different number of trials
rectf   = @(t, sig) ones(1, length(find(t<sig))) * 1/sig;
average = zeros(length(windows)*length(n_trials), length(time));
N       = size(SpikeTimes,2);                               % number of trials

figure(1);

% for the different window functions
for i = 1:length(windows)
    for j = 1:length(n_trials);
        idx = (i*2)-mod(j,2);
        subplot(length(windows),length(n_trials),idx);
        
        perms       = randperm(N);
        rand_trials = perms(1:n_trials(j));
        % for all trials
        for k = 1:n_trials(j);
            
            % remove NaNs, create spiketrain
            valid           = SpikeTimes(rand_trials(k), ~isnan(SpikeTimes(rand_trials(k),:)));
            spiketrain      = zeros(1, T/res);
            spiketrain(int16(valid/res)) = 1;
            
            % create, normalize kernel and convolve the signals
            kernel          = rectf(time, windows(i));
            kernel          = kernel/sum(kernel);
            c               = conv(spiketrain, kernel);
            samerange       = length(kernel)/2:length(c)-(length(kernel)/2);
            average(idx,:)    = average(idx,:) + c(samerange);
        end
        
        % average over trials and plot the average
        average(idx,:) = average(idx,:) / n_trials(j);
        plot(time, average(idx,:)*10000);
        title(['window size: ' num2str(windows(i)) ' Ntrials: ' num2str(n_trials(j))]);
        xlabel('t [ms]');
        ylabel('f [Hz]');
    end
end

%% c) reading of the neural code
% the neural code of the presented stimulus seams to be oscillatory firing.
% the readability could be improved by using a measure for oscillatory behavior.
% the autocorrelation of the response could be measured for example




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

