// =========================================================
// MENU DE RECURSOS SUSPENSO - MOUSE LEFT PRESSED
// Toggle (abrir/fechar) ao clicar no cabeçalho
// =========================================================

var _mouse_gui_x = device_mouse_x_to_gui(0);
var _mouse_gui_y = device_mouse_y_to_gui(0);

var _menu_x1 = menu_pos_x;
var _menu_y1 = menu_pos_y;
var _menu_x2 = menu_pos_x + menu_largura_expandido;
// ✅ REDUZIDO EM 20%
var _header_height = 40; // 50 * 0.8 = 40

// === VERIFICAR CLIQUE NO CABEÇALHO ===
if (point_in_rectangle(_mouse_gui_x, _mouse_gui_y,
                       _menu_x1, _menu_y1,
                       _menu_x2, _menu_y1 + _header_height)) {
    
    // Alternar estado
    if (menu_estado == 0) {
        // Recolhido -> Abrindo
        menu_estado = 1;
        timer_animacao = 0;
        
        if (variable_global_exists("debug_enabled") && global.debug_enabled) {
            show_debug_message("✅ Menu de Recursos: Expandindo...");
        }
    } else if (menu_estado == 2) {
        // Aberto -> Fechando
        menu_estado = 3;
        timer_animacao = 0;
        
        if (variable_global_exists("debug_enabled") && global.debug_enabled) {
            show_debug_message("✅ Menu de Recursos: Recolhendo...");
        }
    }
}
