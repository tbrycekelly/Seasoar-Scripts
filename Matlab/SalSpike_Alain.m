CorrSectionLength = 500;
NoLags = 40;
NoSections = floor(length(p)/CorrSectionLength);
Skip = 1000;
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
    CondData = diff(conduc(S:E));
    TempData = diff(temp(S:E));
    
    % do the correlation analysis and determine the index of the maximum
    % value which corresponds to the lag
    [CorrArr, Lags] = xcorr(TempData, CondData, NoLags,'coeff');
    Index = round(mean(find(CorrArr == max(CorrArr))));
    %Lags(Index)
    SS.Lag(N) = 1+Index;
    
    % record the depth and number of the section analyzed
    SS.Depth(N) = round(mean(p(S:E)));
    SS.Num(N) = S;
    
    % plot the data
    hold on;
%    plot(zscore(TempData), 'b-')
%    plot(zscore(CondData), 'r-')
    hold off;
%    pause
end

disp(strcat('The Best lag is: ',num2str(Lags(round(nanmean(SS.Lag))))));

% get a smoothed timeseries of lags
%SS.SmLag = smooth(SS.Lag, .1, 'rloess');
