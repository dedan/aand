% Hints for exercise 3 of AAND
% 
% %
% author: Mirko Dietrich
% date: 8 May 2009
% 
% 
% NAME: 
% Student ID number: 328984
% I co-operated with: 
% I used some __ hours doing this exercise
% 
% 
% % You are welcome to use this code as a basis for your solution. 
% % Please send your solution 
% % to p.kuokkanen@biologie.hu-berlin.de 
%
% % by Wed 13 May 2009
% 
% 
% 
function Hints3

clear

% generate Poisson spike trains


load PoissonSpikeTrains.mat

% if you want to play around with the parameters of the Poisson spike
% train, you can also uncomment the next two rows (and, accordingly,
% comment the one above)

% generatePoissonTrains;
% load MyPoissonSpikeTrains.mat



%% Problem 1. Homogeneous Poisson process

% a) calculate the interspike intervals form the spike times. Note that the
% first ISI is relative to time point 0
% Include a plot of the histogram.
isi = diff(SpikeTimes);
hist(isi);
ylabel('count');
xlabel('isi [ms]');
title('isi histogram');


% b) write functions to determine 
disp(CV(isi));
disp(F(SpikeTimes, 100, 10000));

% c) as well as a function determining
%       * autocorrelation: C = Auto(SpikeTimes, dt)
% where dt = 0.1;
% and tau = -100:dt:100; is the time span you want to calculate the
% correlations for.

% please remember to scale all the results correctly and name all the axis. 
% Only this way you can see whether your result makes sense at all!
%
% C(tau) should have loads of  values around 0 Hz and a peak at 0 ms to
% approximately 5*10^-3. Which units does this autocorrelation function
% have?
dt = 0.1;
c = Auto(SpikeTimes, dt);
n = length(c);
tau_range = int32(n/2 - 100/dt:dt:n/2 + 100/dt);

bar(tau_range-min(tau_range)-1000, c(tau_range));

% your CV and Fano factor may deviate from the theoretical value (1). Why?

%% Problem 1. Inhomogeneous Poisson process

% construct and plot ISIs and ISI distribution

% use previously written functions CV(ISI), FF(SpikeTimes) and
% Auto(SpikeTimes, dt) to save some time. You don't have to write everything
% twice, do you?

% How come the tail of the ISI histogram looks different from the histogram
% in the homogeneous case?


%%
%% Poisson process with refractoriness, a new figure
figure(2); clf


%% Poisson process with absolute refractory period

% construct and plot ISIs and ISI distribution for all r

% compute the effective firing rate and plot r_eff against r

% use previously written functions CV(ISI), FF(SpikeTimes) and
% Auto(SpikeTimes, dt) to save some time. This time you might have to work
% column-wise through different driving rates, depending how you wrote your
% functions.

% plot CV and FF (optionally in the same subplot) as a function of r_eff

% construct and plot autocorrelation functions (but please, not in the 
% same subplot!)





%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all

%% Problem 3

load c1p8

figure(3); clf

% first, calculate spike-triggered average
% caution, the STA runs into the wrong time-direction if you calculate it with
% xcorr, so please name your axis accordingly


end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function res = CV(isi)
    res = std(isi)/mean(isi);
end

function res = F(isi, binsize, T)
    n = hist(isi, T/binsize);
    res = var(n)/mean(n);        
end

function c = Auto(SpikeTimes, dt)
    if size(SpikeTimes,1) > size(SpikeTimes,2)
        SpikeTimes = SpikeTimes';
    end
    N_bins  = ceil(max(SpikeTimes)/dt);
    M1      = length(SpikeTimes);
    D       = ones(M1,1)*SpikeTimes - SpikeTimes'*ones(1,M1);
    D       = D(:);
    c       = hist(D,N_bins);
    c(c==max(c)) = 0;
end













