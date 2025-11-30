
function my_busy_indicator(obj,status)
% See: http://undocumentedmatlab.com/blog/animated-busy-spinning-icon

if status
    %create indicator object and disable GUI elements
    set(obj.mainFigure,'pointer','watch');

    obj.modelEditHandle.busyObj = getUIControlEnabledHandles(obj.viewEditHandle);

    set( obj.modelEditHandle.busyObj, 'Enable', 'off');
    %appDesignElementChanger(obj.panelControl);

else

    if ~isempty(obj.modelEditHandle.busyObj)
        valid = isvalid(obj.modelEditHandle.busyObj);
        obj.modelEditHandle.busyObj(~valid)=[];
        set( obj.modelEditHandle.busyObj, 'Enable', 'on')
        %appDesignElementChanger(obj.panelControl);
    end

    workbar(1.5,'delete workbar','delete workbar',obj.mainFigure);
    set(obj.mainFigure,'pointer','arrow');
end
end