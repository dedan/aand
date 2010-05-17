% Hints for exercise 4

%% Author: Paula Kuokkanen
%% Date: 14 May 2010

%% Your name:
%% Student ID:
%% how much time was needed?
%% You co-operated with:

%%
% this time I'm not providing too many tips or code, please read the
% exercise sheet 4 carefully, there's lots of information there

clear

load c1p8


%% 1. STA: C(tau)
% Be careful: which direction does your time scale run?



%% 2. Linear kernel D(tau)
%
% D = C(tau)*<r>/var(stimulus) 
%
% you might have to normalize to get the units right!



%% 3. r_est
%
% don't get confused if the estimated rate gets negative, this can happen.
% But why?

% plot one second (t=10 s to t=11 s) of r_est(t) and r(t). Use sliding
% rectangular window of 20 ms width


%% 4. Poisson spike train

% you might want to take a look at the Poisson spike generator 
%   generatePoissonTrains.m used in exercise 3

% generate synthetic spike trains with r_eff. Should you use homogeneous
% Poisson process, inhomogeneous Poisson process or the one with 
% a refractory period? 


% a 1) plot actual and poisson spike trains

% a 2) what differences do they have?


% b 1) plot autocorrelation functions for both spike trains. 
%       range = 100 ms!

% b 2) Why there is a dip at a lag of 2 ms in the autocorrelation of the
% actual spike train? Is there a dip ffor the synthetic train too?

% c 1) Plot the ISI histograms for both trains.
% Why is there a dip below 6 ms for the actual spike train?

% c 2) what are the CVs for the two spike trains and why might they differ?

