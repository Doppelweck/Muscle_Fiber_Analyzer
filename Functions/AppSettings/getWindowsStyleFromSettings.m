function WindowStyle = getWindowsStyleFromSettings()
switch getSettingsValue('AppState')
    case 'develop'
        WindowStyle = 'normal';
    case 'production'
        WindowStyle = 'modal';
    otherwise
        WindowStyle = 'modal';
end
end