function epo= makeepochs(cnt, mrk, ival)

idc= floor(ival(1)*cnt.fs/1000):ceil(ival(2)*cnt.fs/1000);
T= length(idc);
nEvents= size(mrk.y, 2);
nChans= length(cnt.clab);

IV= idc(:)*ones(1,nEvents) + ones(T,1)*mrk.pos;
epo.x= reshape(cnt.x(IV, :), [T, nEvents, nChans]);
epo.x= permute(epo.x, [1 3 2]);
epo.fs= cnt.fs;
epo.clab= cnt.clab;
epo.y= mrk.y;
epo.className= mrk.className;
epo.t= linspace(ival(1), ival(2), length(idc));
