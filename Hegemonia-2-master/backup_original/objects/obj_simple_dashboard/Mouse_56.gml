/// Strategic Dashboard - Mouse Left Released Event
/// Sistema de recolher/expandir do Centro de Comando

// Converter coordenadas do mouse para GUI
var _mouse_gui_x = device_mouse_x_to_gui(0);
var _mouse_gui_y = device_mouse_y_to_gui(0);

// === BOTÃO RECOLHER/EXPANDIR ===
var btn_size = 16; // Igual ao Draw_64.gml
var btn_x = dashboard_x + dashboard_width - btn_size - 5; // Igual ao Draw_64.gml
var btn_y = dashboard_y + 5; // Igual ao Draw_64.gml

// Debug: Mostrar posições
show_debug_message("=== DEBUG BOTÃO RECOLHER ===");
show_debug_message("Mouse: (" + string(_mouse_gui_x) + ", " + string(_mouse_gui_y) + ")");
show_debug_message("Botão: (" + string(btn_x) + ", " + string(btn_y) + ") - (" + string(btn_x + btn_size) + ", " + string(btn_y + btn_size) + ")");

// Verificar clique no botão
if (point_in_rectangle(_mouse_gui_x, _mouse_gui_y, btn_x, btn_y, btn_x + btn_size, btn_y + btn_size)) {
    show_debug_message("*** BOTÃO RECOLHER CLICADO! ***");
    dashboard_expanded = !dashboard_expanded;
    
    if (dashboard_expanded) {
        dashboard_height = dashboard_height_expanded;
        show_debug_message("Centro de Comando EXPANDIDO");
    } else {
        dashboard_height = dashboard_height_collapsed;
        show_debug_message("Centro de Comando RECOLHIDO");
    }
} else {
    show_debug_message("Clique fora do botão recolher");
}
