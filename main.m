try
     
    % find starting path
    warning('off', 'all');
    try %%Not need for .exe
        path = cd;
        % add files to the current matalb path
        addpath(genpath('MVC'));
        addpath(genpath('Functions'));
        addpath(genpath('Icons'));
        rmpath(genpath('Functions/OLD_FUNCTIONS_2_BE_REMOVED'));
        pause(0.5);
        cl;
    catch
    end
    
    build_up_time_delay = 0.300;
    
    setSettingsValue('AppState','develop'); %Can be 'develop' or 'production'. 'develop' will set certain 'modal' windows to 'normal'

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
    mainFig = figure(...
        'Visible','off',...
        'Name',['Muscle-Fiber-Classification-Tool ' getSettingsValue('Version')],...
        'DockControls','off',...
        'WindowStyle','normal','NumberTitle','off',...
        'Tag','mainFigure');
    theme(mainFig,getSettingsValue('Style'))


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

    set(mainFig, 'OuterPosition', hf.Position);
    
    set(hf,'Visible','on');
    figure(hf);drawnow;
    set(hf,'WindowStyle','alwaysontop');

    update_menu_bar_main_figure(mainFig,versionString,...
        @changeAppDesign,...
        @loadUserSettings,...
        @saveUserSettings,...
        @openInformationFigure);

    set(mainFig,'Visible','on');
    set(hf,'Visible','on');
    set(hf,'WindowStyle','alwaysontop');
    set(hf,'WindowStyle',getWindowsStyleFromSettings());
    figure(hf);drawnow;
    pause(build_up_time_delay);

    %create card panel onbject
    mainCard = uix.CardPanel('Parent', mainFig,'Selection',0,'Tag','mainCard');
    InfoText.String='Loading please wait...   Initialize VIEW-Components...';
    %Init VIEW's
    viewEditHandle = viewEdit(mainCard);
    InfoText.String='Loading please wait...   Initialize VIEW-Edit...';
    mainCard.Selection = 1; drawnow;
    drawnow;pause(build_up_time_delay);
    viewAnalyzeHandle = viewAnalyze(mainCard);
    InfoText.String='Loading please wait...   Initialize VIEW-Analyze...';
    mainCard.Selection = 2; drawnow;
    drawnow;pause(build_up_time_delay);
    viewResultsHandle = viewResults(mainCard);
    InfoText.String='Loading please wait...   Initialize VIEW-Results...';
    mainCard.Selection = 3; drawnow;
    drawnow;pause(build_up_time_delay);
    mainCard.Selection = 1; drawnow;

    InfoText.String='Loading please wait...   Load User Settings...';
    % LOAD USER Settings
    uiControls = findobj(mainCard,'-not','Tag','','-and','Type','uicontrol','-not','Tag','textFiberInfo',...
        '-and','-not','Style','pushbutton');

    for i = 1:numel(uiControls)
        reverseEnable = false;
        if(strcmp(uiControls(i).Enable ,'off'))
            set( uiControls(i), 'Enable', 'on');
            reverseEnable = true;
        end

        if(strcmp(uiControls(i).Style,'edit'))
            uiControls(i).String = getSettingsValue(uiControls(i).Tag);
        else
            uiControls(i).Value = str2double( getSettingsValue(uiControls(i).Tag) );
        end

        if(reverseEnable)
            set( uiControls(i), 'Enable', 'off');
        end
    end

    drawnow;pause(build_up_time_delay);

    InfoText.String='Loading please wait...   Initialize MODEL-Components...';
    %Init MODEL's
    modelEditHandle = modelEdit();
    modelAnalyzeHandle = modelAnalyze();
    modelResultsHandle = modelResults();
    pause(build_up_time_delay)

    InfoText.String='Loading please wait...   Initialize CONTROLLER-Components...';
    %Init CONTROLLER's
    controllerEditHandle = controllerEdit(mainFig, mainCard, viewEditHandle, modelEditHandle);
    controllerAnalyzeHandle = controllerAnalyze(mainFig, mainCard, viewAnalyzeHandle, modelAnalyzeHandle);
    controllerResultsHandle = controllerResults(mainFig, mainCard, viewResultsHandle, modelResultsHandle);
    pause(build_up_time_delay)

    InfoText.String='Loading please wait...   Connecting components...';
    %Connecting Model's and their Controller's
    modelEditHandle.controllerEditHandle = controllerEditHandle;
    modelAnalyzeHandle.controllerAnalyzeHandle = controllerAnalyzeHandle;
    modelResultsHandle.controllerResultsHandle = controllerResultsHandle;
    pause(build_up_time_delay)

    InfoText.String='Loading please wait...   Update app design...';
    drawnow;
    pause(build_up_time_delay)

    InfoText.String='Loading please wait...   Start application...';
    %Connecting Controller's to each other
    controllerEditHandle.controllerAnalyzeHandle = controllerAnalyzeHandle;
    controllerAnalyzeHandle.controllerEditHandle = controllerEditHandle;
    controllerAnalyzeHandle.controllerResultsHandle = controllerResultsHandle;
    controllerResultsHandle.controllerAnalyzeHandle = controllerAnalyzeHandle;
    pause(build_up_time_delay)

    InfoText.String='Run application';
    drawnow;
    pause(build_up_time_delay);

    theme(mainFig,getSettingsValue('Style'))
    set(mainFig,'WindowState','maximized');
    drawnow;
    pause(2);
    delete(hf);
    set(mainFig,'WindowState','maximized');
    %set(mainFig,'Position',[0.01 0.05 0.98 0.85]);
    drawnow;
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
    pause(1); % Brief pause to let callbacks finish

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
    mode = struct('WindowStyle', getWindowsStyleFromSettings(), 'Interpreter', 'tex');
    uiwait(errordlg(Text, 'ERROR: Initialize Program failed', mode));
end

function changeAppDesign(src,~)

style = lower(src.Text);

mainCordObj=findobj(src.Parent.Parent,'Tag','mainCard');
mainCordObj.Visible = 'off';
drawnow;
mainFigObj=findobj(src.Parent.Parent,'Type','figure');
theme(mainFigObj,style)

drawnow;
mainCordObj.Visible = 'on';
drawnow;
end

function loadUserSettings(src,~)
mainFigObj=findobj(src.Parent.Parent,'Type','figure');
theme(mainFigObj,getDefaultSettingsValue('Style'))

uiControls = find_all_ui_elements(mainFigObj);


for i = 1:numel(uiControls)
    workbar(i/numel(uiControls),'load settings','Load USER settings',mainFigObj);
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

    switch src.Text
        case 'Load User Settings'
            switch ui_type
                case 'edit'
                    uiControls(i).String = getSettingsValue(uiControls(i).Tag);
                case 'uidropdown'
                    uiControls(i).Value = getSettingsValue(uiControls(i).Tag);
                otherwise
                    uiControls(i).Value = str2double( getSettingsValue(uiControls(i).Tag) );
            end

        case 'Load Default Settings'
            switch ui_type
                case 'edit'
                    uiControls(i).String = getDefaultSettingsValue(uiControls(i).Tag);
                case 'uidropdown'
                    uiControls(i).Value = getDefaultSettingsValue(uiControls(i).Tag);
                otherwise
                    uiControls(i).Value = str2double( getDefaultSettingsValue(uiControls(i).Tag) );
           end

        otherwise
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
end

function saveUserSettings(src,~)

mainFigObj=findobj(src.Parent.Parent,'Type','figure');

setSettingsValue('Style',mainFigObj.Theme.BaseColorStyle)

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

function openInformationFigure(src,~)

mainFigObj=findobj('Tag','mainFigure');
showInfoFigure(mainFigObj);

end




