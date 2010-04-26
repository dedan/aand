
load ExampleSpikeTimes1

T           = 1000;
res         = 0.1;
delta_ts    = [10 50 100];
time        = 0:0.1:T;
epsilon     = 0.00000001;

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
        kernel = kernelfs{j}(time, delta_ts(i));
        kernel = kernel/sum(kernel);
        smoothed    = conv(spiketrain, kernel);
        
        % plot convolved spiketrain
        subplot(length(delta_ts)+1, 1, j+1);
        plotrange   = floor(length(kernel)/2):length(smoothed)-(floor(length(kernel)/2))+1;
        plot(time, 10000 * smoothed(plotrange(1:length(time))));
        xlabel('t [ms]');
        ylabel('f [Hz]');
    end
end

% spike count rate
disp(['spike count rate: r = ' num2str(length(SpikeTimes)/T)]);
