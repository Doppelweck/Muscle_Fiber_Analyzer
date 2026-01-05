function workbar(fractiondone, message, progtitle, mainFig,isVisible)
% WORKBAR Graphically monitors progress of calculations
%   WORKBAR(X) creates and displays the workbar with the fractional length
%   "X". It is an alternative to the built-in matlab function WAITBAR,
%   Featuring:
%       - Doesn't slow down calculations
%       - Stylish progress look
%       - Requires only a single line of code
%       - Displays time remaining
%       - Display time complete
%       - Capable of title and description
%       - Only one workbar can exist (avoids clutter)
%
%   WORKBAR(X, MESSAGE) sets the fractional length of the workbar as well as
%   setting a message in the workbar window.
%
%   WORKBAR(X, MESSAGE, TITLE) sets the fractional length of the workbar,
%   message and title of the workbar window.
%
%   WORKBAR is typically used inside a FOR loop that performs a lengthy 
%   computation.  A sample usage is shown below:
% 
%   for i = 1:10000
%       % Calculation
%       workbar(i/10000,'Performing Calclations...','Progress') 
%   end
%
%   Another example:
%
%   for i = 1:10000
%         % Calculation
%         if i < 2000,
%              workbar(i/10000,'Performing Calclations (Step 1)...','Step 1') 
%         elseif i < 4000
%              workbar(i/10000,'Performing Calclations (Step 2)...','Step 2')
% 	    elseif i < 6000
%              workbar(i/10000,'Performing Calclations (Step 3)...','Step 3')
%         elseif i < 8000
%              workbar(i/10000,'Performing Calclations (Step 4)...','Step 4')
%         else
%              workbar(i/10000,'Performing Calclations (Step 5)...','Step 5')
%         end
%     end
%
% See also: WAITBAR, TIMEBAR, PROGRESSBAR

% Adapted from: 
% Chad English's TIMEBAR
% and Steve Hoelzer's PROGRESSBAR
%
% Created by:
% Daniel Claxton
%
% Last Modified: 3-17-05
arguments
    fractiondone double = 0
    message char = ' '
    progtitle char = ' '
    mainFig handle = gcf
    isVisible char = 'on'
end

persistent progfig progpatch starttime lastupdate text winState windowStyle

if isempty(windowStyle)
    windowStyle = getWindowsStyleFromSettings();
end

% Set defaults for variables not passed in
if nargin < 1
    fractiondone = 0;
end

try
    % Access progfig to see if it exists ('try' will fail if it doesn't)
    dummy = get(progfig,'UserData');
    
    % If progress bar needs to be reset, close figure and set handle to empty
    if fractiondone == 0
%         setAlwaysOnTop(progfig,false);
        delete(progfig) % Close progress bar
        progfig = []; % Set to empty so a new progress bar is created
    end
catch
    progfig = []; % Set to empty so a new progress bar is created
end

if nargin < 2 && isempty(progfig)
    message = '';
end
if nargin < 3 && isempty(progfig)
    progtitle = '';
    mainFig =[];
end



% If task completed, close figure and clear vars, then exit
percentdone = floor(100*fractiondone);
if percentdone > 100 % Task completed
    if ~isempty(progfig)
%         setAlwaysOnTop(progfig,false);
    end
    set(progfig,'pointer','arrow');
    delete(progfig) % Close progress bar

    clear progfig progpatch starttime lastupdate % Clear persistent vars
    if strcmp(winState,'maximized')
        set(mainFig,'WindowState','maximized');
    end
    return
end

if percentdone == 0
    starttime = clock;
end
% Create new progress bar if needed
if isempty(progfig)
    winState=get(mainFig,'WindowState');
    
    %%%%%%%%%% SET WINDOW SIZE AND POSITION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    winwidth = 400;                                         % Width of timebar window
    winheight = 75;                                         % Height of timebar window
    
    if ~isempty(mainFig)
    set(mainFig,'Units','pixels');  
    posMainFig = get(mainFig,'Position');
    set(mainFig,'Units','normalized');
    winpos = [posMainFig(1), posMainFig(2),...
        winwidth, winheight]; 
    
    else
    screensize = get(0,'screensize');                       % User's screen size [1 1 width height]
    screenwidth = screensize(3);                            % User's screen width
    screenheight = screensize(4);                           % User's screen height
    winpos = [0.5*(screenwidth-winwidth), ...
            0.5*(screenheight-winheight),...
            winwidth, winheight];                           % Position of timebar window origin
        
    end    
    wincolor = [ 0.9254901960784314,...
            0.9137254901960784,...
            0.8470588235294118 ];                           % Define window color
    est_text = 'Estimated time remaining: ';                % Set static estimated time text
    pgx = [0 0];
    pgy = [41 43];
    pgw = [57 57];
    pgh = [0 -3];
    m = 1;
    %%%%%%%% END SET WINDOW SIZE AND POSITION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
     % Initialize progress bar
    progfig = uifigure('menubar','none',...                   % Turn figure menu display off
         'numbertitle','off',...                            % Turn figure numbering off
         'position',winpos,...                              % Set the position of the figure as above
         'resize','off',...                                 % Turn of figure resizing
         'tag','timebar',...                                % Tag the figure for later checking
         'WindowStyle',windowStyle,...                         % Stay figure in forground                          
         'Visible','off');
    theme(progfig,mainFig.Theme);
    
    movegui(progfig,'center');
    set(progfig,'Visible','on')
    drawnow;
    
    set(progfig,'CloseRequestFcn','');
    work.progtitle = progtitle;                             % Store initial values for title
    work.message = message;                                 % Store initial value for message
    set(progfig,'userdata',work);                           % Save text in figure's userdata

    % ------- Delete Me (Begin) ----------
%     winchangeicon(progfig,'MavLogo.ico');                   % Change icon (Not Released)
    % ------- Delete Me (End) ------------
     
    imgaxe = axes('parent',progfig,...                               % Set the progress bar parent to the figure
        'units','pixels',...                                % Provide axes units in pixels
        'pos',[10 winheight-45 winwidth-75 15],...          % Set the progress bar position and size
        'xlim',[0 1],...                                    % Set the range from 0 to 1
        'visible','off');                                 % Turn off axes
 
    
    imshow(progimage(m),'Parent',imgaxe);                                   % Set Progress Bar Image
    
    progaxes = axes('parent',progfig,...                    % Set the progress bar parent to the figure
        'units','pixels',...                                % Provide axes units in pixels
        'pos',[12-pgx(m) winheight-pgy(m) winwidth-pgw(m)-22 7-pgh(m)],...   % Set the progress bar position and size
        'xlim',[0 1],...                                    % Set the range from 0 to 1
        'visible','off');                                   % Turn off axes

    progpatch = patch(progaxes,...
        'XData',            [1 0 0 1],...                   % Initialize X-coordinates for patch
        'YData',            [0 0 1 1],...                   % Initialize Y-coordinates for patch
        'Facecolor',        'w',...                         % Set Color of patch
        'edgecolor',        'none');                        % Set the edge color of the patch to none
    
    text(1) = uicontrol(progfig,'style','text',...          % Prepare message text (set the style to text)
        'pos',[10 winheight-30 winwidth-20 20],...          % Set the textbox position and size
        'hor','left',...                                    % Center the text in the textbox
        'string',message);                                  % Set the text to the input message
    
    text(2) = uicontrol(progfig,'style','text',...          % Prepare static estimated time text
        'pos',[10 5 winwidth-20 20],...                     % Set the textbox position and size
        'hor','left',...                                    % Left align the text in the textbox
        'string',est_text);                                 % Set the static text for estimated time
    
    text(3) = uicontrol(progfig,'style','text',...          % Prepare estimated time
        'pos',[135 5 winwidth-145 20],...                   % Set the textbox position and size
        'hor','left',...                                    % Left align the text in the textbox
        'string','');                                       % Initialize the estimated time as blank
    
    text(4) = uicontrol(progfig,'style','text',...          % Prepare the percentage progress
        'pos',[winwidth-45 winheight-50 40 20],...          % Set the textbox position and size
        'hor','right',...                                   % Left align the text in the textbox
        'string','');                                       % Initialize the progress text as blank
    

    drawnow;
    % Set time of last update to ensure a redraw
    lastupdate = clock - 1;
    
    % Task starting time reference
    if isempty(starttime) | (fractiondone == 0)
        starttime = clock;
    end
    drawnow;   
end

% Enforce a minimum time interval between updates
if etime(clock,lastupdate) < 0.01
    return
end

% Update progress patch
n = [.03857 ];
set(progpatch,'XData',[1 fractiondone fractiondone 1])

% Set all dynamic text
runtime = etime(clock,starttime);
if ~fractiondone
    fractiondone = 0.001;
end
work = get(progfig,'userdata');

if exist('progtitle','var')==0; 
progtitle = work.progtitle; 
end 
if exist('message','var')==0; 
message = work.message; 
end

timeleft = runtime/fractiondone - runtime;
timeleftstr = sec2timestr(timeleft);
titlebarstr = sprintf('%2d%%  %s',percentdone,progtitle);
set(progfig,'Name',titlebarstr)
set(text(1),'string',message);
set(text(3),'string',timeleftstr);
set(text(4),'string',[num2str(percentdone) ' %']);
set(progfig,'Visible',isVisible);
if(strcmp(get(progfig,'Visible'),'on'))
    set(progfig,'pointer','watch');
else
    set(progfig,'pointer','arrow');
end
% Force redraw to show changes
drawnow limitrate

% Record time of this update
lastupdate = clock;







% ------------------------------------------------------------------------------
function timestr = sec2timestr(sec)

% Convert seconds to hh:mm:ss
h = floor(sec/3600); % Hours
sec = sec - h*3600;
m = floor(sec/60); % Minutes
sec = sec - m*60;
s = floor(sec); % Seconds

if isnan(sec),
    h = 0;
    m = 0;
    s = 0;
end

if h < 10; h0 = '0'; else h0 = '';end     % Put leading zero on hours if < 10
if m < 10; m0 = '0'; else m0 = '';end     % Put leading zero on minutes if < 10
if s < 10; s0 = '0'; else s0 = '';end     % Put leading zero on seconds if < 10
timestr = strcat(h0,num2str(h),':',m0,...
          num2str(m),':',s0,num2str(s));

function a=progimage(m)
colorVaule = getHighlightColorValue();
colorStr = getSettingsValue('HighlightColor');
if strcmp(colorStr,'none')
    %Default is blue
    colorVaule = [51 153 255]./255;
end
if m == 1
    a=ones(13,385,3);
    a(:,:,1)=ones([13,385])*colorVaule(1);
    a(:,:,2)=ones([13,385])*colorVaule(2);
    a(:,:,3)=ones([13,385])*colorVaule(3);
      
else
    a=ones(13,385,3);
    a(:,:,1)=ones([13,385]);
    a(:,:,2)=ones([13,385]);
    a(:,:,3)=ones([13,385]);
   
end


