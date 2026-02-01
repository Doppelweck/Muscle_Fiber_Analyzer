function value = getSettingsValue(searchString)
    global APP_SETTINGS

    if isempty(APP_SETTINGS)
        % Load settings
        currentFile = mfilename('fullpath');
        data = loadSettings(currentFile);
        APP_SETTINGS = data.Settings;
    end
    
    idx = find(strcmp(APP_SETTINGS(:, 1), searchString), 1);
    value = ~isempty(idx) && APP_SETTINGS{idx, 2} || [];
end