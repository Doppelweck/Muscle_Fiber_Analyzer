function colorVaule = getHighlightColorValue(colorStr)
%GETHIGHLIGHTCOLOR Summary of this function goes here
%   Detailed explanation goes here
if nargin < 1
    colorStr = getSettingsValue('HighlightColor');
end

switch colorStr
    case 'none'
        colorVaule = [0.490196078431373 0.490196078431373 0.490196078431373];
    case 'red'
        colorVaule = [1 0 0];
    case 'green'
        colorVaule = [0 1 0];
    case 'cyan'
        colorVaule = [0 1 1];
    case 'magenta'
        colorVaule = [1 0 1];
    case 'yellow'
        colorVaule = [1 1 0];
    case 'orange'
        colorVaule = [1 0.5 0];
    case 'purple'
        colorVaule = [128 63 152]./255;
    case 'blue'
        colorVaule = [51 153 255]./255;
    case 'black'
        colorVaule = [0 0 0];
    case 'white'
        colorVaule = [1 1 1];
end
 
colorVaule = colorVaule.*0.8; %Make it slighlty darker

end