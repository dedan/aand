function generatePoissonTrains

%% author: Paula Kuokkanen
%% 5. Mai 2009

%% homogeneous Poisson process

% A homogeneous Poisson process generates events (spikes) with a constant 
% probability or rate r(t) = r. Spikes are independent. Thus, at each 
% time point t, the probability P of observing a spike within 
% a sufficiently small temporal window from t to t + delta_t is 
% P= r*delta_t.

% There are two simple ways of implementing a homogeneous Poisson process:
% 1.    Progress through time in small steps of size delta_t, 
%       draw a random number x (from a uniform distribution 
%       between 0 and 1, Matlab function 'rand' 
%       at each time step. If x < P, generate a spike.
%
% 2.    Generate interspike intervals from an exponential probability 
%       density. When x is uniformly distributed between 0 and 1, 
%       its negative logarithm is exponentially distributed. Thus, we 
%       can generate spike times t(i) iteratively from the 
%       formula t(i+1) = t(i) - log(x)/r.

% Using implementation #2, generate 1000 spikes by a homogeneous
% Poisson process with a rate of r=100 (Hz)

n = 1000;   % desired number of spikes
rate = 100;  % rate in spikes per second
randNumbers = rand(n,1);  % n random numbers, uniform distribution
ISIs = -log(randNumbers)/rate;   % ISIs in seconds
ISIs = ISIs*1000;   % ISIs in milliseconds

% compute spike times from ISIs

SpikeTimes = zeros(n,1);
SpikeTimes(1) = ISIs(1);
for i = 2: length(SpikeTimes)
    SpikeTimes(i) = SpikeTimes(i-1)+ISIs(i);
end


%% inhomogeneous Poisson process

% An inhomogeneous Poisson process is characterized by a time-dependent
% rate r(t). There are several ways of generating spikes. 
% Two basic ways are:
% 1.    Progress through time in small intervals of width delta_t. 
%       For sufficiently small delta_t, the probability P(i) of 
%       observing a spike in interval i from t(i) = i*delta_t to 
%       t_(i) + delta_t is then given by 
%           P(i) = integral_t(i)^[t_(i)+delta_t)] r(tau) d tau . 
%       Then, draw a random number x(i) from a uniform distribution 
%       for each time interval. If x(i) < P(i)$, generate a spike.
%
% 2.    `Thinning' the spike train of a homogeneous Poisson process: 
%       First, a spike sequence is generated with a homogeneous 
%       Poisson process at rate r_max = max[r(t)]. The spike 
%       sequence is then thinned by generating a random number 
%       x(i) for each spike and removing the spike at time 
%       t(i) from the train if r(t(i))/r_max < x(i).

% We use now method 2, thinning. Our probability distribution r is
%     r(t) = A* sin(2*pi*f*t) + r_0
% with A = 50 Hz, r_0 = 100 Hz and f = 10 Hz. We generate 1000 spikes.

% First, start with the homogeneous, but with more spikes so that you can
% thin out later on

n = 10000;   % desired number of spikes
maxRate = 150;%150;  % rate in spikes per second
randNumbers2 = rand(n,1);  % n random numbers, uniform distribution
ISIs2 = -log(randNumbers2)/maxRate;   % ISIs in seconds
ISIs2 = ISIs2*1000;   % ISIs in milliseconds

% compute spike times from ISIs

SpikeTimes2 = zeros(n,1);
SpikeTimes2(1) = ISIs2(1);
for i = 2: length(SpikeTimes2)
    SpikeTimes2(i) = SpikeTimes2(i-1)+ISIs2(i);
end

% thin the spike train
amp = 100; % 50; %
fre = 10;% 10;
randNumbers = rand(n,1);
rates = amp*sin(SpikeTimes2*2*pi*fre./1000) + 100;
Ps = rates/maxRate;
SpikeTimes_inh = SpikeTimes2(find(randNumbers>Ps));
n = 1000;
SpikeTimes_inh = SpikeTimes_inh(1:n);     % take just 1000 spikes

%% Poisson process with absolute refractory period

% Real neurons are in a refractory state immediately after a spike. 
% Thus, during a certain ‘refractory period’ after a spike, it is 
% impossible or much harder to evoke the next spike.
% When the effect of refractoriness is taken into account, spikes 
% can no longer considered to be independent because the probability 
% of observing the next spike then also depends on the time that has 
% passed since the last spike.
%
% In point process models, an approximation of refractoriness is to 
% set the probability of generating a spike to 0 for a certain absolute 
% refractory period tr after a spike, and then to r afterwards. 
%
% We simulate a homogeneous Poisson process and add an absolute refractory
% period of t_r = 5 ms. We use different ‘driving’ rates 
% r = 10, 50, 100, 200, 500, and 1000Hz.
% We simulate 1000 spikes for each rate r.
%
% Adding an absolute refractory period corresponds to simply adding a 
% fixed value to each interspike interval of a ‘normal’ 
% homogeneous Poisson process.


n = 1000;   % desired number of spikes

rates_ref = [10 50 100 200 500 1000];  % "driving" rates in spikes per second
ISIs_ref = zeros(n,length(rates_ref));
randNumbers3 = rand(n,1);  % n random numbers, uniform distribution
t_r = 5;    % absolute refractory period in ms

for i = 1:length(rates_ref)
    ISIs_ref(:,i) = -log(randNumbers3)/rates_ref(i)*1000 + t_r;   % ISIs in milliseconds
end

% compute spike times from ISIs

SpikeTimes_ref = zeros(n,length(rates_ref));
for j = 1:length(rates_ref)
    SpikeTimes_ref(1,j) = ISIs_ref(1,j);
    for i = 2:n
        SpikeTimes_ref(i,j) = SpikeTimes_ref(i-1,j)+ISIs_ref(i,j);
    end
end


save('MyPoissonSpikeTrains.mat','SpikeTimes','SpikeTimes_inh','SpikeTimes_ref','rates_ref','SpikeTimes_refT')

clear