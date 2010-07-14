% Exercise Sheet 12 of AAND_2010
% Solution of Stephan Gabler (329131)

function [ w, b, S_ext_res] = classify2(S_ext, feature, mu_diff, UC)


S_ext_res   = (1-UC)*S_ext + UC*[1;feature]*[1;feature]';

% fisher discriminant and bias
w = pinv(S_ext_res(2:end,2:end) - S_ext_res(2:end,1) * S_ext_res(1,2:end)) *(mu_diff);
b = -w'*(S_ext_res(2:end,1));

end