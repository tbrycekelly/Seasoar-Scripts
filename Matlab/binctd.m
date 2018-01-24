function [sbin,pbin,nbin] = binctd(s,p,n,pmin,pstep,pmax)
% bins ctd data s given pressure, p, and the number of seconds to bin over, n, 
% and pbin, i.e. [pmin:pstep:pmax].
% Returned are sbin s binned, pbin, and nbin number of data in each bin.

% INPUT
% s - 1 hz ctd data,e.g. temp
% p - pressure, corresponding to s
% n - bin size in seconds. 
% pmin,pstep,pmax - bin pressure min, stepsize and max

% OUTPUT
% 

% Call function using, e.g.:
%   [sbin,pbin,nbin] = binctd(data.t1, data.p ,100, 50, 5, 350);

% Quick plot of the data
%   pcolor(sbin); set(gca,'YDir','reverse');

warning off MATLAB:divideByZero

pbin=[pmin:pstep:pmax]';
np=length(pbin);
nt=floor(length(s)/n);
sbin=nan*ones(np,nt);
nbin=zeros(np,nt);

pst2=pstep/2;

for nn = 1 : nt
   ii=1+(nn-1)*n:nn*n;
   for ibin=1:np
      jj=(((abs(p(ii)-pbin(ibin)) < pst2) | (p(ii) == pbin(ibin)-pst2)));
      sbin(ibin,nn)=nanmean(s(ii(jj)));
      nbin(ibin,nn)=sum(isfinite(s(ii(jj))));
   end
end
