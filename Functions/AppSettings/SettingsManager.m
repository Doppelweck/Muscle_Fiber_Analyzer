classdef SettingsManager < handle
    properties (Access = private)
        settings
        settingsPath
        userValueIdx = 2
        deafultValueIdx = 3
    end
    
    methods (Access = private)
        % Private constructor - use getInstance() instead
        function obj = SettingsManager()
            currentFile = mfilename('fullpath');
            [pathstr, ~, ~] = fileparts(currentFile);
            obj.settingsPath = fullfile(pathstr, 'AppSettings.mat');
            
            if isfile(obj.settingsPath)
                data = load(obj.settingsPath);
                obj.settings = data.Settings;
            else
                % Initialize with empty 3-column cell array
                obj.settings = cell(0, 3);
            end
        end
    end
    
    methods (Static)
        function obj = getInstance()
            % Singleton pattern - only one instance exists
            persistent instance
            if isempty(instance) || ~isvalid(instance)
                instance = SettingsManager();
            end
            obj = instance;
        end
        
        function clearInstance()
            % Utility to force reload settings from disk
            clear SettingsManager
        end
    end
    
    methods
        function value = getValue(obj, searchString)
            % Get value from column 2
            idx = find(strcmp(obj.settings(:, 1), searchString), 1);
            if ~isempty(idx)
                value = obj.settings{idx, obj.userValueIdx};
            else
                value = [];
            end
        end
        
        function value = getDefaultValue(obj, searchString)
            % Get default value from column 3
            idx = find(strcmp(obj.settings(:, 1), searchString), 1);
            if ~isempty(idx)
                value = obj.settings{idx,obj.deafultValueIdx};
            else
                value = [];
            end
        end
        
        function setValue(obj, settingsString, value)
            % Set value in column 2
            idx = find(strcmp(obj.settings(:, 1), settingsString), 1);
            
            if isempty(idx)
                % Add new setting
                obj.settings{end+1, 1} = settingsString;
                obj.settings{end, obj.userValueIdx} = value;
                % Column 3 (default) stays empty for new settings
            else
                % Update existing setting
                obj.settings{idx, obj.userValueIdx} = value;
            end
            
            obj.save();
        end
        
        function setDefaultValue(obj, settingsString, value)
            % Set default value in column 3
            idx = find(strcmp(obj.settings(:, 1), settingsString), 1);
            
            if isempty(idx)
                % Add new setting with default only
                obj.settings{end+1, 1} = settingsString;
                obj.settings{end, obj.deafultValueIdx} = value;
            else
                obj.settings{idx, obj.deafultValueIdx} = value;
            end
            
            obj.save();
        end
        
        function tf = exists(obj, settingsString)
            % Check if setting exists
            idx = find(strcmp(obj.settings(:, 1), settingsString), 1);
            tf = ~isempty(idx);
        end
        
        function removeSetting(obj, settingsString)
            % Remove a setting entirely
            idx = find(strcmp(obj.settings(:, 1), settingsString), 1);
            if ~isempty(idx)
                obj.settings(idx, :) = [];
                obj.save();
            end
        end
        
        function allSettings = getAllSettings(obj)
            % Return all settings
            allSettings = obj.settings;
        end
        
        function keys = getKeys(obj)
            % Return all setting keys
            if isempty(obj.settings)
                keys = {};
            else
                keys = obj.settings(:, 1);
            end
        end
        
        function resetToDefaults(obj)
            % Reset all values (column 2 userValueIdx) to defaults (column 3 deafultValueIdx)
            for i = 1:size(obj.settings, 1)
                if ~isempty(obj.settings{i, 3})
                    obj.settings{i, obj.userValueIdx} = obj.settings{i, obj.deafultValueIdx};
                end
            end
            obj.save();
        end
        
        function reload(obj)
            % Reload settings from disk
            if isfile(obj.settingsPath)
                data = load(obj.settingsPath);
                obj.settings = data.Settings;
            end
        end
        
        function save(obj)
            % Save settings to disk
            Settings = obj.settings;
            save(obj.settingsPath, 'Settings');
        end
    end
end