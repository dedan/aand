function rsq= signed_r_square(fv)

sz= size(fv.x);
x= reshape(fv.x, [prod(sz(1:end-1)), sz(end)]);

i1= find(fv.y(1,:));
i2= find(fv.y(2,:));
N1= length(i1);
N2= length(i2);

r= (mean(x(:,i1),2) - mean(x(:,i2),2) ) ./ std(x, 0, 2);
r= sqrt(N1*N2)/(N1+N2) * sign(r) .* r.^2;

rsq= rmfield(fv, 'y');
rsq.x= reshape(r, sz(1:end-1));
rsq.className= {sprintf('sgn r^2(%s,%s)', fv.className{:})};
