function SS = SalSpikeN (data, NoSections, Skip, NoLags)
% determine that lag between Temp and Cond that maximizes the correlation
% between the two measurements. Lags are measured as sampling intervals.
% R. Goericke SIO, June 2011

% Outline:  Using 24 hz seasoar temp and cond data, determine the lag which
% maximises the correlation between the two measurements for short sections
% of the data, i.e. sections about 200 to 1000 samples long.  Do this for a
% number of sections (NoSections) at intervals corresponding to the value
% Skip.  Look at possible Lags given by the number NoLags.

% Input: 
% data - 24 hz Seasoar data structure with .t1, .c1, .p

CorrSectionLength = 500;

SS.Depth(1:NoSections) = NaN;
SS.Num(1:NoSections) = NaN;
SS.Lag(1:NoSections) = NaN;


% for each section determine the lag that maximizes the correlation. This
% is done by using xcorr.m to calculate the correlation between the cond
% section.
for N = 1:NoSections
    % get the start(S) and end (E) index for the section.  
    S = N * Skip;
    E = S + CorrSectionLength;
    
    % get the data and difference them (add 1 to the calculated lags)
    CondData = diff(data.c1(S:E));
    TempData = diff(data.t1(S:E));
    
    % do the correlation analysis and determine the index of the maximum
    % value which corresponds to the lag
    [CorrArr, Lags] = xcorr(TempData, CondData, NoLags,'coeff');
    Index = round(mean(find(CorrArr == max(CorrArr))));
    Lags(Index)
    SS.Lag(N) = 1+Lags(Index);
    
    % record the depth and number of the section analyzed
    SS.Depth(N) = round(mean(data.p(S:E)));
    SS.Num(N) = S;
    
    % plot the data
    hold on;
    %plot(zscore(TempData), 'b-')
    %plot(zscore(CondData), 'r-')
    hold off;
	%pause
	clf
end

% get a smoothed timeseries of lags
SS.SmLag = smooth(SS.Lag, .1, 'rloess');


end


