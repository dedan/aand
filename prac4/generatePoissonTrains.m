function SpikeTimes_inh = generatePoissonTrains(rates, len)
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

n = length(rates);   % desired number of spikes
maxRate = max(rates); %150;  % rate in spikes per second
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
Ps = rates/maxRate;
SpikeTimes_inh = SpikeTimes2(find(randNumbers>Ps));
n = len;
SpikeTimes_inh = SpikeTimes_inh(1:n);     % take just 1000 spikes

%save('SpikeTimes_inh')

