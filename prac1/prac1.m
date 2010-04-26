
%% load data and constants
load ExampleSpikeTimes1


T           = 1000;             % ms
res         = 0.1;              % ms
delta_ts    = [10 50 100];      % ms
time        = 0:res:T;          % ms

%% exercise 1
% first plot the spiketrain
figure(1)
subplot(length(delta_ts)+1, 1, 1)
hold on
for i = 1: length(SpikeTimes)
    plot([SpikeTimes(i) SpikeTimes(i)],[0.1 0.9],'k');
end
axis([0 1000 0 1])
hold off

% spike histograms
for i=1:length(delta_ts)
    subplot(length(delta_ts)+1, 1, i+1)
    
    % compute the histogram
    edges   = 1:delta_ts(i):T;
    n       = histc(SpikeTimes, edges);
    
    % plot and labelling
    bar(edges, (n/delta_ts(i)) * 1000)
    axis([0 1000 0 1000]),
    title(['delta t: ' num2str(delta_ts(i))]);
    xlabel('t [ms]');
    ylabel('f [Hz]');
end


%% exersize 2
% create spiketrain
spiketrain = zeros(T/res, 1);
spiketrain(int16(SpikeTimes/res)) = 1;

% cell array of window functions
% zeros are padded to the alpha function in order to make it a causal filter
rectf = @(t, sig) ones(1, length(find(t<sig))) * 1/sig;
gausf = @(t, sig) (1/sqrt(2*pi*sig)) * exp(-((t-T/2).^2)/(2*sig^2));
alphf = @(t, sig) [zeros(size(t)) abs( ((1/sig)^2 * t) .* exp(-(1/sig) * t ))];
kernelfs = {rectf gausf alphf};

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

%% exercise 3
% spike count rate (is it really that simple or did I misunderstand the question)? I really thought
% about it for a while but don't see what else to do.
T = 1; % 1 second
disp(['spike count rate: r = ' num2str(length(SpikeTimes)/T)' Hz']);


%% finished early 1
% the first task is to try other windows. I do see the point of it. We already had different window
% sizes (bin sizes) and what it showed is that changing the window size is a transition from the
% original signal (very small bin size) over a local averaging to the overall spike count rate.
% I don't understand what other windows could be meant.

% To try a differet kernel function I will use a gabor filter and expect it to work  as a kind of
% edge detection. When comparing it with the the result of the gaussion filter it becomes visible
% what this 'edge detection' for spiketrains means. The single spike in the very end of the
% spiketrain is much more emphasized by the gabor filter. I don't think this filter is biologically
% reasonable. Maybe it could be used when someone is interested in the onset of a neurons firing
% after a certain stimulus. 
lambda      = 50;
gabor       = @(t, sig) exp(-((t-T/2).^2)/(2*sig^2)) .* cos((2*pi*t)/lambda);
kernel      = gabor(time, 10);
kernel      = kernel/sum(kernel);
smoothed    = conv(spiketrain, kernel);

subplot 211
plot(spiketrain)
subplot 212
plotrange   = floor(length(kernel)/2):length(smoothed)-(floor(length(kernel)/2))+1;
plot(time, 10000 * smoothed(plotrange(1:length(time))));


%% finished early 2
% ok, I have to admit that my code is not very flexible. It takes ages when computing it for
% SpikeTimes2 and the range of the plot is messed up. I really don't know why this happens to the
% plotted range. But I guess that the convolution could be speeded up by doing it as a
% multiplication in fourier space.
res     = 0.1;
T       = 10000;    % ms
time    = 0:res:T;          % ms

load ExampleSpikeTimes2

% create spiketrain
spiketrain = zeros(T/res, 1);
spiketrain(int16(SpikeTimes/res)) = 1;

% cell array of window functions
% zeros are padded to the alpha function in order to make it a causal filter
rectf = @(t, sig) ones(1, length(find(t<sig))) * 1/sig;
gausf = @(t, sig) (1/sqrt(2*pi*sig)) * exp(-((t-T/2).^2)/(2*sig^2));
alphf = @(t, sig) [zeros(size(t)) abs( ((1/sig)^2 * t) .* exp(-(1/sig) * t ))];
kernelfs = {rectf gausf alphf};

% compute and plot different window functions
for i=1:1
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


%% trial average neural respone functions.
% I don't understand the data structure of ExampleSpikeTimes3.
% It does not contain spiketimes as the values are not monotonously increasing and it also contains
% a lot of NaN!?

