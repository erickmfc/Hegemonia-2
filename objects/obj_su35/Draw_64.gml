// ===============================================
// HEGEMONIA GLOBAL - CAÇA SU-35 DRAW GUI EVENT
// Interface com informações de SU-35
// ===============================================

// A interface SÓ será desenhada se a unidade estiver selecionada
if (selecionado) {
    
    // --- 1. CONVERTE A POSIÇÃO DO AVIÃO DO "MUNDO" PARA A "TELA" ---
    var _cam = view_camera[0];
    var _cam_x = camera_get_view_x(_cam);
    var _cam_y = camera_get_view_y(_cam);
    var _cam_w = camera_get_view_width(_cam);
    var _cam_h = camera_get_view_height(_cam);

    var _proj_x = (x - _cam_x) / (_cam_w / display_get_gui_width());
    var _proj_y = (y - _cam_y) / (_cam_h / display_get_gui_height());

    // --- 2. DEFINE A POSIÇÃO DA CAIXA DE INFORMAÇÕES ACIMA DO AVIÃO ---
    var _info_x = _proj_x;
    var _info_y = _proj_y - 80 + (display_get_gui_height() * 0.05); // ✅ Movido 5% para baixo
    var _info_w = 150;
    var _info_h = 60; // ✅ Reduzido para 2 linhas

    // --- 3. DESENHA A INTERFACE ---
    // Fundo da caixa de informações
    draw_set_color(c_black);
    draw_set_alpha(0.7);
    draw_rectangle(_info_x - _info_w/2, _info_y - _info_h/2, _info_x + _info_w/2, _info_y + _info_h/2, false);
    draw_set_alpha(1.0);

    // Borda da caixa
    draw_set_color(c_white);
    draw_set_alpha(0.8);
    draw_rectangle(_info_x - _info_w/2, _info_y - _info_h/2, _info_x + _info_w/2, _info_y + _info_h/2, true);
    draw_set_alpha(1.0);

    // Configurações do texto
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(c_white);

    // Escreve as informações, bem espaçadas
    var _text_x = _info_x;
    var _text_y = _info_y - _info_h/2 + 5;

    // Nome da unidade
    draw_set_color(c_yellow);
    draw_text(_text_x, _text_y, "SU-35 Flanker");
    _text_y += 18;
    
    // ✅ Linha 1: HP com cor baseada na porcentagem
    var _hp_percent = (hp_atual / hp_max) * 100;
    if (_hp_percent < 30) draw_set_color(c_red);
    else if (_hp_percent < 60) draw_set_color(c_yellow);
    else draw_set_color(c_white);
    
    draw_text(_text_x, _text_y, "HP: " + string(round(_hp_percent)) + "%");
    _text_y += 18;
    
    // ✅ Linha 2: Modo atual (informação mais útil)
    if (modo_ataque) {
        draw_set_color(c_red);
        draw_text(_text_x, _text_y, "MODO ATAQUE");
    } else {
        draw_set_color(c_gray);
        draw_text(_text_x, _text_y, "MODO PASSIVO");
    }
    
    // Reset alinhamento
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
