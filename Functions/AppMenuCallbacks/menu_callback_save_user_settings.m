function menu_callback_save_user_settings(~,~)
%MENU_CALLBACK_SAVE_USER_SETTINGS Summary of this function goes here
%   Detailed explanation goes here
mainFigObj=findall(0,'Type','figure','Tag','mainFigure');
setSettingsValue('Style',mainFigObj.Theme.BaseColorStyle);

uiControls = find_all_ui_elements(mainFigObj);

for i = 1:numel(uiControls)

    workbar(i/numel(uiControls),'Save settings','Save USER settings',mainFigObj);
    reverseEnable = false;
    if(strcmp(uiControls(i).Enable ,'off'))
        set( uiControls(i), 'Enable', 'on');
        reverseEnable = true;
    end
    ui_tag = uiControls(i).Tag;

    
    try
        ui_type = uiControls(i).Style;
    catch 
        ui_type = uiControls(i).Type;
    end

    switch ui_type
        case 'edit'
            setSettingsValue(ui_tag, uiControls(i).String);
        case 'uidropdown'
            setSettingsValue(ui_tag, uiControls(i).Value);
        otherwise
            setSettingsValue(ui_tag, num2str(uiControls(i).Value));
    end

    if(reverseEnable)
        set( uiControls(i), 'Enable', 'off');
    end

end
    workbar(2,'Save settings','Save USER settings',mainFigObj);

end