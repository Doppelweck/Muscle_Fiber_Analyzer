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

params.default_box_spacing_padding = {'Spacing',2,'Padding',2 };
params.default_HButtonBox = {'ButtonSize', [600 20], 'Spacing', 2, 'Padding', 2};
params.default_HButtonBox_Main = {'ButtonSize', [600 40], 'Spacing', 2, 'Padding', 2};
params.default_uiLabel = {'ButtonSize', [600 20], 'Spacing', 2, 'Padding', 2};
params.default_normalized_font = {'FontUnits','normalized','Fontsize',0.6};
params.default_panel = {'FontSize',params.fontSizeB,'BorderWidth',2,'Padding', 2, 'Tag','mainPanelsViews','HighlightColor',getHighlightColorValue()};
params.default_tab_panel = {'FontSize',params.fontSizeM,'Padding', 2};

end