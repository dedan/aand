
clear all
close all
clc
load oddballVPei


res         = struct;
interval    = [-100 900];
dt          = 10;
n_trials    = 80;


% ex 1
% find the channel we are looking for and get trial epochs for it
epo = makeepochs(cnt, mrk, interval);
FCz = squeeze(epo.x(:,strmatch('FCz', cnt.clab, 'exact'),:));

figure(1)
subplot 211;
% compute trial averages for each class
for i=1:length(mrk.className)
    res(i).trial_avg = mean(FCz(:,logical(mrk.y(i,:))),2);
end

% ploting and labelling stuff
plot(interval(1):dt:interval(2), [res.trial_avg]);
xlabel('time [ms]');
ylabel('voltage [uV]');
legend(mrk.className);
title('trial averages');
xlim(interval);

% select only dev class
ind         = strmatch('dev', mrk.className, 'exact');
dev_class   = FCz(:,logical(mrk.y(ind,:)));
noise_std   = NaN(1,n_trials);
overk       = NaN(1,n_trials);

for i=1:n_trials
    noise_std(i)    = std(mean(dev_class(:,1:i),2) - res(ind).trial_avg);
    overk(i)        = 1/sqrt(i);
end

subplot 212
plot(1:n_trials, [overk*max(noise_std); noise_std])
title('std(noise) vs. 1/sqrt(k)');
legend({'1/sqrt(k)', 'std(noise)_k'});
xlabel('ntrials');
ylabel('noise std');


%% ex 3

figure(2)

% settings
interval    = [300 370];
res         = 0.001;

% make epochs
epo     = makeepochs(cnt, mrk, interval);
data    = squeeze(mean(epo.x));

% compute fisher discriminant
[w, b]  = fisher(data, epo.y);

% project on discriminant
proj    = w' * data;

% plotting stuff
range   = min(proj):res:max(proj);

subplot 211;
bar(range,histc(proj(logical(epo.y(1,:))), range), 'FaceColor','b') 
hold on; 
bar(range,histc(proj(logical(epo.y(2,:))), range), 'FaceColor','r')
hold off;
legend(mrk.className);

subplot 212
scalpmap(mnt, w);