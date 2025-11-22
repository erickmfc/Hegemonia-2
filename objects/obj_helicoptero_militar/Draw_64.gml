// ===============================================
// HEGEMONIA GLOBAL - HELICÓPTERO MILITAR (Draw GUI Corrigido)
// ===============================================

// A interface SÓ será desenhada se a unidade estiver selecionada.
if (selecionado) {
    
    // Converte a posição do helicóptero do "mundo" para a "tela"
    var _cam = view_camera[0];
    var _cam_x = camera_get_view_x(_cam);
    var _cam_y = camera_get_view_y(_cam);
    var _cam_w = camera_get_view_width(_cam);
    var _cam_h = camera_get_view_height(_cam);
    var _proj_x = (x - _cam_x) / (_cam_w / display_get_gui_width());
    var _proj_y = (y - _cam_y) / (_cam_h / display_get_gui_height());

    // Define a posição da UI acima do helicóptero
    var _ui_x = _proj_x;
    var _ui_y = _proj_y - 60 + (display_get_gui_height() * 0.05); // ✅ Movido 5% para baixo

    // Configurações do texto
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);

    // ✅ Escreve as informações de forma organizada (2 linhas apenas)
    // Linha 1: HP
    var _hp_percent = floor((hp_atual/hp_max)*100);
    var _hp_cor = (_hp_percent < 30) ? c_red : ((_hp_percent < 60) ? c_yellow : c_lime);
    draw_text_color(_ui_x, _ui_y, "HP: " + string(_hp_percent) + "%", _hp_cor, _hp_cor, _hp_cor, _hp_cor, 1);
    _ui_y += 15;
    
    // ✅ Linha 2: Modo (informação mais útil)
    var _modo_cor = (modo_ataque ? c_red : c_lime);
    draw_text_color(_ui_x, _ui_y, "Modo: " + (modo_ataque ? "ATAQUE" : "PASSIVO"), _modo_cor, _modo_cor, _modo_cor, _modo_cor, 1);
    
    // Reseta as configurações de desenho
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}