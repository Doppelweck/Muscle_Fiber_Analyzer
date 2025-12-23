function controller_helper_busy_indicator(obj,status,viewHandle,modelHandel)

if status
    %create indicator object and disable GUI elements
    set(obj.mainFigure,'pointer','watch');
    modelHandel.busyObj = getUIControlEnabledHandles(viewHandle);
    set( modelHandel.busyObj, 'Enable', 'off');

else

    if ~isempty(modelHandel.busyObj)
        valid = isvalid(modelHandel.busyObj);
        modelHandel.busyObj(~valid)=[];
        set( modelHandel.busyObj, 'Enable', 'on')
    end

    workbar(1.5,'delete workbar','delete workbar',obj.mainFigure);
    set(obj.mainFigure,'pointer','arrow');
    
end
    drawnow limitrate
end