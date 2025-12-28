classdef controllerEdit < handle
    %controllerEdit   Controller of the edit-MVC (Model-View-Controller).
    %Controls the communication and data exchange between the view
    %instance and the model instance. Connected to the analyze
    %controller to communicate with the analyze MVC and to exchange data
    %between them.
    %
    %
    %======================================================================
    %
    % AUTHOR:           - Sebastian Friedrich,
    %                     Trier University of Applied Sciences, Germany
    %
    % SUPERVISOR:       - Prof. Dr.-Ing. K.P. Koch
    %                     Trier University of Applied Sciences, Germany
    %
    %                   - Mr Justin Perkins, BVetMed MS CertES Dip ECVS MRCVS
    %                     The Royal Veterinary College, Hertfordshire United Kingdom
    %
    % FIRST VERSION:    30.12.2016 (V1.0)
    %
    % REVISION:         none
    %
    %======================================================================
    %
    
    properties
        mainFigure; %handle to main figure.
        
        mainCardPanel; %handle to card panel in the main figure.
        panelControl;    %handle to panel with the controls included
        panelAxes;   %handle to panel with the image axes included
        panelEdit; %handle to panel with editView components.
        
        viewEditHandle; %hande to viewEdit instance.
        modelEditHandle; %hande to modelEdit instance.
        controllerAnalyzeHandle; %hande to controllerAnalyze instance.
        
        allListeners;
        
        winState;
        CheckMaskActive = false;
    end
    
    methods
        
        function obj = controllerEdit(mainFigure,mainCardPanel,viewEditH,modelEditH)
            % Constuctor of the controllerEdit class. Initialize the
            % callback and listener functions to observes the corresponding
            % View objects. Saves the needed handles of the corresponding
            % View and Model in the properties.
            
            obj.mainFigure = mainFigure;
            obj.mainCardPanel = mainCardPanel;
            
            obj.viewEditHandle = viewEditH;
            
            obj.modelEditHandle = modelEditH;
            
            obj.panelEdit = obj.viewEditHandle.panelEdit;
            obj.panelControl = obj.viewEditHandle.panelControl;
            obj.panelAxes = obj.viewEditHandle.panelAxes;
            
            obj.addMyListener();
            
            obj.setInitValueInModel();
            
            obj.addMyCallbacks();
            
            obj.addWindowCallbacks();
            
            % show init text in the info log
            obj.modelEditHandle.InfoMessage = '*** Start program ***';
            obj.modelEditHandle.InfoMessage = getSettingsValue('AppName');
            obj.modelEditHandle.InfoMessage = ['Version ' getSettingsValue('Version') ' - ' getSettingsValue('Day') '.' getSettingsValue('Month') '.' getSettingsValue('Year')];
            obj.modelEditHandle.InfoMessage = ' ';
            obj.modelEditHandle.InfoMessage = 'Developed by:';
            obj.modelEditHandle.InfoMessage = 'Sebastian Friedrich';
            obj.modelEditHandle.InfoMessage = ' ';
            obj.modelEditHandle.InfoMessage = 'In cooperation with:';
            obj.modelEditHandle.InfoMessage = 'Trier University of Applied Sciences, GER';
            obj.modelEditHandle.InfoMessage = 'The Royal Veterinary College, UK';
            obj.modelEditHandle.InfoMessage = ' ';
            obj.modelEditHandle.InfoMessage = 'Press "New file" to start';
            
            % disable all UI controls
            uicontrols = view_helper_get_all_ui_controls(obj.viewEditHandle);
            view_helper_set_enabled_ui_controls(uicontrols, 'off');
            % enable only NewFile button
            set(obj.viewEditHandle.B_NewPic,'Enable','on');
            
        end % end constructor
        
        function addMyListener(obj)
            % add listeners to the several button objects in the viewEdit
            % instance and value objects or handles in the modelEdit.

            % listeners MODEL
            obj.allListeners{end+1} = addlistener(obj.modelEditHandle,'InfoMessage', 'PostSet',@obj.updateInfoLogEvent);
            
            % listeners VIEW
            obj.allListeners{end+1} = addlistener(obj.viewEditHandle.B_Threshold, 'ContinuousValueChange',@obj.thresholdEvent);
            obj.allListeners{end+1} = addlistener(obj.viewEditHandle.B_Alpha, 'ContinuousValueChange',@obj.alphaMapEvent);
            obj.allListeners{end+1} = addlistener(obj.viewEditHandle.B_LineWidth, 'ContinuousValueChange',@obj.lineWidthEvent);
        end
        
        function addMyCallbacks(obj)
            % Set callback functions to several button objects in the viewEdit
            % instance and handles im the editModel.
           
            %ButtonDownFcn of the binary pic. Starts the hand draw
            %functions
            set(obj.modelEditHandle.handlePicBW,'ButtonDownFcn',@obj.startDragEvent);
            
            set(obj.viewEditHandle.B_Undo,'Callback',@obj.undoEvent);
            set(obj.viewEditHandle.B_Redo,'Callback',@obj.redoEvent);
            set(obj.viewEditHandle.B_NewPic,'Callback',@obj.newFileEvent);
            set(obj.viewEditHandle.B_StartAnalyzeMode,'Callback',@obj.startAnalyzeModeEvent);
            set(obj.viewEditHandle.B_CheckPlanes,'Callback',@obj.checkPlanesEvent);
            set(obj.viewEditHandle.B_CheckMask,'Callback',@obj.checkMaskEvent);
            set(obj.viewEditHandle.B_Invert,'Callback',@obj.invertEvent);
            set(obj.viewEditHandle.B_ThresholdValue,'Callback',@obj.thresholdEvent);
            set(obj.viewEditHandle.B_AlphaValue,'Callback',@obj.alphaMapEvent);
            set(obj.viewEditHandle.B_AlphaActive,'Callback',@obj.alphaMapEvent);
            set(obj.viewEditHandle.B_ImageOverlaySelection,'ValueChangedFcn',@obj.alphaImageEvent);
            set(obj.viewEditHandle.B_LineWidthValue,'Callback',@obj.lineWidthEvent);
            set(obj.viewEditHandle.B_Color,'ValueChangedFcn',@obj.colorEvent);
            set(obj.viewEditHandle.B_MorphOP,'ValueChangedFcn',@obj.morphOpEvent);
            set(obj.viewEditHandle.B_ShapeSE,'ValueChangedFcn',@obj.structurElementEvent);
            set(obj.viewEditHandle.B_SizeSE,'Callback',@obj.morphValuesEvent);
            set(obj.viewEditHandle.B_NoIteration,'Callback',@obj.morphValuesEvent);
            set(obj.viewEditHandle.B_StartMorphOP,'Callback',@obj.startMorphOPEvent);
            set(obj.viewEditHandle.B_ThresholdMode,'ValueChangedFcn',@obj.thresholdModeEvent);
            set(obj.viewEditHandle.B_FiberForeBackGround,'ValueChangedFcn',@obj.fibersInForeOrBackground);
            
        end
        
        function addWindowCallbacks(obj)
            % Set callback functions of the main figure
            
            set(obj.mainFigure,'WindowButtonMotionFcn','');
            set(obj.mainFigure,'WindowButtonDownFcn','');
            set(obj.mainFigure,'ButtonDownFcn','');
            set(obj.mainFigure,'CloseRequestFcn',@obj.closeProgramEvent);
            set(obj.mainFigure,'ResizeFcn','');
        end
        
        function setInitValueInModel(obj)
            % Get the values from the button ang GUI objects in the View
            
            obj.modelEditHandle.ThresholdMode = obj.viewEditHandle.B_ThresholdMode.ValueIndex;
            obj.modelEditHandle.ThresholdValue = obj.viewEditHandle.B_Threshold.Value;
            obj.modelEditHandle.AlphaMapValue = obj.viewEditHandle.B_Alpha.Value;
            obj.modelEditHandle.AlphaMapActive = obj.viewEditHandle.B_AlphaActive.Value;
            obj.modelEditHandle.FiberForeBackGround = obj.viewEditHandle.B_FiberForeBackGround.ValueIndex;
        end
        
        function newFileEvent(obj,~,~)
            try
                %disable all UI controls
                uicontrols = view_helper_get_all_ui_controls(obj.viewEditHandle);
                view_helper_set_enabled_ui_controls(uicontrols, 'off');
            
                format = obj.modelEditHandle.openNewFile();
                obj.busyIndicator(1);
                
                switch format
                    
                    case 'image' %Image (1 to 4 images) file was selected %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        set(obj.viewEditHandle.B_InfoText,'Value',1, 'String',{'*** New Image selected ***'})
                        
                        statusImag = obj.modelEditHandle.openImage();
                        obj.imageLoader(statusImag);
                        
                        
                    case 'bioformat' %BioFormat was selected %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        set(obj.viewEditHandle.B_InfoText,'Value',1, 'String','*** New Bioformat file selected ***')
                        
                        statusBio = obj.modelEditHandle.openBioformat();
                        if ~strcmp(statusBio,'false')
                            obj.modelEditHandle.searchForBrighntessImages();
                        end
                        obj.imageLoader(statusBio);
                        
                    case 'false' %No file was selected %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        %restore UI Control Elements 
                        obj.updateUIControlState();
                        
                    case 'notSupported'
                        infotext = {'Info! File not supported:',...
                            '',...
                            'Supported file formats are:',...
                            '',...
                            ' - 1 RGB image',...
                            ' - 1 to 4 grayscale images',...
                            '    - must have the same file extension',...
                            ' - 1 Bio-Format file',...
                            '',...
                            'See MANUAL for more details.',...
                            };
                        %show info message on gui
                        obj.viewEditHandle.infoMessage(infotext);
                        %restore UI Control Elements 
                        obj.updateUIControlState(obj.viewEditHandle);
                        
                end
                obj.busyIndicator(0);
            catch
                obj.busyIndicator(0);
                obj.errorMessage();
                %disable GUI objects
                set(obj.viewEditHandle.B_NewPic,'Enable','on');
            end
        end
        
        function imageLoader(obj,status)
            switch status
                case 'SuccessIdentify'
                    obj.initImages();
                    %enable all UI controls
                    obj.updateUIControlState();
                    
                case 'ErrorIdentify'
                    obj.initImages();
                    
                    infotext = {'Info! Image Identification:',...
                        '',...
                        'Not all images/planes could be identified.',...
                        '',...
                        'Go to the "Check planes" menu to verify the images:',...
                        '',...
                        'See MANUAL for more details.',...
                        };
                    %show info message on gui
                    obj.viewEditHandle.infoMessage(infotext);
                    %enable all UI controls
                    obj.updateUIControlState();
                    
                case 'false'
                    %restore UI Control Elements 
                    obj.updateUIControlState();
                    
            end % switch statusImag
        end

        function initImages(obj,~,~)
            try
                %Convert all images to uint8
                %brightness adjustment of color plane images
                obj.modelEditHandle.brightnessAdjustment();
                %create RGB images
                obj.modelEditHandle.createRGBImages();
                %reset invert status of binary pic
                obj.modelEditHandle.PicBWisInvert = 'false';
                %create binary pic
                obj.modelEditHandle.createBinary();
                %reset pic buffer for undo redo functionality
                obj.modelEditHandle.PicBuffer = {};
                %load binary pic in the buffer
                obj.modelEditHandle.PicBuffer{1,1} = obj.modelEditHandle.PicBW;
                %reset buffer pointer
                obj.modelEditHandle.PicBufferPointer = 1;
                
                %show images in GUI
                obj.setInitPicsGUI();
            catch
                obj.busyIndicator(0);
                obj.errorMessage();
            end
        end

        function setInitPicsGUI(obj)
            % set the initalize images in the axes handels viewEdit to show
            % the images in the GUI.
            
            % get Pics from the model
            switch obj.viewEditHandle.B_ImageOverlaySelection.Value
                case 1 %RGB
                    Pic = obj.modelEditHandle.PicRGBFRPlanes;
                case 2
                    Pic = obj.modelEditHandle.PicPlaneGreen_RGB;
                case 3
                    Pic = obj.modelEditHandle.PicPlaneBlue_RGB;
                case 4
                    Pic = obj.modelEditHandle.PicPlaneRed_RGB;
                case 5
                    Pic = obj.modelEditHandle.PicPlaneFarRed_RGB;
                otherwise
                    Pic = obj.modelEditHandle.PicRGBFRPlanes;
            end
            PicBW = obj.modelEditHandle.PicBW;
            
            % set axes in the GUI as the current axes
            %             axes(obj.viewEditHandle.hAP);
            
            if isa(obj.modelEditHandle.handlePicRGB,'struct')
                % first start of the programm. No image handle exist.
                % create image handle for Pic RGB
                obj.modelEditHandle.handlePicRGB = imshow(Pic ,'Parent',obj.viewEditHandle.hAP);
            else
                % New image was selected. Change data in existing handle
                obj.modelEditHandle.handlePicRGB.CData = Pic;
            end
            
            hold(obj.viewEditHandle.hAP, 'on');
            
            if isa(obj.modelEditHandle.handlePicBW,'struct')
                % first start of the programm. No image handle exist.
                % create image handle for Pic BW
                obj.modelEditHandle.handlePicBW = imshow(PicBW,'Parent',obj.viewEditHandle.hAP);
                
                % Callback for modelEditHandle.handlePicBW must be refresh
                obj.addMyCallbacks();
            else
                % New image was selected. Change data in existing handle
                obj.modelEditHandle.handlePicBW.CData = PicBW;
            end
            
            % show x and y axis
            axis(obj.viewEditHandle.hAP, 'on');
            axis(obj.viewEditHandle.hAP, 'image');
            hold(obj.viewEditHandle.hAP, 'off');
            title(obj.viewEditHandle.hAP,'Binary Mask for Object Segmentation');
            
            lhx=xlabel(obj.viewEditHandle.hAP, 'x/pixel','Fontsize',12);
            ylabel(obj.viewEditHandle.hAP, 'y/pixel','Fontsize',12);
            axtoolbar(obj.viewEditHandle.hAP,{'export','datacursor','pan','zoomin','zoomout','restoreview'});
            set(lhx, 'Units', 'Normalized', 'Position', [1.01 0]);
            maxPixelX = size(PicBW,2);
            obj.viewEditHandle.hAP.XTick = 0:100:maxPixelX;
            maxPixelY = size(PicBW,1);
            obj.viewEditHandle.hAP.YTick = 0:100:maxPixelY;
            set(obj.viewEditHandle.hAP,'Box','off');
            Titel = [obj.modelEditHandle.PathName obj.modelEditHandle.FileName];
            obj.viewEditHandle.panelAxes.Title = Titel;
            
            
            mainTitel = [getSettingsValue('AppName') ' ' getSettingsValue('Version') ': ' obj.modelEditHandle.FileName];
            set(obj.mainFigure,'Name', mainTitel);
        end
        
        function checkPlanesEvent(obj,~,~)
            % Callback function of the Check planes button in the GUI.
            % Opens a new figure that shows all color plane pictures
            % identified by the program. The figure also shows the
            % origianal RGB image and an RGB image that is created by the
            % color plane images.
            % Set the callback functions for the buttons and the close
            % request function of the created check planes figure.

            set(obj.viewEditHandle.B_NewPic,'Enable','off');
            set(obj.viewEditHandle.B_CheckPlanes,'Enable','off');
            set(obj.viewEditHandle.B_CheckMask,'Enable','off');
            set(obj.viewEditHandle.B_StartAnalyzeMode,'Enable','off');
            set(obj.viewEditHandle.B_Undo,'Enable','off');
            set(obj.viewEditHandle.B_Redo,'Enable','off');
            
            obj.winState=get(obj.mainFigure,'WindowState');
            obj.modelEditHandle.InfoMessage = '   - Checking planes opened';
            PicData = obj.modelEditHandle.sendPicsToController();
            try
                obj.viewEditHandle.checkPlanes(PicData,obj.mainFigure);
            catch
                obj.busyIndicator(0);
                obj.errorMessage();
            end
            % set Callbacks of the cancel and Ok button color planes.
            set(obj.viewEditHandle.B_CheckPOK,'Callback',@obj.checkPlanesOKEvent);
            set(obj.viewEditHandle.B_CheckPBack,'Callback',@obj.checkPlanesBackEvent);
            % set Callbacks of the brightness change buttons.
            set(obj.viewEditHandle.B_SelectBrightImGreen,'Callback',@obj.selectNewBrightnessImage);
            set(obj.viewEditHandle.B_SelectBrightImBlue,'Callback',@obj.selectNewBrightnessImage);
            set(obj.viewEditHandle.B_SelectBrightImRed,'Callback',@obj.selectNewBrightnessImage);
            set(obj.viewEditHandle.B_SelectBrightImFarRed,'Callback',@obj.selectNewBrightnessImage);
            
            set(obj.viewEditHandle.B_CreateBrightImGreen,'Callback',@obj.calculateBrightnessImage);
            set(obj.viewEditHandle.B_CreateBrightImBlue,'Callback',@obj.calculateBrightnessImage);
            set(obj.viewEditHandle.B_CreateBrightImRed,'Callback',@obj.calculateBrightnessImage);
            set(obj.viewEditHandle.B_CreateBrightImFarRed,'Callback',@obj.calculateBrightnessImage);
            
            set(obj.viewEditHandle.B_DeleteBrightImGreen,'Callback',@obj.deleteBrightnessImage);
            set(obj.viewEditHandle.B_DeleteBrightImBlue,'Callback',@obj.deleteBrightnessImage);
            set(obj.viewEditHandle.B_DeleteBrightImRed,'Callback',@obj.deleteBrightnessImage);
            set(obj.viewEditHandle.B_DeleteBrightImFarRed,'Callback',@obj.deleteBrightnessImage);
            % find the handle h of the checkplanes figure
            h = findobj('Tag','CheckPlanesFigure');
            % set the close request functio of the figure h
            set(h,'CloseRequestFcn',@obj.checkPlanesBackEvent);
        end
        
        function checkMaskEvent(obj,~,~)
            % Callback function of the Check mask button in the GUI.

            set(obj.viewEditHandle.B_CheckMask,'Callback','');

            obj.CheckMaskActive = ~obj.CheckMaskActive;
            
            if obj.CheckMaskActive == 1
                
                obj.modelEditHandle.InfoMessage = '   - check mask';
                set(obj.mainFigure,'ButtonDownFcn','');
                set(obj.modelEditHandle.handlePicBW,'ButtonDownFcn','');

                uicontrols = view_helper_get_all_ui_controls(obj.viewEditHandle);
                view_helper_set_enabled_ui_controls(uicontrols, 'off');
                set(obj.viewEditHandle.B_CheckMask,'Enable','on');

                
                obj.modelEditHandle.checkMask(obj.CheckMaskActive);
                
            elseif obj.CheckMaskActive == 0
                
                obj.modelEditHandle.InfoMessage = '   - close check mask';
                obj.addWindowCallbacks();
                set(obj.modelEditHandle.handlePicBW,'ButtonDownFcn',@obj.startDragEvent);
                
                obj.modelEditHandle.checkMask(obj.CheckMaskActive);
                
                % check which buttons must be enabled
                obj.updateUIControlState();
                
            end
            set(obj.viewEditHandle.B_CheckMask,'Callback',@obj.checkMaskEvent);
        end
        
        function checkPlanesOKEvent(obj,~,~)
            % Callback function of the OK button in the check planes
            % figure. Checks if the user has changed the order of the color
            % planes. if the order has changed than the function checks if
            % each color plane is only choosen once.
            
            obj.busyIndicator(1);
            
            % get the values of the color popupmenus
            Values(1) = obj.viewEditHandle.B_ColorPlaneGreen.ValueIndex;
            Values(2) = obj.viewEditHandle.B_ColorPlaneBlue.ValueIndex;
            Values(3) = obj.viewEditHandle.B_ColorPlaneRed.ValueIndex;
            Values(4) = obj.viewEditHandle.B_ColorPlaneFarRed.ValueIndex;
            
            % check if each color is selected once
            C = unique(Values);
            
            if ~isequal(Values,[1 2 3 4])
                % change was made
                
                if length(C) == 4
                    % All Values are unique. No Plane Type is selestet twice
                    obj.modelEditHandle.InfoMessage = '      - changing planes...';
                    
                    %change plane orders
                    temp{1} = obj.modelEditHandle.PicPlaneGreen;
                    temp{2} = obj.modelEditHandle.PicPlaneBlue;
                    temp{3} = obj.modelEditHandle.PicPlaneRed;
                    temp{4} = obj.modelEditHandle.PicPlaneFarRed;
                    
                    obj.modelEditHandle.PicPlaneGreen = temp{Values(1)};
                    obj.modelEditHandle.PicPlaneBlue = temp{Values(2)};
                    obj.modelEditHandle.PicPlaneRed = temp{Values(3)};
                    obj.modelEditHandle.PicPlaneFarRed = temp{Values(4)};
                    
                    %brightness adjustment of color plane image
                    obj.modelEditHandle.brightnessAdjustment();
                    
                    % Create Picture generated from Red Green and Blue
                    % Planes
                    obj.modelEditHandle.createRGBImages();
                    
                    %reset invert status of binary pic
                    obj.modelEditHandle.PicBWisInvert = 'false';
                    
                    %create binary pic
                    obj.modelEditHandle.createBinary();
                    
                    %reset pic buffer for undo redo functionality
                    obj.modelEditHandle.PicBuffer = {};
                    %load binary pic in the buffer
                    obj.modelEditHandle.PicBuffer{1,1} = obj.modelEditHandle.PicBW;
                    %reset buffer pointer
                    obj.modelEditHandle.PicBufferPointer = 1;
                    
                    %show new color planes order in the check planes figure
                    obj.viewEditHandle.B_AxesCheckPlaneGreen.Children.CData = obj.modelEditHandle.PicPlaneGreen;
                    obj.viewEditHandle.B_AxesCheckPlaneBlue.Children.CData = obj.modelEditHandle.PicPlaneBlue;
                    obj.viewEditHandle.B_AxesCheckPlaneRed.Children.CData = obj.modelEditHandle.PicPlaneRed;
                    obj.viewEditHandle.B_AxesCheckPlaneFarRed.Children.CData = obj.modelEditHandle.PicPlaneFarRed;
                    obj.viewEditHandle.B_AxesCheckRGBPlane.Children.CData = obj.modelEditHandle.PicRGBPlanes;
                    obj.viewEditHandle.B_AxesCheckRGBFRPlane.Children.CData = obj.modelEditHandle.PicRGBFRPlanes;
                    
                    %show new color planes images in the brightness
                    %correction tab
                    obj.viewEditHandle.B_AxesCheckRGB_noBC.Children.CData = obj.modelEditHandle.PicRGBFRPlanesNoBC;
                    obj.viewEditHandle.B_AxesCheckRGB_BC.Children.CData = obj.modelEditHandle.PicRGBFRPlanes;
                    
                    %reset the color popupmenus
                    obj.viewEditHandle.B_ColorPlaneGreen.ValueIndex = 1;
                    obj.viewEditHandle.B_ColorPlaneBlue.ValueIndex = 2;
                    obj.viewEditHandle.B_ColorPlaneRed.ValueIndex = 3;
                    obj.viewEditHandle.B_ColorPlaneFarRed.ValueIndex = 4;
                    
                    obj.modelEditHandle.InfoMessage = '   - Planes was changed';
                else
                    obj.viewEditHandle.B_CheckPText.String = 'Each color type can only be selected once!';
                    obj.modelEditHandle.InfoMessage = '      - Error checking planes:';
                    obj.modelEditHandle.InfoMessage = '      - Each color type can only be selected once!';
                end
            else
                obj.modelEditHandle.InfoMessage = '      - No change was made';
                
            end
            
            obj.busyIndicator(0);
            
        end
        
        function checkPlanesBackEvent(obj,~,~)
            % Callback function of the Back button in the check planes
            % figure. Is also the close request function of the check
            % planes figure. Delete the figure object.
            
            obj.modelEditHandle.InfoMessage = '   - Checking planes closed';
            % find the handle h of the checkplanes figure
            h = findobj('Tag','CheckPlanesFigure');
            set(h,'Visible','off');
            obj.busyIndicator(1);
            delete(h);
            obj.busyIndicator(0);
            if strcmp(obj.winState,'maximized')
                set(obj.mainFigure,'WindowState','maximized');
            end
            set(obj.viewEditHandle.B_NewPic,'Enable','on');
            set(obj.viewEditHandle.B_CheckPlanes,'Enable','on');
            set(obj.viewEditHandle.B_CheckMask,'Enable','on');
            set(obj.viewEditHandle.B_StartAnalyzeMode,'Enable','on');
            set(obj.viewEditHandle.B_Undo,'Enable','on');
            set(obj.viewEditHandle.B_Redo,'Enable','on');
        end
        
        function selectNewBrightnessImage(obj,~,evnt)
            %Get file extension of the current bioformat file. Brightness
            %adjusment images must have the same extension, that means that
            %they must made with the same microscope.
            [~,~,BioExt] = fileparts(obj.modelEditHandle.FileName);
            
            obj.busyIndicator(1);
            
            oldPath = pwd;
            cd(obj.modelEditHandle.PathName)
            
            switch evnt.Source.Tag
                
                case obj.viewEditHandle.B_SelectBrightImGreen.Tag
                    [FileName,PathName,~] = uigetfile(['*' BioExt],'Select Brightness Image for Green Plane','MultiSelect','off');
                    
                    if isequal(FileName ,0)
                        %No file was selected
                        createNew = 0;
                    else
                        data = bfopen([PathName FileName]);
                        reader = bfGetReader([PathName FileName]);
                        seriesCount = size(data, 1);
                        NumberOfPlanes = size(data{1,1},1);
                        
                        if seriesCount == 1 && NumberOfPlanes == 1
                            obj.modelEditHandle.PicBCGreen = double(bfGetPlane(reader,1));
                            obj.modelEditHandle.PicBCGreen = obj.modelEditHandle.PicBCGreen/max(max(obj.modelEditHandle.PicBCGreen));
                            obj.modelEditHandle.FilenameBCGreen = FileName;
                            createNew = 1;
                        else
                            obj.modelEditHandle.InfoMessage = '   - Error changing BC image';
                            obj.modelEditHandle.InfoMessage = '   - image has more than 1 plane or series';
                            createNew = 0;
                        end
                    end
                    
                case obj.viewEditHandle.B_SelectBrightImBlue.Tag
                    [FileName,PathName,~] = uigetfile(['*' BioExt],'Select Brightness Image for Blue Plane','MultiSelect','off');
                    
                    if isequal(FileName ,0)
                        %No file was selected
                        createNew = 0;
                    else
                        data = bfopen([PathName FileName]);
                        reader = bfGetReader([PathName FileName]);
                        seriesCount = size(data, 1);
                        NumberOfPlanes = size(data{1,1},1);
                        
                        if seriesCount == 1 && NumberOfPlanes == 1
                            obj.modelEditHandle.PicBCBlue = double(bfGetPlane(reader,1));
                            obj.modelEditHandle.PicBCBlue = obj.modelEditHandle.PicBCBlue/max(max(obj.modelEditHandle.PicBCBlue));
                            obj.modelEditHandle.FilenameBCBlue = FileName;
                            createNew = 1;
                        else
                            obj.modelEditHandle.InfoMessage = '   - Error changing BC image';
                            obj.modelEditHandle.InfoMessage = '   - image has more than 1 plane or series';
                            createNew = 0;
                        end
                    end
                    
                case obj.viewEditHandle.B_SelectBrightImRed.Tag
                    [FileName,PathName,~] = uigetfile(['*' BioExt],'Select Brightness Image for Red Plane','MultiSelect','off');
                    
                    if isequal(FileName ,0)
                        %No file was selected
                        createNew = 0;
                    else
                        data = bfopen([PathName FileName]);
                        reader = bfGetReader([PathName FileName]);
                        seriesCount = size(data, 1);
                        NumberOfPlanes = size(data{1,1},1);
                        
                        if seriesCount == 1 && NumberOfPlanes == 1
                            obj.modelEditHandle.PicBCRed = double(bfGetPlane(reader,1));
                            obj.modelEditHandle.PicBCRed = obj.modelEditHandle.PicBCRed/max(max(obj.modelEditHandle.PicBCRed));
                            obj.modelEditHandle.FilenameBCRed = FileName;
                            createNew = 1;
                        else
                            obj.modelEditHandle.InfoMessage = '   - Error changing BC image';
                            obj.modelEditHandle.InfoMessage = '   - image has more than 1 plane or series';
                            createNew = 0;
                        end
                    end
                    
                case obj.viewEditHandle.B_SelectBrightImFarRed.Tag
                    [FileName,PathName,~] = uigetfile(['*' BioExt],'Select Brightness Image for Farred Plane','MultiSelect','off');
                    
                    if isequal(FileName ,0)
                        %No file was selected
                        createNew = 0;
                    else
                        data = bfopen([PathName FileName]);
                        reader = bfGetReader([PathName FileName]);
                        seriesCount = size(data, 1);
                        NumberOfPlanes = size(data{1,1},1);
                        
                        if seriesCount == 1 && NumberOfPlanes == 1
                            obj.modelEditHandle.PicBCFarRed = double(bfGetPlane(reader,1));
                            obj.modelEditHandle.PicBCFarRed = obj.modelEditHandle.PicBCFarRed/max(max(obj.modelEditHandle.PicBCFarRed));
                            obj.modelEditHandle.FilenameBCFarRed = FileName;
                            createNew = 1;
                        else
                            obj.modelEditHandle.InfoMessage = '   - Error changing BC image';
                            obj.modelEditHandle.InfoMessage = '   - image has more than 1 plane or series';
                            createNew = 0;
                        end
                    end
                    
                otherwise
                    createNew = 0;
            end
            
            cd(oldPath);
            
            if createNew
                %brightness adjustment of color plane image
                obj.modelEditHandle.brightnessAdjustment();
                
                % Create Picture generated from Red Green and Blue
                % Planes
                obj.modelEditHandle.createRGBImages();
                
                %reset invert status of binary pic
                obj.modelEditHandle.PicBWisInvert = 'false';
                
                %create binary pic
                obj.modelEditHandle.createBinary();
                
                %save data into Buffer after new BC image was created
                obj.modelEditHandle.addToBuffer();
                
                %update GUI checkplanes figure
                obj.viewEditHandle.B_AxesCheckRGB_noBC.Children.CData = obj.modelEditHandle.PicRGBFRPlanesNoBC;
                obj.viewEditHandle.B_AxesCheckRGB_BC.Children.CData = obj.modelEditHandle.PicRGBFRPlanes;
                
                imshow(obj.modelEditHandle.PicBCGreen,'Parent',obj.viewEditHandle.B_AxesCheckBrightnessGreen);
                caxis(obj.viewEditHandle.B_AxesCheckBrightnessGreen,[0, 1])
                
                imshow(obj.modelEditHandle.PicBCBlue,'Parent',obj.viewEditHandle.B_AxesCheckBrightnessBlue);
                caxis(obj.viewEditHandle.B_AxesCheckBrightnessBlue,[0, 1])
                
                imshow(obj.modelEditHandle.PicBCRed,'Parent',obj.viewEditHandle.B_AxesCheckBrightnessRed);
                caxis(obj.viewEditHandle.B_AxesCheckBrightnessRed,[0, 1])
                
                imshow(obj.modelEditHandle.PicBCFarRed,'Parent',obj.viewEditHandle.B_AxesCheckBrightnessFarRed);
                caxis(obj.viewEditHandle.B_AxesCheckBrightnessFarRed,[0, 1])
                
                obj.viewEditHandle.B_CurBrightImGreen.Text = obj.modelEditHandle.FilenameBCGreen;
                obj.viewEditHandle.B_CurBrightImBlue.Text = obj.modelEditHandle.FilenameBCBlue;
                obj.viewEditHandle.B_CurBrightImRed.Text = obj.modelEditHandle.FilenameBCRed;
                obj.viewEditHandle.B_CurBrightImFarRed.Text = obj.modelEditHandle.FilenameBCFarRed;
                
                %show new images in the COlor Plane Tab
                obj.viewEditHandle.B_AxesCheckRGBPlane.Children.CData = obj.modelEditHandle.PicRGBPlanes;
                obj.viewEditHandle.B_AxesCheckRGBFRPlane.Children.CData = obj.modelEditHandle.PicRGBFRPlanes;
                
            end
            
            obj.busyIndicator(0);
            
        end
        
        function deleteBrightnessImage(obj,~,evnt)
            
            obj.busyIndicator(1);
            
            switch evnt.Source.Tag
                
                case obj.viewEditHandle.B_DeleteBrightImGreen.Tag
                    
                    obj.modelEditHandle.PicBCGreen = [];
                    obj.modelEditHandle.FilenameBCGreen = '-';
                    
                case obj.viewEditHandle.B_DeleteBrightImBlue.Tag
                    
                    obj.modelEditHandle.PicBCBlue = [];
                    obj.modelEditHandle.FilenameBCBlue = '-';
                    
                case obj.viewEditHandle.B_DeleteBrightImRed.Tag
                    
                    obj.modelEditHandle.PicBCRed = [];
                    obj.modelEditHandle.FilenameBCRed = '-';
                    
                case obj.viewEditHandle.B_DeleteBrightImFarRed.Tag
                    
                    obj.modelEditHandle.PicBCFarRed = [];
                    obj.modelEditHandle.FilenameBCFarRed = '-';
                    
                otherwise
                    
            end
            %brightness adjustment of color plane image
            obj.modelEditHandle.brightnessAdjustment();
            
            % Create Picture generated from Red Green and Blue
            % Planes
            obj.modelEditHandle.createRGBImages();
            
            %reset invert status of binary pic
            obj.modelEditHandle.PicBWisInvert = 'false';
            
            %create binary pic
            obj.modelEditHandle.createBinary();
            
            %save data into Buffer after new BC image was created
            obj.modelEditHandle.addToBuffer();
            
            obj.viewEditHandle.B_AxesCheckRGB_noBC.Children.CData = obj.modelEditHandle.PicRGBFRPlanesNoBC;
            obj.viewEditHandle.B_AxesCheckRGB_BC.Children.CData = obj.modelEditHandle.PicRGBFRPlanes;
            
            imshow(obj.modelEditHandle.PicBCGreen,'Parent',obj.viewEditHandle.B_AxesCheckBrightnessGreen);
            
            imshow(obj.modelEditHandle.PicBCBlue,'Parent',obj.viewEditHandle.B_AxesCheckBrightnessBlue);
            
            imshow(obj.modelEditHandle.PicBCRed,'Parent',obj.viewEditHandle.B_AxesCheckBrightnessRed);
            
            imshow(obj.modelEditHandle.PicBCFarRed,'Parent',obj.viewEditHandle.B_AxesCheckBrightnessFarRed);
            
            obj.viewEditHandle.B_CurBrightImGreen.Text = obj.modelEditHandle.FilenameBCGreen;
            obj.viewEditHandle.B_CurBrightImBlue.Text = obj.modelEditHandle.FilenameBCBlue;
            obj.viewEditHandle.B_CurBrightImRed.Text = obj.modelEditHandle.FilenameBCRed;
            obj.viewEditHandle.B_CurBrightImFarRed.Text = obj.modelEditHandle.FilenameBCFarRed;
            
            obj.viewEditHandle.B_AxesCheckRGBPlane.Children.CData = obj.modelEditHandle.PicRGBPlanes;
            obj.viewEditHandle.B_AxesCheckRGBFRPlane.Children.CData = obj.modelEditHandle.PicRGBFRPlanes;
            
            obj.busyIndicator(0);
            
        end
        
        function calculateBrightnessImage(obj,~,evnt)
            
            obj.busyIndicator(1);
            
            % find the handle h of the checkplanes figure
            h = findobj('Tag','CheckPlanesFigure');
            % set the close request functio of the figure h
            set(h,'CloseRequestFcn','');
            
            switch evnt.Source.Tag
                
                case obj.viewEditHandle.B_CreateBrightImGreen.Tag
                    
                    obj.modelEditHandle.calculateBackgroundIllumination('Green')
                    
                case obj.viewEditHandle.B_CreateBrightImBlue.Tag
                    
                    obj.modelEditHandle.calculateBackgroundIllumination('Blue')
                    
                case obj.viewEditHandle.B_CreateBrightImRed.Tag
                    
                    obj.modelEditHandle.calculateBackgroundIllumination('Red')
                    
                case obj.viewEditHandle.B_CreateBrightImFarRed.Tag
                    
                    obj.modelEditHandle.calculateBackgroundIllumination('Farred')
                    
                otherwise
                    
            end
            
            %brightness adjustment of color plane image
            obj.modelEditHandle.brightnessAdjustment();
            
            % Create Picture generated from Red Green and Blue
            % Planes
            obj.modelEditHandle.createRGBImages();
            
            %reset invert status of binary pic
            obj.modelEditHandle.PicBWisInvert = 'false';
            
            %create binary pic
            obj.modelEditHandle.createBinary();
            
            %save data into Buffer after new BC image was created
            obj.modelEditHandle.addToBuffer();
            
            obj.viewEditHandle.B_AxesCheckRGB_noBC.Children.CData = obj.modelEditHandle.PicRGBFRPlanesNoBC;
            obj.viewEditHandle.B_AxesCheckRGB_BC.Children.CData = obj.modelEditHandle.PicRGBFRPlanes;
            
            imshow(obj.modelEditHandle.PicBCGreen,[],'Parent',obj.viewEditHandle.B_AxesCheckBrightnessGreen);
            caxis(obj.viewEditHandle.B_AxesCheckBrightnessGreen,[0, 1])
            
            imshow(obj.modelEditHandle.PicBCBlue,[],'Parent',obj.viewEditHandle.B_AxesCheckBrightnessBlue);
            caxis(obj.viewEditHandle.B_AxesCheckBrightnessBlue,[0, 1])
            
            imshow(obj.modelEditHandle.PicBCRed,[],'Parent',obj.viewEditHandle.B_AxesCheckBrightnessRed);
            caxis(obj.viewEditHandle.B_AxesCheckBrightnessRed,[0, 1])
            
            imshow(obj.modelEditHandle.PicBCFarRed,[],'Parent',obj.viewEditHandle.B_AxesCheckBrightnessFarRed);
            caxis(obj.viewEditHandle.B_AxesCheckBrightnessFarRed,[0, 1])
            
            obj.viewEditHandle.B_CurBrightImGreen.Text = obj.modelEditHandle.FilenameBCGreen;
            obj.viewEditHandle.B_CurBrightImBlue.Text = obj.modelEditHandle.FilenameBCBlue;
            obj.viewEditHandle.B_CurBrightImRed.Text = obj.modelEditHandle.FilenameBCRed;
            obj.viewEditHandle.B_CurBrightImFarRed.Text = obj.modelEditHandle.FilenameBCFarRed;
            
            obj.viewEditHandle.B_AxesCheckRGBPlane.Children.CData = obj.modelEditHandle.PicRGBPlanes;
            obj.viewEditHandle.B_AxesCheckRGBFRPlane.Children.CData = obj.modelEditHandle.PicRGBFRPlanes;
            
            set(h,'CloseRequestFcn',@obj.checkPlanesBackEvent);
            obj.busyIndicator(0);
        end
        
        function fibersInForeOrBackground(obj,src,~)
            % Callback function of the Fiber in Fore or Background popupmenu in the
            % GUI. Checks whether the value is within the
            % permitted value range. Sets the corresponding values in the
            % model depending on the selection. Calls the
            % createBinary() function in the model.

            %Check if Fibers are shown as Black or White Pixel within the
            %green Plane and change Value in the Model
            
            obj.modelEditHandle.FiberForeBackGround = src.ValueIndex;
            %Create binary image with current Threshold Mode.
            
            obj.busyIndicator(1);
            obj.modelEditHandle.createBinary();
            obj.busyIndicator(0);
            obj.modelEditHandle.addToBuffer();
        end
        
        function thresholdModeEvent(obj,src,~)
            % Callback function of the threshold mode popupmenu in the
            % GUI. Checks whether the value is within the
            % permitted value range. Sets the corresponding values in the
            % model depending on the selection. Calls the
            % createBinary() function in the model.
            
            Mode = src.ValueIndex;
            
            obj.modelEditHandle.InfoMessage = '   - Binarization operation';
            
            switch Mode
                case 1
                    % Use manual global threshold for binarization
                    set(obj.viewEditHandle.B_ThresholdValue,'Enable','on');
                    set(obj.viewEditHandle.B_Threshold,'Enable','on');
                    
                    obj.busyIndicator(1);
                    
                    obj.modelEditHandle.ThresholdMode = Mode;
                    obj.modelEditHandle.InfoMessage = '      - Manual threshold mode has been selected';
                    obj.modelEditHandle.InfoMessage = '      - Use slider to change threshold';
                    
                    %Create binary image with threshold value in model
                    obj.modelEditHandle.createBinary();
                    obj.busyIndicator(0);
                    
                case 2
                    % Use automatic adaptive threshold for binarization
                    set(obj.viewEditHandle.B_ThresholdValue,'Enable','on');
                    set(obj.viewEditHandle.B_Threshold,'Enable','on');
                    
                    obj.busyIndicator(1);
                    
                    obj.modelEditHandle.ThresholdMode = Mode;
                    obj.modelEditHandle.InfoMessage = '      - Adaptive threshold mode has been selected';
                    
                    %Create binary image with threshold value in model
                    obj.modelEditHandle.createBinary();
                    obj.busyIndicator(0);
                    
                case 3
                    % Use automatic adaptive and manual global threshold for binarization
                    set(obj.viewEditHandle.B_ThresholdValue,'Enable','on');
                    set(obj.viewEditHandle.B_Threshold,'Enable','on');
                    
                    obj.busyIndicator(1);
                    
                    obj.modelEditHandle.ThresholdMode = Mode;
                    obj.modelEditHandle.InfoMessage = '      - Combined threshold has been selected';
                    obj.modelEditHandle.InfoMessage = '      - Use slider to change threshold';
                    
                    %Create binary image with threshold value in model
                    obj.modelEditHandle.createBinary();
                    obj.busyIndicator(0);
                    
                case 4
                    % Use Automatic setup for binarization (Watershed I)
                    set(obj.viewEditHandle.B_ThresholdValue,'Enable','off');
                    set(obj.viewEditHandle.B_Threshold,'Enable','off');
                    
                    obj.busyIndicator(1);
                    
                    obj.modelEditHandle.ThresholdMode = Mode;
                    obj.modelEditHandle.InfoMessage = '      - Automatic Watershed I has been selected';
                    
                    %Create binary image
                    obj.modelEditHandle.createBinary();
                    obj.busyIndicator(0);
                    
                case 5
                    
                    % Use Automatic setup for binarization (Watershed II)
                    set(obj.viewEditHandle.B_ThresholdValue,'Enable','off');
                    set(obj.viewEditHandle.B_Threshold,'Enable','off');
                    
                    obj.busyIndicator(1);
                    
                    obj.modelEditHandle.ThresholdMode = Mode;
                    obj.modelEditHandle.InfoMessage = '      - Automatic Watershed II has been selected';
                    
                    %Create binary image
                    obj.modelEditHandle.createBinary();
                    obj.busyIndicator(0);
                    
                otherwise
                    % Error Code
                    obj.modelEditHandle.InfoMessage = '! ERROR in thresholdModeEvent() FUNCTION !';
            end
            obj.modelEditHandle.addToBuffer();
        end
        
        function thresholdEvent(obj,src,~)
            % Callback function of the threshold slider and the text edit
            % box in the GUI. Checks whether the value is within the
            % permitted value range. Sets the corresponding values
            % in the model depending on the selection. Calls the
            % createBinary() function in the model.

            if strcmp(src.Tag,'editBinaryThresh')
                % Text Value has changed
                
                Value = str2double( src.String );
                
                if isscalar(Value) && isreal(Value) && ~isnan(Value)
                    % Value is numerical
                    
                    if Value > 1
                        % Value is bigger than 1. Set Value to 1.
                        set(obj.viewEditHandle.B_Threshold,'Value',1);
                        set(obj.viewEditHandle.B_ThresholdValue,'String','1');
                        
                        %Set threshold value in the model
                        obj.modelEditHandle.ThresholdValue = 1;
                        
                        %Create binary image with new threshold
                        obj.modelEditHandle.createBinary();
                    elseif Value < 0
                        % Value is smaller than 0. Set Value to 0.
                        set(obj.viewEditHandle.B_Threshold,'Value',0);
                        set(obj.viewEditHandle.B_ThresholdValue,'String','0');
                        
                        %Set threshold value in the model
                        obj.modelEditHandle.ThresholdValue = 0;
                        
                        %Create binary image with new threshold
                        obj.modelEditHandle.createBinary();
                    else
                        % Value is ok
                        set(obj.viewEditHandle.B_Threshold,'Value',1);
                        set(obj.viewEditHandle.B_Threshold,'Value',Value);
                        
                        %Set threshold value in the model
                        obj.modelEditHandle.ThresholdValue = Value;
                        
                        %Create binary image with new threshold
                        obj.modelEditHandle.createBinary();
                    end
                else
                    % Value is not numerical. Set Value to 0.1.
                    set(obj.viewEditHandle.B_Threshold,'Value',0.1);
                    set(obj.viewEditHandle.B_ThresholdValue,'String','0.1');
                    
                    %Set threshold value in the model
                    obj.modelEditHandle.ThresholdValue = 0.1;
                    
                    %Create binary image with new threshold
                    obj.modelEditHandle.createBinary();
                end
                
            elseif strcmp(src.Tag,'sliderBinaryThresh')
                % slider Value has changed
                set(obj.viewEditHandle.B_ThresholdValue,'String',num2str(src.Value));
                
                %Set threshold value in the model
                obj.modelEditHandle.ThresholdValue = src.Value;
                
                %Create binary image with new threshold
                obj.modelEditHandle.createBinary();
            else
                % Error Code
                obj.modelEditHandle.InfoMessage = '! ERROR in thresholdEvent() FUNCTION !';
            end
            
        end
        
        function alphaMapEvent(obj,src,~)
            % Callback function of the alpha map slider and the text edit
            % box in the GUI. Checks whether the value is within the
            % permitted value range. Sets the corresponding values
            % in the model depending on the selection.
            
            switch src.Tag
                case 'editAlpha' % Text Value has changed
                    
                    Value = str2double( src.String );
                    
                    if isscalar(Value) && isreal(Value) && ~isnan(Value)
                        % Value is numerical
                        
                        if Value > 1
                            % Value is bigger than 1. Set Value to 1.
                            
                            %Set the slider value in GUI to 1
                            set(obj.viewEditHandle.B_Alpha,'Value',1);
                            
                            %Set the text edit box string in GUI to '1'
                            set(obj.viewEditHandle.B_AlphaValue,'String','1');
                            
                            %Set alphamap value in the model
                            obj.modelEditHandle.AlphaMapValue = 1;
                            
                            %Change alphamp (transparency) of binary image
                            obj.modelEditHandle.alphaMapEvent();
                        elseif Value < 0
                            % Value is smaller than 0. Set Value to 0.
                            
                            %Set the slider value in GUI to 0
                            set(obj.viewEditHandle.B_Alpha,'Value',0);
                            
                            %Set the text edit box string in GUI to '0'
                            set(obj.viewEditHandle.B_AlphaValue,'String','0');
                            
                            %Set alphamap value in the model
                            obj.modelEditHandle.AlphaMapValue = 0;
                            
                            %Change alphamp (transparency) of binary image
                            obj.modelEditHandle.alphaMapEvent();
                            
                        else
                            % Value is ok
                            
                            %Copy the textedit value into the text slider in the GUI
                            % 
                            set(obj.viewEditHandle.B_Alpha,'Value',0);
                            set(obj.viewEditHandle.B_Alpha,'Value',1);
                            set(obj.viewEditHandle.B_Alpha,'Value',Value);
                            
                            %Set alphamap value in the model
                            obj.modelEditHandle.AlphaMapValue = Value;
                            
                            %Change alphamp (transparency) of binary image
                            obj.modelEditHandle.alphaMapEvent();
                        end
                    else
                        % Value is not numerical. Set Value to 1.
                        
                        %Set the slider value in GUI to 1
                        set(obj.viewEditHandle.B_Alpha,'Value',1);
                        
                        %Set the text edit box string in GUI to '1'
                        set(obj.viewEditHandle.B_AlphaValue,'String','1');
                        
                        %Set alphamap value in the model
                        obj.modelEditHandle.AlphaMapValue = 1;
                        
                        %Change alphamp (transparency) of binary image
                        obj.modelEditHandle.alphaMapEvent();
                        
                    end
                    
                case 'sliderAlpha'% slider Value has changed
                    
                    %Copy the slider value into the text edit box in the GUI
                    set(obj.viewEditHandle.B_AlphaValue,'String',num2str(src.Value));
                    
                    %Set alphamap value in the model
                    obj.modelEditHandle.AlphaMapValue = src.Value;
                    
                    %Change alphamp (transparency) of binary image
                    obj.modelEditHandle.alphaMapEvent();
                    
                case 'checkboxAlpha' % active Checkbox has changed
                    obj.modelEditHandle.AlphaMapActive = src.Value;
                    %Change alphamp (transparency) of binary image
                    obj.modelEditHandle.alphaMapEvent();
                otherwise
                    % Error Code
                    obj.modelEditHandle.InfoMessage = '! ERROR in alphaMapEvent() FUNCTION !';
            end
            
        end
        
        function alphaImageEvent(obj,~,~)
            % Callback function of the alpha Image dropdown menu.
        
            switch obj.viewEditHandle.B_ImageOverlaySelection.ValueIndex
                case 1 %RGB
                    Pic = obj.modelEditHandle.PicRGBFRPlanes;
                case 2
                    Pic = obj.modelEditHandle.PicPlaneGreen_RGB;
                case 3
                    Pic = obj.modelEditHandle.PicPlaneBlue_RGB;
                case 4
                    Pic = obj.modelEditHandle.PicPlaneRed_RGB;
                case 5
                    Pic = obj.modelEditHandle.PicPlaneFarRed_RGB;
                otherwise
                    Pic = obj.modelEditHandle.PicRGBFRPlanes;
            end
            
            if ~isempty(Pic)
                if isa(obj.modelEditHandle.handlePicRGB,'struct')
                    % first start of the programm. No image handle exist.
                    % create image handle for Pic RGB
                    obj.modelEditHandle.handlePicRGB = imshow(Pic);
                else
                    % New image was selected. Change data in existing handle
                    obj.modelEditHandle.handlePicRGB.CData = Pic;
                end
                
            else
                %No Image loaded
            end
        end
        
        function lineWidthEvent(obj,src,~)
            % Callback function of the linewidth slider and the text edit
            % box in the GUI. Checks whether the value is within the
            % permitted value range. Sets the corresponding values
            % in the model depending on the selection.
            
            if strcmp(src.Tag,'editLineWidtht')
                % Text Value has changed
                
                Value = get(obj.viewEditHandle.B_LineWidthValue,'String');
                Value = round(str2double(Value));
                
                if isscalar(Value) && isreal(Value) && ~isnan(Value)
                    
                    ValueMax = obj.viewEditHandle.B_LineWidth.Max;
                    ValueMin = obj.viewEditHandle.B_LineWidth.Min;
                    
                    if Value > ValueMax
                        Value = ValueMax;
                    end
                    
                    if Value < ValueMin
                        Value = ValueMin;
                    end
                    set(obj.viewEditHandle.B_LineWidth,'Value',1);
                    set(obj.viewEditHandle.B_LineWidth,'Value',Value);
                    set(obj.viewEditHandle.B_LineWidthValue,'String',num2str(Value));
                    obj.modelEditHandle.LineWidthValue = Value;
                else
                    % Value is not numerical. Set Value to 1.
                    set(obj.viewEditHandle.B_LineWidth,'Value',1);
                    set(obj.viewEditHandle.B_LineWidthValue,'String','1');
                    obj.modelEditHandle.LineWidthValue = 1;
                end
            elseif strcmp(src.Tag,'sliderLineWidtht')
                % slider Value has changed
                
                Value = round(src.Value);
                
                set(obj.viewEditHandle.B_LineWidthValue,'String',num2str(Value));
                set(obj.viewEditHandle.B_LineWidth,'Value',Value);
                obj.modelEditHandle.LineWidthValue = Value;
            else
                % Error Code
                obj.modelEditHandle.InfoMessage = '! ERROR in lineWidthEvent() FUNCTION !';
            end
            
        end
        
        function colorEvent(obj,src,~)
            % Callback function of the color popupmenu in the
            % GUI. Sets the corresponding value in the
            % model depending on the selection.
            
            if src.ValueIndex == 1
                % White Color
                obj.modelEditHandle.ColorValue = 1;
            elseif src.ValueIndex == 2
                % Black Color
                obj.modelEditHandle.ColorValue = 0;
            elseif src.ValueIndex == 3
                % White Color fill region
                obj.modelEditHandle.ColorValue = 1;
            elseif src.ValueIndex == 4
                % Black Color fill region
                obj.modelEditHandle.ColorValue = 0;
            else
                % Error Code
                obj.modelEditHandle.InfoMessage = '! ERROR in colorEvent() FUNCTION !';
            end
            
        end
        
        function invertEvent(obj,~,~)
            % Callback function of the invert button in the
            % GUI. Sets the corresponding value in the
            % model depending on the selection.

            obj.modelEditHandle.invertPicBWEvent();
        end
        
        function morphOpEvent(obj,~,~)
            % Callback function of the Morphol. opertion popupmenu in the
            % GUI. Sets the corresponding value in the
            % model depending on the selection. Controlls the visibility of
            % the corresponding buttons.
            
            %check which morph operation is selected
            String = obj.viewEditHandle.B_MorphOP.Value;
            
            if isempty(obj.modelEditHandle.handlePicBW)
                
                set(obj.viewEditHandle.B_StartMorphOP,'Enable','off')
                set(obj.viewEditHandle.B_ShapeSE,'Enable','off')
                set(obj.viewEditHandle.B_SizeSE,'Enable','off')
                set(obj.viewEditHandle.B_NoIteration,'Enable','off')
                set(obj.viewEditHandle.B_MorphOP,'Enable','off')
                
            else
            
            validOps = {
                'erode'
                'dilate'
                'skel'
                'thin'
                'open'
                'close'
                'remove'
                'shrink'
                'majority'
                'smoothing'
                'close small gaps'
                'remove incomplete objects'
            };
            
            if ismember(String, validOps)
                obj.modelEditHandle.morphOP = String;
            else
                set(obj.viewEditHandle.B_StartMorphOP,'Enable','off')
                set(obj.viewEditHandle.B_ShapeSE,'Enable','off')
                set(obj.viewEditHandle.B_SizeSE,'Enable','off')
                set(obj.viewEditHandle.B_NoIteration,'Enable','off')
            
                obj.viewEditHandle.B_MorphOP.ValueIndex = 1;
                obj.modelEditHandle.morphOP = 'choose operation';
                set(obj.viewEditHandle.B_MorphOP,'Enable','on')
            end
            
            % Check wich morph option is selectet to turn off/on the
            % corresponding operating elements
            
            %set(obj.viewEditHandle.B_MorphOP,'Enable','on');
            
            obj.updateUIControlState(obj.viewEditHandle);
            
            end
            
        end
        
        function structurElementEvent(obj,src,~)
            % Callback function of the structering element popupmenu in the
            % GUI. Sets the corresponding value in the
            % model depending on the selection. Controlls the visibility of
            % the corresponding buttons.

            %check which structering element is selected
            String = src.Value;
            
            switch String
                
                case 'diamond'
                    
                    obj.modelEditHandle.SE = 'diamond';
                    obj.modelEditHandle.FactorSE = 1;
                case 'disk'
                    
                    obj.modelEditHandle.SE = 'disk';
                    obj.modelEditHandle.FactorSE = 1;
                    
                case 'octagon'
                    
                    obj.modelEditHandle.SE = 'octagon';
                    %Size if octagon must be n*3
                    obj.modelEditHandle.FactorSE = 3;
                    
                case 'square'
                    
                    obj.modelEditHandle.SE = 'square';
                    obj.modelEditHandle.FactorSE = 1;
                    
                otherwise
                    
                    set(obj.viewEditHandle.B_SizeSE,'Enable','off')
                    set(obj.viewEditHandle.B_NoIteration,'Enable','off')
                    obj.modelEditHandle.SE = '';
                    
            end
            
            % Check wich morph option is selectet to turn off/on the
            % corresponding operating elements
            
            % get morphological operation string
            tempMorpStr = obj.modelEditHandle.morphOP;
            % get structering element string
            tempSEStr = obj.modelEditHandle.SE;
            
            % Check wich operation is selected
            if strcmp(tempMorpStr,'choose operation') || strcmp(tempMorpStr,'')
                % No operation is selected
                
                %disable run morph button, diable structering element
                %buttons
                set(obj.viewEditHandle.B_StartMorphOP,'Enable','off')
                set(obj.viewEditHandle.B_ShapeSE,'Enable','off')
                set(obj.viewEditHandle.B_SizeSE,'Enable','off')
                set(obj.viewEditHandle.B_NoIteration,'Enable','off')
                
            elseif strcmp(tempMorpStr,'erode') || strcmp(tempMorpStr,'dilate') ||...
                    strcmp(tempMorpStr,'open') || strcmp(tempMorpStr,'close')
                % Morph options that need a structuring element. No
                % structering element is selected
                
                %disable run morph button until a structering element was
                %selected
                set(obj.viewEditHandle.B_ShapeSE,'Enable','on')
                set(obj.viewEditHandle.B_SizeSE,'Enable','off')
                set(obj.viewEditHandle.B_NoIteration,'Enable','off')
                set(obj.viewEditHandle.B_StartMorphOP,'Enable','off')
                
                if ~strcmp(tempSEStr,'') && ~strcmp(tempSEStr,'choose SE')
                    % Morph options with choosen structuring element
                    
                    %enable run morph button
                    set(obj.viewEditHandle.B_ShapeSE,'Enable','on')
                    set(obj.viewEditHandle.B_SizeSE,'Enable','on')
                    set(obj.viewEditHandle.B_NoIteration,'Enable','on')
                    set(obj.viewEditHandle.B_StartMorphOP,'Enable','on')
                end
                
            else
                % Morph options that dont need a structuring element
                
                %enable run morph button, diable structering element
                %buttons
                set(obj.viewEditHandle.B_ShapeSE,'Enable','off')
                set(obj.viewEditHandle.B_SizeSE,'Enable','off')
                set(obj.viewEditHandle.B_NoIteration,'Enable','on')
                set(obj.viewEditHandle.B_StartMorphOP,'Enable','on')
            end
        end
        
        function morphValuesEvent(obj,~,~)
            % Callback function of the value textedit boxes Size and
            % NoInterations in the GUI. Checks whether the value is within
            % the permitted value range. Sets the corresponding value in
            % the model depending on the selection.
            
            %get strings from GUI text box and transform into numeric value
            ValueSE = round(str2double(obj.viewEditHandle.B_SizeSE.String));
            ValueNoI = round(str2double(obj.viewEditHandle.B_NoIteration.String));
            
            if isnan(ValueSE) || ValueSE < 1 || ~isreal(ValueSE)
                %Value size of structering element is not numeric, not real
                %or negativ.
                %set value to 1
                ValueSE = 1;
                set(obj.viewEditHandle.B_SizeSE,'String','1')
            end
            
            if isnan(ValueNoI) || ValueNoI < 1 || ~isreal(ValueNoI)
                %Value number of iterations is not numeric, not real or
                %negativ.
                %set value to 1
                ValueSE = 1;
                set(obj.viewEditHandle.B_NoIteration,'String','1')
            end
            
            %set value in the model
            obj.modelEditHandle.SizeSE = ValueSE;
            set(obj.viewEditHandle.B_SizeSE,'String',num2str(ValueSE));
            
            obj.modelEditHandle.NoIteration = ValueNoI;
            set(obj.viewEditHandle.B_NoIteration,'String',num2str(ValueNoI));
        end
        
        function startMorphOPEvent(obj,~,~)
            % Callback function of the run morph operation button in the
            % GUI. Runs the runMorphOperation function in the editModel
            % object.

            obj.busyIndicator(1);
            obj.modelEditHandle.runMorphOperation();
            obj.busyIndicator(0);
        end
        
        function startDragEvent(obj,~,~)
            % ButtonDownFcn callback function of the GUI figure. Set the
            % WindowButtonMotionFcn callback function of the GUI figure.
            % Get the current cursor position in the figure and calls the
            % startDragFcn in the editModel.

            if ~isempty(obj.modelEditHandle.handlePicBW)
                set(obj.mainFigure,'WindowButtonUpFcn',@obj.stopDragEvent);
                set(obj.mainFigure,'WindowButtonMotionFcn',@obj.dragEvent);
                if (obj.viewEditHandle.B_Color.ValueIndex == 1 || ...
                        obj.viewEditHandle.B_Color.ValueIndex == 2 )
                    % Color Black or white is selected to use free hand draw
                    % mode.
                    Pos = get(obj.viewEditHandle.hAP, 'CurrentPoint');
                    obj.modelEditHandle.startDragFcn(Pos);
                    
                elseif (obj.viewEditHandle.B_Color.ValueIndex == 3 || ...
                        obj.viewEditHandle.B_Color.ValueIndex == 4 )
                    % Color Black or white is selected to use region fill
                    % mode.
                    Pos = get(obj.viewEditHandle.hAP, 'CurrentPoint');
                    obj.modelEditHandle.fillRegion(Pos);
                else
                    
                end
                
            end
        end
        
        function dragEvent(obj,~,~)
            % WindowButtonMotionFcn callback function of the GUI figure.
            % Get the current cursor position in the figure and calls the
            % dragEvent in the editModel.

            %get cursor positon in binary pic
            Pos = get(obj.viewEditHandle.hAP, 'CurrentPoint');
            %call drag fcn in model with given cursor position
            if (obj.viewEditHandle.B_Color.ValueIndex == 1 || ...
                    obj.viewEditHandle.B_Color.ValueIndex == 2 )
                obj.modelEditHandle.DragFcn(Pos);
            else
                obj.modelEditHandle.fillRegion(Pos);
            end
        end
        
        function stopDragEvent(obj,~,~)
            % ButtonUpFcn callback function of the GUI figure. Delete the
            % WindowButtonMotionFcn callback function of the GUI figure.
            % Calls the stopDragEvent in the editModel.
            
            %clear ButtonUp and motion function
            set(obj.mainFigure,'WindowButtonUpFcn','');
            set(obj.mainFigure,'WindowButtonMotionFcn','');
            %call stop drag fcn in model
            obj.modelEditHandle.stopDragFcn();
        end
        
        function startAnalyzeModeEvent(obj,~,~)
            % Callback function of the Start Analyze Mode-Button in the GUI.
            % Calls the function sendPicsToController() in the editModel to
            % send all image Data to the analyze model. Calls the
            % startAnalyzeMode function in the controllerAnalyze instanze.

            set(obj.viewEditHandle.B_NewPic,'Enable','off');
            set(obj.viewEditHandle.B_CheckPlanes,'Enable','off');
            set(obj.viewEditHandle.B_CheckMask,'Enable','off');
            set(obj.viewEditHandle.B_StartAnalyzeMode,'Enable','off');
            set(obj.viewEditHandle.B_Undo,'Enable','off');
            set(obj.viewEditHandle.B_Redo,'Enable','off');
            obj.modelEditHandle.InfoMessage = ' ';
            
            %Send Data to Controller Analyze
            InfoText = get(obj.viewEditHandle.B_InfoText, 'String');
            
            obj.controllerAnalyzeHandle.startAnalyzeMode(InfoText);
            set(obj.viewEditHandle.B_NewPic,'Enable','on');
            set(obj.viewEditHandle.B_CheckPlanes,'Enable','on');
            set(obj.viewEditHandle.B_CheckMask,'Enable','on');
            set(obj.viewEditHandle.B_StartAnalyzeMode,'Enable','on');
            set(obj.viewEditHandle.B_Undo,'Enable','on');
            set(obj.viewEditHandle.B_Redo,'Enable','on');
        end
        
        function undoEvent(obj,~,~)
            % Callback function of the Undo Button in the GUI. Calls the
            % undo() function in the editModel.

            obj.modelEditHandle.undo();
        end
        
        function redoEvent(obj,~,~)
            % Callback function of the Redo Button in the GUI. Calls the
            % redo() function in the editModel.
           
            obj.modelEditHandle.redo();
        end
        
        function updateUIControlState(obj,~,~)
            uicontrols = view_helper_get_all_ui_controls(obj.viewEditHandle);
            if isa(obj.modelEditHandle.handlePicRGB,'struct') || ...
               isempty(obj.modelEditHandle.handlePicBW)
               %No image is loaded into the program
               view_helper_set_enabled_ui_controls(uicontrols,'off');
               set(obj.viewEditHandle.B_NewPic,'Enable','on');
            else
                %One image is already loaded into the program.
                view_helper_set_enabled_ui_controls(uicontrols, 'on');
    
                disableB_ThresholdMode = ~ismember(obj.viewEditHandle.B_ThresholdMode.ValueIndex,[1 2 3]);
    
                if disableB_ThresholdMode
                    set(obj.viewEditHandle.B_Threshold,'Enable','off');
                    set(obj.viewEditHandle.B_ThresholdValue,'Enable','off');
                end
            end
            % check which morphOp buttons must be enabled
            op = lower(strtrim(obj.modelEditHandle.morphOP));
            se = lower(strtrim(obj.modelEditHandle.SE));
        
            opsNeedSE = {'erode','dilate','open','close'};
            opsNoSE   = {'smoothing','skel','remove incomplete objects'};
        
            % Default: alles aus
            set(obj.viewEditHandle.B_StartMorphOP,'Enable','off')
            set(obj.viewEditHandle.B_ShapeSE,'Enable','off')
            set(obj.viewEditHandle.B_SizeSE,'Enable','off')
            set(obj.viewEditHandle.B_NoIteration,'Enable','off')
        
            % Keine Operation gewählt
            if isempty(op) || strcmp(op,'choose operation')
                return
            end
        
            % Operationen MIT Structuring Element
            if ismember(op, opsNeedSE)
                set(obj.viewEditHandle.B_ShapeSE,'Enable','on')
        
                if ~isempty(se) && ~strcmp(se,'choose se')
                    set(obj.viewEditHandle.B_SizeSE,'Enable','on')
                    set(obj.viewEditHandle.B_NoIteration,'Enable','on')
                    set(obj.viewEditHandle.B_StartMorphOP,'Enable','on')
                end
                return
            end
        
            % Operationen OHNE Structuring Element, OHNE Iteration
            if ismember(op, opsNoSE)
                set(obj.viewEditHandle.B_StartMorphOP,'Enable','on')
                return
            end
        
            % Operationen OHNE SE, MIT Iteration
            set(obj.viewEditHandle.B_NoIteration,'Enable','on')
            set(obj.viewEditHandle.B_StartMorphOP,'Enable','on')
        end

        function setInfoTextView(obj,InfoText)
            % Sets the log text on the GUI.
            % Only called by changing the MVC if the stage of the
            % program changes.

            set(obj.viewEditHandle.B_InfoText, 'String', InfoText);
            set(obj.viewEditHandle.B_InfoText, 'Value' , length(obj.viewEditHandle.B_InfoText.String));
        end
        
        function updateInfoLogEvent(obj,~,~)
            % Listener callback function of the InfoMessage propertie in
            % the model. Is called when InfoMessage string changes. Appends
            % the text in InfoMessage to the log text in the GUI.
            
            controller_helper_update_Info_Log(obj.viewEditHandle, obj.modelEditHandle)         
        end
        
        function busyIndicator(obj,status)
            controller_helper_busy_indicator(obj,status,obj.viewEditHandle,obj.modelEditHandle);
        end
              
        function errorMessage(obj)
            controller_helper_error_message(obj);
            obj.updateUIControlState();   
        end
        
        function closeProgramEvent(obj,~,~)
            % Colose Request function of the main figure.
            %
            %   closeProgramEvent(obj,~,~)
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerEdit object
            %
            
            obj.winState=get(obj.mainFigure,'WindowState');
            choice = questdlg({'Are you sure you want to quit? ','All unsaved data will be lost.'},...
                'Close Program', ...
                'Yes','No','No');
            if strcmp(obj.winState,'maximized')
                set(obj.mainFigure,'WindowState','maximized');
            end
            
            switch choice
                case 'Yes'
                    delete(obj.viewEditHandle);
                    delete(obj.modelEditHandle);
                    delete(obj.mainCardPanel);
                    
                    %find all objects
                    object_handles = findall(obj.mainFigure);
                    %delete objects
                    delete(object_handles);
                    %find all figures and delete them
                    figHandles = findobj('Type','figure');
                    delete(figHandles);
                    delete(obj)
                case 'No'
                    obj.modelEditHandle.InfoMessage = '   - closing program canceled';
                otherwise
                    obj.modelEditHandle.InfoMessage = '   - closing program canceled';
            end
            
        end
        
        function delete(obj)
            %deconstructor
            delete(obj)
        end
    end
    
    
end

