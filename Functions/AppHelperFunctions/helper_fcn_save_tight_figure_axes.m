function helper_fcn_save_tight_figure_axes(inputData,outfilename)
% SAVETIGHTFIGURE(OUTFILENAME) Saves the current figure without the white
%   space/margin around it to the file OUTFILENAME. Output file type is
%   determined by the extension of OUTFILENAME. All formats that are
%   supported by MATLAB's "saveas" are supported. 
%
%   SAVETIGHTFIGURE(H, OUTFILENAME) Saves the figure or axes with handle H. 
%
% E Akbas (c) Aug 2010
% * Updated to handle subplots and multiple axes. March 2014. 
%
[~,~,ext] = fileparts(outfilename);
saveAsVectorGraphic = ismember(lower(ext), {'.pdf', '.svg'});
tempFigureIsCreated = false;

if isa(inputData, 'matlab.ui.Figure')
    tempFigureIsCreated = false;
    hfig = inputData;

elseif isa(inputData, 'matlab.graphics.axis.Axes')
    tempFigureIsCreated = true;
    hF = uifigure('NumberTitle','on','Units','normalized','Name','Picture Results','Visible','off','Theme', 'light');
    
    try
        copyobj([inputData,inputData.Legend] ,hF);
        set(inputData.Legend, 'Location', 'best');
    catch
        copyobj(inputData ,hF);
    end
    hfig = hF;

elseif ismatrix(inputData)
    if saveAsVectorGraphic
        tempFigureIsCreated = true;
        hF = uifigure('NumberTitle','on','Units','normalized','Name','Picture Results','Visible','off','Theme', 'light');
        axs = axes(hF);
        imshow(inputData,'Parent',axs);
        hfig = hF;
    else
        imwrite(inputData,outfilename);
        return;
    end
end


%% find all the axes in the figure
hax = findall(hfig, 'type', 'axes');

%% compute the tighest box that includes all axes
% Set units for all axes at once
set(hax, 'Units', 'centimeters');

% Get positions and tightinsets as cell arrays
posMat = get(hax, 'Position');      % cell array: { [x y w h], ... }
tiMat  = get(hax, 'TightInset');    % cell array: { [l b r t], ... }


% Compute left, bottom, right, top for all axes
% Each row: [left bottom right top] including tight inset
axesBBox = [posMat(:,1)-tiMat(:,1), ...
            posMat(:,2)-tiMat(:,2), ...
            posMat(:,1)+posMat(:,3)+tiMat(:,3), ...
            posMat(:,2)+posMat(:,4)+tiMat(:,4)];

% Compute the tightest bounding box
tighest_box = [min(axesBBox(:,1)), min(axesBBox(:,2)), ...
               max(axesBBox(:,3)), max(axesBBox(:,4))];

%% move all axes to left-bottom
for i=1:length(hax)
    if strcmp(get(hax(i),'tag'),'legend')
        continue
    end
    p = get(hax(i), 'position');
    set(hax(i), 'position', [p(1)-tighest_box(1) p(2)-tighest_box(2) p(3) p(4)]);
end

%% resize figure to fit tightly
set(hfig, 'units', 'centimeters');
p = get(hfig, 'position');

width = (tighest_box(3)-tighest_box(1))*1.0;
height =  (tighest_box(4)-tighest_box(2))*1.0; 
set(hfig, 'position', [p(1) p(2) width height]);

%% set papersize
set(hfig,'PaperUnits','centimeters');
set(hfig,'PaperSize', [width height]);
set(hfig,'PaperPositionMode', 'manual');
set(hfig,'PaperPosition',[0 0.1 width height]);                

%% save
if saveAsVectorGraphic
    exportgraphics(hfig, outfilename, 'ContentType', 'vector');
else
    exportgraphics(hfig, outfilename, 'ContentType', 'auto');
end

%% Close temp Figure if h is an axes Type 
if tempFigureIsCreated
    delete(hfig)
end


