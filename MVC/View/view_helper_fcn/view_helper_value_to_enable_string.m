function enableString = view_helper_value_to_enable_string(value)
%VIEW_HELPER_VALUE_TO_ENABLE_STRING Summary of this function goes here

if logical(value)
    enableString = 'on';
else
    enableString = 'off';
end

end