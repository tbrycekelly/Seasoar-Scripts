function [Index, salinity, density] = densindex (pressure, sal1, sal2, den1, den2)
% densityspikecorr - take seasoar density data and exclude noise spikes 
% from the data.
% R. Goericke, SIO; 2011-05

% this script is not well documented as of now

% FUNCTION IS CALLED BY:
%   none

% FUNCTIONS CALLED
%   consolidator.m - from matlab file exchange in folder 0-Assorted

% Call function using e.g.:
%   density = densindex (data.p, data.sigma1, data.sigma2);


% Initialize some variables
maxpres = round(max(pressure));
meanden = zeros(maxpres, 2);
stdden = zeros(maxpres, 2);

% Determine for each depth interval the mean and std of density 1 and 2
for N = 1 : 1 : maxpres
    K = ( (pressure >= N - 0.5) & (pressure <= N + 0.5) );
    meanden(N,1) = nanmean(den1(K));
    meanden(N,2) = nanmean(den2(K));
    stdden(N,1) = nanstd(den1(K));
    stdden(N,2) = nanstd(den2(K));
end

% Calculate the difference between the two densities and display the
% results
SalDiffV = meanden(:,1) - meanden(:,2);
SalDiff = nanmean(SalDiffV(50:end));
display(['The average difference between Den1 and Den2 is: ', num2str(SalDiff)]);

if SalDiff > 0.1
    display('WARNING - The average Sal difference is high!');
end

% Generate two arrays of length(data.i) with values of meanden and stdden
% corresponding to elements in data.pressure.
intpres = round(pressure);
meandenV = zeros(length(pressure),1);
stdden1V = zeros(length(pressure),1);

for N = 1 : length(pressure)
    meandenV(N) = meanden(intpres(N),1);
    stdden1V(N) = stdden(intpres(N),1);
end
display('calculated meandenV and stddenV');


density (1:(length(pressure)),1) = NaN;
salinity (1:(length(pressure)),1) = NaN;

den2stdI(:,1) = ((den1 - meandenV) ./ stdden1V) < 2;
den2stdI(:,2) = ((den2 - meandenV) ./ stdden1V) < 2;

den3stdI(:,1) = ((den1 - meandenV) ./ stdden1V) < 3;
den3stdI(:,2) = ((den2 - meandenV) ./ stdden1V) < 3;

Index1 = den2stdI(:,1);
%density(Index1) = den1(Index1);

Index2 = ~den2stdI(:,1) & den2stdI(:,2);
%density(Index2) = den2(Index2);

Index3 = ~(Index1 | Index2) & den3stdI(:,1);
%density(Index3) = den1(Index3);

Index4 = ~(Index1 | Index2 | Index3) & den3stdI(:,2);
%density(Index4) = den1(Index4);

% generate an index giving the 'good' records for density to be used for
% other calculations
Index(:,1) = Index1 | Index3;
Index(:,2) = Index2 | Index4;

% fill in 'good' values for sal and density using the Index
density (Index(:,1)) = den1(Index(:,1));
density (Index(:,2)) = den2(Index(:,2));
salinity (Index(:,1)) = sal1(Index(:,1));
salinity (Index(:,2)) = sal2(Index(:,2));

misdataI = find(isnan(density));
for N = 1 : length(misdataI)
    I = misdataI(N);
    
    try
    pressureV = pressure(I-20:I+20);
    densityV = density(I-20:I+20);
    NaNI = find(~isnan(densityV));
    pressureV = pressureV(NaNI);
    densityV = densityV (NaNI);
 
    [~, SortI] = sort(pressureV);
    pressureV = pressureV(SortI);
    densityV = densityV (SortI);
    [pressureV, densityV] = consolidator(pressureV, densityV);
    density(I)= interp1(pressureV, densityV, pressure(I));
    
    catch
        density(I) = NaN;
        display(['interpolation failed for I = ' num2str(I)]);
    end
    

end  % function densindex



