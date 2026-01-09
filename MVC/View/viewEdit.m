classdef viewEdit < handle
    %viewEdit   view of the edit-MVC (Model-View-Controller).
    %Creates the first card panel in the main figure to select new pictures 
    %for further processing. The viewEdit class is called by the main.m  
    %file. Contains serveral buttons and uicontrol elements to manipulate
    %the binary picture.
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
    
    properties(SetObservable)
        
        panelControl;    %handle to panel with the controls included
        panelAxes;   %handle to panel with the image axes included
        panelEdit; %handle to panel with editView components.
        hAP;    %handle to axes that shows the image.
        hFCP;   %handle to figure with planes to check. Opens after the check plane button was pressed.
        
        B_Undo; %Button, to undo a change in the binary image.
        B_Redo; %Button, to redo a change in the binary image.
        B_NewPic; %Button, to select a new picture.
        B_CheckPlanes; %Button, opens a new figure to check and change the image planes.
        B_CheckMask; %Button, shows all objects in RGB colors to check the binary mask.
        B_StartAnalyzeMode; %Button, close the EditMode and opens the the AnalyzeMode.
        
        B_FiberForeBackGround
        
        B_Alpha; %Slider, to change the transperancy between the binary and the RGB picture.
        B_AlphaValue; % TextEditBox, to change the transperancy between the binary and the RGB picture.
        B_AlphaActive; %Checkbox, Switch Overlay on and off
        B_ImageOverlaySelection;

        B_Color; %Popupmenu, to select the color to draw into the binary image.
        B_Invert; %Butto, invert the binary pic.

        B_LineWidth; %Slider, to change the linewidth of the free hand draw function in the binary image.
        B_LineWidthValue; %TextEditBox, to change the linewidth of the free hand draw function in the binary image.
        
        B_ThresholdMode; %Popupmenu, to choose between manual-global and adaptive threshold mode binarize the image.
        B_Threshold;%Slider, to change the threshold value.
        B_ThresholdValue;%TextEditBox, to change the threshold value.
        
        B_MorphOP; %Popupmenu, to select between different morphologocal operations.
        B_ShapeSE; %Popupmenu, to select between different structering elements for morphologocal operation.
        B_SizeSE; %TextEditBox, to select the size of the structering element.
        B_NoIteration; %TextEditBox, to select the number of iterations of the morpological operations.
        B_StartMorphOP; %Button, runs the morpological operations.
        B_InfoText; %Shows the info log text.
        
        B_AxesCheckRGBFRPlane; %axes handle that contains the RGB image in the check planes figure.
        B_AxesCheckRGBPlane; %axes handle that contains the RGB image in the check planes figure.
        B_AxesCheckPlaneGreen; %axes handle that contains the green plane in the imagecheck planes figure.
        B_AxesCheckPlaneBlue; %axes handle that contains the blue plane image in the check planes figure.
        B_AxesCheckPlaneRed; %axes handle that contains the red plane image in the check planes figure.
        B_AxesCheckPlaneFarRed; %axes handle that contains the farred plane image in the check planes figure.

        B_ColorPlaneGreen %Popupmenu, to change the color plane in the check planes figure.
        B_ColorPlaneBlue %Popupmenu, to change the color plane in the check planes figure.
        B_ColorPlaneRed %Popupmenu, to change the color plane in the check planes figure.
        B_ColorPlaneFarRed %Popupmenu, to change the color plane in the check planes figure.
        
        B_CheckPOK %Button, to confirm changes in the check planes figure.
        B_CheckPBack %Button, to cancel and close the check planes figure.
        B_CheckPText %Text, shows information text in the check planes figure.
        
        B_AxesCheckRGB_noBC
        B_AxesCheckRGB_BC
        B_AxesCheckBrightnessGreen
        B_AxesCheckBrightnessBlue
        B_AxesCheckBrightnessRed
        B_AxesCheckBrightnessFarRed
        
        B_CurBrightImGreen
        B_SelectBrightImGreen
        B_CreateBrightImGreen
        B_DeleteBrightImGreen
        
        B_CurBrightImBlue
        B_SelectBrightImBlue
        B_CreateBrightImBlue
        B_DeleteBrightImBlue
        
        B_CurBrightImRed
        B_SelectBrightImRed
        B_CreateBrightImRed
        B_DeleteBrightImRed
        
        B_CurBrightImFarRed
        B_SelectBrightImFarRed
        B_CreateBrightImFarRed
        B_DeleteBrightImFarRed
    end
    
    methods
        function obj = viewEdit(mainCard)
            % constructor
            if nargin < 1 || isempty(mainCard)
                
                mainFig = uifigure('Units','normalized','Position',[0.01 0.05 0.98 0.85]);
                mainCard = uix.CardPanel('Parent', mainFig,'Selection',0,'Tag','mainCard');
                theme(mainFig,"light");
                 set(mainFig,'WindowState','maximized');
            end
            
            params = view_helper_default_params();
            
            set(mainCard,'Visible','on');
            obj.panelEdit = uix.HBox( 'Parent', mainCard, params.default_box_spacing_padding{:});
            
            obj.panelAxes =    uix.Panel('Parent',  obj.panelEdit, params.default_panel{:},'Title','IMAGE');
            obj.panelControl = uix.Panel('Parent',  obj.panelEdit,params.default_panel{:},'Title', 'SEGMENTATION','TitlePosition','centertop');
            set(  obj.panelEdit, 'MinimumWidths', [1 320] );
            set(  obj.panelEdit, 'Widths', [-80 -20] );
            obj.hAP = axes('Parent',uicontainer('Parent', obj.panelAxes));
            axis(obj.hAP ,'image');

            set(obj.hAP, 'LooseInset', [0,0,0,0]);
            set(obj.hAP,'Box','off');

            
            PanelVBox = uix.VBox('Parent',obj.panelControl,params.default_box_spacing_padding{:});
            
            PanelControl = uix.Panel('Parent',PanelVBox,params.default_panel{:},'Title','Main Controls');
            PanelAlpha =   uix.Panel('Parent',PanelVBox,params.default_panel{:},'Title','Image Overlay');
            PanelBinari =  uix.Panel('Parent',PanelVBox,params.default_panel{:},'Title','Binarization');
            PanelMorphOp = uix.Panel('Parent',PanelVBox,params.default_panel{:},'Title','Morphological Operations');
            PanelInfo =    uix.Panel('Parent',PanelVBox,params.default_panel{:},'Units','normalized','Title','Info Log');
            
            set( PanelVBox, 'Heights', [-18 -10 -22 -23 -27]);
            drawnow limitrate;

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%% Panel Control %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            mainVBBoxControl = uix.VBox('Parent', PanelControl, params.default_box_spacing_padding{:} );
            
            HBoxControl1 = uix.HButtonBox('Parent', mainVBBoxControl, params.default_HButtonBox_Main{:});
            obj.B_NewPic =           uicontrol( 'Parent', HBoxControl1, params.default_normalized_font{:}, 'String', sprintf('\x25A8 New File') );
            obj.B_StartAnalyzeMode = uicontrol( 'Parent', HBoxControl1, params.default_normalized_font{:},'Style','pushbutton', 'String', sprintf('Analyze \x276F\x276F') ,'Enable','off');
            
            HBoxControl2 = uix.HButtonBox('Parent', mainVBBoxControl,params.default_HButtonBox_Main{:});
            obj.B_CheckMask =   uicontrol( 'Parent', HBoxControl2, params.default_normalized_font{:},'Style','pushbutton', 'String', sprintf('\x25D0 Check Mask') ,'Enable','off');
            obj.B_CheckPlanes = uicontrol( 'Parent', HBoxControl2, params.default_normalized_font{:}, 'String', sprintf('Check Planes \x2750') ,'Enable','off');
            
            HBoxControl3 = uix.HButtonBox('Parent', mainVBBoxControl,params.default_HButtonBox_Main{:} );
            obj.B_Undo = uicontrol( 'Parent', HBoxControl3, params.default_normalized_font{:}, 'String', sprintf('\x23EE Undo') );
            obj.B_Redo = uicontrol( 'Parent', HBoxControl3, params.default_normalized_font{:}, 'String', sprintf('Redo \x23ED') );
            drawnow limitrate;

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%% Panel Image Overview %%%%%%%%%%%%%%%%%%%%%%%%%%%
            mainVBoxAlpha = uix.VBox('Parent', PanelAlpha, params.default_box_spacing_padding{:});

            %%%%%%%%%%%%%%%% 1. Row Image Selection %%%%%%%%%%%%%%%%%%%%%%%%
            HBoxAlpha1 = uix.HBox('Parent', mainVBoxAlpha,params.default_box_spacing_padding{:});
            
            HButtonBoxAlpha1_1 = uix.HButtonBox('Parent', HBoxAlpha1, params.default_HButtonBox{:});
            uilabel( 'Parent', HButtonBoxAlpha1_1,'HorizontalAlignment','left', 'Text', 'Image:' );

            
            HButtonBoxAlpha1_2 = uix.HButtonBox('Parent', HBoxAlpha1, params.default_HButtonBox{:});
            obj.B_ImageOverlaySelection = uidropdown( 'Parent', HButtonBoxAlpha1_2,'Tag','popupmenuOverlay','Items', {'RGB Image' , 'Green Plane', 'Blue Plane', 'Red Plane', 'Farred Plane'} ,'Enable','on');
            
            set( HBoxAlpha1, 'Widths', [-1.3 -3.7] );
            
            %%%%%%%%%%%%%%%% 2. Row Alpha %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            HBoxAlpha2 = uix.HBox('Parent', mainVBoxAlpha, params.default_box_spacing_padding{:});
            
            HButtonBoxAlpha2_1 = uix.HButtonBox('Parent', HBoxAlpha2,params.default_HButtonBox{:});
            uilabel( 'Parent', HButtonBoxAlpha2_1,'HorizontalAlignment','left', 'Text', 'Alpha:');

            
            HButtonBoxAlpha2_4 = uix.HButtonBox('Parent', HBoxAlpha2,params.default_HButtonBox{:});
            obj.B_AlphaActive = uicontrol( 'Parent', HButtonBoxAlpha2_4,'Style','checkbox','Value',1,'Tag','checkboxAlpha','Enable','off');
            
            HButtonBoxAlpha2_2 = uix.HButtonBox('Parent', HBoxAlpha2,params.default_HButtonBox{:});
            obj.B_Alpha = uicontrol( 'Parent', HButtonBoxAlpha2_2,'Style','slider', 'String', 'Alpha' ,'Tag','sliderAlpha','Enable','off');
            
            HButtonBoxAlpha2_3 = uix.HButtonBox('Parent', HBoxAlpha2,params.default_HButtonBox{:});
            obj.B_AlphaValue = uicontrol( 'Parent', HButtonBoxAlpha2_3,'Style','edit','Tag','editAlpha','Enable','off');
            
            set( HBoxAlpha2, 'Widths', [-0.8 -0.2 -2 -1] );
            drawnow limitrate;

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%% Panel Hand Draw Grid %%%%%%%%%%%%%%%%%%%%%%%%%%%
            mainVBoxBinari = uix.VBox('Parent', PanelBinari,params.default_box_spacing_padding{:});
            
            %%%%%%%%%%%%%%%% 1. Row Threshold Mode %%%%%%%%%%%%%%%%%%%%%%%%
            HBoxBinari1 = uix.HBox('Parent', mainVBoxBinari, params.default_box_spacing_padding{:});
            
            HButtonBoxBinari1_1 = uix.HButtonBox('Parent', HBoxBinari1,params.default_HButtonBox{:});
            uilabel( 'Parent', HButtonBoxBinari1_1, 'HorizontalAlignment','left', 'Text', 'Mode:' );

            
            HButtonBoxBinari1_2 = uix.HButtonBox('Parent', HBoxBinari1,params.default_HButtonBox{:} );
            obj.B_ThresholdMode = uidropdown( 'Parent', HButtonBoxBinari1_2,'Tag','popupmenuThresholdMode',...
                'Items', {'Manual global threshold' , 'Automatic adaptive threshold', 'Combined manual and adaptive', 'Automatic Watershed I', 'Automatic Watershed II'} ,'Enable','off');
            
            set( HBoxBinari1, 'Widths', [-1 -3] );
            
            %%%%%%%%%%%%%%%% 2. Row Green Plane Fiber Back or Forground %%%%%%%%%%%%%%%%%%%%%%%%
            HBoxBinari2 = uix.HBox('Parent', mainVBoxBinari, params.default_box_spacing_padding{:});
            
            HButtonBoxBinari2_1 = uix.HButtonBox('Parent', HBoxBinari2, params.default_HButtonBox{:});
            uilabel( 'Parent', HButtonBoxBinari2_1,'HorizontalAlignment','left', 'Text', 'Green Plane:' );

            
            HButtonBoxBinari2_2 = uix.HButtonBox('Parent', HBoxBinari2, params.default_HButtonBox{:});
            obj.B_FiberForeBackGround = uidropdown( 'Parent', HButtonBoxBinari2_2,'Tag','popupmenuForeBackGround', ...
                'Items', {'Fibers shown as Background (Dark Pixels)','Fibers shown as Forground (Light Pixels)' } ,'Enable','off');
            
            set( HBoxBinari2, 'Widths', [-1 -3] );
            drawnow limitrate;

            %%%%%%%%%%%%%%%% 3. Row Threshold %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            HBoxBinari3 = uix.HBox('Parent', mainVBoxBinari, params.default_box_spacing_padding{:});
            
            HButtonBoxBinari3_1 = uix.HButtonBox('Parent', HBoxBinari3, params.default_HButtonBox{:});
            uilabel( 'Parent', HButtonBoxBinari3_1, 'HorizontalAlignment','left','Text', 'Threshold:' );
            
            HButtonBoxBinari3_2 = uix.HButtonBox('Parent', HBoxBinari3, params.default_HButtonBox{:});
            obj.B_Threshold = uicontrol( 'Parent', HButtonBoxBinari3_2,'Style','slider', 'String', 'Thresh', 'Tag','sliderBinaryThresh' ,'Enable','off');
            
            HButtonBoxBinari3_3 = uix.HButtonBox('Parent', HBoxBinari3, params.default_HButtonBox{:});
            obj.B_ThresholdValue = uicontrol( 'Parent', HButtonBoxBinari3_3,'Style','edit', 'Tag','editBinaryThresh','Enable','off');
            
            set( HBoxBinari3, 'Widths', [-1 -2 -1] );
            drawnow limitrate;

            %%%%%%%%%%%%%%%% 4. Row Linewidth %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            HBoxBinari5 = uix.HBox('Parent', mainVBoxBinari, params.default_box_spacing_padding{:});
            
            HButtonBoxBinari5_1 = uix.HButtonBox('Parent', HBoxBinari5, params.default_HButtonBox{:});
            uilabel( 'Parent', HButtonBoxBinari5_1, 'HorizontalAlignment','left','Text', 'Pen Width:');


            HButtonBoxBinari5_2 = uix.HButtonBox('Parent', HBoxBinari5, params.default_HButtonBox{:});
            obj.B_LineWidth = uicontrol( 'Parent', HButtonBoxBinari5_2,'Style','slider','FontUnits','normalized','Fontsize',0.6, 'String', 'Pen width','Min',0,'Max',100,'SliderStep',[1/100,1/100],'Tag','sliderLineWidtht' );
            
            HButtonBoxBinari5_3 = uix.HButtonBox('Parent', HBoxBinari5, params.default_HButtonBox{:});
            obj.B_LineWidthValue = uicontrol( 'Parent', HButtonBoxBinari5_3,'Style','edit', 'Tag','editLineWidtht');
            
            set( HBoxBinari5, 'Widths', [-1 -2 -1] );
            drawnow limitrate;
            
            %%%%%%%%%%%%%%%% 5. Row Color/Invert %%%%%%%%%%%%%%%%%%%%%%%%%%
             
            HBoxBinari6 = uix.HBox('Parent', mainVBoxBinari, params.default_box_spacing_padding{:});
            
            HButtonBoxBinari6_1 = uix.HButtonBox('Parent', HBoxBinari6, params.default_HButtonBox{:});
            uilabel( 'Parent', HButtonBoxBinari6_1,'HorizontalAlignment','left', 'Text', 'Pen Color:' );
            
            HButtonBoxBinari6_2 = uix.HButtonBox('Parent', HBoxBinari6, params.default_HButtonBox{:});
            obj.B_Color = uidropdown( 'Parent', HButtonBoxBinari6_2, 'Tag','popupmenuBinaryColor', 'Items', {'White' , 'Black', 'White fill region', 'Black fill region'} ,'Enable','off');
            
            HButtonBoxBinari6_3 = uix.HButtonBox('Parent', HBoxBinari6, params.default_HButtonBox{:});
            obj.B_Invert = uicontrol( 'Parent', HButtonBoxBinari6_3, 'String', 'Invert' ,'Enable','off','Tag','buttonBinaryInvert');
            
            set( HBoxBinari6, 'Widths', [-1 -2 -1] );

            %%%%%%%%%%%%%% Morph Operations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            MainVBoxMorph = uix.VBox('Parent',PanelMorphOp,'Padding', 3 );
            
            HButtonBoxMorph1 = uix.HButtonBox('Parent', MainVBoxMorph, params.default_HButtonBox{:} );
            HButtonBoxMorph2 = uix.HButtonBox('Parent', MainVBoxMorph, params.default_HButtonBox{:} );
            HButtonBoxMorph3 = uix.HButtonBox('Parent', MainVBoxMorph, params.default_HButtonBox{:} );
            HButtonBoxMorph4 = uix.HButtonBox('Parent', MainVBoxMorph, params.default_HButtonBox{:} );
            HButtonBoxMorph5 = uix.HButtonBox('Parent', MainVBoxMorph, params.default_HButtonBox{:}, 'ButtonSize', [600 60]);
            
            uilabel( 'Parent', HButtonBoxMorph1,  'HorizontalAlignment','left', 'Text', 'Morphol. Operation:');

            String = {'choose operation' ,'remove incomplete objects','close small gaps' ,'smoothing','erode', 'dilate', 'skel' ,'thin','shrink','majority','remove','open','close'};
            obj.B_MorphOP = uidropdown( 'Parent', HButtonBoxMorph1, 'Tag','popupmenuMorphOP', 'Items', String ,'Enable','off');
              
            uilabel( 'Parent', HButtonBoxMorph2,  'HorizontalAlignment','left', 'Text', 'Structuring Element:');

            String = {'choose SE' , 'diamond', 'disk', 'octagon' ,'square'};
            obj.B_ShapeSE = uidropdown( 'Parent', HButtonBoxMorph2, 'Tag','popupmenuShapeSE', 'Items', String,'Enable','off' );
            
            uilabel( 'Parent', HButtonBoxMorph3, 'HorizontalAlignment','left', 'Text', 'Size of Structuring Element:');

            obj.B_SizeSE = uicontrol( 'Parent', HButtonBoxMorph3,'Style','edit', 'String','1','Enable','off','Tag','editSizeSE' );
            
            uilabel( 'Parent', HButtonBoxMorph4, 'HorizontalAlignment','left', 'Text', 'No. of Iterations / Size Gaps:');

            obj.B_NoIteration = uicontrol( 'Parent', HButtonBoxMorph4,'Style','edit', 'String','1','Enable','off','Tag','editNoIteration' );
            
            obj.B_StartMorphOP = uicontrol( 'Parent', HButtonBoxMorph5, params.default_normalized_font{:}, 'String', 'Run Morphological Operation','Enable','off','Tag','buttonMorphOP' );
            drawnow limitrate;

            %%%%%%%%%%%%%% Panel Info Text %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            hBoxSize=uix.HBox('Parent', PanelInfo, params.default_box_spacing_padding{:});
            obj.B_InfoText = uicontrol('Parent',hBoxSize,'Style','listbox','String',{''});
            
            %%%%%%%%%%%%%% Set Init Values %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            set(obj.B_LineWidth,'Value',1);
            set(obj.B_Threshold,'Value',0.1);
            set(obj.B_Alpha,'Value',1);
            set(obj.B_MorphOP,'Value','close small gaps' );
            
            set(obj.B_LineWidthValue,'String',num2str(get(obj.B_LineWidth,'Value')));
            set(obj.B_ThresholdValue,'String',num2str(get(obj.B_Threshold,'Value')));
            set(obj.B_AlphaValue,'String',num2str(get(obj.B_Alpha,'Value')));
            
            set(obj.B_ThresholdMode,'Value','Automatic Watershed I');
            %%%%%%%%%%%%%%% call edit functions for GUI
            obj.setToolTipStrings();
                        
            set(mainCard,'Visible','on');
            drawnow limitrate;

        end % end constructor
        
        function checkPlanes(obj,Pics,mainFig)
            % Opens a new figure to show all founded color plane images.
            % User can change the plane if the program classified these
            % wrong.
            %
            %   checkPlanes(obj,Pics);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to viewEdit object
            %           Pics:   Cell-Array containing all color-plane
            %                   images and the original RGB image
            %
            params = view_helper_default_params();
              
            obj.hFCP = uifigure('NumberTitle','off','ToolBar','none',...
                'MenuBar','none','Name','Check Color Planes',...
                'Units','normalized','Visible','off','Tag','CheckPlanesFigure',...
                'InvertHardcopy','on');
            
            theme(obj.hFCP ,mainFig.Theme)
            %get position of mainFigure
            posMainFig = get(mainFig,'Position');
            set(obj.hFCP, 'position', [posMainFig(1) posMainFig(2) 0.8 0.8]);
            movegui(obj.hFCP,'center')
            set(obj.hFCP,'WindowStyle',getWindowsStyleFromSettings());

            mainBox = uix.HBox('Parent', obj.hFCP, params.default_box_spacing_padding{:},'Padding', 5);
            tabPanel = uix.TabPanel( 'Parent',  mainBox, params.default_tab_panel{:},'FontSize',params.fontSizeB, 'Tag', 'checkPlanesTabPanel');
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Color Plane Tab
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            panelolorPlane =    uix.Panel('Parent',  tabPanel, params.default_panel{:},'FontSize',params.fontSizeM,'BorderWidth',1,...
                'Title','Color Plane Images. Check and Change Pseudocolor for each Image');
            MainVBoxColorPlane = uix.VBox('Parent',panelolorPlane,'Spacing', 5,'Padding',5);
            MainGridColor = uix.Grid('Parent',MainVBoxColorPlane,'Padding',5);
            
            VBox1ColorPlane = uix.VBox('Parent',MainGridColor,'Spacing', 5,'Padding',5);
            obj.B_AxesCheckRGBFRPlane = axes('Parent',VBox1ColorPlane,'ActivePositionProperty','position');
            axis(obj.B_AxesCheckRGBFRPlane,'image');
            imshow(Pics{3},'Parent',obj.B_AxesCheckRGBFRPlane)
            uilabel( 'Parent', VBox1ColorPlane, 'HorizontalAlignment','center', 'Text', 'RGB Image generated from Red Green Blue and FarRed plane');
            set(VBox1ColorPlane,'Heights',[-10 40])
            
            VBox2ColorPlane = uix.VBox('Parent',MainGridColor,'Spacing', 5,'Padding',5);
            obj.B_AxesCheckRGBPlane = axes('Parent',VBox2ColorPlane,'ActivePositionProperty','position');
            axis(obj.B_AxesCheckRGBPlane ,'image');
            imshow(Pics{9},'Parent',obj.B_AxesCheckRGBPlane)
            uilabel( 'Parent', VBox2ColorPlane, 'HorizontalAlignment','center','Text', 'RGB Image generated from Red Green and Blue Plane (no FarRed)');
            set(VBox2ColorPlane,'Heights',[-10 40])
            
            VBox3ColorPlane = uix.VBox('Parent',MainGridColor,'Spacing', 5,'Padding',5);
            obj.B_AxesCheckPlaneGreen = axes('Parent',uicontainer('Parent', VBox3ColorPlane),'ActivePositionProperty','position','Units','normalized');
            axis(obj.B_AxesCheckPlaneGreen ,'image');
            set(obj.B_AxesCheckPlaneGreen, 'position', [0 0 1 1]);
            imshow(Pics{5},'Parent',obj.B_AxesCheckPlaneGreen)
            String = {'Green Plane - Collagen (pseudo color: green)' , 'Blue Plane - Type 1 fibers (pseudo color: blue)', 'Red Plane - Type 2 fibers (all) (pseudo color: red)', 'FarRed Plane - Type 2 fibers specification (2x,2a,2ax) (pseudo color: yellow)'};
            obj.B_ColorPlaneGreen = uidropdown( 'Parent', VBox3ColorPlane,'Tag','popupmenu', 'Items', String, 'ValueIndex' ,1);
            set(VBox3ColorPlane,'Heights',[-10 40])
            
            VBox4ColorPlane = uix.VBox('Parent',MainGridColor,'Spacing', 5,'Padding',5);
            obj.B_AxesCheckPlaneBlue = axes('Parent',uicontainer('Parent', VBox4ColorPlane),'ActivePositionProperty','position','Units','normalized');
            axis(obj.B_AxesCheckPlaneBlue ,'image');
            set(obj.B_AxesCheckPlaneBlue, 'position', [0 0 1 1]);
            imshow(Pics{6} ,'Parent',obj.B_AxesCheckPlaneBlue )

            String = {'Green Plane - Collagen (pseudo color: green)' , 'Blue Plane - Type 1 fibers (pseudo color: blue)', 'Red Plane - Type 2 fibers (all) (pseudo color: red)', 'FarRed Plane - Type 2 fibers specification (2x,2a,2ax) (pseudo color: yellow)'};
            obj.B_ColorPlaneBlue = uidropdown( 'Parent', VBox4ColorPlane,'Tag','popupmenu', 'Items', String , 'ValueIndex' ,2);
            set(VBox4ColorPlane,'Heights',[-10 40])
            
            VBox5ColorPlane = uix.VBox('Parent',MainGridColor,'Spacing', 5,'Padding',5);
            obj.B_AxesCheckPlaneRed = axes('Parent',uicontainer('Parent', VBox5ColorPlane),'ActivePositionProperty','position','Units','normalized');
            axis(obj.B_AxesCheckPlaneRed ,'image');
            set(obj.B_AxesCheckPlaneRed, 'position', [0 0 1 1]);
            imshow(Pics{7},'Parent',obj.B_AxesCheckPlaneRed)

            String = {'Green Plane - Collagen (pseudo color: green)' , 'Blue Plane - Type 1 fibers (pseudo color: blue)', 'Red Plane - Type 2 fibers (all) (pseudo color: red)', 'FarRed Plane - Type 2 fibers specification (2x,2a,2ax) (pseudo color: yellow)'};
            obj.B_ColorPlaneRed = uidropdown( 'Parent', VBox5ColorPlane,'Tag','popupmenu', 'Items', String , 'ValueIndex' ,3);
            set(VBox5ColorPlane,'Heights',[-10 40])
            
            VBox6ColorPlane = uix.VBox('Parent',MainGridColor,'Spacing', 5,'Padding',5);
            obj.B_AxesCheckPlaneFarRed = axes('Parent',uicontainer('Parent', VBox6ColorPlane),'ActivePositionProperty','position','Units','normalized');
            axis(obj.B_AxesCheckPlaneFarRed ,'image');
            set(obj.B_AxesCheckPlaneFarRed, 'position', [0 0 1 1]);
            imshow(Pics{8},'Parent',obj.B_AxesCheckPlaneFarRed)

            String = {'Green Plane - Collagen (pseudo color: green)' , 'Blue Plane - Type 1 fibers (pseudo color: blue)', 'Red Plane - Type 2 fibers (all) (pseudo color: red)', 'FarRed Plane - Type 2 fibers specification (2x,2a,2ax) (pseudo color: yellow)'};
            obj.B_ColorPlaneFarRed = uidropdown( 'Parent', VBox6ColorPlane,'Tag','popupmenu', 'Items', String , 'ValueIndex' ,4);
            set(VBox6ColorPlane,'Heights',[-10 40])
            
            HBox = uix.HBox('Parent',MainVBoxColorPlane,'Spacing', 5,'Padding',5);
            
            HButtonBox1ColorPlane = uix.HButtonBox('Parent',HBox,'Spacing', 5,'Padding',5,'ButtonSize',[600 600]);
            obj.B_CheckPText = uilabel( 'Parent', HButtonBox1ColorPlane,'HorizontalAlignment','center','Text', 'Confirm changes with OK:','FontSize',params.fontSizeB*1.5);
            
            HButtonBox2ColorPlane = uix.HButtonBox('Parent',HBox,'Spacing', 5,'Padding',5,'ButtonSize',[600 600]);
            obj.B_CheckPBack = uicontrol( 'Parent', HButtonBox2ColorPlane,'String', 'Back to Edit-Mode','FontSize',params.fontSizeB);
            
            HButtonBox3ColorPlane = uix.HButtonBox('Parent',HBox,'Spacing', 5,'Padding',5,'ButtonSize',[600 600]);
            obj.B_CheckPOK = uicontrol( 'Parent', HButtonBox3ColorPlane,'String', 'OK','FontSize',params.fontSizeB);
            
            set( MainGridColor, 'Heights', [-1 -1 ], 'Widths', [-1 -1 -1] ,'Spacing',3);
            set(MainVBoxColorPlane,'Heights',[-10 -1])
            set(HBox,'Widths',[-3 -1 -1])
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Brigntness Correction images Tab
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            panelolorPlane =    uix.Panel('Parent',  tabPanel, params.default_panel{:},'FontSize',params.fontSizeM,'BorderWidth',1,...
                'Title','Brightness Correction Images. Check, Select or Calculate Brightness Correction Images');
            MainVBoxBrightness = uix.VBox('Parent',panelolorPlane,'Spacing', 5,'Padding',5);
            MainGridBrightness = uix.Grid('Parent',MainVBoxBrightness,'Padding',5,'Spacing', 5);
            drawnow limitrate
            tabPanel.Selection = 2;
            drawnow limitrate
            % Image befor brightness correction
            VBox1Brightness = uix.VBox('Parent',MainGridBrightness,'Spacing', 5,'Padding',5);
            obj.B_AxesCheckRGB_noBC= axes('Parent',VBox1Brightness,'ActivePositionProperty','position');
            imshow(Pics{10},'Parent',obj.B_AxesCheckRGB_noBC)
            axis(obj.B_AxesCheckRGB_noBC ,'image');
            VButtonBox1 = uix.VButtonBox('Parent', VBox1Brightness,'ButtonSize',[2000 20]);
            uilabel( 'Parent', VButtonBox1, 'HorizontalAlignment','center', 'Text', 'RGB Image befor brightness correction');
            uix.Empty( 'Parent', VBox1Brightness );
            set(VBox1Brightness,'Heights',[-10 30 30])
            
            % Image after brightness correction
            VBox2Brightness = uix.VBox('Parent',MainGridBrightness,'Spacing', 5,'Padding',5);
            obj.B_AxesCheckRGB_BC = axes('Parent',VBox2Brightness,'ActivePositionProperty','position');
            imshow(Pics{3},'Parent',obj.B_AxesCheckRGB_BC)
            axis(obj.B_AxesCheckRGB_BC ,'image');
            VButtonBox2 = uix.VButtonBox('Parent', VBox2Brightness,'ButtonSize',[2000 20]);
            uilabel( 'Parent', VButtonBox2,'HorizontalAlignment','center', 'Text', 'RGB Image after brightness correction');
            uix.Empty( 'Parent', VBox2Brightness );
            set(VBox2Brightness,'Heights',[-10 30 30])
            
            % Brightness correction image for Green Plane
            VBox3Brightness = uix.VBox('Parent',MainGridBrightness,'Spacing', 5,'Padding',5);
            obj.B_AxesCheckBrightnessGreen = axes('Parent',uicontainer('Parent', VBox3Brightness),'ActivePositionProperty','position','Units','normalized');
            axis(obj.B_AxesCheckBrightnessGreen ,'image');
            set(obj.B_AxesCheckBrightnessGreen, 'position', [0 0 1 1]);
            imshow(Pics{11},[],'Parent',obj.B_AxesCheckBrightnessGreen)
            %caxis([0, 1])
            HBox31Brightness = uix.HButtonBox('Parent',VBox3Brightness,'Spacing', 5,'Padding',5,'ButtonSize',[600 20]);

            uilabel( 'Parent', HBox31Brightness,'HorizontalAlignment','center', 'Text', 'Current image Green plane:');
            obj.B_CurBrightImGreen = uilabel( 'Parent', HBox31Brightness,'HorizontalAlignment','center', 'Text', Pics{12});

            HBox32Brightness = uix.HButtonBox('Parent',VBox3Brightness,'Spacing', 1,'Padding',1,'ButtonSize',[600 30]);
            obj.B_SelectBrightImGreen = uicontrol( 'Parent', HBox32Brightness,'String', 'Select new image','FontUnits','normalized','Fontsize',0.5,'Tag','SelectBCGreen');
            obj.B_CreateBrightImGreen = uicontrol( 'Parent', HBox32Brightness,'String', 'Create image','FontUnits','normalized','Fontsize',0.5,'Tag','CreateBCGreen');
            obj.B_DeleteBrightImGreen = uicontrol( 'Parent', HBox32Brightness,'String', 'Delete image','FontUnits','normalized','Fontsize',0.5,'Tag','DeleteBCGreen');
            
            set(VBox3Brightness,'Heights',[-10 30 30])
            
            % Brightness correction image for Blue Plane
            VBox4Brightness = uix.VBox('Parent',MainGridBrightness,'Spacing', 5,'Padding',5);
            obj.B_AxesCheckBrightnessBlue = axes('Parent',uicontainer('Parent', VBox4Brightness),'ActivePositionProperty','position','Units','normalized');
            axis(obj.B_AxesCheckBrightnessBlue ,'image');
            set(obj.B_AxesCheckBrightnessBlue, 'position', [0 0 1 1]);
            imshow(Pics{13},[],'Parent',obj.B_AxesCheckBrightnessBlue)
            %caxis([0, 1])
            HBox41Brightness = uix.HButtonBox('Parent',VBox4Brightness,'Spacing', 5,'Padding',5,'ButtonSize',[600 20]);

            uilabel( 'Parent', HBox41Brightness,'HorizontalAlignment','center', 'Text', 'Current image Blue plane:');
            obj.B_CurBrightImBlue = uilabel( 'Parent', HBox41Brightness,'HorizontalAlignment','center', 'Text', Pics{14});

            HBox42Brightness = uix.HButtonBox('Parent',VBox4Brightness,'Spacing', 1,'Padding',1,'ButtonSize',[600 30]);
            obj.B_SelectBrightImBlue = uicontrol( 'Parent', HBox42Brightness,'String', 'Select new image','FontUnits','normalized','Fontsize',0.5,'Tag','SelectBCBlue');
            obj.B_CreateBrightImBlue = uicontrol( 'Parent', HBox42Brightness,'String', 'Create image','FontUnits','normalized','Fontsize',0.5,'Tag','CreateBCBlue');
            obj.B_DeleteBrightImBlue = uicontrol( 'Parent', HBox42Brightness,'String', 'Delete image','FontUnits','normalized','Fontsize',0.5,'Tag','DeleteBCBlue');
            
            set(VBox4Brightness,'Heights',[-10 30 30])
            
            % Brightness correction image for Red Plane
            VBox5Brightness = uix.VBox('Parent',MainGridBrightness,'Spacing', 5,'Padding',5);
            obj.B_AxesCheckBrightnessRed = axes('Parent',uicontainer('Parent', VBox5Brightness),'ActivePositionProperty','position','Units','normalized');
            axis(obj.B_AxesCheckBrightnessRed ,'image');
            set(obj.B_AxesCheckBrightnessRed, 'position', [0 0 1 1]);
            imshow(Pics{15},[],'Parent',obj.B_AxesCheckBrightnessRed)
            %caxis([0, 1])
            HBox51Brightness = uix.HButtonBox('Parent',VBox5Brightness,'Spacing', 5,'Padding',5,'ButtonSize',[600 20]);

            uilabel( 'Parent', HBox51Brightness,'HorizontalAlignment','center', 'Text', 'Current image Red plane:');
            obj.B_CurBrightImRed = uilabel( 'Parent', HBox51Brightness,'HorizontalAlignment','center', 'Text', Pics{16});

            HBox52Brightness = uix.HButtonBox('Parent',VBox5Brightness,'Spacing', 1,'Padding',1,'ButtonSize',[600 30]);
            obj.B_SelectBrightImRed = uicontrol( 'Parent', HBox52Brightness,'String', 'Select new image','FontUnits','normalized','Fontsize',0.5,'Tag','SelectBCRed');
            obj.B_CreateBrightImRed = uicontrol( 'Parent', HBox52Brightness,'String', 'Create image','FontUnits','normalized','Fontsize',0.5,'Tag','CreateBCRed');
            obj.B_DeleteBrightImRed = uicontrol( 'Parent', HBox52Brightness,'String', 'Delete image','FontUnits','normalized','Fontsize',0.5,'Tag','DeleteBCRed');
            
            set(VBox5Brightness,'Heights',[-10 30 30])
            
            % Brightness correction image for FarRed Plane
            VBox6Brightness = uix.VBox('Parent',MainGridBrightness,'Spacing', 5,'Padding',5);
            obj.B_AxesCheckBrightnessFarRed = axes('Parent',uicontainer('Parent', VBox6Brightness),'ActivePositionProperty','position','Units','normalized');
            axis(obj.B_AxesCheckBrightnessFarRed ,'image');
            set(obj.B_AxesCheckBrightnessFarRed, 'position', [0 0 1 1]);
            imshow(Pics{17},[],'Parent',obj.B_AxesCheckBrightnessFarRed)
            %caxis([0, 1])
            HBox61Brightness = uix.HButtonBox('Parent',VBox6Brightness,'Spacing', 5,'Padding',5,'ButtonSize',[600 20]);

            uilabel( 'Parent', HBox61Brightness,'HorizontalAlignment','center', 'Text', 'Current image Farred plane:');
            obj.B_CurBrightImFarRed = uilabel( 'Parent', HBox61Brightness,'HorizontalAlignment','center', 'Text', Pics{18});

            HBox62Brightness = uix.HButtonBox('Parent',VBox6Brightness,'Spacing', 1,'Padding',1,'ButtonSize',[600 30]);
            obj.B_SelectBrightImFarRed = uicontrol( 'Parent', HBox62Brightness,'String', 'Select new image','FontUnits','normalized','Fontsize',0.5,'Tag','SelectBCFarRed');
            obj.B_CreateBrightImFarRed = uicontrol( 'Parent', HBox62Brightness,'String', 'Create image','FontUnits','normalized','Fontsize',0.5,'Tag','CreateBCFarRed');
            obj.B_DeleteBrightImFarRed = uicontrol( 'Parent', HBox62Brightness,'String', 'Delete image','FontUnits','normalized','Fontsize',0.5,'Tag','DeleteBCFarRed');
            
            set(VBox6Brightness,'Heights',[-10 30 30])
            
            set( MainGridBrightness, 'Heights', [-1 -1 ], 'Widths', [-1 -1 -1] ,'Spacing',10);
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Sizes
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            tabPanel.TabTitles = {'Color Plane Images', 'Brightness Correction Images'};
            tabPanel.TabWidth = 450;
            drawnow limitrate
            tabPanel.Selection =1;
            set(obj.hFCP,'Visible','on');
            drawnow limitrate;
        end
        
        function infoMessage(~,Text)
            % Shows info text to the user.
            %
            %   infoMessage(obj,Text);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to viewEdit object
            %           Text:   Cellaray containing the info text
            %
            beep
            uiwait(msgbox(Text,'Info','warn','modal'));
        end
        
        function setToolTipStrings(obj)
            % Set all tooltip strings in the properties of the operationg
            % elements that are shown in the main Edit GUI.

            UndoToolTip = sprintf('Undo the last changes to the binary image.');

            RedoToolTip = sprintf('Redo the last undone changes to the binary image.');
            
            NewPicToolTip = sprintf('Select a new image file for further processing.');
            
            CheckPlanesToolTip = sprintf(['Open a menu to view or modify the color plane images:\n',...
                'Red, Green, Blue, and Far-Red.']);
            
            CheckMaskToolTip = sprintf(['Display detected objects in different RGB colors\n',...
                'to verify the mask for further segmentation.']);
            
            StartAnaModeToolTip = sprintf('Start image analysis mode.');

            
            ImageOverlaySelectionToolTip = sprintf('Select the image displayed behind the binary mask.');
            
            AlphaActiveToolTip = sprintf(['Enable to display the image behind the binary mask.\n',...
                'Use the alpha value to adjust the transparency effect.']);
            
            AlphaValueToolTip = sprintf('Adjust the transparency of the binary mask to reveal the image behind.');

            
            ThreshModeToolTip = sprintf('Select the binarization method for fiber segmentation.');

            FiberForeBackGroundToolTip = sprintf(['Select whether fibers in the green plane are displayed in the foreground or background.\n',...
                'The green (pseudocolor) plane corresponds to the image highlighting collagen.']);  

            ThreshToolTip = sprintf('Adjust the threshold value for image binarization (only applies to certain modes).');            
            
            LineWidthToolTip = sprintf('Adjust the line width used for drawing on the binary image.');
            
            ColorToolTip = sprintf('Select the color used for drawing on the binary image.');
            
            InvertToolTip = sprintf(['Invert the binary image.\n',...
                'This does not affect segmentation results.']);
            
            MorphToolTip = sprintf('Select a morphological operation.');
            
            StructuringToolTip = sprintf('Select the structuring element.');
            
            StructuringSizeToolTip = sprintf('Set the size of the structuring element.');
            
            NoOfIterationsToolTip = sprintf('Set the number of iterations.');
            
            RunMorphToolTip = sprintf(['Apply the selected morphological operation\n',...
                'to the binary image.']);
            
            set(obj.B_Undo,'tooltipstring',UndoToolTip);
            set(obj.B_Redo,'tooltipstring',RedoToolTip);
            set(obj.B_NewPic,'tooltipstring',NewPicToolTip);
            set(obj.B_CheckPlanes,'tooltipstring',CheckPlanesToolTip);
            set(obj.B_CheckMask,'tooltipstring',CheckMaskToolTip);
            set(obj.B_StartAnalyzeMode,'tooltipstring',StartAnaModeToolTip);

            set(obj.B_Alpha,'tooltipstring',AlphaValueToolTip);
            set(obj.B_AlphaValue,'tooltipstring',AlphaValueToolTip);
            set(obj.B_AlphaActive,'tooltipstring',AlphaActiveToolTip);
            set(obj.B_ImageOverlaySelection,'Tooltip',ImageOverlaySelectionToolTip);
            
            set(obj.B_ThresholdMode,'Tooltip',ThreshModeToolTip);
            set(obj.B_FiberForeBackGround,'Tooltip',FiberForeBackGroundToolTip);
            set(obj.B_Threshold,'tooltipstring',ThreshToolTip);
            set(obj.B_ThresholdValue,'tooltipstring',ThreshToolTip);
            set(obj.B_LineWidth,'tooltipstring',LineWidthToolTip);
            set(obj.B_LineWidthValue,'tooltipstring',LineWidthToolTip);
            set(obj.B_Color,'Tooltip',ColorToolTip);
            set(obj.B_Invert,'tooltipstring',InvertToolTip);
            
            set(obj.B_MorphOP,'Tooltip',MorphToolTip);
            set(obj.B_ShapeSE,'Tooltip',StructuringToolTip);
            set(obj.B_SizeSE,'tooltipstring',StructuringSizeToolTip);
            set(obj.B_NoIteration,'tooltipstring',NoOfIterationsToolTip);
            set(obj.B_StartMorphOP,'tooltipstring',RunMorphToolTip); 
        end
        
        function delete(~)
            %Deconstructor
        end
        
    end
   
    
    
end

