function enableString = view_helper_value_to_enable_string(value)
%VIEW_HELPER_VALUE_TO_ENABLE_STRING Summary of this function goes here

try
    if logical(value)
        enableString = 'on';
    else
        enableString = 'off';
    end
catch 
    warning('Error in %s','view_helper_value_to_enable_string')
    enableString = 'off';
end