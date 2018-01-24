function data = parseall(d,cfg)
%function data = parseall(d,cfg) parses the raw data structure d (from
%rawfileread), calibrates using the configuration structure cfg (from
%cfgload), and returns all ctd and engineering data in a structure.
%temperature is IPTS90.
%pressure is nominally corrected to be relative to the surface.
%time is unix time.

%D. Rudnick 03/21/05
%added oxygen 07/30/06
%took out oxygen, good for HOT cruise 12/07

p_atm=10.1353;

data.filename=d.filename;
data.lat=d.lat;
data.lon=d.lon;

day0=floor(d.systime(1)/86400)*86400;
data.time=d.gpstime+day0;
%fix for gps day rollover.  fix good for files less than a day in length.
ii=find(diff(data.time) < -80000);
if ~isempty(ii)
   data.time(ii+1:end)=data.time(ii+1:end)+86400;
end

data.cog=d.cog;
data.sog=d.sog;
data.heading=d.heading;
data.sow=d.sow;
data.bottomdepth=d.bottomdepth;
data.moogdrive=d.moogdrive;
data.moogmonitor=d.moogmonitor;
data.tension=d.tension;

data.t1=freq2temp(word2freq(d.ctdscans(:,1:3)),cfg.t1cal);
data.t2=freq2temp(word2freq(d.ctdscans(:,10:12)),cfg.t2cal);

data.p=freq2pres(word2freq(d.ctdscans(:,7:9)),d.ctdscans(:,28:29),cfg.pcal)-p_atm;

data.c1=freq2cond(word2freq(d.ctdscans(:,4:6)),data.t1,data.p,cfg.c1cal);
data.c2=freq2cond(word2freq(d.ctdscans(:,13:15)),data.t1,data.p,cfg.c2cal);

% use the lines below to look at all 6 voltage channels Seasoar has
[data.trans,data.v2]=word2volt(d.ctdscans(:,22:24));
[data.fl,data.v4]=word2volt(d.ctdscans(:,25:27));
[data.v5,data.v6]=word2volt(d.ctdscans(:,28:30));

% assign proper voltages to fl, trans, oxygen
% [data.fl,dum]=word2volt(d.ctdscans(:,22:24));
% [data.fl,data.trans]=word2volt(d.ctdscans(:,28:30));

[data.wingpitch,data.roll]=word2volt(d.ctdscans(:,16:18));
data.wingpitch=adlin(data.wingpitch,cfg.wingpitch);
data.roll=adlin(data.roll,cfg.roll);

[data.fishpitch,data.proprpm]=word2volt(d.ctdscans(:,19:21));
data.fishpitch=adlin(data.fishpitch,cfg.fishpitch);
data.proprpm=adlin(data.proprpm,cfg.proprpm);

data.modcount=d.ctdscans(:,30);

function y=adlin(x,c)
y=c(1)*(x+c(2));
