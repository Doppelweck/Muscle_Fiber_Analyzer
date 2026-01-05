function update_menu_bar_main_figure(mainFig,versionString,changeAppTheme, changeAppColor,loadUserSettings , saveUserSettings,openInformationFigure)

if nargin < 1 || isempty(mainFig) || ~isvalid(mainFig) %For testing and debugging
    mainFig = uifigure('Tag','testFigure','Theme',getSettingsValue('Style'));
    newVersionAvailable = false;
    checkSuccessfull = false;
    newVersion = '';
    changeAppTheme = '';
    changeAppColor = '';
    loadUserSettings = '';
    saveUserSettings = '';
    openInformationFigure = '';
else
    [newVersionAvailable, checkSuccessfull, newVersion] = checkAppForNewVersion(versionString);
end

%%Remove unwanted Menu icons
editMenu = findall(mainFig, 'Tag', 'figMenuFile' ,'-or','Tag', 'figMenuEdit',...
    '-or','Tag', 'figMenuView','-or','Tag', 'figMenuInsert','-or','Tag', 'figMenuDesktop',...
    '-or','Tag', 'figMenuHelp');
delete(editMenu);

figTheme = getSettingsValue('Style');
highlightColor = getSettingsValue('HighlightColor');

uimenu(mainFig,'Enable','off','Text','  |  ')
% Add Menu for Design
mDesign = uimenu(mainFig,'Text','App Design Theme','Tag','menuDesignSelection');
mDesignitem1 = uimenu(mDesign,'Text','Dark','Checked','off','Tag','menuDesignDark');
mDesignitem1.MenuSelectedFcn = changeAppTheme;
mDesignitem2 = uimenu(mDesign,'Text','Light','Checked','off','Tag','menuDesignLight');
mDesignitem2.MenuSelectedFcn = changeAppTheme;
mDesignitem3 = uimenu(mDesign,'Text','Auto','Checked','off','Tag','menuDesignDefault');
mDesignitem3.MenuSelectedFcn = changeAppTheme;

switch figTheme
    case 'dark'
        set(mDesignitem1,'Checked','on');
    case 'light'
        set(mDesignitem2,'Checked','on');
    case 'auto'
        set(mDesignitem3,'Checked','on');
end



uimenu(mainFig,'Enable','off','Text','  |  ')
% Add Menu for Highlight Color
mDesignColor = uimenu(mainFig,'Text','App Design Highlight Color','Tag','menuDesignSelection');
mDesignColorItem1 = uimenu(mDesignColor,'Text','none','Checked','off','Tag','menuDesignColorNone');
mDesignColorItem1.MenuSelectedFcn = changeAppColor;
mDesignColorItem2 = uimenu(mDesignColor,'Text','red','Checked','off','Tag','menuDesignColorRed');
mDesignColorItem2.MenuSelectedFcn = changeAppColor;
mDesignColorItem3 = uimenu(mDesignColor,'Text','green','Checked','off','Tag','menuDesignColorGreen');
mDesignColorItem3.MenuSelectedFcn = changeAppColor;
mDesignColorItem4 = uimenu(mDesignColor,'Text','cyan','Checked','off','Tag','menuDesignColorCyan');
mDesignColorItem4.MenuSelectedFcn = changeAppColor;
mDesignColorItem5 = uimenu(mDesignColor,'Text','magenta','Checked','off','Tag','menuDesignColorMagenta');
mDesignColorItem5.MenuSelectedFcn = changeAppColor;
mDesignColorItem6 = uimenu(mDesignColor,'Text','yellow','Checked','off','Tag','menuDesignColorYellow');
mDesignColorItem6.MenuSelectedFcn = changeAppColor;
mDesignColorItem7 = uimenu(mDesignColor,'Text','orange','Checked','off','Tag','menuDesignColorOrange');
mDesignColorItem7.MenuSelectedFcn = changeAppColor;
mDesignColorItem8 = uimenu(mDesignColor,'Text','purple','Checked','off','Tag','menuDesignColorPurple');
mDesignColorItem8.MenuSelectedFcn = changeAppColor;
mDesignColorItem9 = uimenu(mDesignColor,'Text','blue','Checked','off','Tag','menuDesignColorBlue');
mDesignColorItem9.MenuSelectedFcn = changeAppColor;


switch highlightColor
    case 'none'
        set(mDesignColorItem1,'Checked','on');
    case 'red'
        set(mDesignColorItem2,'Checked','on');
    case 'green'
        set(mDesignColorItem3,'Checked','on');
    case 'cyan'
        set(mDesignColorItem4,'Checked','on');
    case 'magenta'
        set(mDesignColorItem5,'Checked','on');
    case 'yellow'
        set(mDesignColorItem6,'Checked','on');
    case 'orange'
        set(mDesignColorItem7,'Checked','on');
    case 'purple'
        set(mDesignColorItem8,'Checked','on');
    case 'blue'
        set(mDesignColorItem9,'Checked','on');
    case 'black'

    case 'white'

end

uimenu(mainFig,'Enable','off','Text','  |  ')
% Add Menu for Settings
mSettings = uimenu(mainFig,'Text','App Settings');
mSettingsitem1 = uimenu(mSettings,'Text','Load Default Settings');
mSettingsitem1.MenuSelectedFcn = loadUserSettings;
mSettingsitem2 = uimenu(mSettings,'Text','Load User Settings');
mSettingsitem2.MenuSelectedFcn = loadUserSettings;
mSettingsitem3 = uimenu(mSettings,'Text','Save User Settings');
mSettingsitem3.MenuSelectedFcn = saveUserSettings;



uimenu(mainFig,'Enable','off','Text','  |  ')
% Add Menu for Info
if(newVersionAvailable && checkSuccessfull)
    AboutText =['About (NEW VERSION ' newVersion ' AVAILABLE)'];
else
    AboutText ='About';
end
mInfo = uimenu(mainFig,'Text',AboutText);
mInfoItem1 = uimenu(mInfo,'Text','Show Info');
mInfoItem1.MenuSelectedFcn = openInformationFigure;

uimenu(mainFig,'Enable','off','Text','  |  ')

end