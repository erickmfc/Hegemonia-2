/// @description Step - Detectar clique no botão usando coordenadas GUI
// Detecta cliques no botão e volta para a room "menu"

// Verificar se o botão esquerdo do mouse foi pressionado
if (device_mouse_check_button_pressed(0, mb_left)) {
    // === CALCULAR DIMENSÕES (MESMAS DO DRAW_64) ===
    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();
    var _menu_w = _gui_w * 0.85;
    var _menu_h = _gui_h * 0.85;
    var _menu_x = (_gui_w - _menu_w) / 2;
    var _menu_y = (_gui_h - _menu_h) / 2;
    
    // Posição e tamanho do botão (mesmo do Draw_64)
    var _btn_voltar_y = _menu_y + _menu_h - 80;
    var _btn_voltar_x = _menu_x + _menu_w / 2;
    var _btn_width = 250;
    var _btn_height = 60;
    
    // Obter posição do mouse em coordenadas GUI
    var _mouse_gui_x = device_mouse_x_to_gui(0);
    var _mouse_gui_y = device_mouse_y_to_gui(0);
    
    // Calcular limites do botão
    var _btn_left = _btn_voltar_x - _btn_width/2;
    var _btn_right = _btn_voltar_x + _btn_width/2;
    var _btn_top = _btn_voltar_y;
    var _btn_bottom = _btn_voltar_y + _btn_height;
    
    // Verificar se o clique está dentro do botão
    if (_mouse_gui_x >= _btn_left && _mouse_gui_x <= _btn_right &&
        _mouse_gui_y >= _btn_top && _mouse_gui_y <= _btn_bottom) {
        // Voltar para o menu principal
        var _room_menu = asset_get_index("menu");
        if (_room_menu == -1) {
            // Fallback: tentar outros nomes possíveis
            _room_menu = asset_get_index("rm_menu");
        }
        
        if (_room_menu != -1) {
            room_goto(_room_menu);
            show_debug_message("Voltando ao menu principal...");
        } else {
            show_debug_message("[VOLTAR MENU] Sala de menu não encontrada!");
        }
    }
}
