function c = crosscorr(t1,N_bins)
    M1 = length(t1);
    D = ones(M1,1)*t1 - t1'*ones(1,M1);
    D = D(:);
    c = hist(D,N_bins);
    c(c==max(c)) = 0;
end
