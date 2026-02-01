function value = getDefaultSettingsValue(searchString)
    global APP_SETTINGS

    if isempty(APP_SETTINGS)
        % Load settings
        currentFile = mfilename('fullpath');
        data = loadSettings(currentFile);
        APP_SETTINGS = data.Settings;
    end
    
    idx = find(strcmp(APP_SETTINGS(:, 1), searchString), 1);
    value = [];  % default
    if ~isempty(idx)
        value = APP_SETTINGS{idx, 3};
    end
end