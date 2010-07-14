function [W, D]= trainCSP(epo)

cl1= find(epo.y(1,:));
cl2= find(epo.y(2,:));
[T, C, nTrials]= size(epo.x);
nTrials1= length(cl1);
nTrials2= length(cl2);
X= reshape(permute(epo.x(:,:,cl1), [1 3 2]), [T*nTrials1 C]);
S= cov(X(:,:));
X= reshape(permute(epo.x(:,:,cl2), [1 3 2]), [T*nTrials2 C]);
S(:,:,2)= cov(X(:,:));
[W,D]= eig(S(:,:,1), sum(S,3));
