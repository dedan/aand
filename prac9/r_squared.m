function r = r_squared(x1, x2)
    r = (sqrt(length(x1)*length(x2))/(length(x1) + length(x2)) *(mean(x1)-mean(x2))/std(cat(1,x1,x2)));
    r1 = r^2;
    r = r1*sign(r);
end
    