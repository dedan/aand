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


%% make figure for Problem 1

figure(1); clf;
set(gcf,'DefaultAxesTickLength',[0.005 0.01]);
set(gcf,'DefaultAxesTickDir','out')
set(gcf,'DefaultAxesbox','off')
set(gcf,'DefaultAxesLayer','top')
set(gcf,'DefaultAxesFontSize',10)
xSize = 15.5;
ySize = 11;
xLeft = (21-xSize)/2;
yTop = (30-ySize)/2;
set(gcf,'PaperUnits','centimeters','PaperPosition',[xLeft yTop xSize ySize],'Position',[1000-xSize*30 700-ySize*30 xSize*40 ySize*40])

w = 6/xSize;
h1 = 5/ySize;
h2 = 3/ySize;
dh = 1.3/ySize;
b1 = 1-h1-0.6/ySize; b2 = b1 -h2-dh; b3 = b2 -h2-dh; b4 = b3 -h2-dh;
l1 = 1.5/xSize; l2 = l1 + w + 1.5/xSize; 

hISI = axes('position',[l1 b1 w h1]);
hAuto = axes('position',[l1 b2 w h2]);
hISI_inh = axes('position',[l2 b1 w h1]);
hAuto_inh = axes('position',[l2 b2 w h2]);


%% Problem 1. Homogeneous Poisson process

% a) calculate the interspike intervals form the spike times. Note that the
% first ISI is relative to time point 0
% Include a plot of the histogram.


% b) write functions to determine 
%       *CV:            CvValue = CV(ISI) and 
%       *Fano factor:   Fano = FF(SpikeTimes)
% and write the results either in the figure (with function TEXT) or to the
% screen
%
% you can place these functions either to the end of this file
% or in a separate file. In either case start them with a line
%
% function result1 = TheNameOfTheFunction(parameter1, parameter2)
%
% now, if you give the parameter result1 any value within the function, it
% will be returned to the calling function

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

























