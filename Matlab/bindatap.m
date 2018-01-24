function sections = bindatap(data,p0,pmin,pstep,pmax)
% Make a structure 'sections' from profiles of 1-second ctd data
% p0 is the pressure to define cycles
% this one bins according to depth

% INPUT
% data - 1 hz ctd data structure with t1, t2, s1,s2, ...
% po - pressure value that designates the start of a profile 
% pmin,pstep,pmax - bin pressure min, stepsize and max. 

% OUTPUT
% section - profiles of data binned according to [pmin:pstep:pmax]


% binprof

[sections.t1,sections.depth] = binprof(data.t1,data.depth,p0,pmin,pstep,pmax);
sections.t2 = binprof(data.t2,data.depth,p0,pmin,pstep,pmax);
sections.s1 = binprof(data.s1,data.depth,p0,pmin,pstep,pmax);
sections.s2 = binprof(data.s2,data.depth,p0,pmin,pstep,pmax);
sections.theta1 = binprof(data.theta1,data.depth,p0,pmin,pstep,pmax);
sections.theta2 = binprof(data.theta2,data.depth,p0,pmin,pstep,pmax);
sections.sigma1 = binprof(data.sigma1,data.depth,p0,pmin,pstep,pmax)-1000;
sections.sigma2 = binprof(data.sigma2,data.depth,p0,pmin,pstep,pmax)-1000;
sections.soundspeed1 = binprof(data.soundspeed1,data.depth,p0,pmin,pstep,pmax);
sections.soundspeed2 = binprof(data.soundspeed2,data.depth,p0,pmin,pstep,pmax);
sections.fl = binprof(data.fl,data.depth,p0,pmin,pstep,pmax)*3; %3 is the magic number to calibrate
sections.bc = binprof(beamc(data.trans),data.depth,p0,pmin,pstep,pmax);

ii=find(data.lat == -99);
data.time(ii) = nan;
data.lat(ii) = nan;
data.lon(ii) = nan;

sections.time = binprof(data.time,data.depth,p0);
sections.lat = binprof(data.lat,data.depth,p0);
sections.lon = binprof(data.lon,data.depth,p0);

sections.dist = sw_dist(sections.lat,sections.lon, 'km');
sections.dist = vertcat(0, cumsum(sections.dist));
