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
            average(idx,:)  = average(idx,:) + c(samerange);
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




%% Part 2, spike-train statistics

%% 2 a) ISI distribution

% compute differences  row-wise, flatten the result and remove NaNs
isis = diff(SpikeTimes,1,2);
isis = isis(:);
isis = isis(~isnan(isis));

% construct histogram
figure(2)
hist(isis)

%% 2 b) CV
disp(['coeff of variation: ' num2str(std(isis)/mean(isis))]);


%% 2 c) Fano factor

% count the spikes in a trial
spikes      = sum(~isnan(SpikeTimes(:,:)),2);
fano_factor = std(spikes)^2/mean(spikes);
disp(['fano factor: ' num2str(fano_factor)]);



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



%% finished early
% I think this should almost be the solution.
% Just the factor is not in the range that I expect and at the moment
% I don't get why. So solution with some scaling problem left but except from
% this the method should be correct I think.
sliding_window = 50;

counts  = zeros(N, length(time));

figure(3);

% for all trials
for i = 1:N
    
    % remove NaNs, create spiketrain
    valid           = SpikeTimes(i, ~isnan(SpikeTimes(i,:)));
    spiketrain      = zeros(1, T/res);
    spiketrain(int16(valid/res)) = 1;
    
    % create, normalize kernel and convolve the signals
    kernel      = rectf(time, sliding_window);
    kernel      = kernel/sum(kernel);
    c           = conv(spiketrain, kernel);
    samerange   = length(kernel)/2:length(c)-(length(kernel)/2);
    counts(i,:) = c(samerange) * 1000;
end

% fano factor across trials over time
factors = zeros(1, length(time));
for i = 1:length(time)
    factors(i) = std(counts(:,i))^2 / mean(counts(:,i));
end
plot(time, factors);


