function PlotHorzSection(Data, Depth, PropertyName, Title, GridMethod, Scale)
% Horizontal contour plot of any SeaSoar property at any depth. 
% Note that HorzSection.m calculates the property average for depth +/- 5m.

% INPUT
% Data - 1 hz Seasoar data structure
% Depth - depth for which data are to be plotted (+/- 5 m) see HorzSection.m 
% PropertyName - name of the property to be plotted. Needs to correspond to
%   an entry in switch lists below
% Title - title for the figure
% GridMethod - The gridmethod that is used must be specified.  See griddata
%	for details. Methods are 'linear', 'cubic', 'nearest', 'v4'
% Scale - scale factor to be applied to the pcolor axis scaling.  The lower
%   the value the more color resultion for the property.  Values of 0 allow
%   the user to enter values.

% Call the function from Matlab using, e.g.:
%	PlotHorzSection(data, 20, 'Temp', 'SpiceExp - 20 m Temp', 'linear', .1)

% Functions Called:
%   HorzSection.m in Seasoar

Slice = HorzSection (Data, Depth);

Long_Data = Slice.lon;
Lat_Data = Slice.lat;

% Given PropertyName assign a variable of Section to PropertyData
switch PropertyName
    case {'temp', 'Temp', 't1', 't2'}
        Property_Data = Slice.t1;
        
    case {'cond', 'Cond', 'c1', 'c2'}
        Property_Data = Slice.c1;
        
    case {'trans', 'Trans'}
        Property_Data = Slice.trans;
        
    case {'fluor','Fluor', 'fl', 'chl', 'Chl'}
        Property_Data = Slice.fl;
        
    case {'sal', 'Sal','salinity', 'Salinity', 's1', 's2'}
        Property_Data = Slice.s1;
        
    case {'theta', 'Theta', 'theta1', 'theta2'}
        Property_Data = Slice.theta1;
        
    case {'sigma', 'Sigma', 'sigma1', 'sigma2', 'den', 'dens', 'density'}
        Property_Data = (Slice.sigma1 - 1000);
        
    case {'oxygen', 'Oxygen', 'O2'}
        Property_Data = Slice.oxygen;
        
    otherwise
        display(['No valid property was recognized - you used name: ' PropertyName]);
        return
end

% Test that the data vectors are of equal length
if ~( isequal(size (Long_Data), size (Lat_Data) , size (Property_Data)));
    error ('The data vectors are not of the same size or orientation');
end

Lat_AxisMaxLim = max (Lat_Data) + .1;
Lat_AxisMinLim = min (Lat_Data) - .1;
Long_AxisMaxLim = max (Long_Data) + .1;
Long_AxisMinLim = min (Long_Data) - .1;

% Set Min and Max property values for pcolor axis

if Scale > 0
Property_MaxLim = ceil(max (Property_Data/Scale))*Scale;
Property_MinLim = floor (min (Property_Data/Scale))*Scale;
else
    display(' ');
    display('Give min and max values for pcolor axis');
   Property_MinLim =  input('Minimum Value: ');
   Property_MaxLim =  input('Maximum Value: '); 
end

% Generate gidded data
[LongGrid,LatGrid] = meshgrid(Long_AxisMinLim : .01 : Long_AxisMaxLim,  Lat_AxisMinLim : 0.01 : (Lat_AxisMaxLim));
PropertyGrid = griddata(Long_Data, Lat_Data, Property_Data, LongGrid, LatGrid, GridMethod);

%% Create figure
figure1 = figure(...
    'PaperOrientation','portrait',...
    'InvertHardcopy','off',...
    'PaperPosition',[0.25 0.25 10.5 8],...
    'PaperSize',[11 8.5]);

%% Create axes  !!! Set CLim values if desired.
axes1 = axes(...
    'CLim',[Property_MinLim Property_MaxLim],...
    'FontName','arial',...
    'FontSize',11.54,...
    'Parent',figure1);

%%          !!! Set Axis Limits.
axis(axes1,[Long_AxisMinLim Long_AxisMaxLim Lat_AxisMinLim Lat_AxisMaxLim]);
TempTitle = Title;
title(axes1, TempTitle);
xlabel(axes1,'Longitude (deg)');  ylabel(axes1,'Latitude (deg)');
hold(axes1,'all');

pcolor (LongGrid, LatGrid, PropertyGrid); shading interp;

switch PropertyName
    case {'temp', 'Temp', 't1', 't2'}
        contour (LongGrid, LatGrid, PropertyGrid, 'k','LevelList', 5:1:26,'ShowText','on','TextList', 5:2:26  );
        
    case {'cond', 'Cond', 'c1', 'c2'}
        contour (LongGrid, LatGrid, PropertyGrid, 'k','LevelList',3.5:.1:5,'ShowText','on','TextList',3.5:.1:5);
        
    case {'trans', 'Trans'}
        contour (LongGrid, LatGrid, PropertyGrid, 'k','LevelList',0:.1:1,'ShowText','on','TextList',0:.1:1);
        
    case {'fluor','Fluor', 'fl', 'chl', 'Chl'}
        contour (LongGrid, LatGrid, PropertyGrid, 'k','LevelList',0:.1:1,'ShowText','on','TextList',0:.1:1);
        
    case {'sal', 'Sal','salinity', 'Salinity', 's1', 's2'}
        contour (LongGrid, LatGrid, PropertyGrid, 'k','LevelList', 32.6:.2:36,'ShowText','on','TextList',32.6:.2:36 );
        
    case {'theta', 'Theta', 'theta1', 'theta2'}
        contour (LongGrid, LatGrid, PropertyGrid, 'k','LevelList',10:1:22,'ShowText','on','TextList',10:1:22 );
        
    case {'sigma', 'Sigma', 'sigma1', 'sigma2', 'den', 'dens', 'density'}
        contour (LongGrid, LatGrid, PropertyGrid, 'k','LevelList', 22:.1:28,'ShowText','on','TextList',22:.2:28);
        
    case {'oxygen', 'Oxygen', 'O2', 'o2'}
        contour (LongGrid, LatGrid, PropertyGrid, 'k','LevelList', 2:.3:7,'ShowText','on','TextList',2:.6:7);
        
    otherwise
        disp(['No valid property name was recoginized for property: ' PropertyName])
        Property_Range = Property_MaxLim - Property_MinLim;
        
        if Property_Range < .4
            Lower = ceil  (100*Property_MinLim) / 100;
            Upper = floor (100*Property_MaxLim) / 100;
            List = Lower : (round (Property_Range*100) / 500) : Upper;
            
        elseif  Property_Range < 7
            Lower = ceil  (10*Property_MinLim) / 10;
            Upper = floor (10*Property_MaxLim) / 10;
            List = Lower : (round (Property_Range*10) / 50) : Upper;
            
        else
            Lower = ceil  (Property_MinLim);
            Upper = floor (Property_MaxLim);
            RangeTemp = round (Property_Range / 5);
            List = Lower : RangeTemp : Upper;
            
        end
        contour (LongGrid, LatGrid, PropertyGrid, 'k','LevelList', List,'ShowText','on','TextList', List);
end


title (TempTitle, 'FontSize', 16);
colorbar('peer',axes1,[0.8886 0.1076 0.03283 0.815],'Box','on','location', 'EastOutside');

plot (Long_Data, Lat_Data, 'LineStyle', 'none', 'Marker', '+', 'MarkerEdgeColor', 'k' , 'MarkerSize', 2);



set(figure1, 'color', 'white'); % sets the color to white
% set(gca, 'Box', 'off' );
set(gca, 'Position', get(gca, 'OuterPosition') -  get(gca, 'TightInset') * [-1 0 1 0; 0 -1 0 1; 0 0 1 0; 0 0 0 1]);
TextboxString = ['R. Goericke, ' date];
% Create textbox
annotation(...
    figure1,'textbox',...
    'Units', 'centimeters', ...
    'Position',[0.1 0.1 7 .5],...
    'LineStyle','none',...
    'String',TextboxString,...
    'FitHeightToText','on',...
    'FontSize', 8,...
    'VerticalAlignment', 'middle', ...
    'HorizontalAlignment', 'left');


% FileName = [TempTitle, '.png'];
% saveas(figure1, FileName);

end %function
