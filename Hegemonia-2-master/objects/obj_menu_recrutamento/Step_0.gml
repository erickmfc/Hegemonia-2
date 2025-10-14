// ===============================================
// HEGEMONIA GLOBAL - MENU DE RECRUTAMENTO
// Bloco 4, Fase 3: Controle de Delay e Navegação
// ===============================================

// Evento Step de obj_menu_recrutamento

// Reduzir o delay de abertura
if (delay_abertura > 0) {
    delay_abertura--;
}

// Reduzir o debounce de navegação
if (debounce_navegacao > 0) {
    debounce_navegacao--;
}

// === CONTROLE DE NAVEGAÇÃO ENTRE UNIDADES ===
if (instance_exists(id_do_quartel) && delay_abertura <= 0) {
    var _mw = display_get_gui_width() * 0.5;
    var _mh = display_get_gui_height() * 0.6;
    var _mx = (display_get_gui_width() - _mw) / 2;
    var _my = (display_get_gui_height() - _mh) / 2;
    
    // Botões de navegação
    var _nav_btn_w = 40;
    var _nav_btn_h = 30;
    var _nav_y = _my + 100;
    var _prev_x = _mx + 20;
    var _next_x = _mx + _mw - _nav_btn_w - 20;
    
    // Verificar clique no botão anterior
    if (mouse_check_button_pressed(mb_left) && debounce_navegacao <= 0) {
        var _gui_mouse_x = device_mouse_x_to_gui(0);
        var _gui_mouse_y = device_mouse_y_to_gui(0);
        
        // Botão anterior
        if (point_in_rectangle(_gui_mouse_x, _gui_mouse_y, _prev_x, _nav_y, _prev_x + _nav_btn_w, _nav_y + _nav_btn_h)) {
            if (id_do_quartel.unidade_selecionada > 0) {
                id_do_quartel.unidade_selecionada--;
                debounce_navegacao = debounce_delay; // Ativar debounce
                global.debug_log("Navegando para unidade anterior: " + string(id_do_quartel.unidade_selecionada));
            }
        }
        
        // Botão próximo
        if (point_in_rectangle(_gui_mouse_x, _gui_mouse_y, _next_x, _nav_y, _next_x + _nav_btn_w, _nav_y + _nav_btn_h)) {
            if (id_do_quartel.unidade_selecionada < ds_list_size(id_do_quartel.unidades_disponiveis) - 1) {
                id_do_quartel.unidade_selecionada++;
                debounce_navegacao = debounce_delay; // Ativar debounce
                global.debug_log("Navegando para próxima unidade: " + string(id_do_quartel.unidade_selecionada));
            }
        }
    }
}
