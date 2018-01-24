function sections=bindata2(data,n,pmin,pstep,pmax)
% Make sections from 1-second ctd data
% n is the number of seconds per bin
% this one bins according to depth

% FUNCTION CALLED:
% binctd

[sections.t1,sections.depth] = binctd(data.t1,data.depth,n,pmin,pstep,pmax);
sections.t2 = binctd(data.t2,data.depth,n,pmin,pstep,pmax);
sections.s1 = binctd(data.s1,data.depth,n,pmin,pstep,pmax);
sections.s2 = binctd(data.s2,data.depth,n,pmin,pstep,pmax);
sections.theta1 = binctd(data.theta1,data.depth,n,pmin,pstep,pmax);
sections.theta2 = binctd(data.theta2,data.depth,n,pmin,pstep,pmax);
sections.sigma1 = binctd(data.sigma1,data.depth,n,pmin,pstep,pmax)-1000;
sections.sigma2 = binctd(data.sigma2,data.depth,n,pmin,pstep,pmax)-1000;
sections.soundspeed1 = binctd(data.soundspeed1,data.depth,n,pmin,pstep,pmax);
sections.soundspeed2 = binctd(data.soundspeed2,data.depth,n,pmin,pstep,pmax);
sections.fl = binctd(data.fl,data.depth,n,pmin,pstep,pmax)*3; %3 is the magic number to calibrate
sections.bc = binctd(beamc(data.trans),data.depth,n,pmin,pstep,pmax);

ii=find(data.lat == -99);
data.time(ii)=nan;
data.lat(ii)=nan;
data.lon(ii)=nan;

sections.time = nanblock(data.time,n);
sections.lat = nanblock(data.lat,n);
sections.lon = nanblock(data.lon,n);

sections.dist=gcdist(sections.lat,sections.lon)/1000;
sections.dist=[0 cumsum(sections.dist)]';
