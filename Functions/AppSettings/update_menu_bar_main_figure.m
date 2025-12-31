function update_menu_bar_main_figure(mainFig,versionString,changeAppDesign, loadUserSettings , saveUserSettings,openInformationFigure)

[newVersionAvailable, checkSuccessfull, newVersion] = checkAppForNewVersion(versionString);

%%Remove unwanted Menu icons
    editMenu = findall(mainFig, 'Tag', 'figMenuFile' ,'-or','Tag', 'figMenuEdit',...
        '-or','Tag', 'figMenuView','-or','Tag', 'figMenuInsert','-or','Tag', 'figMenuDesktop',...
        '-or','Tag', 'figMenuHelp');
    delete(editMenu);
    
    uimenu(mainFig,'Enable','off','Text','  |  ')
    % Add Menu for Design
    mDesign = uimenu(mainFig,'Text','App Design','Tag','menuDesignSelection');
    mDesignitem1 = uimenu(mDesign,'Text','Dark','Tag','menuDesignDark');
    mDesignitem1.MenuSelectedFcn = changeAppDesign;
    mDesignitem2 = uimenu(mDesign,'Text','Light','Tag','menuDesignLight');
    mDesignitem2.MenuSelectedFcn = changeAppDesign;
    mDesignitem3 = uimenu(mDesign,'Text','Auto','Tag','menuDesignDefault');
    mDesignitem3.MenuSelectedFcn = changeAppDesign;

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
    mInfo1 = uimenu(mainFig,'Text',AboutText);
    mInfo1.MenuSelectedFcn = openInformationFigure;

    uimenu(mainFig,'Enable','off','Text','  |  ')




    % hide needless ToogleTool objects in the main figure
    set( findall(mainFig,'ToolTipString','Edit Plot') ,'Visible','Off');
    set( findall(mainFig,'ToolTipString','Insert Colorbar') ,'Visible','Off');
    set( findall(mainFig,'ToolTipString','Insert Legend') ,'Visible','Off');
    set( findall(mainFig,'ToolTipString','Hide Plot Tools') ,'Visible','Off');
    set( findall(mainFig,'ToolTipString','New Figure') ,'Visible','Off');
    set( findall(mainFig,'ToolTipString','Show Plot Tools') ,'Visible','Off');
    set( findall(mainFig,'ToolTipString','Brush/Select Data') ,'Visible','Off');
    set( findall(mainFig,'ToolTipString','Show Plot Tools and Dock Figure') ,'Visible','Off');
    set( findall(mainFig,'ToolTipString','Link Plot') ,'Visible','Off');
    set( findall(mainFig,'ToolTipString','Save Figure') ,'Visible','Off');
    set( findall(mainFig,'ToolTipString','Open File') ,'Visible','Off');

end