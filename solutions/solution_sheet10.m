load([DATA_DIR 'teaching/imagVPaw.mat']);


%%
%% sheet 10 - exercise 1
%%

c4= strmatch('C4', cnt.clab);
clab= {'C2','C6','FC4','CP4'};
c4neigh= [];
for cc= 1:length(clab);
  c4neigh= [c4neigh strmatch(clab{cc}, cnt.clab)];
end
cntC4lap= cnt;
cntC4lap.x= cnt.x(:,c4) - cnt.x(:,c4neigh)*0.25*ones(4,1);
cntC4lap.clab= {'C4 lap'};
% motor imagery is performed until 4s after cue presentation;
% the latency of ERD is on average 750ms.
epo= makeepochs(cntC4lap, mrk, [750 4000]);

clf;
cl1= find(epo.y(1,:));
cl2= find(epo.y(2,:));
X1= squeeze(epo.x(:,1,cl1));
X2= squeeze(epo.x(:,1,cl2));
h= spectrum.welch;
psd(h, X1(:), 'fs', cnt.fs);
X2psd= psd(h, X2(:), 'fs', cnt.fs);
hold on;
plot(X2psd.Frequencies, 10*log10(X2psd.Data), 'r');
hold off;
band= [9 13];


%%
%% sheet 10 - exercise 2
%%

[b,a]= butter(5, band/cnt.fs*2);
cnt_flt= cnt;
cnt_flt.x= filter(b, a, cnt.x);
epo= makeepochs(cnt_flt, mrk, [750 4000]);
[W, D]= trainCSP(epo);
W_csp= W(:,[1:3 end-2:end]);
Dd= diag(D);
D_csp= Dd([1:3 end-2:end]);

for c= 1:2,
  for k= 1:3,
    ki= k+(c-1)*3;
    subplot(2, 3, ki);
    scalpmap(mnt, W_csp(:,ki));
    title(sprintf('ev= %.2f', D_csp(ki)));
  end
end

cnt_csp= cnt;
cnt_csp.x= cnt_flt.x * W_csp;
cnt_csp.clab= strcat('CSP', cellstr(int2str([1:6]')));


%%
%% sheet 10 - exercise 3
%%

epo= makeepochs(cnt_csp, mrk, [1000 4500]);
fv= epo;
fv.x= squeeze(log(var(epo.x, 0, 1)));
clf;
cl1= find(epo.y(1,:));
cl2= find(epo.y(2,:));
plot(fv.x(1,cl1), fv.x(end,cl1), 'b.');
hold on;
plot(fv.x(1,cl2), fv.x(end,cl2), 'r.');

[w, b]= trainFD(fv.x([1 end],:), fv.y);
yl= (-w(1)*xlim-b)/w(2);
plot(xlim, yl, 'k');
hold off;
