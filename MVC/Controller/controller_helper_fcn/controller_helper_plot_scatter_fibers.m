function LegendString = controller_helper_plot_scatter_fibers(statsMat,axs,type)
%CONTROLLER_HELPER_PLOT_SCATTER_FIBERS Summary of this function goes here
%Color Map for FIber Types
[~,ColorMap] = view_helper_fiber_color_map();
        
%get all Type Fibers
[T1, T12h, T2, T2x, T2a, T2ax, T0] = controller_helper_get_all_fibers(statsMat);

LegendString = {};
hold(axs, 'on');
%--- Main Plot Red over Blue for 'all' and 'main'
if ~isempty(T0) && ( strcmp(type,'all') || strcmp(type,'main') )
    scatter(axs,[T0.ColorRed],[T0.ColorBlue],20,ColorMap(6,:),'filled','MarkerEdgeColor','k');
    LegendString{end+1} = 'Type-0';
end
if ~isempty(T1) && ( strcmp(type,'all') || strcmp(type,'main') )
    scatter(axs,[T1.ColorRed],[T1.ColorBlue],20,ColorMap(1,:),'filled','MarkerEdgeColor','k');
    LegendString{end+1} = 'Type 1';
end
if ~isempty(T12h) && ( strcmp(type,'all') || strcmp(type,'main') )
    scatter(axs,[T12h.ColorRed],[T12h.ColorBlue],20,ColorMap(2,:),'filled','MarkerEdgeColor','k');
    LegendString{end+1} = 'Type 12h';
end
if ~isempty(T2) && ( strcmp(type,'main') )
    scatter(axs,[T2.ColorRed],[T2.ColorBlue],20,ColorMap(3,:),'filled','MarkerEdgeColor','k');
    LegendString{end+1} = 'Type 2';
end
if ~isempty(T2x) && ( strcmp(type,'all')  )
    scatter(axs,[T2x.ColorRed],[T2x.ColorBlue],20,ColorMap(3,:),'filled','MarkerEdgeColor','k');
    LegendString{end+1} = 'Type 2x';
end
if ~isempty(T2a) && ( strcmp(type,'all')  )
    scatter(axs,[T2a.ColorRed],[T2a.ColorBlue],20,ColorMap(4,:),'filled','MarkerEdgeColor','k');
    LegendString{end+1} = 'Type 2a';
end
if ~isempty(T2ax) && ( strcmp(type,'all')  )
    scatter(axs,[T2ax.ColorRed],[T2ax.ColorBlue],20,ColorMap(5,:),'filled','MarkerEdgeColor','k');
    LegendString{end+1} = 'Type 2ax';
end
%--- Red Subplot Plot Red over Farred for 'Type 2'
if ~isempty(T2x) && (  strcmp(type,'Type 2') )
    scatter(axs,[T2x.ColorRed],[T2x.ColorFarRed],20,ColorMap(3,:),'filled','MarkerEdgeColor','k');
    LegendString{end+1} = 'Type 2x';
end
if ~isempty(T2a) && (  strcmp(type,'Type 2') )
    scatter(axs,[T2a.ColorRed],[T2a.ColorFarRed],20,ColorMap(4,:),'filled','MarkerEdgeColor','k');
    LegendString{end+1} = 'Type 2a';
end
if ~isempty(T2ax) && ( strcmp(type,'Type 2') )
    scatter(axs,[T2ax.ColorRed],[T2ax.ColorFarRed],20,ColorMap(5,:),'filled','MarkerEdgeColor','k');
    LegendString{end+1} = 'Type 2ax';
end
hold(axs, 'off');
end