function scalpmap(mnt, w, opt)

xx= linspace(min(mnt.x), max(mnt.x), 50);
yy= linspace(min(mnt.y), max(mnt.y), 50)';
[xg,yg,zg]= griddata(mnt.x, mnt.y, w, xx, yy, 'linear');
pcolor(xg, yg, zg);
shading interp
axis equal off

mm= max(abs(w));
set(gca, 'CLim',[-mm mm]);
colorbar;
