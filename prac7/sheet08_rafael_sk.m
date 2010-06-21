% Acquisition and Analysis of Neuronal Data - Exercise Sheet 8
% Solution by Rafael Schultze-Kraft

clc
close all
clear all

load arteVPal.mat

%% ex 1

idx_close   = find(mrk.y(strmatch('eyes closed', mrk.className),:));
idx_stop    = find(mrk.y(strmatch('stop', mrk.className),:));
idx_stop    = idx_stop(idx_stop > idx_close);

data        = cnt.x(mrk.pos(idx_close):mrk.pos(idx_stop(1)),:);
C           = cov(data);

figure();
set(gcf, 'Position', [100 100 900 800])
subplot(2,2,1:2)
imagesc(C); colorbar
title('Covariance Matrix', 'FontSize', 16)
xlabel('Channel', 'FontSize', 14)
ylabel('Channel', 'FontSize', 14)

[E D]       = eig(C);
[s, idx]    = sort(diag(D), 'descend');
E           = E(:,idx);

subplot(2,2,3);
scalpmap(mnt, E(:,1));
title('Scalpmap of PC 1', 'FontSize', 16)
subplot(2,2,4);
scalpmap(mnt, E(:,2));
title('Scalpmap of PC 2', 'FontSize', 16)

%% ex2

aelle_beide = data(:,[strmatch('Oz', cnt.clab) strmatch('Cz', cnt.clab)]);
[E2, pr , D2] = princomp(aelle_beide);
E2(:,1) = sqrt(D2(1)) * E2(:,1);
E2(:,2) = sqrt(D2(2)) * E2(:,2);

figure();
set(gcf, 'Position', [100 100 900 800])
plot(aelle_beide(:,1), aelle_beide(:,2), '.');
hold on
plot([0 E2(1,1)], [0 E2(2,1)],'r', 'LineWidth', 2.5); 
plot([0 E2(1,2)], [0 E2(2,2)],'r', 'LineWidth', 2.5); 
axis equal
title('Scatterplot of Channels Oz and Cz', 'FontSize', 16)
xlabel('Channel Oz', 'FontSize', 14)
ylabel('Channel Cz', 'FontSize', 14)
legend('Data', 'PCs', 'Location', 'Best')

%% ex3
band = [8 12];
nyquist = cnt.fs/2;

[b,a] = butter(5,band/nyquist,'bandpass');
X = filter(b,a,data);

figure()
set(gcf, 'Position', [100 100 900 800])
channels = [23 42 69];
for i=1:length(channels)
   subplot(length(channels),1,i);
   hold on
   plot(data(:,channels(i)),'r');
   plot(X(:,channels(i)), 'b');
   hold off
   if i == 1
    title('Instances of Original and Bandpass-Filtered (8 - 12 Hz) Data', 'FontSize', 16)
   end
   legend('Original Data', 'Filtered Data', 'Location', 'Best')
   ylabel('Voltage [\muV]', 'FontSize', 14)
   xlabel('Time [ms]', 'FontSize', 14)
end

figure() % megaplot
set(gcf, 'Position', [100 100 900 800])
subplot(2, 2, 1);
imagesc(C);
title('Covariance Matrix - Original Data', 'FontSize', 16)
subplot(2, 2, 2);
C3 = cov(X);
imagesc(C3);
title('Covariance Matrix - Filtered Data', 'FontSize', 16)

[E3, D3] = eig(C3);
[s, idx] = sort(diag(D3), 'descend');
E3       = E3(:,idx);

subplot(2,2,3)
plot(sqrt(diag(D)), '-o');
title('Eigenvalue Spectrum of Original Data', 'FontSize', 16)
subplot(2, 2, 4);
plot(sqrt(diag(D3)), '-o');
title('Eigenvalue Spectrum of Filtered Data', 'FontSize', 16)

figure()
set(gcf, 'Position', [100 100 900 800])
for i = 1:2:7
   subplot(4,2,i);
   scalpmap(mnt, E(:,i));
   if i == 1
       title('PCs of Original Data','FontSize',16)
   end
end

for i = 2:2:8
   subplot(4,2,i);
   scalpmap(mnt, E(:,i));
   if i == 2
       title('PCs of Filtered Data','FontSize',16)
   end
end

%% ex4

n_recon = 3;
[E3, proj, D3] = princomp(X);
recon = (E3(:,1:n_recon) * proj(:,1:n_recon)')'; 

% figure()
% hold on
% plot(X(:,1),'r');
% plot(recon(:,1), 'b');
% hold off

figure()
set(gcf, 'Position', [100 100 900 800])
title('Mean Square Error in each Channel after Signal Reconstruction using first three PCs', 'FontSize', 16)
err = mean((X-recon).^2, 1);
scalpmap(mnt,err)
title('Mean Square Error in each Channel after Signal Reconstruction using first three PCs', 'FontSize', 16)

