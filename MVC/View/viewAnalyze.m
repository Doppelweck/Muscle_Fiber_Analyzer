classdef viewAnalyze < handle
    %viewAnalyze   view of the analyze-MVC (Model-View-Controller).
    %Creates the second card panel in the main figure to select the  
    %parameters for further classification. The viewEdit class is called by  
    %the main.m file. Contains serveral buttons and uicontrol elements to 
    %tchange the classification parameters and to runs the classification.
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

        panelControl;    %handle to panel with controls.
        panelAxes;   %handle to panel with image.
        panelAnalyze; %handle to panel with editAnalyze components.
        hAP;    %handle to axes with image.
        hAMC; %handle to axes for manual classification mode.
        hFM; %handle to figure to change the Fiber-Type.
        hFMC; %handle to figure for manual classification mode.
        hFPR; %handle to figure the shows a preview of the ruslts after calssification.
        hAPRBR; %handle to axes with Blue over Red classification results in the Preview Results Figure.
        hAPRFRR; %handle to axes with Farred over Red classification results in the Preview Results Figure.
        ParaCard;
        
        B_BackEdit; %Button, close the AnalyzeMode and opens the the EditMode.     
        B_StartAnalyze; %Button, runs the segmentation and classification functions.
        B_StartResults; %Button, close the AnalyzeMode and opens the the ResultsMode.
        B_PreResults; %Button, Shows a preview scatter plot with classified fibers. 
        
        B_AnalyzeMode; %Popup menu, select the classification method.
        
        B_AreaActive; %Ceckbox, select if area parameter is used for classificaton.
        B_MinArea; %TextEditBox, minimal allowed fiber area.
        B_MaxArea; %TextEditBox, maximal allowed fiber area.
        
        B_RoundnessActive; %Checkbox, select if roundness parameter is used for classificaton.
        B_MinRoundness; %TextEditBox, minimal allowed fiber roudness.
        
        B_AspectRatioActive %Checkbox, select if aspect ratio parameter is used for classificaton.
        B_MinAspectRatio; %TextEditBox, minimal allowed fiber aspect ratio.
        B_MaxAspectRatio; %TextEditBox, maximal allowed fiber aspect ratio.
        
        B_BlueRedThreshActive; %Checkbox, select if Blue/Red threshold parameter is used for classificaton.
        B_BlueRedThresh; %TextEditBox, Blue/Red threshold to indentify type 1 and type 2 fibers.
        B_BlueRedDistBlue; %TextEditBox, distance from Blue/Red threshold line in Blue direction to indentify type 12 hybrid fibers.
        B_BlueRedDistRed; %TextEditBox, distance from Blue/Red threshold line in Red direction to indentify type 12 hybrid fibers.
        
        B_FarredRedThreshActive; %Checkbox, select if FarRed/Red threshold parameter is used for classificaton.
        B_FarredRedThresh; %TextEditBox, FarRed/Red threshold to indentify type 2a and type 2x fibers.
        B_FarredRedDistFarred; %TextEditBox, distance from FarRed/Red threshold line in FarRed direction to indentify type 2ax fibers.
        B_FarredRedDistRed; %TextEditBox, distance from FarRed/Red threshold line in Red direction to indentify type 2ax fibers.
        
        B_ColorValueActive; %Checkbox, select if color value parameter is used for classificaton.
        B_ColorValue; %TextEditBox, minimal allowed fiber color value (HSV).
        
        B_12HybridFiberActive;
        B_2axHybridFiberActive;
        
        B_XScale;
        B_YScale;
        
        B_TextObjNo; %TextBox, shows label number of selected fiber in the fiber information panel.
        B_TextArea; %TextBox, shows area of selected fiber in the fiber information panel.
        B_TextRoundness; %TextBox, shows roundness of selected fiber in the fiber information panel.
        B_TextAspectRatio; %TextBox, shows aspect ratio of selected fiber in the fiber information panel.
        B_TextMeanRed; %TextBox, shows mean Red value of selected fiber in the fiber information panel.
        B_TextMeanGreen; %TextBox, shows mean Green value of selected fiber in the fiber information panel.
        B_TextMeanBlue; %TextBox, shows mean Blue value of selected fiber in the fiber information panel.
        B_TextMeanFarred; %TextBox, shows mean Farred value of selected fiber in the fiber information panel.
        B_TextBlueRedRatio; %TextBox, shows Blue/Red ratio value of selected fiber in the fiber information panel.
        B_TextFarredRedRatio; %TextBox, shows Farred/Red ratio value of selected fiber in the fiber information panel.
        B_TextColorValue; %TextBox, shows color value (HSV) of selected fiber in the fiber information panel.
        B_TextFiberType; %TextBox, shows fiber type of selected fiber in the fiber information panel.
        B_AxesInfo; %handle to axes with image of selected fiber in the fiber information panel.
        B_InfoText; %Shows the info log text.
        
        B_FiberTypeManipulate; %Popup menu, select new fiber type.
        B_ManipulateOK; %Button, apply fiber type changes.
        B_ManipulateCancel; %Button, cancel fiber type changes.
        
        B_ManualInfoText; %Text, info text for manual classification
        B_ManualClassBack; %Button, manual classification, go back to choose main fiber types.
        B_ManualClassEnd; %Button, quit manual classification.
        B_ManualClassForward; %Button, manual classification, go forward to specify type 2 fiber types.
        PanelFiberInformation;
    end
    
    methods
        function obj = viewAnalyze(mainCard)
            if nargin < 1 || isempty(mainCard)
                mainCard = uifigure('Units','normalized','Position',[0.01 0.05 0.98 0.85]);
                theme(mainCard,"auto");
            end
            
            params = view_helper_default_params();
            
            set(mainCard,'Visible','off');
            obj.panelAnalyze = uix.HBox( 'Parent', mainCard , params.default_box_spacing_padding{:});
            
            obj.panelAxes =    uix.Panel('Parent', obj.panelAnalyze,params.default_panel{:}, 'Title', 'PICTURE');
            obj.panelControl = uix.Panel('Parent', obj.panelAnalyze,params.default_panel{:}, 'Title', 'CLASSIFICATION','TitlePosition','centertop');
            set( obj.panelAnalyze, 'MinimumWidths', [1 320] );
            set( obj.panelAnalyze, 'Widths', [-80 -20] );
            
            obj.hAP = axes('Parent',uicontainer('Parent', obj.panelAxes), 'FontUnits','normalized','Fontsize',0.012);
            axtoolbar(obj.hAP,{'export','datacursor','pan','zoomin','zoomout','restoreview'});
            axis image
            set(obj.hAP, 'LooseInset', [0,0,0,0]);
            set(obj.hAP,'Box','off');
            
            PanelVBox = uix.VBox('Parent',obj.panelControl,params.default_box_spacing_padding{:});
            
            PanelControl =              uix.Panel('Parent',PanelVBox,params.default_panel{:},'Title','Main Controls');
            PanelPara =                 uix.Panel('Parent',PanelVBox,params.default_panel{:},'Title','Parameter');
            obj.PanelFiberInformation = uix.Panel('Parent',PanelVBox,params.default_panel{:},'Title','Fiber Informations');
            PanelInfo =                 uix.Panel('Parent',PanelVBox,params.default_panel{:},'Title','Info Log');
            
            
            set( PanelVBox, 'Heights', [-13 -30 -41 -16]);
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%% Panel Control %%%%%%%%%%%%%%%%%%%%%%%%%
            VBBoxControl = uix.VBox('Parent', PanelControl, params.default_box_spacing_padding{:});
            
            HBBoxControl1 = uix.HButtonBox('Parent',  VBBoxControl,params.default_HButtonBox_Main{:}  );
            obj.B_BackEdit =     uicontrol( 'Parent', HBBoxControl1,params.default_normalized_font{:}, 'String', sprintf('\x25C4 Segmentation'),'Tag','pushbuttonBackEdit');
            obj.B_StartResults = uicontrol( 'Parent', HBBoxControl1,params.default_normalized_font{:}, 'String', sprintf('Results \x25BA'),'Tag','pushbuttonStartResults');
            
            HBBoxControl2 = uix.HButtonBox('Parent',  VBBoxControl,params.default_HButtonBox_Main{:} );
            obj.B_StartAnalyze = uicontrol( 'Parent', HBBoxControl2,params.default_normalized_font{:}, 'String', sprintf('\x21DB Start analyzing'),'Tag','pushbuttonAnalyze' );
            obj.B_PreResults =   uicontrol( 'Parent', HBBoxControl2,params.default_normalized_font{:}, 'String', sprintf('Preview results \x2750') ,'Tag','pushbuttonPreResults');
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%% Panel Para %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            mainVBoxPara = uix.VBox('Parent', PanelPara,params.default_box_spacing_padding{:});
            
            %%%%%%%%%%%%%%%% 1. Row Analyze Mode
            HBoxPara1 = uix.HBox('Parent', mainVBoxPara, params.default_box_spacing_padding{:});
            
            HButtonBoxPara12 = uix.HButtonBox('Parent', HBoxPara1, params.default_HButtonBox{:} );
            String= {'Color-Ratio-Based triple labeling' ; 'Color-Ratio-Based quad labeling';...
            'OPTICS-Cluster-Based triple labeling' ; 'OPTICS-Cluster-Based quad labeling';'Manual CLassification triple labeling';'Manual CLassification quad labeling'; 'Collagen / Dystrophin'};
            obj.B_AnalyzeMode = uidropdown( 'Parent', HButtonBoxPara12, 'Items', String ,'Value','Color-Ratio-Based quad labeling','Tag','popupmenuAnalyzeMode');
                       
            %%%%%%%%%%%%%%%% 2. Row: Area
            HBoxPara2 = uix.HBox('Parent', mainVBoxPara, params.default_box_spacing_padding{:});
            
            HButtonBoxPara21 = uix.HButtonBox('Parent', HBoxPara2, params.default_HButtonBox{:});
            obj.B_AreaActive = uicontrol( 'Parent', HButtonBoxPara21,'Style','checkbox','Value',1,'Tag','AreaActive','Tag','checkboxAreaActive');

            HButtonBoxPara22 = uix.HButtonBox('Parent', HBoxPara2, params.default_HButtonBox{:});
            tempH = uilabel( 'Parent', HButtonBoxPara22, 'HorizontalAlignment','left', 'Text', ['Area (' sprintf('\x3BCm^2') ') from:']);
            
            HButtonBoxPara23 = uix.HButtonBox('Parent', HBoxPara2, params.default_HButtonBox{:});
            obj.B_MinArea = uicontrol( 'Parent', HButtonBoxPara23, params.default_normalized_font{:} ,'Style','edit','Tag','MinAreaValue', 'String', '100' ,'Tag','editMinArea');
            
            HButtonBoxPara24 = uix.HButtonBox('Parent', HBoxPara2, params.default_HButtonBox{:});
            tempH = uilabel( 'Parent', HButtonBoxPara24,'HorizontalAlignment','center', 'Text', 'to' );

            HButtonBoxPara25 = uix.HButtonBox('Parent', HBoxPara2, params.default_HButtonBox{:});
            obj.B_MaxArea = uicontrol( 'Parent', HButtonBoxPara25, params.default_normalized_font{:}, 'Style','edit', 'Tag','MaxAreaValue', 'String', '10000','Tag','editMaxArea' );
            
            set( HBoxPara2, 'Widths', [-8 -34 -22 -12 -22] );
            
            %%%%%%%%%%%%%%%% 3. Aspect Ratio
            HBoxPara3 = uix.HBox('Parent', mainVBoxPara, params.default_box_spacing_padding{:} );
            
            HButtonBoxPara31 = uix.HButtonBox('Parent', HBoxPara3, params.default_HButtonBox{:} );
            obj.B_AspectRatioActive = uicontrol( 'Parent', HButtonBoxPara31,'Style','checkbox','Value',1,'Tag','AspectRatioActive','Tag','checkboxAspectRatioActive');
            
            HButtonBoxPara32 = uix.HButtonBox('Parent', HBoxPara3, params.default_HButtonBox{:} );
            tempH = uilabel( 'Parent', HButtonBoxPara32, 'HorizontalAlignment','left', 'Text', 'Aspect Ratio from:' );
            
            HButtonBoxPara33 = uix.HButtonBox('Parent', HBoxPara3, params.default_HButtonBox{:} );
            obj.B_MinAspectRatio = uicontrol( 'Parent', HButtonBoxPara33,params.default_normalized_font{:}, 'Style','edit','Tag','MinAspectRatioValue', 'String', '1' ,'Tag','editMinAspectRatio');
            
            HButtonBoxPara34 = uix.HButtonBox('Parent', HBoxPara3, params.default_HButtonBox{:} );
            tempH = uilabel( 'Parent', HButtonBoxPara34, 'HorizontalAlignment','center', 'Text', 'to' );
            
            HButtonBoxPara35 = uix.HButtonBox('Parent', HBoxPara3, params.default_HButtonBox{:} );
            obj.B_MaxAspectRatio= uicontrol( 'Parent', HButtonBoxPara35, params.default_normalized_font{:}, 'Style','edit','Tag','MaxAspectRatioValue', 'String', '4' ,'Tag','editMaxAspectRatio');
            
            set( HBoxPara3, 'Widths', [-8 -34 -22 -12 -22] );
            
            %%%%%%%%%%%%%%%% 4. Row Color Value HSV ColorRoom
            HBoxPara4 = uix.HBox('Parent', mainVBoxPara, params.default_box_spacing_padding{:} );
            
            HButtonBoxPara41 = uix.HButtonBox('Parent', HBoxPara4, params.default_HButtonBox{:} );
            obj.B_ColorValueActive = uicontrol( 'Parent', HButtonBoxPara41,'Style','checkbox','Value',1,'Tag','ColorValueActive','Tag','checkboxColorValueActive');
            
            HButtonBoxPara42 = uix.HButtonBox('Parent', HBoxPara4, params.default_HButtonBox{:} );
            tempH = uilabel( 'Parent', HButtonBoxPara42, 'HorizontalAlignment','left', 'Text', 'Minimal Color Value:' ,'Tag','editMinColorValue');
            
            HButtonBoxPara43 = uix.HButtonBox('Parent', HBoxPara4, params.default_HButtonBox{:} );
            obj.B_ColorValue = uicontrol( 'Parent', HButtonBoxPara43, params.default_normalized_font{:}, 'Style','edit', 'Tag','ColorValue', 'String', '0.1' ,'Tag','editMaxColorValue');
            
            set( HBoxPara4, 'Widths', [-8 -34 -56] );
            
            %%%%%%%%%%%%%%%% 5. Row: Roundness
            HBoxPara5 = uix.HBox('Parent', mainVBoxPara,  params.default_box_spacing_padding{:} );
            
            HButtonBoxPara51 = uix.HButtonBox('Parent', HBoxPara5, params.default_HButtonBox{:} );
            obj.B_RoundnessActive = uicontrol( 'Parent', HButtonBoxPara51,'Style','checkbox','Value',1,'Tag','RoundnessActive','Tag','checkboxRoundnessActive');
            
            HButtonBoxPara52 = uix.HButtonBox('Parent', HBoxPara5, params.default_HButtonBox{:} );
            tempH = uilabel( 'Parent', HButtonBoxPara52, 'HorizontalAlignment','left', 'Text', 'Minimal Roundness:' ,'Tag','editMinRoundness');
            
            HButtonBoxPara53 = uix.HButtonBox('Parent', HBoxPara5, params.default_HButtonBox{:} );
            obj.B_MinRoundness = uicontrol( 'Parent', HButtonBoxPara53, params.default_normalized_font{:}, 'Style','edit', 'Tag','MinRoundValue', 'String', '0.15' ,'Tag','editMaxRoundness');
            
            set( HBoxPara5, 'Widths', [-8 -34 -56] );
            
            
            %%%%%%%%%%%%%%%% 6. Row Blue Red thresh
            obj.ParaCard = uix.CardPanel('Parent', mainVBoxPara,'Selection',0, 'Padding',0);
            
            VBoxMainPara1 = uix.VBox('Parent', obj.ParaCard );
            
            HBoxPara6 = uix.HBox('Parent', VBoxMainPara1,  params.default_box_spacing_padding{:} );
            
            HButtonBoxPara61 = uix.HButtonBox('Parent', HBoxPara6, params.default_HButtonBox{:} );
            obj.B_BlueRedThreshActive = uicontrol( 'Parent', HButtonBoxPara61,'style','checkbox','Value',1,'Tag','checkboxBlueRedThreshActive');
            
            HButtonBoxPara62 = uix.HButtonBox('Parent', HBoxPara6, params.default_HButtonBox{:} );
            tempH = uilabel( 'Parent', HButtonBoxPara62,  'HorizontalAlignment','left', 'Text', 'B/R thresh:' );
            
            HButtonBoxPara63 = uix.HButtonBox('Parent', HBoxPara6, params.default_HButtonBox{:} );
            obj.B_BlueRedThresh = uicontrol( 'Parent', HButtonBoxPara63, params.default_normalized_font{:}, 'Style','edit', 'Tag','editBlueRedThresh', 'String', '1');
            
            HButtonBoxPara64 = uix.HButtonBox('Parent', HBoxPara6, params.default_HButtonBox{:} );
            tempH = uilabel( 'Parent', HButtonBoxPara64, 'HorizontalAlignment','center',   'Text', 'Blue dist:' );
            
            HButtonBoxPara65 = uix.HButtonBox('Parent', HBoxPara6, params.default_HButtonBox{:} );
            obj.B_BlueRedDistBlue = uicontrol( 'Parent', HButtonBoxPara65, params.default_normalized_font{:}, 'Style','edit', 'Tag','editBlueRedDistBlue', 'String', '0.1');
            
            HButtonBoxPara66 = uix.HButtonBox('Parent', HBoxPara6, params.default_HButtonBox{:} );
            tempH = uilabel( 'Parent', HButtonBoxPara66, 'HorizontalAlignment','center',  'Text', 'Red dist:' );
            
            HButtonBoxPara67 = uix.HButtonBox('Parent', HBoxPara6, params.default_HButtonBox{:} );
            obj.B_BlueRedDistRed = uicontrol( 'Parent', HButtonBoxPara67, params.default_normalized_font{:}, 'Style','edit', 'Tag','editBlueRedDistRed', 'String', '0.1' );
            
            set( HBoxPara6, 'Widths', [-8 -22 -10 -20 -10 -20 -10] );
            

            %%%%%%%%%%%%%%%% 7. Row FarRed Red thresh
            HBoxPara7 = uix.HBox('Parent', VBoxMainPara1, params.default_box_spacing_padding{:} );
            
            HButtonBoxPara71 = uix.HButtonBox('Parent', HBoxPara7, params.default_HButtonBox{:} );
            obj.B_FarredRedThreshActive = uicontrol( 'Parent', HButtonBoxPara71,'style','checkbox','Value',1,'Tag','checkboxFarredRedThreshActive');
            
            HButtonBoxPara72 = uix.HButtonBox('Parent', HBoxPara7, params.default_HButtonBox{:} );
            tempH = uilabel( 'Parent', HButtonBoxPara72, 'HorizontalAlignment','left', 'Text', 'FR/R thresh:' );
            
            HButtonBoxPara73 = uix.HButtonBox('Parent', HBoxPara7, params.default_HButtonBox{:} );
            obj.B_FarredRedThresh = uicontrol( 'Parent', HButtonBoxPara73, params.default_normalized_font{:}, 'Style','edit', 'Tag','editFarredRedThresh', 'String', '1' );
            
            HButtonBoxPara74 = uix.HButtonBox('Parent', HBoxPara7, params.default_HButtonBox{:} );
            tempH = uilabel( 'Parent', HButtonBoxPara74, 'HorizontalAlignment','center', 'Text', 'Farred dist:');
            
            HButtonBoxPara75 = uix.HButtonBox('Parent', HBoxPara7, params.default_HButtonBox{:} );
            obj.B_FarredRedDistFarred = uicontrol( 'Parent', HButtonBoxPara75, params.default_normalized_font{:}, 'Style','edit', 'Tag','editFarredRedDistFarred', 'String', '0.1' );
            
            HButtonBoxPara76 = uix.HButtonBox('Parent', HBoxPara7, params.default_HButtonBox{:} );
            tempH = uilabel( 'Parent', HButtonBoxPara76, 'HorizontalAlignment','center', 'Text', 'Red dist:');
            
            HButtonBoxPara77 = uix.HButtonBox('Parent', HBoxPara7, params.default_HButtonBox{:} );
            obj.B_FarredRedDistRed = uicontrol( 'Parent', HButtonBoxPara77, params.default_normalized_font{:}, 'Style','edit', 'Tag','editFarredRedDistRed', 'String', '0.1' );
            
            set( HBoxPara7, 'Widths', [-8 -22 -10 -20 -10 -20 -10] );
            
            VBoxMainPara2 = uix.VBox('Parent', obj.ParaCard,'Padding',0,'Spacing', 0);
            
            HBoxPara71 = uix.HBox('Parent', VBoxMainPara2, params.default_box_spacing_padding{:} );
            
            HButtonBoxPara711 = uix.HButtonBox('Parent', HBoxPara71, params.default_HButtonBox{:} );
            obj.B_12HybridFiberActive = uicontrol( 'Parent', HButtonBoxPara711,'style','checkbox','Value',1,'Tag','checkboxHybrid12FiberActive');
            
            HButtonBoxPara712 = uix.HButtonBox('Parent', HBoxPara71, params.default_HButtonBox{:} );
            tempH = uilabel( 'Parent', HButtonBoxPara712, 'HorizontalAlignment','left', 'Text', 'Searching for 1/2-Hybrid Fibers allowed?' );
            
            set( HBoxPara71, 'Widths', [-8 -92] );
            
            HBoxPara72 = uix.HBox('Parent', VBoxMainPara2, params.default_box_spacing_padding{:} );
            
            HButtonBoxPara721 = uix.HButtonBox('Parent', HBoxPara72, params.default_HButtonBox{:} );
            obj.B_2axHybridFiberActive = uicontrol( 'Parent', HButtonBoxPara721,'style','checkbox','Value',1,'Tag','checkboxHybrid2axFiberActive');
            
            HButtonBoxPara722 = uix.HButtonBox('Parent', HBoxPara72, params.default_HButtonBox{:} );
            tempH = uilabel( 'Parent', HButtonBoxPara722, 'HorizontalAlignment','left', 'Text', 'Searching for 2ax-Hybrid Fibers allowed?' );
            
            set( HBoxPara72, 'Widths', [-8 -92] );
            
            obj.ParaCard.Selection = 1;
            %%%%%%%%%%%%%%%% 8. Pixel Scale
            HBoxPara8 = uix.HBox('Parent', mainVBoxPara,  params.default_box_spacing_padding{:} );

            HButtonBoxPara80 = uix.HButtonBox('Parent', HBoxPara8, params.default_HButtonBox{:} );
            tempH = uilabel( 'Parent', HButtonBoxPara80, 'HorizontalAlignment','left', 'Text', sprintf('Pixel Scale:'));
            
            HButtonBoxPara81 = uix.HButtonBox('Parent', HBoxPara8, params.default_HButtonBox{:} );
            tempH = uilabel( 'Parent', HButtonBoxPara81, 'HorizontalAlignment','center', 'Text', sprintf('Xs: \x3BCm/pixel'));
            
            HButtonBoxPara82 = uix.HButtonBox('Parent', HBoxPara8, params.default_HButtonBox{:} );
            obj.B_XScale = uicontrol( 'Parent', HButtonBoxPara82, params.default_normalized_font{:}, 'Style','edit', 'Tag','editXScale', 'String', '1' );
            
            HButtonBoxPara83 = uix.HButtonBox('Parent', HBoxPara8, params.default_HButtonBox{:} );
            tempH = uilabel( 'Parent', HButtonBoxPara83, 'HorizontalAlignment','center', 'Text' ,sprintf('Ys: \x3BCm/pixel') );
            
            HButtonBoxPara83 = uix.HButtonBox('Parent', HBoxPara8, params.default_HButtonBox{:} );
            obj.B_YScale = uicontrol( 'Parent', HButtonBoxPara83,params.default_normalized_font{:}, 'Style','edit', 'Tag','editYScale', 'String', '1' );
            
            set( HBoxPara8, 'Widths', [-1 -1 -1 -1 -1] );
            
            set( mainVBoxPara, 'Heights', [-1 -1 -1 -1 -1 -2 -1], 'Spacing', 0 );
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%% Panel FiberInformation %%%%%%%%%%%%%%%%%%%%%
            VBoxMainInfoFiber = uix.VBox('Parent', obj.PanelFiberInformation, params.default_box_spacing_padding{:} );
            
            HBoxInfo1 = uix.HBox('Parent', VBoxMainInfoFiber,  params.default_box_spacing_padding{:} );
            
            HButtonBoxInfo11 = uix.HButtonBox('Parent', HBoxInfo1, params.default_HButtonBox{:} );
            uilabel( 'Parent', HButtonBoxInfo11, 'HorizontalAlignment','left', 'Text', 'Label No.:' );
            
            HButtonBoxInfo12 = uix.HButtonBox('Parent', HBoxInfo1, params.default_HButtonBox{:} );
            obj.B_TextObjNo = uilabel( 'Parent', HButtonBoxInfo12,  'HorizontalAlignment','right',  'Text', ' - ','Tag','textFiberInfo' );
            
            uiextras.Empty( 'Parent', HBoxInfo1);
            
            HButtonBoxInfo13 = uix.HButtonBox('Parent', HBoxInfo1, params.default_HButtonBox{:} );
            uilabel( 'Parent', HButtonBoxInfo13,  'HorizontalAlignment','left', 'Text' , ['Area' sprintf(' (\x3BCm^2)') ':'] );
            
            HButtonBoxInfo14 = uix.HButtonBox('Parent', HBoxInfo1, params.default_HButtonBox{:} );
            obj.B_TextArea = uilabel( 'Parent', HButtonBoxInfo14, 'HorizontalAlignment','right', 'Text', ' - ' ,'Tag','textFiberInfo');
            
            set( HBoxInfo1, 'Widths', [-2 -2 -2 -2 -2] );
            
            
            HBoxInfo2 = uix.HBox('Parent', VBoxMainInfoFiber, params.default_box_spacing_padding{:} );
            
            HButtonBoxInfo21 = uix.HButtonBox('Parent', HBoxInfo2, params.default_HButtonBox{:} );
            uilabel( 'Parent', HButtonBoxInfo21,  'HorizontalAlignment','left',  'Text', 'Aspect Ratio:' );
            
            HButtonBoxInfo22 = uix.HButtonBox('Parent', HBoxInfo2, params.default_HButtonBox{:} );
            obj.B_TextAspectRatio = uilabel( 'Parent', HButtonBoxInfo22, 'HorizontalAlignment','right', 'Text', ' - ' ,'Tag','textFiberInfo');
            
            uiextras.Empty( 'Parent', HBoxInfo2);
            
            HButtonBoxInfo23 = uix.HButtonBox('Parent', HBoxInfo2, params.default_HButtonBox{:} );
            uilabel( 'Parent', HButtonBoxInfo23,  'HorizontalAlignment','left', 'Text', 'Roundness:' );
            
            HButtonBoxInfo24 = uix.HButtonBox('Parent', HBoxInfo2, params.default_HButtonBox{:} );
            obj.B_TextRoundness = uilabel( 'Parent', HButtonBoxInfo24, 'HorizontalAlignment','right', 'Text', ' - ' ,'Tag','textFiberInfo');
            
            set( HBoxInfo2, 'Widths', [-2 -2 -2 -2 -2] );
            
            
            HBoxInfo3 = uix.HBox('Parent', VBoxMainInfoFiber,  params.default_box_spacing_padding{:} );
            
            HButtonBoxInfo31 = uix.HButtonBox('Parent', HBoxInfo3, params.default_HButtonBox{:} );
            uilabel( 'Parent', HButtonBoxInfo31, 'HorizontalAlignment','left', 'Text', 'mean Red:' );
            
            HButtonBoxInfo32 = uix.HButtonBox('Parent', HBoxInfo3, params.default_HButtonBox{:} );
            obj.B_TextMeanRed = uilabel( 'Parent', HButtonBoxInfo32, 'HorizontalAlignment','right', 'Text', ' - ' ,'Tag','textFiberInfo');
            
            uiextras.Empty( 'Parent', HBoxInfo3);
            
            HButtonBoxInfo33 = uix.HButtonBox('Parent', HBoxInfo3, params.default_HButtonBox{:} );
            uilabel( 'Parent', HButtonBoxInfo33,  'HorizontalAlignment','left', 'Text', 'mean Green:' );
            
            HButtonBoxInfo34 = uix.HButtonBox('Parent', HBoxInfo3, params.default_HButtonBox{:} );
            obj.B_TextMeanGreen = uilabel( 'Parent', HButtonBoxInfo34,  'HorizontalAlignment','right', 'Text', ' - ' ,'Tag','textFiberInfo');
            
            set( HBoxInfo3, 'Widths', [-2 -2 -2 -2 -2] );
            
            
            HBoxInfo4 = uix.HBox('Parent', VBoxMainInfoFiber,  params.default_box_spacing_padding{:} );
            
            HButtonBoxInfo41 = uix.HButtonBox('Parent', HBoxInfo4, params.default_HButtonBox{:} );
            uilabel( 'Parent', HButtonBoxInfo41, 'HorizontalAlignment','left',  'Text', 'mean Blue:' );
            
            HButtonBoxInfo42 = uix.HButtonBox('Parent', HBoxInfo4, params.default_HButtonBox{:} );
            obj.B_TextMeanBlue = uilabel( 'Parent', HButtonBoxInfo42,  'HorizontalAlignment','right',  'Text', ' - ' ,'Tag','textFiberInfo');
            
            uiextras.Empty( 'Parent', HBoxInfo4);
            
            HButtonBoxInfo43 = uix.HButtonBox('Parent', HBoxInfo4, params.default_HButtonBox{:} );
            uilabel( 'Parent', HButtonBoxInfo43,  'HorizontalAlignment','left',  'Text', 'mean Farred:' );
            
            HButtonBoxInfo44 = uix.HButtonBox('Parent', HBoxInfo4, params.default_HButtonBox{:} );
            obj.B_TextMeanFarred = uilabel( 'Parent', HButtonBoxInfo44, 'HorizontalAlignment','right', 'Text', ' - ' ,'Tag','textFiberInfo');
            
            set( HBoxInfo4, 'Widths', [-2 -2 -2 -2 -2] );
            
            
            HBoxInfo5 = uix.HBox('Parent', VBoxMainInfoFiber,   params.default_box_spacing_padding{:} );
            
            HButtonBoxInfo51 = uix.HButtonBox('Parent', HBoxInfo5, params.default_HButtonBox{:} );
            uilabel( 'Parent', HButtonBoxInfo51,  'HorizontalAlignment','left' ,'Text', 'Blue/Red:' );
            
            HButtonBoxInfo52 = uix.HButtonBox('Parent', HBoxInfo5, params.default_HButtonBox{:} );
            obj.B_TextBlueRedRatio = uilabel( 'Parent', HButtonBoxInfo52,  'HorizontalAlignment','right', 'Text', ' - ' ,'Tag','textFiberInfo');
            
            uiextras.Empty( 'Parent', HBoxInfo5);
            
            HButtonBoxInfo53 = uix.HButtonBox('Parent', HBoxInfo5, params.default_HButtonBox{:} );
            uilabel( 'Parent', HButtonBoxInfo53, 'HorizontalAlignment','left', 'Text', 'Farred/Red:' );
            
            HButtonBoxInfo54 = uix.HButtonBox('Parent', HBoxInfo5, params.default_HButtonBox{:} );
            obj.B_TextFarredRedRatio = uilabel( 'Parent', HButtonBoxInfo54,  'HorizontalAlignment','right', 'Text', ' - ' ,'Tag','textFiberInfo');
            
            set( HBoxInfo5, 'Widths', [-2 -2 -2 -2 -2] );
            
            
            HBoxInfo6 = uix.HBox('Parent', VBoxMainInfoFiber,  params.default_box_spacing_padding{:} );
            
            HButtonBoxInfo61 = uix.HButtonBox('Parent', HBoxInfo6, params.default_HButtonBox{:} );
            uilabel( 'Parent', HButtonBoxInfo61,  'HorizontalAlignment','left' , 'Text', 'Color Value:' );
            
            HButtonBoxInfo62 = uix.HButtonBox('Parent', HBoxInfo6, params.default_HButtonBox{:} );
            obj.B_TextColorValue = uilabel( 'Parent', HButtonBoxInfo62, 'HorizontalAlignment','right', 'Text', ' - ' ,'Tag','textFiberInfo');
            
            uiextras.Empty( 'Parent', HBoxInfo6);
            
            HButtonBoxInfo63 = uix.HButtonBox('Parent', HBoxInfo6, params.default_HButtonBox{:} );
            uilabel( 'Parent', HButtonBoxInfo63, 'HorizontalAlignment','left', 'Text', 'Fiber Type:' );
            
            HButtonBoxInfo64 = uix.HButtonBox('Parent', HBoxInfo6, params.default_HButtonBox{:} );
            obj.B_TextFiberType = uilabel( 'Parent', HButtonBoxInfo64, 'HorizontalAlignment','right', 'Text', ' - ' ,'Tag','textFiberInfo');
            
            set( HBoxInfo6, 'Widths', [-2 -2 -2 -2 -2] );
            
            
            HBoxInfo7 = uix.HBox('Parent', VBoxMainInfoFiber);
            obj.B_AxesInfo = axes('Parent',uicontainer('Parent', HBoxInfo7),'FontUnits','normalized','Fontsize',0.015);
            axis image
            set(obj.B_AxesInfo, 'LooseInset', [0,0,0,0]);
            
            set( VBoxMainInfoFiber, 'Heights', [-6 -6 -6 -6 -6 -6 -64], 'Spacing', 1 );
            set( VBoxMainInfoFiber, 'MinimumHeights', [10 10 10 10 10 10 10] );

            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%% Panel Info Log %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            hBoxSize=uix.HBox('Parent', PanelInfo, params.default_box_spacing_padding{:});
            obj.B_InfoText = uicontrol('Parent',hBoxSize,'Style','listbox','String',{});
            
            %%%%%%%%%%%%%%% call edit functions for GUI
            obj.setToolTipStrings();
                        
            set(mainCard,'Visible','on');

        end
        
        function showInfoToManipulate(obj,PosInAxes,PosMainFig,PosCurrent,Info)
            % Creates a new figure to show and change the type of the
            % selected fiber object. 
            %
            %   showInfoToManipulate(obj,PosInAxes,PosMainFig,PosCurrent,Info);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:        Handle to viewEdit object
            %           PosInAxes:  Relative position of the point where
            %                       the users clicked in the axes
            %           PosMainFig: Positon of the main figure
            %           PosCurrent: Position of the point where the users
            %                       clicked in the figure
            %           Info:       Cell array that contains all needed
            %                       informations and images
            %
            
            if ismac
                fontSizeS = 10; % Font size small
                fontSizeM = 12; % Font size medium
                fontSizeB = 16; % Font size big
            elseif ispc
                fontSizeS = 10*0.75; % Font size small
                fontSizeM = 12*0.75; % Font size medium
                fontSizeB = 16*0.75; % Font size big
            else
                fontSizeS = 10; % Font size small
                fontSizeM = 12; % Font size medium
                fontSizeB = 16; % Font size big
                
            end
            
            
            
            PosCurrent(1) = PosCurrent(1)+PosMainFig(1);
            PosCurrent(2) = PosCurrent(2)+PosMainFig(2);
            
            SizeInfoFigure = [400 250]; %[width height]
            
            obj.hFM = figure('NumberTitle','off','Units','pixels','Name','Change fiber informations','Visible','off','MenuBar','none','ToolBar','none');
            set(obj.hFM,'Tag','FigureManipulate')
            set(obj.hFM,'WindowStyle','normal');
            
            if PosInAxes(1,2)-SizeInfoFigure(2) < 0
                set(obj.hFM, 'position', [PosCurrent(1)+5 PosCurrent(2)-SizeInfoFigure(2)-10 SizeInfoFigure(1) SizeInfoFigure(2)]);
            else
                set(obj.hFM, 'position', [PosCurrent(1)+5 PosCurrent(2)+5 SizeInfoFigure(1) SizeInfoFigure(2)]);
            end
            
            mainVBoxInfo = uix.VBox('Parent', obj.hFM);
            HBBoxInfo = uix.HBox('Parent', mainVBoxInfo,'Spacing', 5,'Padding',5);
            VButtonBoxleftInfo = uix.VButtonBox('Parent', HBBoxInfo,'ButtonSize',[6000 200],'Spacing', 5 );
            VButtonBoxleftValue = uix.VButtonBox('Parent', HBBoxInfo,'ButtonSize',[6000 200],'Spacing', 5 );
            VButtonBoxrightInfo = uix.VButtonBox('Parent', HBBoxInfo,'ButtonSize',[6000 200], 'Spacing', 5);
            VButtonBoxrightValue = uix.VButtonBox('Parent', HBBoxInfo,'ButtonSize',[6000 200], 'Spacing', 5);
            
            uicontrol( 'Parent', VButtonBoxleftInfo,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', 'Label No. :' );
            uicontrol( 'Parent', VButtonBoxleftValue,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', Info{1} ,'Tag','textFiberInfo');
            
            uicontrol( 'Parent', VButtonBoxrightInfo,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', ['Area in ' sprintf(' \x3BCm^2') ' :'] );
            uicontrol( 'Parent', VButtonBoxrightValue,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', Info{2} ,'Tag','textFiberInfo');
            
            uicontrol( 'Parent', VButtonBoxleftInfo,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', 'Aspect Ratio :' );
            uicontrol( 'Parent', VButtonBoxleftValue,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', Info{3} ,'Tag','textFiberInfo');
            
            uicontrol( 'Parent', VButtonBoxrightInfo,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', 'Roundness :' );
            uicontrol( 'Parent', VButtonBoxrightValue,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', Info{4} ,'Tag','textFiberInfo');
            
            uicontrol( 'Parent', VButtonBoxleftInfo,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', 'mean Red :' );
            uicontrol( 'Parent', VButtonBoxleftValue,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', Info{7} ,'Tag','textFiberInfo');
            
            uicontrol( 'Parent', VButtonBoxrightInfo,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', 'mean Green :' );
            uicontrol( 'Parent', VButtonBoxrightValue,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', Info{8} ,'Tag','textFiberInfo');
            
            uicontrol( 'Parent', VButtonBoxleftInfo,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', 'mean Blue :' );
            uicontrol( 'Parent', VButtonBoxleftValue,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', Info{9} ,'Tag','textFiberInfo');
            
            uicontrol( 'Parent', VButtonBoxrightInfo,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', 'mean Farred :' );
            uicontrol( 'Parent', VButtonBoxrightValue,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', Info{10} ,'Tag','textFiberInfo');
            
            uicontrol( 'Parent', VButtonBoxleftInfo,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', 'Blue/red :' );
            uicontrol( 'Parent', VButtonBoxleftValue,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', Info{5} ,'Tag','textFiberInfo');
            
            uicontrol( 'Parent', VButtonBoxrightInfo,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', 'Farred/Red :' );
            uicontrol( 'Parent', VButtonBoxrightValue,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', Info{6} ,'Tag','textFiberInfo');
            
            uicontrol( 'Parent', VButtonBoxleftInfo,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', 'Color Value :' );
            uicontrol( 'Parent', VButtonBoxleftValue,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', Info{11} ,'Tag','textFiberInfo');
            
            uix.Empty( 'Parent', VButtonBoxrightInfo);
            uix.Empty( 'Parent', VButtonBoxrightValue);
            
            HBBoxType = uix.HBox('Parent', mainVBoxInfo,'Spacing', 5,'Padding',5);
            
            uicontrol( 'Parent', HBBoxType,'Style','text','FontUnits','normalized','Fontsize',0.5, 'String', 'Fiber type :' );
            obj.B_FiberTypeManipulate = uicontrol( 'Parent', HBBoxType,'Style','popupmenu','FontUnits','normalized','Fontsize',0.4 );
            
            analyzeMode = Info{15}; % last performed analyz mode 
            if analyzeMode == 1 || analyzeMode == 3 || analyzeMode == 5 || analyzeMode == 7
                %tripple labeling was active only Type 1,2 and 12h fibers
                %allowed
            set(obj.B_FiberTypeManipulate,'String',{'Type 1 (blue)' , 'Type 12h (magenta)', 'Type 2 (red)','Type 0 undefined (white)'})
            else
                %quad labeling was active all fibers allowed
            set(obj.B_FiberTypeManipulate,'String',{'Type 1 (blue)' , 'Type 12h (magenta)', 'Type 2x (red)', 'Type 2a (yellow)', 'Type 2ax (orange)' ,'Type 0 undefined (white)' })    
            end
           
            HBBoxCont = uix.HButtonBox('Parent', mainVBoxInfo,'Spacing', 5,'Padding',5,'ButtonSize',[6000 200]);
            obj.B_ManipulateCancel = uicontrol( 'Parent', HBBoxCont, 'String', 'Cancel','FontUnits','normalized','Fontsize',0.6 );
            obj.B_ManipulateOK = uicontrol( 'Parent', HBBoxCont, 'String', 'Change Info','FontUnits','normalized','Fontsize',0.6 );
            set( mainVBoxInfo, 'Heights', [-4 -1 -1], 'Spacing', 1 );
            
            if analyzeMode == 1 || analyzeMode == 3 || analyzeMode == 5 || analyzeMode == 7
                switch Info{12} %Fiber Type
                    case 'Type 1'
                        %Fiber Type 1 (blue)
                        set(obj.B_FiberTypeManipulate,'Value',1);
                    case 'Type 12h'
                        %Fiber Type 12h (magenta)
                        set(obj.B_FiberTypeManipulate,'Value',2);
                    case 'Type 2'
                        %Fiber Type 3 (red)
                        set(obj.B_FiberTypeManipulate,'Value',3);
                    case 'undefined'
                        %Fiber Type 0 (white)
                        set(obj.B_FiberTypeManipulate,'Value',4);    
                end
            else
                switch Info{12} %Fiber Type
                    case 'Type 1'
                        %Fiber Type 1 (blue)
                        set(obj.B_FiberTypeManipulate,'Value',1);
                    case 'Type 12h'
                        %Fiber Type 12h (magenta)
                        set(obj.B_FiberTypeManipulate,'Value',2);
                    case 'Type 2x'
                        %Fiber Type 3 (red)
                        set(obj.B_FiberTypeManipulate,'Value',3);
                    case 'Type 2a'
                        %Fiber Type 3 (yellow)
                        set(obj.B_FiberTypeManipulate,'Value',4);
                    case 'Type 2ax'
                        %Fiber Type 3 (orange)
                        set(obj.B_FiberTypeManipulate,'Value',5);
                    case 'undefined'
                        %Fiber Type 0 (white)
                        set(obj.B_FiberTypeManipulate,'Value',6);
                end
                
            end
            set(obj.hFM,'Visible','on')
        end
        
        function showFigureManualClassify(obj,mainFig)
            % Creates a new figure when the user selects manual classification.
            %
            %   showFigureManualClassify(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:        Handle to viewEdit object
            %
            
            if ismac
                fontSizeS = 10; % Font size small
                fontSizeM = 12; % Font size medium
                fontSizeB = 16; % Font size big
            elseif ispc
                fontSizeS = 10*0.75; % Font size small
                fontSizeM = 12*0.75; % Font size medium
                fontSizeB = 16*0.75; % Font size big
            else
                fontSizeS = 10; % Font size small
                fontSizeM = 12; % Font size medium
                fontSizeB = 16; % Font size big 
            end
            
            obj.hFMC = figure('NumberTitle','off','Units','normalized','Name','Manual Classification','Visible','off');
            set(obj.hFMC,'Tag','FigureManualClassify');
            
            %get position of mainFigure
            posMainFig = get(mainFig,'Position');
            
            set(obj.hFMC, 'position', [posMainFig(1) posMainFig(2) 0.6 0.8]);
            movegui(obj.hFMC,'center');
            
            set(obj.hFMC,'WindowStyle','normal');
            
            VBox = uix.VBox('Parent', obj.hFMC );
     
            %VBox 2 with axes
            AxesBox = uix.HBox('Parent', VBox,'Padding', 1 );
            obj.hAMC = axes('Parent',uicontainer('Parent', AxesBox), 'FontSize',fontSizeB,'Tag','AxesManualClassify');
            set(obj.hAMC, 'LooseInset', [0,0,0,0]);
            daspect(obj.hAMC,[1 1 1]);
            %VBox 3 with Buttons
            BBox = uix.HButtonBox('Parent', VBox,'ButtonSize',[600 40],'Padding', 10 );
            obj.B_ManualClassBack = uicontrol( 'Parent', BBox, 'String', '<- Back Main Fbers','FontUnits','normalized','Fontsize',0.6 ,'Tag','Back Main Fbers');
            obj.B_ManualClassEnd = uicontrol( 'Parent', BBox, 'String', 'Complete Classification','FontUnits','normalized','Fontsize',0.6 ,'Tag','Complete Classification');
            obj.B_ManualClassForward = uicontrol( 'Parent', BBox, 'String', 'Specify Type 2 Fibers ->','FontUnits','normalized','Fontsize',0.6 ,'Tag','Specify Type 2 Fibers');
            
            set( VBox, 'Heights', [ -8 -1], 'Spacing', 1 ); 
            set(obj.hFMC, 'Visible', 'on');
        end
        
        function showFigurePreResults(obj,mainFig)
            if ismac
                fontSizeS = 10; % Font size small
                fontSizeM = 12; % Font size medium
                fontSizeB = 16; % Font size big
            elseif ispc
                fontSizeS = 10*0.75; % Font size small
                fontSizeM = 12*0.75; % Font size medium
                fontSizeB = 16*0.75; % Font size big
            else
                fontSizeS = 10; % Font size small
                fontSizeM = 12; % Font size medium
                fontSizeB = 16; % Font size big 
            end
            
            obj.hFPR = figure('NumberTitle','off','Units','normalized','Name','Preview Results','Visible','off','MenuBar','none','ToolBar','none','Color',[1 1 1],...
                'WindowStyle', 'modal');
            set(obj.hFPR,'Tag','FigurePreResults')
            
            %get position of mainFigure
            posMainFig = get(mainFig,'Position');
            
            set(obj.hFPR, 'position', [posMainFig(1) posMainFig(2) 0.8 0.8]);
            movegui(obj.hFPR,'center')
            
            set(obj.hFPR,'WindowStyle','modal');
            
            AxesBox = uix.HBox('Parent', obj.hFPR,'Padding', 25,'Spacing', 10);
            obj.hAPRBR = axes('Parent',uicontainer('Parent', AxesBox), 'FontUnits','normalized','Fontsize',0.015,'Tag','AxesManualClassify');
            set(obj.hAPRBR, 'LooseInset', [0,0,0,0]);
            obj.hAPRFRR = axes('Parent',uicontainer('Parent', AxesBox), 'FontUnits','normalized','Fontsize',0.015,'Tag','AxesManualClassify');
            set(obj.hAPRFRR, 'LooseInset', [0,0,0,0]);
            
            set(obj.hFPR, 'Visible', 'on');
        end
        
        function setToolTipStrings(obj)
            % Set all tooltip strings in the properties of the operationg
            % elements that are shown in the main GUI
            %
            %   setToolTipStrings(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to viewAnalyze object
            %
            
            BackEditToolTip = sprintf('Go back to edit mode.');
            
            ShowResultsToolTip = sprintf(['Switch to Result-Mode. \n',...
                'Show classification results']);
            
            StartAnaToolTip = sprintf('Start fiber type classification');
            
            PreviewToolTip = sprintf('Show preview classification results');
            
            ClassModeToolTip = sprintf('Select classification method.');
            
            MinAreaToolTip = sprintf(['Select minimal area value. \n',...
                'Smaller objects will be removed.']);
            
            MaxAreaToolTip = sprintf(['Select maximal area value. \n',...
                'Larger objects will be classified as Type 0 fiber.']);
            
            MinAspectToolTip = sprintf(['Select minimal aspect ratio.\n',...
                'Objects with smaller aspect ratio\n will be classified as Type-0 fiber']);
            
            MaxAspectToolTip = sprintf(['Change maximal aspect ratio. \n',...
                'Objects with larger aspect ratio\n will be classified as Type-0 fiber.']);
            
            MinRoundToolTip = sprintf(['Change minimal roundness value. \n',...
                'Objects with samller roundness value\n will be classified as Type-0 fiber.']);
            
            MinColorValueToolTip = sprintf(['Change minimal color value. \n',...
                'Value form the HSV color model (lightness).',...
                'Objects with samller color value\n will be classified as Type-0 fiber.']);
            
            BRTreshToolTip = sprintf('Slope of Blue/Red classification function.');
            
            BRDistBhToolTip = sprintf('Blue offset of Blue/Red classification function in percent');
            
            BRDistRhToolTip = sprintf('Red offset of Blue/Red classification function in percent');
            
            FRRTreshToolTip = sprintf('Slope of Farred/Red classification function.');
            
            FRRDistFRhToolTip = sprintf('Farred offset of Farred/Red classification function in percent');
            
            FRRDistRhToolTip = sprintf('Farred offset of Farred/Red classification function in percent');
            
            set(obj.B_BackEdit,'tooltipstring',BackEditToolTip);
            set(obj.B_StartResults,'tooltipstring',ShowResultsToolTip);
            set(obj.B_StartAnalyze,'tooltipstring',StartAnaToolTip);
            set(obj.B_PreResults,'tooltipstring',PreviewToolTip);
            
            set(obj.B_AnalyzeMode,'Tooltip',ClassModeToolTip);
            set(obj.B_MinArea,'tooltipstring',MinAreaToolTip);
            set(obj.B_MaxArea,'tooltipstring',MaxAreaToolTip);
            set(obj.B_MinAspectRatio,'tooltipstring',MinAspectToolTip);
            set(obj.B_MaxAspectRatio,'tooltipstring',MaxAspectToolTip);
            set(obj.B_MinRoundness,'tooltipstring',MinRoundToolTip);
            set(obj.B_ColorValue,'tooltipstring',MinColorValueToolTip);
            
            set(obj.B_BlueRedThresh,'tooltipstring',BRTreshToolTip);
            set(obj.B_BlueRedDistBlue,'tooltipstring',BRDistBhToolTip);
            set(obj.B_BlueRedDistRed,'tooltipstring',BRDistRhToolTip);
        
            set(obj.B_FarredRedThresh,'tooltipstring',FRRTreshToolTip);
            set(obj.B_FarredRedDistFarred,'tooltipstring',FRRDistFRhToolTip);
            set(obj.B_FarredRedDistRed,'tooltipstring',FRRDistRhToolTip);
        end
        
        function delete(obj)
            
        end
        
    end
    
end

