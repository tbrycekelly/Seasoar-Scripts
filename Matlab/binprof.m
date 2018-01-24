function [sbin,pbin,nbin]=binprof(s,p,p0,pmin,pstep,pmax)
% binprof - bins data 's' into profiles made up of full cycles 
% (i.e. one down and one up seasoar trace)
% Make binned profiles from 1-second ctd data and pressure bins defined by
% [pmin:pstep:pmax]

% INPUT
% s - 1 hz ctd data,e.g. temp
% p - pressure, corresponding to s
% po - pressure value that designates the start of a profile 
% pmin,pstep,pmax - bin pressure min, stepsize and max. If pmin, pstep, and 
%   pmax are not given, s is assumed to be one-dimensional.


% OUTPUT
% sbin - profiles of s binned according to [pmin:pstep:pmax]
% pbin - pressure bins used
% nbin - number of samples per bin

% Call function using, e.g.:
%   [sbin,pbin,nbin]=binprof(data.t1, data.p, 100, 10, 10, 350);

% Quick plot of the data
%   pcolor(sbin); set(gca,'YDir','reverse');


prel=p-p0;
ii=find(prel(1:end-1).*prel(2:end) < 0);
istart=ii(1:2:end-2)+1;
iend=ii(3:2:end);
nt=length(istart);

if nargin > 3
    pst2=pstep/2;
    pbin=[pmin:pstep:pmax]';
    np=length(pbin);
    sbin=nan(np,nt);
    nbin=zeros(np,nt);
    for n=1:nt
        ii=istart(n):iend(n);
        for ibin=1:np
            jj=(((abs(p(ii)-pbin(ibin)) < pst2) | (p(ii) == pbin(ibin)-pst2)));
            sbin(ibin,n)=nanmean(s(ii(jj)));
            nbin(ibin,n)=sum(isfinite(s(ii(jj))));
        end
    end
else
    sbin=nan(nt,1);
    nbin=zeros(nt,1);
    pbin=0;
    for n=1:nt
        ii=istart(n):iend(n);
        sbin(n)=nanmean(s(ii));
        nbin(n)=sum(isfinite(s(ii)));
    end
end
