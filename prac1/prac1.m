

load ExampleSpikeTimes1

T = 1000;
res = 0.1;
delta_ts = [10 50 100];

%%
subplot(length(delta_ts)+1, 1, 1)
hold on
for i = 1: length(SpikeTimes)
    plot([SpikeTimes(i) SpikeTimes(i)],[0.1 0.9],'k');
end
axis([0 1000 0 1])
hold off


figure(1);
for i=1:length(delta_ts)
    subplot(length(delta_ts)+1, 1, i+1)
    edges = 1:delta_ts(i):T;
    n = histc(SpikeTimes, edges);
    %n = hist(SpikeTimes, floor(T/delta_ts(i)));
    bar(edges, (n/delta_ts(i)) * 1000)
    title(['delta t: ' num2str(delta_ts(i))]);
    axis([0 1000 0 1000]),
    xlabel('t [ms]');
    ylabel('f [Hz]');
end

%%
spiketrain = zeros(T/res);
spiketrain(logical(SpikeTimes/res)) = 1;
%plot(spiketrain);
%kernel1 = ones(10/0.1,1) * 1/10;

