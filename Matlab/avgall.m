function data = avgall(pathstr,prefix,suffix1,suffix2,cfg)
%function avgall calculates 1-second averages of ctd and engineering data
%from files defined by directory path pathstr, prefix prefix, between hex
%suffix1 and suffix2. Requires calibration structure cfg.

%D. Rudnick 03/23/05
%added oxygen 07/30/06
%took out oxygen 12/07/07

data.files = fullfile(pathstr, [prefix '.' suffix1 '-' suffix2]);
data.lat = [];
data.lon = [];
data.bottomdepth = [];
data.time = [];
data.t1 = [];
data.t2 = [];
data.p = [];
data.c1 = [];
data.c2 = [];
data.trans = [];
data.fl = [];
data.s1 = [];
data.s2 = [];
data.theta1 = [];
data.theta2 = [];
data.sigma1 = [];
data.sigma2 = [];
data.soundspeed1 = [];
data.soundspeed2 = [];
data.moogdrive = [];
data.moogmonitor = [];
data.cog = [];
data.sog = [];
data.heading = [];
data.sow = [];
data.tension = [];
data.wingpitch = [];
data.roll = [];
data.fishpitch = [];
data.proprpm = [];
mcold = [];

for n = hex2dec(suffix1):hex2dec(suffix2)
   d = allread(pathstr,prefix,dec2hex(n,3),cfg);
   if ~isstruct(d)
      data.files = fullfile(pathstr,[prefix '.' suffix1 '-' dec2hex(n-1, 3)]);
      break
   elseif ~isempty(d.lat)
      data.lat = [data.lat; d.lat];
      data.lon = [data.lon; d.lon];
      data.bottomdepth = [data.bottomdepth; d.bottomdepth];
      data.time = [data.time; d.time];
      data.cog = [data.cog; d.cog];
      data.sog = [data.sog; d.sog];
      data.heading = [data.heading; d.heading];
      data.sow = [data.sow; d.sow];
      data.moogdrive = [data.moogdrive; d.moogdrive];
      data.moogmonitor = [data.moogmonitor; d.moogmonitor];
      data.tension = [data.tension; d.tension];
      data.t1 = [data.t1; blocks(d.t1,24)];
      data.t2 = [data.t2; blocks(d.t2,24)];
      data.p = [data.p; blocks(d.p,24)];
      data.c1 = [data.c1; blocks(d.c1,24)];
      data.c2 = [data.c2; blocks(d.c2,24)];
      data.trans = [data.trans; blocks(d.trans,24)];
      data.fl = [data.fl; blocks(d.fl,24)];
      data.s1 = [data.s1; blocks(d.s1,24)];
      data.s2 = [data.s2; blocks(d.s2,24)];
      data.theta1 = [data.theta1; blocks(d.theta1,24)];
      data.theta2 = [data.theta2; blocks(d.theta2,24)];
      data.sigma1 = [data.sigma1; blocks(d.sigma1,24)];
      data.sigma2 = [data.sigma2; blocks(d.sigma2,24)];
      data.soundspeed1 = [data.soundspeed1; blocks(d.soundspeed1,24)];
      data.soundspeed2 = [data.soundspeed2; blocks(d.soundspeed2,24)];
      data.wingpitch = [data.wingpitch; blocks(d.wingpitch,24)];
      data.roll = [data.roll; blocks(d.roll,24)];
      data.fishpitch = [data.fishpitch; blocks(d.fishpitch,24)];
      data.proprpm = [data.proprpm; blocks(d.proprpm,24)];
      mc = [mcold; d.modcount];
      ii = find(~(diff(mc) == 1 | (mc(1:end-1) == 255 & mc(2:end) == 0)), 1);
      if ~isempty(ii)
         disp('Skipped modulo counts')
      end
      mcold = d.modcount(end);
   end
end
data.depth = sw_dpth(data.p, data.lat);
