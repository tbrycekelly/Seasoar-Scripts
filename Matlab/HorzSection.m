function Slice = HorzSection (data, depth)
% Slice.m - extract from Seasoar data, data corresponding to a depth
% interval given by depth +/- 5.
% R. Goericke SIO,
%
% INPUT
% var - 1hz seasoar data 
% lon - 
% lat - 
% pressure - 
% depth - 

% OUTPUT
% Slice - structure with lon, lat, pressure and var data within the
% interval depth +/- 5

% Call function e.g.:
%   Slice = HorzSection (data, depth)

Interval = 5;

% generate an index of all records within the target depth interval
Index = find((data.p > depth - Interval) & (data.p < depth + Interval));

% find the points in Index where depth intervals start/end.  The starting
% points are found by looking for large breaks in the progression of index
% values in 'Index'.  This is done using diff.m.
StartIndex = logical([1; diff(Index)>4]);
StartRecords = Index(StartIndex);
EndIndex = logical([StartIndex(2:end); 1]);
EndRecords = Index(EndIndex);
NoIntervals = length(StartRecords);

Slice.Depth = depth;
%
for N = 1 : NoIntervals
    S = StartRecords(N);
    E = EndRecords(N);
    Slice.p(N) = nanmean(data.p(S:E));
    Slice.lon(N) = nanmean(data.lon(S:E));
    Slice.lat(N) = nanmean(data.lat(S:E));
    Slice.t1(N) = nanmean(data.t1(S:E));
    Slice.c1(N) = nanmean(data.c1(S:E));
    Slice.trans(N) = nanmean(data.trans(S:E));
    Slice.fl(N) = nanmean(data.fl(S:E));
    Slice.s1(N) = nanmean(data.s1(S:E));
    Slice.theta1(N) = nanmean(data.theta1(S:E));
    Slice.sigma1(N) = nanmean(data.sigma1(S:E));
    % Slice.oxygen(N) = nanmean(data.oxygen(S:E));
    
end

end   % function HorzSection
