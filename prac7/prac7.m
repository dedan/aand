clc
close all
clear all

load arteVPal.mat

% ex 1

idx_close   = find(mrk.y(strmatch('eyes closed', mrk.className),:));
idx_stop    = find(mrk.y(strmatch('stop', mrk.className),:));
idx_stop    = idx_stop(idx_stop > idx_close);

data        = cnt.x(mrk.pos(idx_close):mrk.pos(idx_stop(1)),:);
C           = cov(data);

figure(1);
imagesc(C); colorbar

[E D]       = eig(C);
[~, idx]    = sort(diag(D), 'descend');
E           = E(:,idx);

figure(2);
first_n = 2;
for i = 1:first_n
    subplot(1,first_n, i);
    scalpmap(mnt, E(:,i));
end

%% ex2

aelle_beide = data(:,[strmatch('Oz', cnt.clab) strmatch('Cz', cnt.clab)]);
[E2,~, D2] = princomp(aelle_beide);
E2(:,1) = sqrt(D2(1)) * E2(:,1);
E2(:,2) = sqrt(D2(2)) * E2(:,2);

figure(3);
plot(aelle_beide(:,1), aelle_beide(:,2), '.');
hold on
plot([0 E2(1,1)], [0 E2(2,1)],'r', 'LineWidth', 2.5); 
plot([0 E2(1,2)], [0 E2(2,2)],'r', 'LineWidth', 2.5); 
axis equal

%% ex3
band = [8 12];
nyquist = cnt.fs/2;

[b,a] = butter(5,band/nyquist,'bandpass');
X = filter(b,a,data);

figure(4)
channels = [7 45 68];
for i=1:length(channels)
   subplot(length(channels),1,i); 
   hold on
   plot(data(:,channels(i)),'r');
   plot(X(:,channels(i)), 'b');
   hold off
end

figure(5) %megaplot
subplot(4, 4, 1:2);
imagesc(C);
subplot(4, 4, 3:4);
C3 = cov(X);
imagesc(C3);

[E3, D3] = eig(C3);
[~, idx] = sort(diag(D3), 'descend');
E3       = E3(:,idx);

subplot(4, 4, 5:6);
plot(sqrt(diag(D)), '-o');
subplot(4, 4, 7:8);
plot(sqrt(diag(D3)), '-o');

pfush = [9 10 13 14];
for i = 1:4
   subplot(4,4,pfush(i));
   scalpmap(mnt, E(:,i));
   subplot(4,4,pfush(i)+2);
   scalpmap(mnt, E3(:,i));
end


%% ex4

n_recon = 3;
[E3, proj, D3] = princomp(X);
recon = (E3(:,1:n_recon) * proj(:,1:n_recon)')'; 

figure(7);
hold on
plot(X(:,1),'r');
plot(recon(:,1), 'b');
hold off

err = mean((X-recon).^2,1);
scalpmap(mnt,err)

