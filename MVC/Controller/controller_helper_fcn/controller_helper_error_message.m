function controller_helper_error_message(obj)
%CONTROLLER_HELPER_ERROR_MESSAGE Summary of this function goes here
%   Detailed explanation goes here

if nargin == 1
    objIsgiven = true;
else
    %No obj given. example error in main.m
    objIsgiven= false;
    obj = [];
end


ErrorInfo = lasterror;
stackDepth = numel(ErrorInfo.stack);
Text = cell(5*stackDepth + 2, 1);
Text{1,1} = ErrorInfo.message;
Text{2,1} = '';

for i=1:stackDepth
    idx = (i - 1) * 5 + 2;
    Text{idx+1,1} = [ErrorInfo.stack(i).file];
    Text{idx+2,1} = [ErrorInfo.stack(i).name];
    Text{idx+3,1} = ['Line: ' num2str(ErrorInfo.stack(i).line)];
    Text{idx+4,1} = '------------------------------------------';
end


mode = struct('WindowStyle',getWindowsStyleFromSettings(),'Interpreter','none');
beep
uiwait(errordlg(Text,['ERROR ' getSettingsValue('AppName')],mode));

if objIsgiven
    workbar(1.5,'delete workbar','delete workbar',obj.mainFigure);
    obj.busyIndicator(0);
end
drawnow;
end