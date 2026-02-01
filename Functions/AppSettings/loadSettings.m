function data = loadSettings(currentFile)
    [pathstr, ~, ~] = fileparts(currentFile);
    settingsFile = fullfile(pathstr, 'AppSettings.mat');
    data = load(settingsFile);
end