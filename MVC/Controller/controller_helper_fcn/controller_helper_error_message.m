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

Text = Text(~cellfun('isempty', Text));
mode = struct('WindowStyle',getWindowsStyleFromSettings(),'Interpreter','none');
beep

fig = findall(0,'Type','figure','Tag','mainFigure');
msg = Text;
title = 'ERROR';
btnText = "Send Error Report";

selection = uiconfirm(fig,msg,title, ...
    "Options",["OK",btnText], ...
    "DefaultOption",1,"CancelOption",1,...
    "Icon",'error');

try
    if strcmp(selection,btnText)
        % E-Mail-Adresse
        recipient = getSettingsValue('EMail');
        
        % Betreff
        subject = sprintf(['Error Report: ' getSettingsValue('AppName') ' ' getSettingsValue('Version')]);
        
        % Nachrichtentext
        body = strjoin(msg, char(10));  % WICHTIG: Cell Array zusammenfügen
        
        % Standard-Mail-Client öffnen
        mailtoLink = sprintf('mailto:%s?subject=%s&body=%s', ...
            recipient, ...
            subject, ...
            body);
        
        web(mailtoLink, '-browser');
    end
catch
end

if objIsgiven
    workbar(1.5,'delete workbar','delete workbar',obj.mainFigure);
    obj.busyIndicator(0);
end
drawnow;
end

function encoded = urlencode(str)
    str = char(str);
    
    % Ersetze Sonderzeichen
    encoded = strrep(str, '%', '%25');  % % zuerst!
    encoded = strrep(encoded, ' ', '%20');
    encoded = strrep(encoded, char(10), '%0A');  % Newline
    encoded = strrep(encoded, char(13), '%0D');  % Carriage return
    encoded = strrep(encoded, '!', '%21');
    encoded = strrep(encoded, '"', '%22');
    encoded = strrep(encoded, '#', '%23');
    encoded = strrep(encoded, '$', '%24');
    encoded = strrep(encoded, '&', '%26');
    encoded = strrep(encoded, '''', '%27');
    encoded = strrep(encoded, '(', '%28');
    encoded = strrep(encoded, ')', '%29');
    encoded = strrep(encoded, '*', '%2A');
    encoded = strrep(encoded, '+', '%2B');
    encoded = strrep(encoded, ',', '%2C');
    encoded = strrep(encoded, '/', '%2F');
    encoded = strrep(encoded, ':', '%3A');
    encoded = strrep(encoded, ';', '%3B');
    encoded = strrep(encoded, '=', '%3D');
    encoded = strrep(encoded, '?', '%3F');
    encoded = strrep(encoded, '@', '%40');
    encoded = strrep(encoded, '[', '%5B');
    encoded = strrep(encoded, ']', '%5D');
end