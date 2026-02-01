function [ColorMapMain,ColorMapAll] = view_helper_fiber_color_map()

ColorMapMain(1,:) = [51 51 255]; % Blue Fiber Type 1
ColorMapMain(2,:) = [255 51 255]; % Magenta Fiber Type 12h
ColorMapMain(3,:) = [255 51 51]; % Red Fiber Type 2
ColorMapMain(4,:) = [224 224 224]; % Grey Fiber Type undifiend
ColorMapMain(5,:) = [51 255 51]; % Green Collagen
ColorMapMain = ColorMapMain/255;

ColorMapAll(1,:) = [51 51 255]; % Blue Fiber Type 1
ColorMapAll(2,:) = [255 51 255]; % Magenta Fiber Type 12h
ColorMapAll(3,:) = [255 51 51]; % Red Fiber Type 2x
ColorMapAll(4,:) = [255 255 51]; % Yellow Fiber Type 2a
ColorMapAll(5,:) = [255 153 51]; % orange Fiber Type 2ax
ColorMapAll(6,:) = [224 224 224]; % Grey Fiber Type undifiend
ColorMapAll(7,:) = [51 255 51]; % Green Collagen
ColorMapAll = ColorMapAll/255;

end