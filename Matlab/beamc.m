function c=beamc(tr)
%function c=beamc(tr) calculates beam c as a function of transmissometer
%voltage.
%

vd=0.061;
vdcurrent=0.055;
% vdcurrent=0.054; %value from NPAL
% vdcurrent=0.056; %value from HOME02
vair=4.882;
% vaircurrent=4.409; %value from HOT maybe not so hot
vaircurrent=4.825; %value from NPAL but use it for HOT until we get a better calibration
% vaircurrent=4.752; %value from HOME02
vref=4.761;
vr=(vref-vd)*(vaircurrent-vdcurrent)/(vair-vd);
c=-4*log((tr-vdcurrent)/vr);