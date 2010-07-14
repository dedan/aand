function [w, b]= trainFD(X, y)

i1= find(y(1,:));
i2= find(y(2,:));
m1= mean(X(:,i1),2);
m2= mean(X(:,i2),2);
xn= (X(:,i1)-repmat(m1,[1 length(i1)]));
S1= xn*xn';
xn= (X(:,i2)-repmat(m2,[1 length(i2)]));
S2= xn*xn';

w= pinv(S1+S2)*(m1-m2);
b= -w'*(m1+m2)/2;
