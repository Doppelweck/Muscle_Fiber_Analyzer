function menu_callback_change_app_theme(src,~)
%MENU_CALLBACK_CHANGE_APP_THEME Summary of this function goes here
%   Detailed explanation goes here
style = lower(src.Text);

mainCordObj=findall(0,'Tag','mainCard');
mainCordObj.Visible = 'off';
drawnow;
mainFigObj=findall(0,'Type','figure','Tag','mainFigure');
theme(mainFigObj,style)

setSettingsValue('Style',style);

menuDark = findall(0,'Tag','menuDesignDark');
menuLight = findall(0,'Tag','menuDesignLight');
menuAuto = findall(0,'Tag','menuDesignDefault');

set(menuDark,'Checked','off');
set(menuLight,'Checked','off');
set(menuAuto,'Checked','off');

set(src,'Checked','on');

mainCordObj.Visible = 'on';
drawnow;
end