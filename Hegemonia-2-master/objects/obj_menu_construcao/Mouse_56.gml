// =========================================================
// HEGEMONIA GLOBAL - MENU DE CONSTRUÇÃO EM LISTA VERTICAL
// Lógica de clique atualizada para layout em lista
// =========================================================

if (global.modo_construcao) {
    
    var _mouse_gui_x = device_mouse_x_to_gui(0);
    var _mouse_gui_y = device_mouse_y_to_gui(0);
    
    // === DIMENSÕES ATUALIZADAS PARA LISTA VERTICAL ===
    var _menu_width = 600;   // Mesmo tamanho do Draw
    var _menu_height = 470;  // Mesmo tamanho do Draw
    var _menu_x = display_get_gui_width() / 2 - _menu_width / 2;
    var _menu_y = display_get_gui_height() / 2 - _menu_height / 2;
    
    var _btn_width = 300;    // Mesmo tamanho do Draw
    var _btn_height = 50;    // Mesmo tamanho do Draw
    var _btn_spacing_y = 70; // Mesmo espaçamento do Draw
    var _btn_start_x = _menu_x + 50;  // Mesma margem do Draw
    var _btn_start_y = _menu_y + 100; // 60 (header) + 40 (margin)
    
    // === CUSTOS DOS EDIFÍCIOS ===
    var _custo_casa = 1000;
    var _custo_banco = 2000;
    var _custo_quartel = 3000;
    var _custo_quartel_marinha = 4000;
    var _custo_aeroporto = 5000;
    
    // === VERIFICAÇÃO DE CLIQUES EM LISTA VERTICAL ===
    // Botão 1: Casa
    if (point_in_rectangle(_mouse_gui_x, _mouse_gui_y, 
                          _btn_start_x, _btn_start_y, 
                          _btn_start_x + _btn_width, _btn_start_y + _btn_height)) {
        // CORREÇÃO: Verificar recursos antes de construir
        if (global.dinheiro >= _custo_casa) {
            // CORREÇÃO: Usar referência direta ao objeto
            global.construindo_agora = obj_casa;
            global.modo_construcao = false;
            show_debug_message("✅ SELECIONADO: Casa - Custo: $" + string(_custo_casa));
            exit;
        } else {
            show_debug_message("❌ Recursos insuficientes para Casa! Precisa: $" + string(_custo_casa) + ", Tem: $" + string(global.dinheiro));
        }
    }
    
    // Botão 2: Banco
    if (point_in_rectangle(_mouse_gui_x, _mouse_gui_y, 
                          _btn_start_x, _btn_start_y + _btn_spacing_y, 
                          _btn_start_x + _btn_width, _btn_start_y + _btn_spacing_y + _btn_height)) {
        // CORREÇÃO: Verificar recursos antes de construir
        if (global.dinheiro >= _custo_banco) {
            // CORREÇÃO: Usar referência direta ao objeto
            global.construindo_agora = obj_banco;
            global.modo_construcao = false;
            show_debug_message("✅ SELECIONADO: Banco - Custo: $" + string(_custo_banco));
            exit;
        } else {
            show_debug_message("❌ Recursos insuficientes para Banco! Precisa: $" + string(_custo_banco) + ", Tem: $" + string(global.dinheiro));
        }
    }
    
    // Botão 3: Quartel
    if (point_in_rectangle(_mouse_gui_x, _mouse_gui_y, 
                          _btn_start_x, _btn_start_y + (_btn_spacing_y * 2), 
                          _btn_start_x + _btn_width, _btn_start_y + (_btn_spacing_y * 2) + _btn_height)) {
        // CORREÇÃO: Verificar recursos antes de construir
        if (global.dinheiro >= _custo_quartel) {
            // CORREÇÃO: Usar referência direta ao objeto
            global.construindo_agora = obj_quartel;
            global.modo_construcao = false;
            show_debug_message("✅ SELECIONADO: Quartel - Custo: $" + string(_custo_quartel));
            exit;
        } else {
            show_debug_message("❌ Recursos insuficientes para Quartel! Precisa: $" + string(_custo_quartel) + ", Tem: $" + string(global.dinheiro));
        }
    }
    
    // Botão 4: Quartel Marinha
    if (point_in_rectangle(_mouse_gui_x, _mouse_gui_y, 
                          _btn_start_x, _btn_start_y + (_btn_spacing_y * 3), 
                          _btn_start_x + _btn_width, _btn_start_y + (_btn_spacing_y * 3) + _btn_height)) {
        // CORREÇÃO: Verificar recursos antes de construir
        if (global.dinheiro >= _custo_quartel_marinha) {
            // CORREÇÃO: Usar referência direta ao objeto
            global.construindo_agora = obj_quartel_marinha;
            global.modo_construcao = false;
            show_debug_message("✅ SELECIONADO: Quartel Marinha - Custo: $" + string(_custo_quartel_marinha));
            exit;
        } else {
            show_debug_message("❌ Recursos insuficientes para Quartel Marinha! Precisa: $" + string(_custo_quartel_marinha) + ", Tem: $" + string(global.dinheiro));
        }
    }
    
    // Botão 5: Aeroporto Militar
    if (point_in_rectangle(_mouse_gui_x, _mouse_gui_y, 
                          _btn_start_x, _btn_start_y + (_btn_spacing_y * 4), 
                          _btn_start_x + _btn_width, _btn_start_y + (_btn_spacing_y * 4) + _btn_height)) {
        // CORREÇÃO: Verificar recursos antes de construir
        if (global.dinheiro >= _custo_aeroporto) {
            // CORREÇÃO: Usar referência direta ao objeto em vez de asset_get_index
            global.construindo_agora = obj_aeroporto_militar;
            global.modo_construcao = false;
            show_debug_message("✅ SELECIONADO: Aeroporto Militar - Custo: $" + string(_custo_aeroporto));
            exit;
        } else {
            show_debug_message("❌ Recursos insuficientes para Aeroporto Militar! Precisa: $" + string(_custo_aeroporto) + ", Tem: $" + string(global.dinheiro));
        }
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
