load([DATA_DIR 'teaching/oddballVPei']);

% Ex 7.1
epo= makeepochs(cnt, mrk, [-100 900]);
ci= strmatch('FCz', cnt.clab);
X= squeeze(epo.x(:,ci,:));
i1= find(epo.y(1,:));
i2= find(epo.y(2,:));
erp= [mean(X(:,i1),2), mean(X(:,i2),2)];
plot(epo.t, erp);
legend(epo.className);
xlabel('time [ms]');
ylabel('potential [uV]');

X= squeeze(epo.x(:,ci,i1));
erp= mean(X,2);
K= size(X,2);
for k= 1:K,
  avg= mean(X(:,1:k),2);
  amp(k)= std(avg - erp);
end
plot([amp' amp(1)./sqrt(1:K)']);
legend('empirical','theory');
xlabel('number of trials in average [#]');
ylabel('standard deviation');


% Ex 7.2
%see trainFD.m

% Ex 7.3
epo= makeepochs(cnt, mrk, [300 370]);
X= squeeze(mean(epo.x,1));
[w,b]= trainFD(X, epo.y);
scalpmap(mnt, w);

y= w'*X+b;
plot(i1, y(i1), 'r.');
hold on;
plot(i2, y(i2), 'b.');
hold off;
legend(epo.className);
xlabel('number of trial');
ylabel('projection on FD');
