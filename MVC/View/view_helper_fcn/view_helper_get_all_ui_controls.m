function ui = view_helper_get_all_ui_controls(viewHandle)

ui.buttons     = findall(viewHandle.panelControl,'Style','pushbutton');
ui.dropdowns   = findall(viewHandle.panelControl,'Type','uidropdown');
ui.sliders     = findall(viewHandle.panelControl,'Style','slider');
ui.checkboxes  = findall(viewHandle.panelControl,'Style','checkbox');
ui.editboxes   = findall(viewHandle.panelControl,'Style','edit');

end
