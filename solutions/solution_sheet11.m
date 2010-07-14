%%
%% sheet 11 - exercise 1
%%

load([DATA_DIR 'teaching/erp_hexVPsag.mat']);

ref_ival= [-100 0];
ival= [120 140; 200 220; 230 260; 260 290; 300 320; 330 370; 380 430; 460 490];
nIvals= size(ival, 1);


%%
%% sheet 11 - exercise 1
%%

% see file trainFDshrink.m


%%
%% sheet 11 - exercise 2
%%

nTrials= size(mrk.y, 2);
idx_train= 1:floor(nTrials/2);
idx_test= floor(nTrials/2)+1:nTrials;
cl1= find(mrk.y(1,idx_test));
cl2= find(mrk.y(2,idx_test));
N1= length(cl1);
N2= length(cl2);

epo_ref= makeepochs(cnt, mrk, ref_ival);
baseline= squeeze(mean(epo_ref.x, 1));

X= cell(1, nIvals);
for ii= 1:nIvals,
  fv= makeepochs(cnt, mrk, ival(ii,:));
  X{ii}= squeeze(mean(fv.x, 1)) - baseline;
  [w, b]= trainFD(X{ii}(:,idx_train), fv.y(:,idx_train));
  out= sign(w'*X{ii}(:,idx_test)+b);
  miss= out~=[1 -1]*fv.y(:,idx_test);
  loss= mean([N1 N2]) * [miss(cl1)/N1 miss(cl2)/N2];
  fprintf('error on [%d %d]: %.1f%%\n', ival(ii,:), 100*mean(loss));
end

XX= cat(1, X{:});
[w, b]= trainFD(XX(:,idx_train), fv.y(:,idx_train));
out= sign(w'*XX(:,idx_test)+b);
miss= out~=[1 -1]*fv.y(:,idx_test);
loss= mean([N1 N2]) * [miss(cl1)/N1 miss(cl2)/N2];
fprintf('error on all with FD: %.1f%%\n', 100*mean(loss));

[w, b]= trainFDshrink(XX(:,idx_train), fv.y(:,idx_train));
out= sign(w'*XX(:,idx_test)+b);
miss= out~=[1 -1]*fv.y(:,idx_test);
loss= mean([N1 N2]) * [miss(cl1)/N1 miss(cl2)/N2];
fprintf('error on all with FDshrink: %.1f%%\n', 100*mean(loss));
