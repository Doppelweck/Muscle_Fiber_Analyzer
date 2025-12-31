function view_helper_set_enabled_ui_controls(uicontrols, enabled)

% Alle Handles in ein Array ziehen
hAll = struct2cell(uicontrols);
hAll = vertcat(hAll{:});

% Nur gültige Handles mit Enable-Eigenschaft
hAll = hAll(isgraphics(hAll) & isprop(hAll,'Enable'));

% Vektorisiert setzen
set(hAll,'Enable',enabled);

end