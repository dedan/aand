%%
%% sheet 08 - exercise 1
%%

load([DATA_DIR 'teaching/arteVPal.mat']);

ci= strmatch('eyes closed', mrk.className);
idx_start= find(mrk.y(ci,:));
ci= strmatch('stop', mrk.className);
idx_stop= find(mrk.y(ci,:) & 1:numel(mrk.pos)>idx_start, 1, 'first');
X= cnt.x(mrk.pos(idx_start):mrk.pos(idx_stop), :);
C= cov(X);

figure(1); clf;
subplot(1,2,1);
imagesc(C);
colorbar;
idx_z= find(ismember(cnt.clab, {'Fpz','Fz','FCz','Cz','CPz','Pz','POz','Oz'}));
set(gca, 'YTick',idx_z, 'YTickLabel',cnt.clab(idx_z));
%% -> most energy in the frontal channels (eye movements?)
subplot(1,2,2);
[V,D]= eig(C);
plot(diag(D), '-o');
%% -> two components explain most of the variance

figure(2); clf;
[V,D]= eig(C);
subplot(1,2,1);
scalpmap(mnt, V(:,end));
%% -> global pattern, origin unclear
subplot(1,2,2);
scalpmap(mnt, V(:,end-1));
%% -> pattern of vertical eye movements and/or blinks


%%
%% sheet 08 - exercise 2
%%

figure(1); 
cz= strmatch('Cz', cnt.clab);
oz= strmatch('Oz', cnt.clab);
plot(X(:,oz), X(:,fz), '.')
xlabel('Oz  [uV]');
ylabel('Fz  [uV]');

C= cov(X(:,[oz cz]));
[V,D]= eig(C);
len= sqrt(diag(D));
center= mean(X(:,[oz cz]))';
L= [center-len(1)*V(:,1) center+len(1)*V(:,1)];
line(L(1,:), L(2,:), 'Color','k', 'LineWidth',2);
L= [center-len(2)*V(:,2) center+len(2)*V(:,2)];
line(L(1,:), L(2,:), 'Color','k', 'LineWidth',2);
axis equal


%%
%% sheet 08 - exercise 3
%%

band= [8 12];
[b,a]= butter(5, band/cnt.fs*2);
Xf= filter(b, a, X);

figure(1);
subplot(2,1,1);
plot([X(:,oz) Xf(:,oz)]);
subplot(2,1,2);
plot([X(:,cz) Xf(:,cz)]);

C= cov(Xf);
figure(1);
subplot(1,2,1);
imagesc(C);
colorbar;
set(gca, 'YTick',idx_z, 'YTickLabel',cnt.clab(idx_z));
%% -> now most energy is in the occipital region: strong visual alpha rhythm
subplot(1,2,2);
[V,D]= eig(C);
plot(diag(D), '-o');
%% -> 3 strong components

figure(2);
subplot(1,3,1);
scalpmap(mnt, V(:,end));
%% monopolar pattern in the occipital area (visual cortex)
subplot(1,3,2);
scalpmap(mnt, V(:,end-1));
%% bipolar pattern in the occipital area
subplot(1,3,3);
scalpmap(mnt, V(:,end-2));
%% bipolar pattern with focus in centro-parietal area and other in occipital


%%
%% sheet 08 - exercise 4
%%

figure(1); clf;
%% Note that pinv(V(:,[end-2:end])') = V(:,[end-2:end]) !
P= V(:,[end-2:end])*V(:,[end-2:end])';
%% this works also:
%P= V(:,end)*V(:,end)' + V(:,end-1)*V(:,end-1)' + V(:,end-2)*V(:,end-2)';
Xf2= Xf * P;
plot([Xf(1:600,oz) Xf2(1:600,oz)]);

figure(2); clf;
mse= mean((Xf-Xf2).^2, 1);
plot(mse);
set(gca, 'XTick',idx_z, 'XTickLabel',cnt.clab(idx_z));
