function params = view_helper_default_params()

if ismac
    params.fontSizeS = 10; % Font size small
    params.fontSizeM = 12; % Font size medium
    params.fontSizeB = 16; % Font size big
elseif ispc
    params.fontSizeS = 10*0.75; % Font size small
    params.fontSizeM = 12*0.75; % Font size medium
    params.fontSizeB = 16*0.75; % Font size big
else
    params.fontSizeS = 10; % Font size small
    params.fontSizeM = 12; % Font size medium
    params.fontSizeB = 16; % Font size big
end

clipping = 'on';

params.default_uifugure = {'Units','normalized', 'WindowState','maximized','Visible','on','AutoResizeChildren','off','SizeChangedFcn',@view_helper_figure_resize_callback};
params.default_box_spacing_padding = {'Spacing',2,'Padding',2,'Clipping',clipping };
params.default_Grid_Buttons = {'Spacing',2,'Padding',2,'ButtonSize', [600 20]};
params.default_HButtonBox = {'ButtonSize', [600 20], 'Spacing', 2, 'Padding', 2,'Clipping',clipping};
params.default_HButtonBox_Main = {'ButtonSize', [600 40], 'Spacing', 2, 'Padding', 2,'Clipping',clipping};
params.default_uiLabel = {'ButtonSize', [600 20], 'Spacing', 2, 'Padding', 2};
params.default_normalized_font = {'FontUnits','normalized','Fontsize',0.5};
params.default_panel = {'FontSize',params.fontSizeB,'BorderWidth',2,'Padding', 5,'Clipping',clipping, 'Tag','mainPanelsViews','HighlightColor',getHighlightColorValue()};
params.default_tab_panel = {'FontSize',params.fontSizeM,'Padding', 2,'Clipping',clipping};

params.default_axes = {'Units','normalized','OuterPosition',[0 0 1 1],'LooseInset', [0,0,0,0],'Box','off'};
params.default_axes_toolbar = {{'export','datacursor','pan','zoomin','zoomout','restoreview'}};

params.default_mainPanel_ration = [-78 -22];

end