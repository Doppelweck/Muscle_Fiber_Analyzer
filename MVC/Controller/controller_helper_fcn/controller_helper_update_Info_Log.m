function controller_helper_update_Info_Log(viewHandle, modelHandle)

%Is called when InfoMessage string changes from the corresponding controller. 
% Appends the text in InfoMessage to the log text in the GUI.

temp=get(viewHandle.B_InfoText, 'String');
InfoText = cat(1, temp, {modelHandle.InfoMessage});
set(viewHandle.B_InfoText, 'String', InfoText);
set(viewHandle.B_InfoText, 'Value' , length(viewHandle.B_InfoText.String));
drawnow;
set(viewHandle.B_InfoText, 'ListboxTop' , length(viewHandle.B_InfoText.String));
viewHandle.B_InfoText.ListboxTop =length(viewHandle.B_InfoText.String);
drawnow;

end