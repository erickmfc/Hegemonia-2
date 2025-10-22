// =========================================================
// HEGEMONIA GLOBAL - MENU DE CONSTRUÇÃO EM LISTA VERTICAL
// Lógica de clique atualizada para layout em lista
// =========================================================

if (global.modo_construcao) {
    
    var _mouse_gui_x = device_mouse_x_to_gui(0);
    var _mouse_gui_y = device_mouse_y_to_gui(0);
    
    // === DIMENSÕES ATUALIZADAS PARA LISTA VERTICAL ===
    var _menu_width = 600;   // Mesmo tamanho do Draw
    var _menu_height = 540;  // Mesmo tamanho do Draw
    var _menu_x = display_get_gui_width() / 2 - _menu_width / 2;
    var _menu_y = display_get_gui_height() / 2 - _menu_height / 2;
    
    var _btn_width = 300;    // Mesmo tamanho do Draw
    var _btn_height = 50;    // Mesmo tamanho do Draw
    var _btn_spacing_y = 70; // Mesmo espaçamento do Draw
    var _btn_start_x = _menu_x + 50;  // Mesma margem do Draw
    var _btn_start_y = _menu_y + 100; // 60 (header) + 40 (margin)
    
    // === VERIFICAÇÃO DE CLIQUES EM LISTA VERTICAL ===
    // Botão 1: Casa
    if (point_in_rectangle(_mouse_gui_x, _mouse_gui_y, 
                          _btn_start_x, _btn_start_y, 
                          _btn_start_x + _btn_width, _btn_start_y + _btn_height)) {
        global.construindo_agora = asset_get_index("obj_casa");
        global.modo_construcao = false;
        show_debug_message("✅ SELECIONADO: Casa");
        exit;
    }
    
    // Botão 2: Banco
    if (point_in_rectangle(_mouse_gui_x, _mouse_gui_y, 
                          _btn_start_x, _btn_start_y + _btn_spacing_y, 
                          _btn_start_x + _btn_width, _btn_start_y + _btn_spacing_y + _btn_height)) {
        global.construindo_agora = asset_get_index("obj_banco");
        global.modo_construcao = false;
        show_debug_message("✅ SELECIONADO: Banco");
        exit;
    }
    
    // Botão 3: Fazenda
    if (point_in_rectangle(_mouse_gui_x, _mouse_gui_y, 
                          _btn_start_x, _btn_start_y + (_btn_spacing_y * 2), 
                          _btn_start_x + _btn_width, _btn_start_y + (_btn_spacing_y * 2) + _btn_height)) {
        global.construindo_agora = asset_get_index("obj_fazenda");
        global.modo_construcao = false;
        show_debug_message("✅ SELECIONADO: Fazenda");
        exit;
    }
    
    // Botão 4: Quartel
    if (point_in_rectangle(_mouse_gui_x, _mouse_gui_y, 
                          _btn_start_x, _btn_start_y + (_btn_spacing_y * 3), 
                          _btn_start_x + _btn_width, _btn_start_y + (_btn_spacing_y * 3) + _btn_height)) {
        global.construindo_agora = asset_get_index("obj_quartel");
        global.modo_construcao = false;
        show_debug_message("✅ SELECIONADO: Quartel");
        exit;
    }
    
    // Botão 5: Quartel Marinha
    if (point_in_rectangle(_mouse_gui_x, _mouse_gui_y, 
                          _btn_start_x, _btn_start_y + (_btn_spacing_y * 4), 
                          _btn_start_x + _btn_width, _btn_start_y + (_btn_spacing_y * 4) + _btn_height)) {
        global.construindo_agora = asset_get_index("obj_quartel_marinha");
        global.modo_construcao = false;
        show_debug_message("✅ SELECIONADO: Quartel Marinha");
        exit;
    }
    
    // Botão 6: Aeroporto Militar
    if (point_in_rectangle(_mouse_gui_x, _mouse_gui_y, 
                          _btn_start_x, _btn_start_y + (_btn_spacing_y * 5), 
                          _btn_start_x + _btn_width, _btn_start_y + (_btn_spacing_y * 5) + _btn_height)) {
        global.construindo_agora = asset_get_index("obj_aeroporto_militar");
        global.modo_construcao = false;
        show_debug_message("✅ SELECIONADO: Aeroporto Militar");
        exit;
    }
    
    // === BOTÃO DE FECHAR ===
    var _close_btn_size = 30;
    var _close_x = _menu_x + _menu_width - _close_btn_size - 10;
    var _close_y = _menu_y + 10;
    
    if (point_in_rectangle(_mouse_gui_x, _mouse_gui_y, 
                          _close_x, _close_y, 
                          _close_x + _close_btn_size, _close_y + _close_btn_size)) {
        global.modo_construcao = false;
        show_debug_message("❌ Menu de construção fechado");
        exit;
    }
}
