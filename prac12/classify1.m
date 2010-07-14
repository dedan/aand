% Exercise Sheet 12 of AAND_2010
% Solution of Stephan Gabler (329131)

function [ w, b, mu_res, S_res] = classify1(S, mu, feature, mu_diff, UC)

mu_res  = (1-UC)*mu + UC*feature;
S_res   = (1-UC)*S  + UC*(feature-mu_res)*(feature-mu_res)';

% fisher discriminant and bias
w = pinv(S_res)*(mu_diff);
b = -w'*(mu_res);

end