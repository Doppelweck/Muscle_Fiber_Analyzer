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
        B_SavePicGroups; %Checkbox, select if processed image without Farred image should be saved.
        B_SaveBinaryMask; %Checkbox, select if Binary Mask should be saved.
        B_SaveOpenDir %Button, opens the save directory.
        
        B_TableStatistic; %Table, that shows all statistic data.
        B_TableMain; %Table, that shows all object data.
        B_InfoText; %Shows the info log text.
        
    end
    
    methods
        function obj = viewResults(mainCard)
            if nargin < 1 || isempty(mainCard)
                mainCard = figure('Units','normalized','Position',[0.01 0.05 0.98 0.85]);
                theme(mainCard,"auto");
            end
            
            params = view_helper_default_params();

            fontSizeS = 10; % Font size small
            fontSizeM = 12; % Font size medium
            fontSizeB = 16; % Font size big


            set(mainCard,'Visible','on');
            obj.panelResults = uix.HBox( 'Parent', mainCard, params.default_box_spacing_padding{:});
            
            obj.panelAxes =    uix.Panel('Parent', obj.panelResults, params.default_panel{:}, 'Title', 'FIBER INFORMATIONS' );
            obj.panelControl = uix.Panel('Parent', obj.panelResults, params.default_panel{:}, 'Title', 'RESULTS', 'TitlePosition','centertop');
            set( obj.panelResults, 'MinimumWidths', [1 320] );
            set( obj.panelResults, 'Widths', [-4 -1] );
            
            %%%%%%%%%%%%%%%%%% Panel controls %%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            PanelVBox = uix.VBox('Parent',obj.panelControl, params.default_box_spacing_padding{:});
            
            PanelControl = uix.Panel('Parent',PanelVBox,params.default_panel{:},'Title','Main Controls');
            PanelSave =    uix.Panel('Parent',PanelVBox,params.default_panel{:},'Title','Save Options');
            PanelInfo =    uix.Panel('Parent',PanelVBox,params.default_panel{:},'Title','Info Log');
            
            set( PanelVBox, 'Heights', [-13 -35 -52]);
            
            %%%%%%%%%%%%%%%%%% Panel control %%%%%%%%%%%%%%%%%%%%%%%%
            mainVBBoxControl = uix.VBox('Parent', PanelControl, params.default_box_spacing_padding{:} );
            
            HBoxControl1 = uix.HButtonBox('Parent', mainVBBoxControl,params.default_HButtonBox_Main{:});
            obj.B_BackAnalyze =   uicontrol( 'Parent', HBoxControl1,params.default_normalized_font{:}, 'String', sprintf('\x276E\x276E Classification'));
            obj.B_CloseProgramm = uicontrol( 'Parent', HBoxControl1,params.default_normalized_font{:}, 'String', sprintf('Close Program \x23FB') );
            
            HBoxControl2 = uix.HButtonBox('Parent', mainVBBoxControl,params.default_HButtonBox_Main{:});
            obj.B_NewPic = uicontrol( 'Parent', HBoxControl2,params.default_normalized_font{:}, 'String', sprintf('\x25A8 New File') );
            obj.B_Save =   uicontrol( 'Parent', HBoxControl2,params.default_normalized_font{:}, 'String', sprintf('Save Data \x26DB') );
            
            %%%%%%%%%%%%%%%%%%%Panel SaveOptions %%%%%%%%%%%%%%%%%%%%%%%%%%
            mainVBBoxSave = uix.VBox('Parent', PanelSave,params.default_box_spacing_padding{:});
            
            %%%%%%%%%%%%%%%% 1. Row Save Overview plots 
            HBoxSave1 = uix.HBox('Parent', mainVBBoxSave, params.default_box_spacing_padding{:} );
            
            HButtonBoxSave11 = uix.HButtonBox('Parent', HBoxSave1, params.default_HButtonBox{:});
            tempH = uilabel( 'Parent', HButtonBoxSave11, 'HorizontalAlignment','left','Text', 'Save Overview plots as .pdf: ..................................................................................' );
            set(tempH, 'FontSize',14);
            
            HButtonBoxSave12 = uix.HButtonBox('Parent', HBoxSave1, params.default_HButtonBox{:} );
            obj.B_SavePlots = uicontrol( 'Parent', HButtonBoxSave12,'Style','checkbox','Value',1,'Tag','checkboxSaveOverview');
            
            set( HBoxSave1, 'Widths', [-10 -1] );
            
            %%%%%%%%%%%%%%%% 2. Row Save Histogram plots 
            HBoxSave2 = uix.HBox('Parent', mainVBBoxSave, params.default_box_spacing_padding{:} );
            
            HButtonBoxSave21 = uix.HButtonBox('Parent', HBoxSave2, params.default_HButtonBox{:} );
            tempH = uilabel( 'Parent', HButtonBoxSave21, 'HorizontalAlignment','left','Text', 'Save Histogram plots as .pdf: ..................................................................................' );
            set(tempH, 'FontSize',14);
            
            HButtonBoxSave22 = uix.HButtonBox('Parent', HBoxSave2, params.default_HButtonBox{:} );
            obj.B_SaveHisto = uicontrol( 'Parent', HButtonBoxSave22,'Style','checkbox','Value',1,'Tag','checkboxSaveHistogram');
            
            set( HBoxSave2, 'Widths', [-10 -1] );
            
            %%%%%%%%%%%%%%%% 3. Row Save Processed image
            HBoxSave3 = uix.HBox('Parent', mainVBBoxSave, params.default_box_spacing_padding{:}  );
            
            HButtonBoxSave31 = uix.HButtonBox('Parent', HBoxSave3, params.default_HButtonBox{:} );
            tempH = uilabel( 'Parent', HButtonBoxSave31, 'HorizontalAlignment','left','Text', 'Save Processed Image as .pdf: ..................................................................................' );
            set(tempH, 'FontSize',14);
            
            HButtonBoxSave32 = uix.HButtonBox('Parent', HBoxSave3, params.default_HButtonBox{:} );
            obj.B_SavePicProc = uicontrol( 'Parent', HButtonBoxSave32,'Style','checkbox','Value',1,'Tag','checkboxSavePicProcessed');
            
            set( HBoxSave3, 'Widths', [-10 -1] );
            
            %%%%%%%%%%%%%%%% 4. Row Save Fiber Groups image
            HBoxSave4 = uix.HBox('Parent', mainVBBoxSave, params.default_box_spacing_padding{:}  );
            
            HButtonBoxSave41 = uix.HButtonBox('Parent', HBoxSave4, params.default_HButtonBox{:} );
            tempH = uilabel( 'Parent', HButtonBoxSave41, 'HorizontalAlignment','left','Text', 'Save Fiber-Grouping Image as .pdf: ..................................................................................' );
            set(tempH, 'FontSize',14);
            
            HButtonBoxSave42 = uix.HButtonBox('Parent', HBoxSave4, params.default_HButtonBox{:} );
            obj.B_SavePicGroups = uicontrol( 'Parent', HButtonBoxSave42,'Style','checkbox','Value',1,'Tag','checkboxSavePicGroups');
            
            set( HBoxSave4, 'Widths', [-10 -1] );
            
            %%%%%%%%%%%%%%%% 5. Row Save Fiber Table 
            HBoxSave5 = uix.HBox('Parent', mainVBBoxSave, params.default_box_spacing_padding{:}  );
            
            HButtonBoxSave51 = uix.HButtonBox('Parent', HBoxSave5, params.default_HButtonBox{:} );
            tempH = uilabel( 'Parent', HButtonBoxSave51, 'HorizontalAlignment','left','Text', 'Save Fiber-Table as Excel spreadsheet: ..................................................................................' );
            set(tempH, 'FontSize',14);
            
            HButtonBoxSave52 = uix.HButtonBox('Parent', HBoxSave5, params.default_HButtonBox{:} );
            obj.B_SaveFiberTable = uicontrol( 'Parent', HButtonBoxSave52,'Style','checkbox','Value',1,'Tag','checkboxSaveFiberTable'); 
            
            set( HBoxSave5, 'Widths', [-10 -1] );
            
            %%%%%%%%%%%%%%%% 6. Row Save Scatter all 
            HBoxSave6 = uix.HBox('Parent', mainVBBoxSave, params.default_box_spacing_padding{:}  );
            
            HButtonBoxSave61 = uix.HButtonBox('Parent', HBoxSave6, params.default_HButtonBox{:} );
            tempH = uilabel( 'Parent', HButtonBoxSave61, 'HorizontalAlignment','left','Text', 'Save Scatterplot all Fibers as .pdf: ..................................................................................' );
            set(tempH, 'FontSize',14);
            
            HButtonBoxSave62 = uix.HButtonBox('Parent', HBoxSave6, params.default_HButtonBox{:} );
            obj.B_SaveScatterAll = uicontrol( 'Parent', HButtonBoxSave62,'Style','checkbox','Value',1,'Tag','checkboxSaveScatterAll');
            
            set( HBoxSave6, 'Widths', [-10 -1] );
            
            %%%%%%%%%%%%%%%% 7. Row Save Binary Mask
            HBoxSave7 = uix.HBox('Parent', mainVBBoxSave, params.default_box_spacing_padding{:}  );
            
            HButtonBoxSave71 = uix.HButtonBox('Parent', HBoxSave7, params.default_HButtonBox{:} );
            tempH = uilabel( 'Parent', HButtonBoxSave71,  'HorizontalAlignment','left','Text', 'Save Binary Mask as .tif: ..................................................................................' );
            set(tempH, 'FontSize',14);
            
            HButtonBoxSave72 = uix.HButtonBox('Parent', HBoxSave7, params.default_HButtonBox{:} );
            obj.B_SaveBinaryMask = uicontrol( 'Parent', HButtonBoxSave72,'Style','checkbox','Value',1,'Tag','checkboxSaveBinaryMask');
            
            set( HBoxSave7, 'Widths', [-10 -1] );

            %%%%%%%%%%%%%%%% 7. Row Save dir
            HBoxSave8 = uix.HBox('Parent', mainVBBoxSave, params.default_box_spacing_padding{:} );
            
            HButtonBoxSave81 = uix.HButtonBox('Parent', HBoxSave8,'ButtonSize',[600 30],'Padding', 2 );
            obj.B_SaveOpenDir = uicontrol( 'Parent', HButtonBoxSave81,'FontUnits','normalized','Fontsize',0.5, 'String', 'Open Results Folder' );
            
            %%%%%%%%
            set( mainVBBoxSave, 'Heights', [-1 -1 -1 -1 -1 -1 -1 -1.5] );
            drawnow;

            %%%%%%%%%%%%%%%%%%% Pnael Info Text Log %%%%%%%%%%%%%%%%%%%%%%%
            hBoxSize=uix.HBox('Parent', PanelInfo, params.default_box_spacing_padding{:});
            obj.B_InfoText = uicontrol('Parent',hBoxSize,'Style','listbox','String',{});
            
            %%%%%%%%%%%%%%%%%%% Panel with Tabs %%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            obj.tabPanel = uix.TabPanel('Parent',obj.panelAxes,params.default_tab_panel{:},'Tag','tabMainPanel');
            
            statisticTabPanel =       uix.Panel('Parent',obj.tabPanel,'BorderType','line','Tag','obj.tabPanel');
            histogramTabPanel =       uix.Panel('Parent',obj.tabPanel,'BorderType','line','Tag','obj.tabPanel');
            pictureTabPanel =         uix.Panel('Parent',obj.tabPanel,'BorderType','line','Tag','obj.tabPanel');
            pictureRGBPlaneTabPanel = uix.Panel('Parent',obj.tabPanel,'BorderType','line','Tag','obj.tabPanel');
            tableTabPanel =           uix.Panel('Parent',obj.tabPanel,'BorderType','line','Tag','obj.tabPanel');
            scatterAllTabPanel =      uix.Panel('Parent',obj.tabPanel,'BorderType','line','Tag','obj.tabPanel');
            
            obj.tabPanel.TabTitles = {'Overview','Histograms','Image processed','Image with Fiber-Groups', 'Fiber Type Table','Scatterplot all Fibers'};
            obj.tabPanel.TabWidth = -1;
            %%%%%%%%%%%%%%%%%%% Tab Overview %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            obj.tabPanel.Selection = 1;drawnow;
            statisticTabHBox = uix.HBox('Parent',statisticTabPanel,'Spacing',2,'Padding',2);
            
            statsVBoxleft = uix.VBox( 'Parent', statisticTabHBox, 'Spacing', 15 ,'Padding',5);
            statsVBoxMiddle = uix.VBox( 'Parent', statisticTabHBox, 'Spacing', 15 ,'Padding',5);
            statsVBoxRight = uix.VBox( 'Parent', statisticTabHBox, 'Spacing', 15 ,'Padding',5);
            
            PanelArea = uix.Panel('Parent',statsVBoxleft,'Padding',5);
            PanelCount = uix.Panel('Parent',statsVBoxleft,'Padding',5);
            PanelDia = uix.Panel('Parent',statsVBoxMiddle,'Padding',5);
            PanelScatter = uix.Panel('Parent',statsVBoxMiddle,'Padding',5);
            PanelStatisticTabel = uix.Panel('Parent',statsVBoxRight,'Padding',5);
            
            obj.hAArea = axes('Parent',uicontainer('Parent',PanelArea));
            set(obj.hAArea, 'LooseInset', [0,0,0,0]);
            axtoolbar(obj.hAArea,{'export','datacursor','pan','zoomin','zoomout','restoreview'});
            obj.hACount= axes('Parent',uicontainer('Parent',PanelCount));
            set(obj.hACount, 'LooseInset', [0,0,0,0]);
            axtoolbar(obj.hACount,{'export','datacursor','pan','zoomin','zoomout','restoreview'});
            obj.hAScatterFarredRed = axes('Parent',uicontainer('Parent',PanelDia));
            set(obj.hAScatterFarredRed, 'LooseInset', [0,0,0,0]);
            axtoolbar(obj.hAScatterFarredRed,{'export','datacursor','pan','zoomin','zoomout','restoreview'});
            obj.hAScatterBlueRed = axes('Parent',uicontainer('Parent',PanelScatter));
            set(obj.hAScatterBlueRed, 'LooseInset', [0,0,0,0]);
            axtoolbar(obj.hAScatterBlueRed,{'export','datacursor','pan','zoomin','zoomout','restoreview'});
            drawnow;
           

            obj.B_TableStatistic = uitable('Parent',PanelStatisticTabel);
            obj.B_TableMain.Position =[0 0 1 1];
            
            set(statisticTabHBox,'Widths', [-2 -2 -1.2])
            set( statsVBoxleft, 'Heights', [-1 -1] );
            set( statsVBoxMiddle, 'Heights', [-1 -1] );
            
            set(obj.hAArea,'Units','normalized','OuterPosition',[0 0 1 1]);
            set(obj.hAArea,'XLim',[-1.8 1.8]);
            set(obj.hAArea,'YLim',[-1.8 1.8]);
            set(obj.hAArea,'xtick',[],'ytick',[])
            set(obj.hAArea,'PlotBoxAspectRatio',[1 1 1]);
            
            set(obj.hACount,'Units','normalized','OuterPosition',[0 0 1 1]);

            set(obj.hAScatterFarredRed,'Units','normalized','OuterPosition',[0 0 1 1]);

            set(obj.hAScatterBlueRed,'Units','normalized','OuterPosition',[0 0 1 1]);
            drawnow;

            %%%%%%%%%%%%%%%%%%%%%%%% Tab Histogramms %%%%%%%%%%%%%%%%%%%%%%
            obj.tabPanel.Selection = 2; drawnow;
            histoTabHBox = uix.HBox('Parent',histogramTabPanel,'Spacing',2,'Padding',2);
            
            histoVBoxleft = uix.VBox( 'Parent', histoTabHBox, 'Spacing', 15 ,'Padding',5);
            histoVBoxright = uix.VBox( 'Parent', histoTabHBox, 'Spacing', 15 ,'Padding',5);
            
            histoArea = uix.Panel('Parent',histoVBoxleft,'Padding',5);
            histoAspect = uix.Panel('Parent',histoVBoxleft,'Padding',5);
            histoDiameter = uix.Panel('Parent',histoVBoxright,'Padding',5);
            histoRound = uix.Panel('Parent',histoVBoxright,'Padding',5);
            
            obj.hAAreaHist = axes('Parent',uicontainer('Parent',histoArea));
            set(obj.hAAreaHist, 'LooseInset', [0,0,0,0]);
            axtoolbar(obj.hAAreaHist,{'export','datacursor','pan','zoomin','zoomout','restoreview'});
            obj.hAAspectHist= axes('Parent',uicontainer('Parent',histoAspect));
            set(obj.hAAspectHist, 'LooseInset', [0,0,0,0]);
            axtoolbar(obj.hAAspectHist,{'export','datacursor','pan','zoomin','zoomout','restoreview'});
            obj.hADiaHist = axes('Parent',uicontainer('Parent',histoDiameter));
            set(obj.hADiaHist, 'LooseInset', [0,0,0,0]);
            axtoolbar(obj.hADiaHist,{'export','datacursor','pan','zoomin','zoomout','restoreview'});
            obj.hARoundHist = axes('Parent',uicontainer('Parent',histoRound));
            set(obj.hARoundHist, 'LooseInset', [0,0,0,0]);
            axtoolbar(obj.hARoundHist,{'export','datacursor','pan','zoomin','zoomout','restoreview'});
            drawnow;
            
            %%%%%%%%%%%%%%%%%%%%%%%% Tab Image processed
            obj.tabPanel.Selection = 3; drawnow;
            mainPicProcPanel = uix.Panel('Parent',pictureTabPanel,params.default_panel{:},'Title', 'RGB Image processed with object boundaries and label numbers','FontSize',fontSizeM);
            
            obj.hAPProcessed = axes('Parent',uicontainer('Parent',mainPicProcPanel));
            axtoolbar(obj.hAPProcessed,{'export','datacursor','pan','zoomin','zoomout','restoreview'});
            axis image
            set(obj.hAPProcessed, 'LooseInset', [0,0,0,0]);
            set(obj.hAPProcessed,'Box','off');
            drawnow;
            %%%%%%%%%%%%%%%%%%%%%%%% Tab Image with Groups %%%%%%%%%%%%%
            obj.tabPanel.Selection = 4;drawnow;
            mainPicGroupPanel = uix.Panel('Parent',pictureRGBPlaneTabPanel,params.default_panel{:},'Title', 'RGB Image with Fiber-Type-Groups','FontSize',fontSizeM);
            
            obj.hAPGroups = axes('Parent',uicontainer('Parent',mainPicGroupPanel));
            axtoolbar(obj.hAPGroups,{'export','datacursor','pan','zoomin','zoomout','restoreview'});
            axis image
            set(obj.hAPGroups, 'LooseInset', [0,0,0,0]);
            set(obj.hAPGroups,'Box','off');
            drawnow;
            %%%%%%%%%%%%%%%%%%%%%%%% Tab Tabel %%%%%%%%%%%%%%%%%%%%%%%%%%
            obj.tabPanel.Selection = 5;drawnow;
            mainTablePanel = uix.Panel('Parent',tableTabPanel,'Padding',5,'FontSize',fontSizeM);
            obj.B_TableMain = uitable('Parent',mainTablePanel);
            
            % obj.B_TableMain.FontSize = fontSizeS;
            % obj.B_TableMain.Units = 'normalized';
            obj.B_TableMain.Position =[0 0 1 1];
            
            set(obj.hACount,'Units','normalized','OuterPosition',[0 0 1 1]);
            
            set(obj.hAScatterFarredRed,'Units','normalized','OuterPosition',[0 0 1 1]);

            set(obj.hAScatterBlueRed,'Units','normalized','OuterPosition',[0 0 1 1]);
            drawnow;
            %%%%%%%%%%%%%%%%%%%%%%%% Tab Scatter all %%%%%%%%%%%%%%%%%%%%%%
            obj.tabPanel.Selection = 6;drawnow;
            mainScatterallPanel = uix.Panel('Parent',scatterAllTabPanel,'Padding',50,'Title', '3D-Scatterplot showing all fibers in a Blue/Red/Farred coordinate system','FontSize',fontSizeM);
            
            obj.hAScatterAll = axes('Parent',uicontainer('Parent',mainScatterallPanel),'Units','normalized','OuterPosition',[0 0 1 1]);
            set(obj.hAScatterAll, 'LooseInset', [0,0,0,0]);
            axtoolbar(obj.hAScatterAll,{'export','datacursor','pan','zoomin','zoomout','restoreview'});
            drawnow;
            %%%%%%%%%%%%%%% call edit functions for GUI
            obj.setToolTipStrings();
            
            set(mainCard,'Visible','on');
            
            obj.tabPanel.Selection = 1;drawnow;

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
            
            BackAnalToolTip = sprintf('Go back to analyze mode.');
            
            NewPicToolTip = sprintf('Select a new image for further processing.');
            
            SaveToolTip = sprintf(['Saves the data in the same \n',...
                ' directory as the selected RGB image.',...
                'Create a new folder for each timestamp.']);
            
            CloseToolTip = sprintf(['Quit the program. \n',...
                'Unsaved data will be lost.']);
            
            set(obj.B_BackAnalyze,'tooltipstring',BackAnalToolTip);
            set(obj.B_CloseProgramm,'tooltipstring',CloseToolTip);
            set(obj.B_NewPic,'tooltipstring',NewPicToolTip);
            set(obj.B_Save,'tooltipstring',SaveToolTip);
        end
        
         function delete(obj)
            
         end

    end
    
end

