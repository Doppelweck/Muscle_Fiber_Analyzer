try
    


    % % find starting path
    warning('off', 'all');
    
    if ~isdeployed
        path = cd;
        % add files to the current matalb path
        addpath(genpath('MVC'));
        addpath(genpath('Functions'));
        addpath(genpath('Icons'));
        %pause(0.5);
        cl;
    end

    setSettingsValue('AppState','develop'); %Can be 'develop' or 'production'. 'develop' will set certain 'modal' windows to 'normal'

    build_up_time_delay = 0.300;
    
    setSettingsValue('AppName','Muscle-Fiber-Analyzer');
    setSettingsValue('Version','1.6');
    setSettingsValue('Day','11');
    setSettingsValue('Month','March');
    setSettingsValue('Year','2025');
    versionString = ['Version ' getSettingsValue('Version') '  ' getSettingsValue('Day') '-' getSettingsValue('Month') '-' getSettingsValue('Year')];
    % write the current Version to LATEST.txt
    test = fullfile(pwd, 'LATEST.txt');
    writeVersionToTxt(versionString,test);
    [newVersionAvailable, checkSuccessfull, newVersion] = checkAppForNewVersion(versionString);

    params = view_helper_default_params();

    % create main figure
    mainFig = uifigure(...
        'Visible','on',...
        'Name',[getSettingsValue('AppName') ' ' getSettingsValue('Version')],...
         params.default_uifugure{:},...
        'Tag','mainFigure');
    theme(mainFig,getSettingsValue('Style'));
    %set(mainFig,'WindowState','maximized');


    %Create Start Screen
    [hf, LoadingText] = startSrcreen();
    %pause(build_up_time_delay);
    drawnow limitrate;
    update_menu_bar_main_figure(mainFig,versionString,...
        @menu_callback_change_app_theme,...
        @menu_callback_change_app_color,...
        @menu_callback_load_user_settings,...
        @menu_callback_save_user_settings,...
        @menu_callback_show_abaut_figure);

    figure(hf); drawnow limitrate;
    set(hf,'WindowStyle','alwaysontop'); drawnow limitrate;
    set(hf,'WindowStyle',getWindowsStyleFromSettings());drawnow limitrate;
    figure(hf); drawnow limitrate; 
    %pause(build_up_time_delay);

    %create card panel onbject
    mainCard = uix.CardPanel('Parent', mainFig,'Selection',0,'Tag','mainCard');
    LoadingText.String='Loading please wait...   Initialize VIEW-Components...';
    %Init VIEW's
    viewEditHandle = viewEdit(mainCard);
    LoadingText.String='Loading please wait...   Initialize VIEW-Edit...';
    mainCard.Selection = 1; 
    drawnow limitrate;%pause(build_up_time_delay);drawnow limitrate;
    viewAnalyzeHandle = viewAnalyze(mainCard);
    LoadingText.String='Loading please wait...   Initialize VIEW-Analyze...';
    mainCard.Selection = 2; 
    drawnow limitrate;%pause(build_up_time_delay);drawnow limitrate;
    viewResultsHandle = viewResults(mainCard);
    LoadingText.String='Loading please wait...   Initialize VIEW-Results...';
    mainCard.Selection = 3;
    drawnow limitrate;%pause(build_up_time_delay);drawnow limitrate;
    mainCard.Selection = 1; drawnow limitrate;

    LoadingText.String='Loading please wait...   Load User Settings...';
    % LOAD USER Settings
    %Color
    panelObj=findall(mainCard,'Type','uipanel');
    colorVaule = getHighlightColorValue();
    set(panelObj,'HighlightColor',colorVaule);
    drawnow limitrate
    %Ui Controls
    menu_callback_load_user_settings();

    drawnow limitrate;%pause(build_up_time_delay);

    LoadingText.String='Loading please wait...   Initialize MODEL-Components...';
    %Init MODEL's
    modelEditHandle = modelEdit();
    modelAnalyzeHandle = modelAnalyze();
    modelResultsHandle = modelResults();
    %pause(build_up_time_delay)

    LoadingText.String='Loading please wait...   Initialize CONTROLLER-Components...';
    %Init CONTROLLER's
    controllerEditHandle = controllerEdit(mainFig, mainCard, viewEditHandle, modelEditHandle);
    controllerAnalyzeHandle = controllerAnalyze(mainFig, mainCard, viewAnalyzeHandle, modelAnalyzeHandle);
    controllerResultsHandle = controllerResults(mainFig, mainCard, viewResultsHandle, modelResultsHandle);
    %pause(build_up_time_delay)

    LoadingText.String='Loading please wait...   Connecting components...';
    %Connecting Model's and their Controller's
    modelEditHandle.controllerEditHandle = controllerEditHandle;
    modelAnalyzeHandle.controllerAnalyzeHandle = controllerAnalyzeHandle;
    modelResultsHandle.controllerResultsHandle = controllerResultsHandle;
    %pause(build_up_time_delay)

    LoadingText.String='Loading please wait...   Update app design...';
    drawnow limitrate;
    %pause(build_up_time_delay)

    LoadingText.String='Loading please wait...   Start application...';
    %Connecting Controller's to each other
    controllerEditHandle.controllerAnalyzeHandle = controllerAnalyzeHandle;
    controllerAnalyzeHandle.controllerEditHandle = controllerEditHandle;
    controllerAnalyzeHandle.controllerResultsHandle = controllerResultsHandle;
    controllerResultsHandle.controllerAnalyzeHandle = controllerAnalyzeHandle;
    %pause(build_up_time_delay)

    LoadingText.String='Run application';
    set(mainFig,'WindowState','maximized');
    drawnow limitrate;
    %pause(build_up_time_delay);

    set(mainFig,'WindowState','maximized');
    drawnow limitrate;
    %pause(2);
    delete(hf);
    drawnow limitrate;
    delete(LoadingText);

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
    if exist('LoadingText', 'var') && isvalid(LoadingText)
        delete(LoadingText);
    end
    if exist('VersionText', 'var') && isvalid(VersionText)
        delete(VersionText);
    end

    % Delete all objects in main figure
    if exist('mainFig', 'var') && isvalid(mainFig)
        delete(findall(mainFig));
    end

    % Stop any ongoing parallel operations
    drawnow limitrate; % Process any pending graphics callbacks
    %pause(1); % Brief %pause to let callbacks finish

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
    mode = struct('WindowStyle', getWindowsStyleFromSettings(), 'Interpreter', 'none');
    uiwait(errordlg(Text, 'ERROR: Initialize Program failed', mode));
end





