function controller_helper_error_message(obj)
%CONTROLLER_HELPER_ERROR_MESSAGE Summary of this function goes here
%   Detailed explanation goes here
ErrorInfo = lasterror;
Text = cell(5*size(ErrorInfo.stack,1)+2,1);
Text{1,1} = ErrorInfo.message;
Text{2,1} = '';

if any(strcmp('stack',fieldnames(ErrorInfo)))
    for i=1:size(ErrorInfo.stack,1)
        idx = (i - 1) * 5 + 2;
        Text{idx+1,1} = [ErrorInfo.stack(i).file];
        Text{idx+2,1} = [ErrorInfo.stack(i).name];
        Text{idx+3,1} = ['Line: ' num2str(ErrorInfo.stack(i).line)];
        Text{idx+4,1} = '------------------------------------------';
    end
end

mode = struct('WindowStyle','modal','Interpreter','tex');
beep
uiwait(errordlg(Text,'ERROR: Edit-Mode',mode));

workbar(1.5,'delete workbar','delete workbar',obj.mainFigure);
obj.busyIndicator(0);
drawnow;
end