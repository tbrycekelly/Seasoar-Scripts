function [h1,h2] = PlotVertSection(sections, var1str, var2str, nn, cont1, cont2)

% creates a plot given the structure sections, the variable strings var1str,
% var2str, the vector of indices to plot nn, and contour vectors cont1 and
% cont2.  var1 is ploted with a color contour, var2 is plotted with black
% contours.

% INPUT
% sections - ctd data structure generated with bindatap.m containing t1 ...
% var1str - variable name in sections to be plotted in pcolor
% var2str - name of variable to be plotted in black contour lines
% nn - profile indices to be plotted, e.g.  [1:30]
% cont1 - values of contour levels to be plotted, e.g. [.01 .025 .05 ...
% cont2 - values of contour levels to be plotted, e.g. [24 24.5 25 ...

% OUTPUT
% h1 - see contourf.m
% h2 - see coutour.m

% Call function using, e.g.:
%   fluorescence and sigma
%   [h1,h2] = psection(sections, 'fl', 'sigma1', [1:30], [.01 .025 .05 .1 .25 .5], [24 24.2 24.6 24.8 25 25.2 25.4 25.6 25.8 26]);
%   temperature and sigma
%   [h1,h2] = psection(sections, 't1', 'fl', [1:30], [11 13 15 17 19 21 23 25], [24 24.5 25 25.5 26]);

nn=nn(isfinite(sections.lat(nn)));

h1=contourf(sections.lat(nn),sections.depth,sections.(var1str)(:,nn),cont1);
hold on;
h2=contour(sections.lat(nn),sections.depth,sections.(var2str)(:,nn),cont2,'k');
plot(sections.lat(nn),zeros(size(sections.lat(nn))),'k+','clipping','off');
hold off;

set(gca,'ydir','rev','ylim',[0 420],'clim',[cont1(1) cont1(end)]);
shading flat;
xlabel('Latitude (\circN)');
ylabel('Depth (m)');
extlab=var1str;
if strcmp(var1str,'s1')
   extlab='Salinity (psu)';
elseif strcmp(var1str,'fl')
   extlab='Chlorophyll (mg/m^3)';
elseif strcmp(var1str,'sigma1')
   extlab='Potential Density (kg/m^3)';
elseif strcmp(var1str,'bc')
   extlab='Beam c (m^{-1})';
elseif strcmp(var1str,'soundspeed1')
   extlab='Sound Speed (m/s)';
elseif strcmp(var1str,'theta1')
   extlab='Potential Temperature (\circC)';
end

colorbar;

if strcmp(var1str,'sigma'), colormap(flipud(jet)); end

TimeStart = datestr(datenum(sections.time(nn(1))/86400) + datenum(1970,1,1));
TimeEnd =datestr( datenum(sections.time(nn(end))/86400) + datenum(1970,1,1));
title([extlab ': ' TimeStart ' - ' TimeEnd]);
   