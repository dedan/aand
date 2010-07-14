%%
%% sheet 09 - exercise 1
%%

load([DATA_DIR 'teaching/erp_hexVPsag.mat']);

ref_ival= [-100 0];
ival= [120 140; 200 220; 230 260; 260 290; 300 320; 330 370; 380 430; 460 490];

epo_ref= makeepochs(cnt, mrk, ref_ival);
topo_ref= mean( mean(epo_ref.x, 1), 3);
nClasses= size(mrk.y, 1);
nIvals= size(ival, 1);
topo= zeros([size(cnt.x,2) nIvals nClasses]);
h_ax= zeros(nIvals, nClasses);
for cc= 1:nClasses,
  idx_cl= find(mrk.y(cc,:));
  for ii= 1:nIvals,
    epo= makeepochs(cnt, mrk, ival(ii,:));
    topo(:,ii,cc)= (mean( mean(epo.x(:,:,idx_cl), 3), 1) - topo_ref)';
    h_ax(ii,cc)= subplot(nClasses, nIvals, (cc-1)*nIvals + ii);
    scalpmap(mnt, topo(:,ii,cc));
    title(sprintf('%s\n[%d %d]', epo.className{cc}, ival(ii,:)));
  end
end
set(h_ax, 'CLim', [-1 1]*max(abs(topo(:))));


%%
%% sheet 09 - exercise 2
%%

disp_ival= [-100 600];
epo= makeepochs(cnt, mrk, disp_ival);
rsq= signed_r_square(epo);
subplot(2,1,1);
imagesc(rsq.t, 1:length(rsq.clab), rsq.x');
idx_z= find(ismember(rsq.clab, {'Fpz','Fz','FCz','Cz','CPz','Pz','POz','Oz'}));
set(gca, 'YTick',idx_z, 'YTickLabel',cnt.clab(idx_z));
title(rsq.className{1});
xlabel('[ms]');

h_ax= zeros(nIvals, 1);
for ii= 1:nIvals,
  h_ax(ii)= subplot(2, nIvals, nIvals+ii);
  iv= 1 + round((ival(ii,:)-rsq.t(1))/1000*rsq.fs);
  scalpmap(mnt, mean(rsq.x(iv(1):iv(2),:),1));
  title(sprintf('[%d %d]', rsq.t(iv)));
end
%set(h_ax, 'CLim', [-1 1]*max(abs(rsq.x(:))));
%% map 1 shows a frontal negative component (~ N1)
%% maps 2, 3 and 4 show a left lateralized negative component in visual area
%%   (~ visual N1)
%% maps 3 and 4 show a fronto central positive component (~ P2)
%% map 5 shows a broader occipital negative component (~ N2)
%% map 6 shows a fronto central positive component (~ P3a)
%% maps 7 and 8 show a centro-parietal positive component (~ P3b)


%%
%% sheet 09 - exercise 3
%%

dd= logspace(1, 3, 200);
x= randn(100,200) * diag(dd);
Cemp= cov(x);
[Ve,De]= eig(Cemp);
plot([dd.^2', diag(De)]);
legend('true','empirical');
