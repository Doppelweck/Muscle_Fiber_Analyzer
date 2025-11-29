try
    theme("light");
    % find starting path
    warning('off', 'all');
    try %%Not need for .exe
        path = cd;
        % add files to the current matalb path
        addpath(genpath('MVC'));
        addpath(genpath('Functions'));
        addpath(genpath('Icons'));
        pause(0.1);
        cl;
    catch
    end

    setSettingsValue('Version','1.6');
    setSettingsValue('Day','11');
    setSettingsValue('Month','March');
    setSettingsValue('Year','2025');
    versionString = ['Version ' getSettingsValue('Version') '  ' getSettingsValue('Day') '-' getSettingsValue('Month') '-' getSettingsValue('Year')];
    % write the current Version to LATEST.txt
    writeVersionToTxt(versionString);
    [newVersionAvailable, checkSuccessfull, newVersion] = checkAppForNewVersion(versionString);


    % create starting screen
    if ismac
        fontSizeS = 18; % Font size small
        fontSizeB = 20; % Font size big
    elseif ispc
        fontSizeS = 20*0.75; % Font size small
        fontSizeB = 20*0.75; % Font size big
    else
        fontSizeS = 18; % Font size small
        fontSizeB = 20; % Font size big
    end

    % create main figure
    mainFig = uifigure('Units','pixels',...
        'Visible','off',...
        'Name',['Muscle-Fiber-Classification-Tool ' getSettingsValue('Version')],...
        'DockControls','off',...
        'Menubar','none','ToolBar','none',...
        'WindowStyle','normal','NumberTitle','off',...
        'Tag','mainFigure');

    %Create Start Screen
    hf = startSrcreen();
    versionString = ['Version ' getSettingsValue('Version') '  ' getSettingsValue('Day') '-' getSettingsValue('Month') '-' getSettingsValue('Year')];
    TitleText1=text(hf.Children,0.3,0.965,'Muscle Fiber Classification Tool',...
        'units','normalized','FontUnits','normalized','FontWeight','bold','FontSize',0.075,'Color',[0 0 0]);
    %     TitleText2=text(hf.Children,0.45,0.83,'Classification Tool',...
    %         'units','normalized','FontUnits','normalized','FontSize',0.08,'Color',[1 0.5 0]);
    VersionText=text(hf.Children,0.54,0.915,versionString,'units','normalized','FontUnits','normalized','FontWeight','bold','FontSize',0.04,'Color','k');
    InfoText=text(hf.Children,0.02,0.035,'Loading please wait... Initialize application...','units','normalized','FontWeight','bold','FontUnits','normalized','FontSize',0.03,'Color','k');
    text(hf.Children,0.02,0.16,'Developed by:','units','normalized','FontUnits','normalized','FontWeight','bold','FontSize',0.04,'Color','k');
    text(hf.Children,0.02,0.12,['Sebastian Friedrich  2017 - ' getSettingsValue('Year')],'units','normalized','FontUnits','normalized','FontWeight','bold','FontSize',0.03,'Color','k');
    text(hf.Children,0.02,0.095,'sebastian.friedrich.software@gmail.com','units','normalized','FontUnits','normalized','FontWeight','bold','FontSize',0.025,'Color','k');
    %     text(hf.Children,0.03,0.19,'In cooperation with:','units','normalized','FontUnits','normalized','FontSize',0.03,'Color','k');
    %     text(hf.Children,0.05,0.07,'2017','units','normalized','FontUnits','normalized','FontSize',0.045,'Color','[1 0.5 0]');
    % setAlwaysOnTop(hf,true);
    drawnow;
    %
    %     % R2010a and newer
    %     iconsClassName = 'com.mathworks.widgets.BusyAffordance$AffordanceSize';
    %     iconsSizeEnums = javaMethod('values',iconsClassName);
    %     SIZE_32x32 = iconsSizeEnums(1);  % (1) = 16x16,  (2) = 32x32
    %     busyIndicator = com.mathworks.widgets.BusyAffordance(SIZE_32x32);  % icon, label
    %     busyIndicator.setPaintsWhenStopped(false);  % default = false
    %     busyIndicator.useWhiteDots(false);         % default = false (true is good for dark backgrounds)
    %     javacomponent(busyIndicator.getComponent, [hf.Position(3)*0.2,hf.Position(4)*0.035,40,40], hf);
    %     busyIndicator.getComponent.setBackground(java.awt.Color(0,0,0,0.1));
    %     busyIndicator.start;


    % Calculate centered position (10% smaller)
    hfPos = hf.Position;
    scale = 0.9; % 10% smaller
    newWidth = hfPos(3) * scale;
    newHeight = hfPos(4) * scale;
    newX = hfPos(1) + (hfPos(3) - newWidth) / 2;
    newY = hfPos(2) + (hfPos(4) - newHeight) / 2;

    set(mainFig, 'OuterPosition', hf.Position);

    set(mainFig,'Visible','on');
    figure(hf);
    set(hf,'Visible','on');
    figure(hf);
    set(hf,'WindowStyle','modal');
    % figure(hf);
    % set(hf,'WindowStyle','normal');
    drawnow;

    %%Remove unwanted Menu icons
    editMenu = findall(mainFig, 'Tag', 'figMenuFile' ,'-or','Tag', 'figMenuEdit',...
        '-or','Tag', 'figMenuView','-or','Tag', 'figMenuInsert','-or','Tag', 'figMenuDesktop',...
        '-or','Tag', 'figMenuHelp');
    delete(editMenu);
    
    uimenu(mainFig,'Enable','off','Text','  |  ')
    % Add Menu for Design
    mDesign = uimenu(mainFig,'Text','App Design','Tag','menuDesignSelection');
    mDesignitem1 = uimenu(mDesign,'Text','Dark','Tag','menuDesignDark');
    mDesignitem1.MenuSelectedFcn = @changeAppDesign;
    mDesignitem2 = uimenu(mDesign,'Text','Light','Tag','menuDesignLight');
    mDesignitem2.MenuSelectedFcn = @changeAppDesign;
    mDesignitem3 = uimenu(mDesign,'Text','Default','Tag','menuDesignDefault');
    mDesignitem3.MenuSelectedFcn = @changeAppDesign;

    uimenu(mainFig,'Enable','off','Text','  |  ')
    % Add Menu for Settings
    mSettings = uimenu(mainFig,'Text','App Settings');
    mSettingsitem1 = uimenu(mSettings,'Text','Load Default Settings');
    mSettingsitem1.MenuSelectedFcn = @loadDefaultSettings;
    mSettingsitem2 = uimenu(mSettings,'Text','Load User Settings');
    mSettingsitem2.MenuSelectedFcn = @loadUserSettings;
    mSettingsitem3 = uimenu(mSettings,'Text','Save User Settings');
    mSettingsitem3.MenuSelectedFcn = @saveUserSettings;

    uimenu(mainFig,'Enable','off','Text','  |  ')
    % Add Menu for Info
    if(newVersionAvailable && checkSuccessfull)
        AboutText =['About (NEW VERSION ' newVersion ' AVAILABLE)'];
    else
        AboutText ='About';
    end
    mInfo1 = uimenu(mainFig,'Text',AboutText);
    mInfo1.MenuSelectedFcn = @openInformationFigure;

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

    %create card panel onbject
    mainCard = uix.CardPanel('Parent', mainFig,'Selection',0,'Tag','mainCard');
    InfoText.String='Loading please wait...   Initialize VIEW-Components...';
    %Init VIEW's
    viewEditHandle = viewEdit(mainCard);
    InfoText.String='Loading please wait...   Initialize VIEW-Edit...';
    mainCard.Selection = 1;
    drawnow;pause(0.5);
    viewAnalyzeHandle = viewAnalyze(mainCard);
    InfoText.String='Loading please wait...   Initialize VIEW-Analyze...';
    mainCard.Selection = 2;
    drawnow;pause(0.5);
    viewResultsHandle = viewResults(mainCard);
    InfoText.String='Loading please wait...   Initialize VIEW-Results...';
    mainCard.Selection = 3;
    drawnow;pause(0.5);
    mainCard.Selection = 1;
    drawnow;

    InfoText.String='Loading please wait...   Load User Settings...';
    % LOAD USER Settings
    uiControls = findobj(mainCard,'-not','Tag','','-and','Type','uicontrol','-not','Tag','textFiberInfo',...
        '-and','-not','Style','pushbutton');

    for i = 1:numel(uiControls)
        reverseEnable = false;
        if(strcmp(uiControls(i).Enable ,'off'))
            set( uiControls(i), 'Enable', 'on');
            appDesignElementChanger(uiControls(i));
            reverseEnable = true;
        end

        if(strcmp(uiControls(i).Style,'edit'))
            uiControls(i).String = getSettingsValue(uiControls(i).Tag);
        else
            uiControls(i).Value = str2double( getSettingsValue(uiControls(i).Tag) );
        end

        if(reverseEnable)
            set( uiControls(i), 'Enable', 'off');
            appDesignElementChanger(uiControls(i));
        end
    end

    drawnow;pause(1);

    InfoText.String='Loading please wait...   Initialize MODEL-Components...';
    %Init MODEL's
    modelEditHandle = modelEdit();
    modelAnalyzeHandle = modelAnalyze();
    modelResultsHandle = modelResults();
    pause(0.2)

    InfoText.String='Loading please wait...   Initialize CONTROLLER-Components...';
    %Init CONTROLLER's
    controllerEditHandle = controllerEdit(mainFig, mainCard, viewEditHandle, modelEditHandle);
    controllerAnalyzeHandle = controllerAnalyze(mainFig, mainCard, viewAnalyzeHandle, modelAnalyzeHandle);
    controllerResultsHandle = controllerResults(mainFig, mainCard, viewResultsHandle, modelResultsHandle);
    pause(0.2)

    InfoText.String='Loading please wait...   Connecting components...';
    %Connecting Model's and their Controller's
    modelEditHandle.controllerEditHandle = controllerEditHandle;
    modelAnalyzeHandle.controllerAnalyzeHandle = controllerAnalyzeHandle;
    modelResultsHandle.controllerResultsHandle = controllerResultsHandle;
    pause(0.2)

    InfoText.String='Loading please wait...   Update app design...';
    appDesignChanger(mainCard,getSettingsValue('Style'));
    appDesignElementChanger(mainCard);
    drawnow;
    pause(0.2)

    InfoText.String='Loading please wait...   Start application...';
    %Connecting Controller's to each other
    controllerEditHandle.controllerAnalyzeHandle = controllerAnalyzeHandle;
    controllerAnalyzeHandle.controllerEditHandle = controllerEditHandle;
    controllerAnalyzeHandle.controllerResultsHandle = controllerResultsHandle;
    controllerResultsHandle.controllerAnalyzeHandle = controllerAnalyzeHandle;
    pause(0.2)

    InfoText.String='Run application';
    drawnow;
    pause(0.5);

    % delete starting screen
    %     busyIndicator.stop;
    delete(hf);
    set(mainFig,'Position',[0.01 0.05 0.98 0.85]);
    set(mainFig,'WindowState','maximized');
    delete(InfoText);
    delete(VersionText);

catch ME
    % FIRST: Stop all timers immediately
    timers = timerfindall;
    if ~isempty(timers)
        stop(timers);
        delete(timers);
    end

    % Clean up UI elements (check if they exist first)
    if exist('hf', 'var') && isvalid(hf)
        delete(hf);
    end
    if exist('InfoText', 'var') && isvalid(InfoText)
        delete(InfoText);
    end
    if exist('VersionText', 'var') && isvalid(VersionText)
        delete(VersionText);
    end

    % Delete all objects in main figure
    if exist('mainFig', 'var') && isvalid(mainFig)
        delete(findall(mainFig));
    end

    % Stop any ongoing parallel operations
    drawnow; % Process any pending graphics callbacks
    pause(0.1); % Brief pause to let callbacks finish

    % Use MException object directly instead of lasterror
    stackDepth = numel(ME.stack);
    Text = cell(5*stackDepth + 2, 1);
    Text{1} = ME.message;
    Text{2} = '';

    % Stack always exists in MException, no need to check
    for i = 1:stackDepth
        idx = (i - 1) * 5 + 2;
        Text{idx+1} = ME.stack(i).file;
        Text{idx+2} = ME.stack(i).name;
        Text{idx+3} = sprintf('Line: %d', ME.stack(i).line);
        Text{idx+4} = repmat('-', 1, 42);
    end

    % Display error dialog
    mode = struct('WindowStyle', 'modal', 'Interpreter', 'tex');
    uiwait(errordlg(Text, 'ERROR: Initialize Program failed', mode));
end

function changeAppDesign(src,~)

setSettingsValue('Style',lower(src.Text));
mainCordObj=findobj(src.Parent.Parent,'Tag','mainCard');
mainCordObj.Visible = 'off';
drawnow;
mainFigObj=findobj(src.Parent.Parent,'Type','figure');
appDesignChanger(mainFigObj,getSettingsValue('Style'));
appDesignElementChanger(mainFigObj);
theme(mainFigObj,"light");
drawnow;
mainCordObj.Visible = 'on';
drawnow;
end

function loadDefaultSettings(src,~)

mainFigObj=findobj(src.Parent.Parent,'Type','figure');

uiControls = findobj(mainFigObj,'-not','Tag','','-and','Type','uicontrol','-not','Tag','textFiberInfo',...
    '-and','-not','Style','pushbutton');

for i = 1:numel(uiControls)
    workbar(i/numel(uiControls),'load settings','Load DEFAULT settings',mainFigObj);
    reverseEnable = false;
    if(strcmp(uiControls(i).Enable ,'off'))
        set( uiControls(i), 'Enable', 'on');
        appDesignElementChanger(uiControls(i));
        reverseEnable = true;
    end

    if(strcmp(uiControls(i).Style,'edit'))
        uiControls(i).String = getDefaultSettingsValue(uiControls(i).Tag);
    else
        uiControls(i).Value = str2double( getDefaultSettingsValue(uiControls(i).Tag) );
    end

    if(reverseEnable)
        set( uiControls(i), 'Enable', 'off');
        appDesignElementChanger(uiControls(i));
    end

    if isprop(uiControls(i),'Callback')
        if ~isempty(uiControls(i).Callback)
            feval(get(uiControls(i),'Callback'),uiControls(i));
        end
    end
end
workbar(2,'load settings','Load DEFAULT settings',mainFigObj);
end

function loadUserSettings(src,~)
% mainCordObj=findobj(src.Parent.Parent,'Tag','mainCard');
mainFigObj=findobj(src.Parent.Parent,'Type','figure');

uiControls = findobj(mainFigObj,'-not','Tag','','-and','Type','uicontrol','-not','Tag','textFiberInfo',...
    '-and','-not','Style','pushbutton');

for i = 1:numel(uiControls)
    workbar(i/numel(uiControls),'load settings','Load USER settings',mainFigObj);
    reverseEnable = false;
    if(strcmp(uiControls(i).Enable ,'off'))
        set( uiControls(i), 'Enable', 'on');
        appDesignElementChanger(uiControls(i));
        reverseEnable = true;
    end

    if(strcmp(uiControls(i).Style,'edit'))
        uiControls(i).String = getSettingsValue(uiControls(i).Tag);
    else
        uiControls(i).Value = str2double( getSettingsValue(uiControls(i).Tag) );
    end

    if(reverseEnable)
        set( uiControls(i), 'Enable', 'off');
        appDesignElementChanger(uiControls(i));
    end

    if isprop(uiControls(i),'Callback')
        if ~isempty(uiControls(i).Callback)
            feval(get(uiControls(i),'Callback'),uiControls(i));
        end
    end
end
workbar(2,'load settings','Load USER settings',mainFigObj);
end

function saveUserSettings(src,~)

mainFigObj=findobj(src.Parent.Parent,'Type','figure');

uiControls = findobj(mainFigObj,'-not','Tag','','-and','Type','uicontrol','-not','Tag','textFiberInfo',...
    '-and','-not','Style','pushbutton');

for i = 1:numel(uiControls)
    if i==37
        disp('')
    end
    workbar(i/numel(uiControls),'Save settings','Save USER settings',mainFigObj);
    reverseEnable = false;
    if(strcmp(uiControls(i).Enable ,'off'))
        set( uiControls(i), 'Enable', 'on');
        appDesignElementChanger(uiControls(i));
        reverseEnable = true;
    end

    if(strcmp(uiControls(i).Style,'edit'))
        setSettingsValue(uiControls(i).Tag, uiControls(i).String);
    else
        setSettingsValue(uiControls(i).Tag, num2str(uiControls(i).Value));
    end

    if(reverseEnable)
        set( uiControls(i), 'Enable', 'off');
        appDesignElementChanger(uiControls(i));
    end

end
workbar(2,'Save settings','Save USER settings',mainFigObj);
end

function openInformationFigure(src,~)

mainFigObj=findobj('Tag','mainFigure');
showInfoFigure(mainFigObj);

end




