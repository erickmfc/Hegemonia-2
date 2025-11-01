// =========================================================
// HEGEMONIA GLOBAL - MENU DE CONSTRUÇÃO EM LISTA VERTICAL
// Lógica de clique atualizada para layout em lista
// =========================================================

if (global.modo_construcao && mouse_check_button_released(mb_left)) {
    
    // === DIMENSÕES SINCRONIZADAS COM DRAW_64.GML ===
    var _menu_width = 360;   // Mesmo tamanho do Draw_64.gml
    var _menu_height = 480;  // Mesmo tamanho do Draw_64.gml
    var _menu_x = display_get_gui_width() / 2 - _menu_width / 2;
    var _menu_y = display_get_gui_height() / 2 - _menu_height / 2;
    
    var _header_height = 50; // Mesmo do Draw_64.gml
    var _btn_width = 280;    // Mesmo tamanho do Draw_64.gml
    var _btn_height = 38;    // Mesmo tamanho do Draw_64.gml
    var _btn_spacing_y = 38; // Mesmo espaçamento do Draw_64.gml
    var _btn_start_x = _menu_x + (_menu_width - 280) / 2;  // Centralizado como no Draw_64.gml
    var _btn_start_y = _menu_y + _header_height + 20; // Header + margem do Draw_64.gml
    
    // Coordenadas GUI do mouse
    var _mouse_gui_x = device_mouse_x_to_gui(0);
    var _mouse_gui_y = device_mouse_y_to_gui(0);
    
    // === BOTÃO DE FECHAR (PRIORIDADE) ===
    var _close_btn_size = 30;
    var _close_x = _menu_x + _menu_width - _close_btn_size - 10;
    var _close_y = _menu_y + 10;
    
    if (point_in_rectangle(_mouse_gui_x, _mouse_gui_y, 
                          _close_x, _close_y, 
                          _close_x + _close_btn_size, _close_y + _close_btn_size)) {
        global.modo_construcao = false;
        exit;
    }
    
    // === VERIFICAÇÃO DE CLIQUES EM LISTA VERTICAL ===
    // Botão 1: Casa
    if (point_in_rectangle(_mouse_gui_x, _mouse_gui_y, 
                          _btn_start_x, _btn_start_y, 
                          _btn_start_x + _btn_width, _btn_start_y + _btn_height)) {
        var _casa_index = asset_get_index("obj_casa");
        global.construindo_agora = _casa_index;
        global.modo_construcao = false;
        exit;
    }
    
    // Botão 2: Banco
    if (point_in_rectangle(_mouse_gui_x, _mouse_gui_y, 
                          _btn_start_x, _btn_start_y + _btn_spacing_y, 
                          _btn_start_x + _btn_width, _btn_start_y + _btn_spacing_y + _btn_height)) {
        var _banco_index = asset_get_index("obj_banco");
        global.construindo_agora = _banco_index;
        global.modo_construcao = false;
        exit;
    }
    
    // Botão 3: Fazenda
    if (point_in_rectangle(_mouse_gui_x, _mouse_gui_y, 
                          _btn_start_x, _btn_start_y + (_btn_spacing_y * 2), 
                          _btn_start_x + _btn_width, _btn_start_y + (_btn_spacing_y * 2) + _btn_height)) {
        var _fazenda_index = asset_get_index("obj_fazenda");
        global.construindo_agora = _fazenda_index;
        global.modo_construcao = false;
        exit;
    }
    
    // Botão 4: Quartel
    if (point_in_rectangle(_mouse_gui_x, _mouse_gui_y, 
                          _btn_start_x, _btn_start_y + (_btn_spacing_y * 3), 
                          _btn_start_x + _btn_width, _btn_start_y + (_btn_spacing_y * 3) + _btn_height)) {
        var _quartel_index = asset_get_index("obj_quartel");
        global.construindo_agora = _quartel_index;
        global.modo_construcao = false;
        exit;
    }
    
    // Botão 5: Quartel Marinha
    if (point_in_rectangle(_mouse_gui_x, _mouse_gui_y, 
                          _btn_start_x, _btn_start_y + (_btn_spacing_y * 4), 
                          _btn_start_x + _btn_width, _btn_start_y + (_btn_spacing_y * 4) + _btn_height)) {
        var _marinha_index = asset_get_index("obj_quartel_marinha");
        global.construindo_agora = _marinha_index;
        global.modo_construcao = false;
        exit;
    }
    
    // Botão 6: Aeroporto Militar
    if (point_in_rectangle(_mouse_gui_x, _mouse_gui_y, 
                          _btn_start_x, _btn_start_y + (_btn_spacing_y * 5), 
                          _btn_start_x + _btn_width, _btn_start_y + (_btn_spacing_y * 5) + _btn_height)) {
        var _aeroporto_index = asset_get_index("obj_aeroporto_militar");
        global.construindo_agora = _aeroporto_index;
        global.modo_construcao = false;
        exit;
    }
}
