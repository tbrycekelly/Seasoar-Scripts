function pres = freq2pres(freq,ptcb,pcal)
%function pres = freq2pres(freq,ptcb,pcal) calculates pressure given
%frequency pressure temperature compensation bytes ptcb
%(data.ctdscans(:,28:29)) and pressure calibration structure pcal.

%D. Rudnick 01/06/05

psi2dbar = 0.689476;

tcw = double(ptcb(:,1))*16 + double(ptcb(:,2)/16);

Td = pcal.AD590(1) .* tcw + pcal.AD590(2);

c = pcal.c(1) + Td .* (pcal.c(2) + Td .* pcal.c(3));
d = pcal.d(1) + Td .* pcal.d(2);
t0 = pcal.t(1) + Td .* (pcal.t(2) + Td .* (pcal.t(3) + Td .* (pcal.t(4) + Td .* pcal.t(5))));
t0f = 1e-6 .* t0 .* freq;
fact = 1 - (t0f .* t0f);
pres = psi2dbar .* c .* fact .* (1 - d .* fact);
pres = pcal.linear(1)*pres + pcal.linear(2);
