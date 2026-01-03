function menu_callback_load_user_settings(src,~)
%MENU_CALLBACK_LOAD_USER_SETTINGS Summary of this function goes here
%   Detailed explanation goes here

if nargin < 1
    src.Text = 'Load User Settings';
end

mainFigObj=findall(0,'Type','figure','Tag','mainFigure');
theme(mainFigObj,getSettingsValue('Style'));

uiControls = find_all_ui_elements(mainFigObj);
for i = 1:numel(uiControls)
    
    reverseEnable = false;
    if(strcmp(uiControls(i).Enable ,'off'))
        set( uiControls(i), 'Enable', 'on');
        reverseEnable = true;
    end

    try
        ui_type = uiControls(i).Style;
    catch 
        ui_type = uiControls(i).Type;
    end
    ui_tag = uiControls(i).Tag;
    if strcmp(ui_tag,'popupmenuThresholdMode') || strcmp(ui_tag,'popupmenuForeBackGround')
        %Skipp all UI Elements that will trigger binarisation algorithm
        % Apply changes at the end
        break;
    end

    switch src.Text
        case 'Load User Settings'
            workbar(i/numel(uiControls),'Load User Setting','Load USER settings',mainFigObj);
            switch ui_type
                case 'edit'
                    uiControls(i).String = getSettingsValue(uiControls(i).Tag);
                case 'uidropdown'
                    uiControls(i).Value = getSettingsValue(uiControls(i).Tag);
                otherwise
                    uiControls(i).Value = str2double( getSettingsValue(uiControls(i).Tag) );
            end

        case 'Load Default Settings'
            workbar(i/numel(uiControls),'Load Default Setting','Load Default settings',mainFigObj);
            switch ui_type
                case 'edit'
                    uiControls(i).String = getDefaultSettingsValue(uiControls(i).Tag);
                case 'uidropdown'
                    uiControls(i).Value = getDefaultSettingsValue(uiControls(i).Tag);
                otherwise
                    uiControls(i).Value = str2double( getDefaultSettingsValue(uiControls(i).Tag) );
           end

        otherwise
            workbar(i/numel(uiControls),'Load Default Setting','Load Default settings',mainFigObj);
            switch ui_type
                case 'edit'
                    uiControls(i).String = getDefaultSettingsValue(uiControls(i).Tag);
                case 'uidropdown'
                    uiControls(i).Value = getDefaultSettingsValue(uiControls(i).Tag);
                otherwise
                    uiControls(i).Value = str2double( getDefaultSettingsValue(uiControls(i).Tag) );
           end

    end
          
    if(reverseEnable)
        set( uiControls(i), 'Enable', 'off');
    end

    if isprop(uiControls(i),'ValueChangedFcn')
        if ~isempty(uiControls(i).ValueChangedFcn)
            feval(get(uiControls(i),'ValueChangedFcn'),uiControls(i));
        end
    end

    if isprop(uiControls(i),'Callback')
        if ~isempty(uiControls(i).Callback)
            feval(get(uiControls(i),'Callback'),uiControls(i));
        end
    end
end
workbar(2,'load settings','Load USER settings',mainFigObj);

ui_popupmenuThresholdMode = findall(0,'Type','uidropdown','Tag','popupmenuThresholdMode');
ui_popupmenuForeBackGround = findall(0,'Type','uidropdown','Tag','popupmenuForeBackGround');


switch src.Text
    case 'Load User Settings'
        ui_popupmenuThresholdMode.Value = getSettingsValue(ui_popupmenuThresholdMode.Tag);
        ui_popupmenuForeBackGround.Value = getSettingsValue(ui_popupmenuForeBackGround.Tag);
    case 'Load Default Settings'
        ui_popupmenuThresholdMode.Value = getDefaultSettingsValue(ui_popupmenuThresholdMode.Tag);
        ui_popupmenuForeBackGround.Value = getDefaultSettingsValue(ui_popupmenuForeBackGround.Tag);
    otherwise
        ui_popupmenuThresholdMode.Value = getDefaultSettingsValue(ui_popupmenuThresholdMode.Tag);
        ui_popupmenuForeBackGround.Value = getDefaultSettingsValue(ui_popupmenuForeBackGround.Tag);
end
if isprop(ui_popupmenuThresholdMode,'ValueChangedFcn') && ~isempty(ui_popupmenuThresholdMode.ValueChangedFcn)
    feval(get(ui_popupmenuThresholdMode,'ValueChangedFcn'),ui_popupmenuThresholdMode);
end

workbar(2,'load settings','Load USER settings',mainFigObj);

end