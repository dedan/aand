% Exercise Sheet 12 of AAND_2010
% Solution of Stephan Gabler (329131)

function [w, b, vars]= trainFDpool(X, y)

vars    = struct;
vars.m1 = mean(X(:,logical(y(1,:))),2);
vars.m2 = mean(X(:,logical(y(2,:))),2);
vars.m3 = mean(X,2);
vars.S3 = cov(X');

w = pinv(vars.S3)*(vars.m1-vars.m2);
b = -w'*vars.m3;
