function menu_callback_change_app_color(src,~)
%MENU_CALLBACK_CHANGE_APP_THEME Summary of this function goes here
%   Detailed explanation goes here
colorStr= lower(src.Text);

mainCardObj=findall(0,'Tag','mainCard');

panelObj=findall(mainCardObj,'Type','uipanel');

colorVaule = getHighlightColorValue(colorStr);

setSettingsValue('HighlightColor',colorStr);
set(panelObj,'HighlightColor',colorVaule);

menuDesignColorNone = findall(0,'Tag','menuDesignColorNone');
set(menuDesignColorNone,'Checked','off');
menuDesignColorRed = findall(0,'Tag','menuDesignColorRed');
set(menuDesignColorRed,'Checked','off');
menuDesignColorGreen = findall(0,'Tag','menuDesignColorGreen');
set(menuDesignColorGreen,'Checked','off');
menuDesignColorCyan = findall(0,'Tag','menuDesignColorCyan');
set(menuDesignColorCyan,'Checked','off');
menuDesignColorMagenta = findall(0,'Tag','menuDesignColorMagenta');
set(menuDesignColorMagenta,'Checked','off');
menuDesignColorYellow = findall(0,'Tag','menuDesignColorYellow');
set(menuDesignColorYellow,'Checked','off');
menuDesignColorOrange = findall(0,'Tag','menuDesignColorOrange');
set(menuDesignColorOrange,'Checked','off');
menuDesignColorPurple = findall(0,'Tag','menuDesignColorPurple');
set(menuDesignColorPurple,'Checked','off');
menuDesignColorBlue = findall(0,'Tag','menuDesignColorBlue');
set(menuDesignColorBlue,'Checked','off');


menuDesignColorBlack = findall(0,'Tag','menuDesignColorBlack');
set(menuDesignColorBlack,'Checked','off');
menuDesignColorWhite = findall(0,'Tag','menuDesignColorWhite');
set(menuDesignColorWhite,'Checked','off');

set(src,'Checked','on');
drawnow;
end