function [hf, LoadingText]= startSrcreen()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
windowStyle = getWindowsStyleFromSettings();
appName = getSettingsValue('AppName');

Pic = imread('StartScreen5.png');

hf  = uifigure('Visible','on','MenuBar','none','NumberTitle','off',...
    'WindowStyle',windowStyle,'Units','pixels','ToolBar','none');
theme(hf ,'light');
ha = axes('Parent',hf,'Visible','on','Units','pixels');
axis(ha ,'image');

set(ha, 'LooseInset', [0,0,0,0]);
ih = imshow(Pic,'Parent',ha);
imxpos = get(ih,'XData');
imypos = get(ih,'YData');
figpos = get(hf,'Position');
figpos(3:4) = [imxpos(2) imypos(2)];
set(ha,'Unit','Normalized','Position',[0,0,1,1]);
set(hf, 'Units','pixels');
set(hf,'Position',figpos);
movegui(hf,'center');
set(hf,'CloseRequestFcn','');
set(hf,'Visible','off');
set(hf,'WindowStyle',getWindowsStyleFromSettings());

versionString = ['Version ' getSettingsValue('Version')]; % '  ' getSettingsValue('Day') '-' getSettingsValue('Month') '-' getSettingsValue('Year')];

text(ha,0.53,0.945, appName,'units','normalized','FontUnits','normalized','FontWeight','bold','FontSize',0.071,'Color',[0 0 0]);
text(ha,0.83,0.875,versionString,'units','normalized','FontUnits','normalized','FontWeight','bold','FontSize',0.035,'Color','k');
text(ha,0.02,0.16,'Developed by:','units','normalized','FontUnits','normalized','FontWeight','bold','FontSize',0.04,'Color','k');
text(ha,0.02,0.115,['Sebastian Friedrich  2017 - ' getSettingsValue('Year')],'units','normalized','FontUnits','normalized','FontWeight','bold','FontSize',0.03,'Color','k');
text(ha,0.02,0.09,'sebastian.friedrich.software@gmail.com','units','normalized','FontUnits','normalized','FontWeight','bold','FontSize',0.025,'Color','k');

LoadingText=text(ha,0.02,0.035,'Loading please wait... Initialize application...','units','normalized','FontWeight','bold','FontUnits','normalized','FontSize',0.03,'Color','k');

set(hf,'Visible','on');
set(hf,'WindowStyle','alwaysontop');
set(hf,'WindowStyle',windowStyle);
end

