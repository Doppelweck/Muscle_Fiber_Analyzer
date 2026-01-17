classdef viewResults < handle
    %viewResults   view of the results-MVC (Model-View-Controller).
    %Creates the third card panel in the main figure that shows the results  
    %after the classification. The viewResult class is called by  
    %the main.m file. Contains serveral buttons and uicontrol elements to 
    %select wich data will be saved.
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
        hFR; %handle to figure with Results and controls.
        panelControl; %handle to panel with controls.
        panelAxes; %handle to panel with resultsView.
        panelResults; %handle to mainPanelBox in  in resultsVIEW
        hAPProcessed; %handle to axes with processed image in the picture Panel all planes.
        hAPGroups; %handle to axes with image created from the Red Green and Blue color-planes.
        tabPanel;
        
        hAArea; %handle to axes with area plot.  
        hACount; %handle to axes with counter plot.
        hAScatterFarredRed; %handle to axes with scatterplot that contains fiber objects.
        hAScatterBlueRed; %handle to axes with scatterplot that contains fiber objects.
        
        hAAreaHist; %handle to axes with the area histogram
        hAAspectHist; %handle to axes with the aspect ratio histogram
        hADiaHist; %handle to axes with the diameter histogram
        hARoundHist; %handle to axes with the roundness histogram

        hAScatterAll %handle to axes with scatterplot that contains all fiber objects.
        
        B_BackAnalyze; %Button, close the ResultsMode and opens the the AnalyzeMode.
        B_Save; %Button, save data into the RGB image folder.
        B_NewPic; %Button, to select a new picture.
        B_CloseProgramm; %Button, to close the program.
        
        B_SaveFiberTable; %Checkbox, select if fiber table should be saved.
        B_SaveScatterAll; %Checkbox, select if statistic table should be saved.
        B_SavePlots; %Checkbox, select if Statistics plots should be saved.
        B_SaveHisto; %Checkbox, select if Histogram plots should be saved.
        B_SavePicProc; %Checkbox, select if processed image with Farred should be saved.
        B_SavePicOriginal; %Checkbox, select if original image with Farred should be saved.
        B_SavePicGroups; %Checkbox, select if processed image without Farred image should be saved.
        B_SaveBinaryMask; %Checkbox, select if Binary Mask should be saved.

        B_SaveFiberTableFileFormat; %FileFormat in which teh data should be saved.
        B_SaveScatterAllFileFormat; %FileFormat in which teh data should be saved.
        B_SavePlotsFileFormat; %FileFormat in which teh data should be saved.
        B_SaveHistoFileFormat; %FileFormat in which teh data should be saved.
        B_SavePicProcFileFormat; %Formatckbox in which teh data should be saved.
        B_SavePicOriginalFileFormat; %Formatckbox in which teh data should be saved.
        B_SavePicGroupsFileFormat; %FileFormat in which teh data should be saved.
        B_SaveBinaryMaskFileFormat; %FileFormat in which teh data should be saved.

        B_SaveFiberTableIndicator; %Lamp, show save state Yellow = unknown, red = faild, green = ok
        B_SaveScatterAllIndicator; %Lamp, show save state Yellow = unknown, red = faild, green = ok
        B_SavePlotsIndicator; %Lamp, show save state Yellow = unknown, red = faild, green = ok
        B_SaveHistoIndicator; %Lamp, show save state Yellow = unknown, red = faild, green = ok
        B_SavePicProcIndicator; %Lamp, show save state Yellow = unknown, red = faild, green = ok
        B_SavePicOriginalIndicator; %Lamp, show save state Yellow = unknown, red = faild, green = ok
        B_SavePicGroupsIndicator; %Lamp, show save state Yellow = unknown, red = faild, green = ok
        B_SaveBinaryMaskIndicator; %Lamp, show save state Yellow = unknown, red = faild, green = ok

        B_SaveOpenDir %Button, opens the save directory.
        
        B_TableStatistic; %Table, that shows all statistic data.
        B_TableMain; %Table, that shows all object data.
        B_InfoText; %Shows the info log text.
        
    end
    
    methods
        function obj = viewResults(mainCard)

            params = view_helper_default_params();

            if nargin < 1 || isempty(mainCard)
                mainCard = uifigure(params.default_uifugure{:});
                theme(mainCard,"auto");
                pause(1)
            end
            
            set(mainCard,'Visible','on');
            obj.panelResults = uix.HBox( 'Parent', mainCard, params.default_box_spacing_padding{:});
            
            obj.panelAxes =    uix.Panel('Parent', obj.panelResults, params.default_panel{:}, 'Title', 'FIBER INFORMATIONS' );
            obj.panelControl = uix.Panel('Parent', obj.panelResults, params.default_panel{:}, 'Title', 'RESULTS', 'TitlePosition','centertop');
            %set( obj.panelResults, 'MinimumWidths', [1 320] );
            set( obj.panelResults, 'Widths', params.default_mainPanel_ration );

            %%%%%%%%%%%%%%%%%% Panel controls %%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            PanelVBox = uix.VBox('Parent',obj.panelControl, params.default_box_spacing_padding{:});
            
            PanelControl = uix.Panel('Parent',PanelVBox,params.default_panel{:},'Title','Main Controls');
            PanelSave =    uix.Panel('Parent',PanelVBox,params.default_panel{:},'Title','Save Options');
            PanelInfo =    uix.Panel('Parent',PanelVBox,params.default_panel{:},'Title','Info Log');
            
            set( PanelVBox, 'Heights', [-13 -35 -52]);
            
            %%%%%%%%%%%%%%%%%% Panel control %%%%%%%%%%%%%%%%%%%%%%%%
            maingridBoxControl = uix.Grid('Parent', PanelControl);

            obj.B_BackAnalyze =   uicontrol('Parent',uix.HButtonBox('Parent', maingridBoxControl,params.default_HButtonBox_Main{:}),params.default_normalized_font{:}, 'String', sprintf('\x276E\x276E Classification'));
            obj.B_NewPic =        uicontrol('Parent',uix.HButtonBox('Parent', maingridBoxControl,params.default_HButtonBox_Main{:}),params.default_normalized_font{:}, 'String', sprintf('\x25A8 New File') );
            obj.B_CloseProgramm = uicontrol('Parent',uix.HButtonBox('Parent', maingridBoxControl,params.default_HButtonBox_Main{:}),params.default_normalized_font{:}, 'String', sprintf('Close Program \x23FB') );
            obj.B_Save =          uicontrol('Parent',uix.HButtonBox('Parent', maingridBoxControl,params.default_HButtonBox_Main{:}),params.default_normalized_font{:}, 'String', sprintf('Save Data \x26DB') );
            set(maingridBoxControl,'Widths', [-1 -1], 'Heights', [-1 -1] );
           

            %%%%%%%%%%%%%%%%%%%Panel SaveOptions %%%%%%%%%%%%%%%%%%%%%%%%%%
            dropdownStringAxes={'.pdf';'.svg';'.jpg';'.png';'.tif'};
            dropdownStringTabel={'.xlsx';'.xls';'.xlsm'};
             
            VBoxSave = uix.VBox('Parent', PanelSave, params.default_box_spacing_padding{:} );

            mainGridBoxSave = uiextras.Grid('Parent',VBoxSave);

            obj.B_SaveFiberTable =  uicontrol( 'Parent', uix.HButtonBox('Parent', mainGridBoxSave,params.default_HButtonBox{:}),'Style','checkbox','Value',1,'Tag','checkboxSaveFiberTable');
            obj.B_SavePlots =       uicontrol( 'Parent', uix.HButtonBox('Parent', mainGridBoxSave,params.default_HButtonBox{:}),'Style','checkbox','Value',1,'Tag','checkboxSaveOverview');
            obj.B_SaveHisto =       uicontrol( 'Parent', uix.HButtonBox('Parent', mainGridBoxSave,params.default_HButtonBox{:}),'Style','checkbox','Value',1,'Tag','checkboxSaveHistogram');
            obj.B_SavePicProc =     uicontrol( 'Parent', uix.HButtonBox('Parent', mainGridBoxSave,params.default_HButtonBox{:}),'Style','checkbox','Value',1,'Tag','checkboxSavePicProcessed');
            obj.B_SavePicOriginal = uicontrol( 'Parent', uix.HButtonBox('Parent', mainGridBoxSave,params.default_HButtonBox{:}),'Style','checkbox','Value',1,'Tag','checkboxSavePicOriginal');
            obj.B_SavePicGroups =   uicontrol( 'Parent', uix.HButtonBox('Parent', mainGridBoxSave,params.default_HButtonBox{:}),'Style','checkbox','Value',1,'Tag','checkboxSavePicGroups');
            obj.B_SaveScatterAll =  uicontrol( 'Parent', uix.HButtonBox('Parent', mainGridBoxSave,params.default_HButtonBox{:}),'Style','checkbox','Value',1,'Tag','checkboxSaveScatterAll');
            obj.B_SaveBinaryMask =  uicontrol( 'Parent', uix.HButtonBox('Parent', mainGridBoxSave,params.default_HButtonBox{:}),'Style','checkbox','Value',1,'Tag','checkboxSaveBinaryMask');

            uilabel( 'Parent', mainGridBoxSave, 'HorizontalAlignment','left','Text', 'Save Fiber-Table as ..................................................................................' );
            uilabel( 'Parent', mainGridBoxSave, 'HorizontalAlignment','left','Text', 'Save Overview Plots as ...............................................................................' );
            uilabel( 'Parent', mainGridBoxSave, 'HorizontalAlignment','left','Text', 'Save Histogram Plots as ..............................................................................' );
            uilabel( 'Parent', mainGridBoxSave, 'HorizontalAlignment','left','Text', 'Save Processed RGB Image as ..........................................................................' );
            uilabel( 'Parent', mainGridBoxSave, 'HorizontalAlignment','left','Text', 'Save Original RGB Image as ...........................................................................' );
            uilabel( 'Parent', mainGridBoxSave, 'HorizontalAlignment','left','Text', 'Save Fiber-Grouping Image as .........................................................................' );
            uilabel( 'Parent', mainGridBoxSave, 'HorizontalAlignment','left','Text', 'Save Scatterplot all Fibers as .......................................................................' );
            uilabel( 'Parent', mainGridBoxSave, 'HorizontalAlignment','left','Text', 'Save Binary Mask as ..................................................................................' );

            obj.B_SaveFiberTableFileFormat =  uidropdown( 'Parent', uix.HButtonBox('Parent', mainGridBoxSave,params.default_HButtonBox{:}), 'Items', dropdownStringTabel,'ValueIndex',1,'Tag','dropdownSaveFiberTableFormat');
            obj.B_SavePlotsFileFormat =       uidropdown( 'Parent', uix.HButtonBox('Parent', mainGridBoxSave,params.default_HButtonBox{:}), 'Items', dropdownStringAxes ,'ValueIndex',1,'Tag','dropdownSaveOverviewFormat');
            obj.B_SaveHistoFileFormat =       uidropdown( 'Parent', uix.HButtonBox('Parent', mainGridBoxSave,params.default_HButtonBox{:}), 'Items', dropdownStringAxes ,'ValueIndex',1,'Tag','dropdownSaveHistogramFormat');
            obj.B_SavePicProcFileFormat =     uidropdown( 'Parent', uix.HButtonBox('Parent', mainGridBoxSave,params.default_HButtonBox{:}), 'Items', dropdownStringAxes ,'ValueIndex',1,'Tag','dropdownSavePicProcessedFormat');
            obj.B_SavePicOriginalFileFormat = uidropdown( 'Parent', uix.HButtonBox('Parent', mainGridBoxSave,params.default_HButtonBox{:}), 'Items', dropdownStringAxes ,'ValueIndex',1,'Tag','dropdownSavePicOriginalFormat');
            obj.B_SavePicGroupsFileFormat =   uidropdown( 'Parent', uix.HButtonBox('Parent', mainGridBoxSave,params.default_HButtonBox{:}), 'Items', dropdownStringAxes ,'ValueIndex',1,'Tag','dropdownSavePicGroupsFormat');
            obj.B_SaveScatterAllFileFormat =  uidropdown( 'Parent', uix.HButtonBox('Parent', mainGridBoxSave,params.default_HButtonBox{:}), 'Items', dropdownStringAxes ,'ValueIndex',1,'Tag','dropdownSaveScatterAllFormat');
            obj.B_SaveBinaryMaskFileFormat =  uidropdown( 'Parent', uix.HButtonBox('Parent', mainGridBoxSave,params.default_HButtonBox{:}), 'Items', dropdownStringAxes ,'ValueIndex',1,'Tag','dropdownSaveBinaryMaskFormat');

            obj.B_SaveFiberTableIndicator =  uilamp(uix.HButtonBox('Parent', mainGridBoxSave,params.default_HButtonBox{:}));
            obj.B_SavePlotsIndicator =       uilamp(uix.HButtonBox('Parent', mainGridBoxSave,params.default_HButtonBox{:}));
            obj.B_SaveHistoIndicator =       uilamp(uix.HButtonBox('Parent', mainGridBoxSave,params.default_HButtonBox{:}));
            obj.B_SavePicProcIndicator =     uilamp(uix.HButtonBox('Parent', mainGridBoxSave,params.default_HButtonBox{:}));
            obj.B_SavePicOriginalIndicator = uilamp(uix.HButtonBox('Parent', mainGridBoxSave,params.default_HButtonBox{:}));
            obj.B_SavePicGroupsIndicator =   uilamp(uix.HButtonBox('Parent', mainGridBoxSave,params.default_HButtonBox{:}));
            obj.B_SaveScatterAllIndicator =  uilamp(uix.HButtonBox('Parent', mainGridBoxSave,params.default_HButtonBox{:}));
            obj.B_SaveBinaryMaskIndicator =  uilamp(uix.HButtonBox('Parent', mainGridBoxSave,params.default_HButtonBox{:}));

            set( mainGridBoxSave, 'Widths', [-1 -6 -3.5 -1], 'Heights', [-1 -1 -1 -1 -1 -1 -1 -1] );

            obj.B_SaveOpenDir = uicontrol( 'Parent', uix.HButtonBox('Parent', VBoxSave,params.default_HButtonBox_Main{:}),'FontUnits','normalized','Fontsize',0.5, 'String', 'Open Results Folder' );
            set(VBoxSave,'Heights',[-8 -1.5]);


            %%%%%%%%%%%%%%%%%%% Pnael Info Text Log %%%%%%%%%%%%%%%%%%%%%%%
            hBoxSize=uix.HBox('Parent', PanelInfo, params.default_box_spacing_padding{:});
            obj.B_InfoText = uicontrol('Parent',hBoxSize,'Style','listbox','String',{});
            
            %%%%%%%%%%%%%%%%%%% Panel with Tabs %%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            obj.tabPanel = uix.TabPanel('Parent',obj.panelAxes,params.default_tab_panel{:},'Tag','tabMainPanel','TabWidth',-1);
            
            statisticTabPanel =       uix.Panel('Parent',obj.tabPanel,params.default_tab_panel{:},'Tag','obj.tabPanel');
            histogramTabPanel =       uix.Panel('Parent',obj.tabPanel,params.default_tab_panel{:},'Tag','obj.tabPanel');
            pictureTabPanel =         uix.Panel('Parent',obj.tabPanel,params.default_tab_panel{:},'Tag','obj.tabPanel');
            pictureRGBPlaneTabPanel = uix.Panel('Parent',obj.tabPanel,params.default_tab_panel{:},'Tag','obj.tabPanel');
            tableTabPanel =           uix.Panel('Parent',obj.tabPanel,params.default_tab_panel{:},'Tag','obj.tabPanel');
            scatterAllTabPanel =      uix.Panel('Parent',obj.tabPanel,params.default_tab_panel{:},'Tag','obj.tabPanel');
            
            obj.tabPanel.TabTitles = {'Overview','Histograms','Image processed','Image with Fiber-Groups', 'Fiber Type Table','Scatterplot all Fibers'};

            %%%%%%%%%%%%%%%%%%% Tab Overview %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            obj.tabPanel.Selection = 1;
            statisticTabHBox = uix.HBox('Parent',statisticTabPanel,'Spacing',2,'Padding',2);
            
            statsVBoxleft = uiextras.VBoxFlex( 'Parent', statisticTabHBox, 'Spacing', 15 ,'Padding',5);
            statsVBoxMiddle = uiextras.VBoxFlex( 'Parent', statisticTabHBox, 'Spacing', 15 ,'Padding',5);
            statsVBoxRight = uiextras.VBoxFlex( 'Parent', statisticTabHBox, 'Spacing', 15 ,'Padding',5);
            
            PanelArea = uix.Panel('Parent',statsVBoxleft,'Padding',5);
            PanelCount = uix.Panel('Parent',statsVBoxleft,'Padding',5);
            PanelDia = uix.Panel('Parent',statsVBoxMiddle,'Padding',5);
            PanelScatter = uix.Panel('Parent',statsVBoxMiddle,'Padding',5);
            PanelStatisticTabel = uix.Panel('Parent',statsVBoxRight,'Padding',5);
            
            obj.hAArea = axes('Parent',uicontainer('Parent',PanelArea),params.default_axes{:});
            axtoolbar(obj.hAArea,params.default_axes_toolbar{:});
            obj.hACount= axes('Parent',uicontainer('Parent',PanelCount),params.default_axes{:});
            axtoolbar(obj.hACount,params.default_axes_toolbar{:});
            obj.hAScatterFarredRed = axes('Parent',uicontainer('Parent',PanelDia),params.default_axes{:});
            axtoolbar(obj.hAScatterFarredRed,params.default_axes_toolbar{:});
            obj.hAScatterBlueRed = axes('Parent',uicontainer('Parent',PanelScatter),params.default_axes{:});
            axtoolbar(obj.hAScatterBlueRed,params.default_axes_toolbar{:});
           
            obj.B_TableStatistic = uitable('Parent',PanelStatisticTabel);
            obj.B_TableMain.Position =[0 0 1 1];
            
            set(statisticTabHBox,'Widths', [-2 -2 -1.2])
            set( statsVBoxleft, 'Heights', [-1 -1] );
            set( statsVBoxMiddle, 'Heights', [-1 -1] );
            

            %%%%%%%%%%%%%%%%%%%%%%%% Tab Histogramms %%%%%%%%%%%%%%%%%%%%%%
            obj.tabPanel.Selection = 2; 
            histoTabHBox = uix.HBox('Parent',histogramTabPanel,'Spacing',2,'Padding',2);
            
            histoVBoxleft = uiextras.VBoxFlex( 'Parent', histoTabHBox, 'Spacing', 15 ,'Padding',5);
            histoVBoxright = uiextras.VBoxFlex( 'Parent', histoTabHBox, 'Spacing', 15 ,'Padding',5);
            
            histoArea = uix.Panel('Parent',histoVBoxleft,'Padding',5);
            histoAspect = uix.Panel('Parent',histoVBoxleft,'Padding',5);
            histoDiameter = uix.Panel('Parent',histoVBoxright,'Padding',5);
            histoRound = uix.Panel('Parent',histoVBoxright,'Padding',5);
            
            obj.hAAreaHist = axes('Parent',uicontainer('Parent',histoArea),params.default_axes{:});
            axtoolbar(obj.hAAreaHist,params.default_axes_toolbar{:});
            obj.hAAspectHist= axes('Parent',uicontainer('Parent',histoAspect),params.default_axes{:});
            axtoolbar(obj.hAAspectHist,params.default_axes_toolbar{:});
            obj.hADiaHist = axes('Parent',uicontainer('Parent',histoDiameter),params.default_axes{:});
            axtoolbar(obj.hADiaHist,params.default_axes_toolbar{:});
            obj.hARoundHist = axes('Parent',uicontainer('Parent',histoRound),params.default_axes{:});
            axtoolbar(obj.hARoundHist,params.default_axes_toolbar{:});
            
            %%%%%%%%%%%%%%%%%%%%%%%% Tab Image processed
            obj.tabPanel.Selection = 3;
            tempTabVBox = uix.VBox('Parent',pictureTabPanel,'Spacing',2,'Padding',2);
            uilabel('Parent',tempTabVBox,'HorizontalAlignment','left','Text', 'RGB Image processed with object boundaries and label numbers','FontSize',params.fontSizeB);
            
            obj.hAPProcessed = axes('Parent',uicontainer('Parent',tempTabVBox),params.default_axes{:});
            axtoolbar(obj.hAPProcessed,params.default_axes_toolbar{:});
            axis(obj.hAPProcessed ,'image');
            set( tempTabVBox, 'Heights', [30 -1], 'Spacing', 10 );

            %%%%%%%%%%%%%%%%%%%%%%%% Tab Image with Groups %%%%%%%%%%%%%
            obj.tabPanel.Selection = 4;
            tempTabVBox = uix.VBox('Parent',pictureRGBPlaneTabPanel,'Spacing',2,'Padding',2);
            uilabel('Parent',tempTabVBox,'HorizontalAlignment','left','Text', 'RGB Image with Fiber-Type-Groups','FontSize',params.fontSizeB);
            
            obj.hAPGroups = axes('Parent',uicontainer('Parent',tempTabVBox),params.default_axes{:});
            axtoolbar(obj.hAPGroups,params.default_axes_toolbar{:});
            axis(obj.hAPGroups ,'image');
            set( tempTabVBox, 'Heights', [30 -1], 'Spacing', 10 );
            
            %%%%%%%%%%%%%%%%%%%%%%%% Tab Tabel %%%%%%%%%%%%%%%%%%%%%%%%%%
            obj.tabPanel.Selection = 5;
            mainTablePanel = uix.Panel('Parent',tableTabPanel,'Padding',5,'FontSize',params.fontSizeM);
            obj.B_TableMain = uitable('Parent',mainTablePanel);
            
            obj.B_TableMain.Position =[0 0 1 1];
            
            %%%%%%%%%%%%%%%%%%%%%%%% Tab Scatter all %%%%%%%%%%%%%%%%%%%%%%
            obj.tabPanel.Selection = 6;
            tempTabVBox = uix.VBox('Parent',scatterAllTabPanel,'Spacing',2,'Padding',2);
            uilabel('Parent',tempTabVBox,'HorizontalAlignment','left','Text', '3D-Scatterplot showing all fibers in a Blue/Red/Farred coordinate system','FontSize',params.fontSizeB);
            
            obj.hAScatterAll = axes('Parent',uicontainer('Parent',tempTabVBox),params.default_axes{:});
            axtoolbar(obj.hAScatterAll,params.default_axes_toolbar{:});
            set( tempTabVBox, 'Heights', [30 -1], 'Spacing', 10 );


            %%%%%%%%%%%%%%% call edit functions for GUI
            obj.setToolTipStrings();
            
            set(mainCard,'Visible','on');
            obj.tabPanel.Selection = 1;
            drawnow 

        end
                
         function setToolTipStrings(obj)
            % Set all tooltip strings in the properties of the operationg
            % elements that are shown in the GUI
            %
            %   setToolTipStrings(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to viewAnalyze object
            %
            
            BackAnalToolTip = sprintf('Return to Classification.');
            
            NewPicToolTip = sprintf('Select a new image for processing.');
            
            SaveToolTip = sprintf(['Saves the data in the same \n',...
                ' directory as the selected RGB image.',...
                'Create a new folder for each timestamp.']);
            
            CloseToolTip = sprintf(['Quit the program. \n',...
                'Unsaved data will be lost.']);

            SaveStateToolTip = sprintf(['Indicates if the saving was successful \n',...
                '   - green: saving file was successfull \n',...
                '   - yellow: unknown \n',...
                '   - red: saving file failed',...
                ]);
            
            set(obj.B_BackAnalyze,'tooltipstring',BackAnalToolTip);
            set(obj.B_CloseProgramm,'tooltipstring',CloseToolTip);
            set(obj.B_NewPic,'tooltipstring',NewPicToolTip);
            set(obj.B_Save,'tooltipstring',SaveToolTip);

            set(obj.B_SaveFiberTableIndicator,'Tooltip',SaveStateToolTip);
            set(obj.B_SaveScatterAllIndicator,'Tooltip',SaveStateToolTip);
            set(obj.B_SavePlotsIndicator,'Tooltip',SaveStateToolTip);
            set(obj.B_SaveHistoIndicator,'Tooltip',SaveStateToolTip);
            set(obj.B_SavePicProcIndicator,'Tooltip',SaveStateToolTip);
            set(obj.B_SavePicOriginalIndicator,'Tooltip',SaveStateToolTip);
            set(obj.B_SavePicGroupsIndicator,'Tooltip',SaveStateToolTip);
            set(obj.B_SaveBinaryMaskIndicator,'Tooltip',SaveStateToolTip);
        end
        
         function delete(~)
            %Deconstructor
         end

    end
    
end

