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
function prac3

%clear

% generate Poisson spike trains

close all
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
figure(1);

subplot 221
isi = diff(SpikeTimes);
hist(isi);
ylabel('count');
xlabel('isi [ms]');
title('isi histogram');


% b) write functions to determine 
disp('Homogeneous:');
disp(['CV = ' num2str(CV(isi))]);
disp(['F  = ' num2str(F(SpikeTimes, 100, 10000))]);

% c) as well as a function determining

% please remember to scale all the results correctly and name all the axis. 
% Only this way you can see whether your result makes sense at all!
%
% C(tau) should have loads of  values around 0 Hz and a peak at 0 ms to
% approximately 5*10^-3. Which units does this autocorrelation function
% have?
subplot 223
dt = 0.1;
c = Auto(SpikeTimes, dt);
n = length(c);
tau_range = int32(n/2 - 100/dt:n/2 + 100/dt);
x = double((tau_range-tau_range(round(length(tau_range)/2))))*0.1;

bar(x, c(tau_range));
xlabel('time [ms]');
ylabel('spike count');
title('autocorrelation');

% your CV and Fano factor may deviate from the theoretical value (1). Why?
% --> because the trial is to short. We don't have enough samples in order to let
% the CV and the Fano factor converge to 1



%% Problem 1. Inhomogeneous Poisson process


subplot 222
% construct and plot ISIs and ISI distribution
isi = diff(SpikeTimes_inh);
hist(isi);
ylabel('count');
xlabel('isi [ms]');
title('isi histogram (inhomogeneous)');

% b) write functions to determine 
disp('Inhomogeneous:');
disp(['CV = ' num2str(CV(isi))]);
disp(['F  = ' num2str(F(SpikeTimes_inh, 100, 10000))]);

% c) as well as a function determining

% please remember to scale all the results correctly and name all the axis. 
% Only this way you can see whether your result makes sense at all!
%
% C(tau) should have loads of  values around 0 Hz and a peak at 0 ms to
% approximately 5*10^-3. Which units does this autocorrelation function
% have?
subplot 224
dt = 0.1;
c = Auto(SpikeTimes_inh, dt);
n = length(c);
tau_range = int32(n/2 - 100/dt:n/2 + 100/dt);
x = double((tau_range-tau_range(round(length(tau_range)/2))))*0.1;

bar(x, c(tau_range));
xlabel('time [ms]');
ylabel('spike count');
title('autocorrelation (inhomogeneous)');

% How come the tail of the ISI histogram looks different from the histogram
% in the homogeneous case?
% -> In the inhomogeneous case are more spikes that are closer together (higher
%    first bar, smaller tail). The periodicity of the inhomogeneous case may be
%    a reason for that.

%%
%% Poisson process with refractoriness, a new figure
figure()

%% Poisson process with absolute refractory period


% construct and plot ISIs and ISI distribution for all r
isis = zeros(length(rates_ref), length(diff(SpikeTimes_ref(:,1))));
for i=1:length(rates_ref)
    subplot(3,2,i)
    isis(i,:) = diff(SpikeTimes_ref(:,i));
    hist(isis(i,:));
    ylabel('count');
    xlabel('isi [ms]');
    title(['isi histogram (with refr. period, driving rate ' num2str(rates_ref(i)) ')']);
end

figure();
% compute the effective firing rate and plot r_eff against r
r_eff   = zeros(1,6);
cvs     = zeros(1,6);
fans    = zeros(1,6);
for i=1:length(rates_ref)
    r_eff(i)    = length(SpikeTimes_ref(:,i)) / max(SpikeTimes_ref(:,i)) * 1000; % Hz
    cvs(i)      = CV(isis(i,:));
    fans(i)     = F(SpikeTimes_ref(:,i), dt, max(SpikeTimes_ref(:,i)));
end
subplot 311
plot(rates_ref, r_eff)
xlabel('r [Hz]')
ylabel('r_{eff} [Hz]')

subplot 312
plot(rates_ref, cvs)
xlabel('r [Hz]')
ylabel('CV')

subplot 313
plot(rates_ref, fans)
xlabel('r [Hz]')
ylabel('Fano Factor')

% construct and plot autocorrelation functions (but please, not in the 
% same subplot!)
figure();
for i=1:length(rates_ref)
    subplot(3,2,i)
    c = Auto(SpikeTimes_ref(:,i), dt);
    n = length(c);
    tau_range = int32(n/2 - 100/dt:n/2 + 100/dt);
    x = double((tau_range-tau_range(round(length(tau_range)/2))))*0.1;
    bar(x, c(tau_range));
    xlabel('time [ms]');
    ylabel('spike count');
    title(['autocorrelation (r = ' num2str(rates_ref(i)) ')']);
end


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

function res = F(SpikeTimes, binsize, T)
    n = hist(SpikeTimes, T/binsize);
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













