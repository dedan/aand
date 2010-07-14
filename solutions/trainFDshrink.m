function [w, b]= trainFDshrink(X, y)

i1= find(y(1,:));
i2= find(y(2,:));
m1= mean(X(:,i1),2);
m2= mean(X(:,i2),2);
S1= cov_shrink(X(:,i1))*(length(i1)-1);
S2= cov_shrink(X(:,i2))*(length(i2)-1);

w= pinv(S1+S2)*(m1-m2);
b= -w'*(m1+m2)/2;



function S= cov_shrink(X);

Xn= (X - repmat(mean(X,2), [1 size(X,2)]))';

[n, d]= size(Xn);
Cemp= (Xn'*Xn) / (n-1);

SumVarCij= 0;
for ii= 1:d,
  for jj= 1:d,
    VarCij= var(Xn(:,ii).*Xn(:,jj));
    SumVarCij= SumVarCij + VarCij;
  end
end

nu= mean(diag(Cemp));
gamma= n/(n-1)^2 * SumVarCij / sum(sum((Cemp-nu*eye(d,d)).^2));
S= gamma*nu*eye(d,d) + (1-gamma)*Cemp;
