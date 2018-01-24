function data = ctdread(pathstr,prefix,suffix,cfg)
%function data = ctdread(pathstr,prefix,suffix,cfg) opens and reads the
%SeaSoar file defined by directory path pathstr, prefix prefix, and a hex
%suffix.  The total path is then pathstr/prefix.suffix
%CTD variables are returned with calibrations applied.
%Data is returned in a self-explanatory structure.

%D. Rudnick 01/07/05
%added a graceful return if file not found
%rawfileread requires cfg to be passed 03/21/05
%added oxygen 07/30/06
%took out oxygen, good for HOT cruise 12/07

d=rawfileread(pathstr,prefix,suffix,cfg);
if ~isstruct(d)
   data=d;
   return
end
data=parsectd(d,cfg);

data.s1=sw_salt(10*data.c1/sw_c3515,data.t1,data.p);
data.s2=sw_salt(10*data.c2/sw_c3515,data.t2,data.p);

data.theta1=sw_ptmp(data.s1,data.t1,data.p,0);
data.theta2=sw_ptmp(data.s2,data.t2,data.p,0);

data.sigma1=sw_pden(data.s1,data.t1,data.p,0);
data.sigma2=sw_pden(data.s2,data.t2,data.p,0);
