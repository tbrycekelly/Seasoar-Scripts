function data = parsectd(d,cfg)
%function data = parsectd(d,cfg) parses the raw data structure d (from
%rawfileread), calibrates using the configuration structure cfg (from
%cfgload), and returns the usual ctd data in a structure.
%temperature is IPTS90.
%pressure is nominally corrected to be relative to the surface.
%time is unix time.

%D. Rudnick 01/07/05
%Added modcount 01/09/05
%Temperature in IPTS90 throughout to go with Seawater Toolbox 3.0. 02/14/05
%add oxygen 07/30/06
%Took out oxygen, good for HOT cruise 12/07

p_atm=10.1353;
pctime2unixtime=2082844800;

data.filename=d.filename;
data.lat=d.lat;
data.lon=d.lon;
data.bottomdepth=d.bottomdepth;

day0=floor(d.systime(1)/86400)*86400;
data.time=d.gpstime+day0;
%fix for gps day rollover.  fix good for files less than a day in length.
ii=find(diff(data.time) < -80000);
if ~isempty(ii)
   data.time(ii+1:end)=data.time(ii+1:end)+86400;
end

data.t1=freq2temp(word2freq(d.ctdscans(:,1:3)),cfg.t1cal);
data.t2=freq2temp(word2freq(d.ctdscans(:,10:12)),cfg.t2cal);

data.p=freq2pres(word2freq(d.ctdscans(:,7:9)),d.ctdscans(:,28:29),cfg.pcal)-p_atm;

data.c1=freq2cond(word2freq(d.ctdscans(:,4:6)),data.t1,data.p,cfg.c1cal);
data.c2=freq2cond(word2freq(d.ctdscans(:,13:15)),data.t1,data.p,cfg.c2cal);

[data.fl,dum]=word2volt(d.ctdscans(:,22:24));
[data.trans,dum]=word2volt(d.ctdscans(:,25:27));

data.modcount=d.ctdscans(:,30);
