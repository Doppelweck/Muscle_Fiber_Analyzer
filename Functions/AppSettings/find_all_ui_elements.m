function allUIElements = find_all_ui_elements(figHandle, varargin)
% FIND_ALL_UI_ELEMENTS Find all UI elements in a figure
%
% Syntax:
%   allUIElements = find_all_ui_elements(figHandle)
%   allUIElements = find_all_ui_elements(figHandle, Name, Value)
%
% Description:
%   Finds both traditional uicontrol elements and modern UI components
%   (App Designer style) in a figure, with options to exclude specific
%   elements by tag or type.
%
% Input Arguments:
%   figHandle - Handle to the figure object
%
% Name-Value Arguments:
%   'ExcludeTags' - Cell array of tags to exclude (default: {'textFiberInfo'})
%   'ExcludeStyles' - Cell array of uicontrol styles to exclude (default: {'pushbutton'})
%   'ExcludeTypes' - Cell array of UI types to exclude (default: {'uibutton'})
%   'IncludeEmptyTags' - Include elements with empty tags (default: false)
%
% Output Arguments:
%   allUIElements - Array of UI element handles
%
% Example:
%   allUIElements = find_all_ui_elements(mainFigObj);
%   allUIElements = find_all_ui_elements(mainFigObj, 'ExcludeTags', {'tag1', 'tag2'});

% Parse input arguments
p = inputParser;
addRequired(p, 'figHandle');
addParameter(p, 'ExcludeTags', {'textFiberInfo'}, @iscell);
addParameter(p, 'ExcludeStyles', {'pushbutton'}, @iscell);
addParameter(p, 'ExcludeTypes', {'uibutton'}, @iscell);
addParameter(p, 'IncludeEmptyTags', false, @islogical);
parse(p, figHandle, varargin{:});

excludeTags = p.Results.ExcludeTags;
excludeStyles = p.Results.ExcludeStyles;
excludeTypes = p.Results.ExcludeTypes;
includeEmptyTags = p.Results.IncludeEmptyTags;

% Find traditional uicontrols
if includeEmptyTags
    uiControls = findobj(figHandle, 'Type', 'uicontrol');
else
    uiControls = findobj(figHandle, '-not', 'Tag', '', 'Type', 'uicontrol');
end

% Exclude specific tags
for i = 1:length(excludeTags)
    uiControls = findobj(uiControls, '-not', 'Tag', excludeTags{i});
end

% Exclude specific styles
for i = 1:length(excludeStyles)
    uiControls = findobj(uiControls, '-not', 'Style', excludeStyles{i});
end

% Find new UI components (App Designer style)
newUITypes = 'ui(dropdown|editfield|numeric|spinner|checkbox|listbox|textarea|slider|knob|gauge|lamp|switch|tree|table|axes|button)';

if includeEmptyTags
    newUIComponents = findobj(figHandle, '-regexp', 'Type', newUITypes);
else
    newUIComponents = findobj(figHandle, '-not', 'Tag', '', '-regexp', 'Type', newUITypes);
end

% Exclude specific tags from new components
for i = 1:length(excludeTags)
    newUIComponents = findobj(newUIComponents, '-not', 'Tag', excludeTags{i});
end

% Exclude specific types
for i = 1:length(excludeTypes)
    newUIComponents = findobj(newUIComponents, '-not', 'Type', excludeTypes{i});
end

% Combine both arrays
allUIElements = [uiControls; newUIComponents];

% Remove duplicates (shouldn't happen, but just in case)
allUIElements = unique(allUIElements);

end