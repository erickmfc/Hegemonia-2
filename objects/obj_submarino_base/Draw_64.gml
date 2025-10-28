// ===============================================
// HEGEMONIA GLOBAL - SUBMARINO DRAW GUI EVENT
// Interface para Submarinos - só aparece quando selecionado
// ===============================================

// A interface SÓ será desenhada se o submarino estiver selecionado
if (selecionado) {
    
    // --- 1. CONVERTE A POSIÇÃO DO SUBMARINO DO "MUNDO" PARA A "TELA" ---
    var _cam = view_camera[0];
    var _cam_x = camera_get_view_x(_cam);
    var _cam_y = camera_get_view_y(_cam);
    var _cam_w = camera_get_view_width(_cam);
    var _cam_h = camera_get_view_height(_cam);

    var _proj_x = (x - _cam_x) / (_cam_w / display_get_gui_width());
    var _proj_y = (y - _cam_y) / (_cam_h / display_get_gui_height());

    // --- 2. DEFINE A POSIÇÃO DA CAIXA DE INFORMAÇÕES ---
    var _info_x = _proj_x;
    var _info_y = _proj_y - 80;
    var _info_w = 180;
    var _info_h = 110; // Aumentado para incluir status de submersão

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

    // Escreve as informações
    var _text_x = _info_x;
    var _text_y = _info_y - _info_h/2 + 5;

    // Nome da unidade
    draw_set_color(make_color_rgb(0, 255, 255));
    draw_text(_text_x, _text_y, nome_unidade);
    _text_y += 18;
    
    // Status de Submersão
    if (submerso) {
        draw_set_color(make_color_rgb(0, 255, 255)); // Ciano
        draw_text(_text_x, _text_y, "🌊 SUBMERSO");
    } else {
        draw_set_color(c_green);
        draw_text(_text_x, _text_y, "⛴️ SUPERFÍCIE");
    }
    _text_y += 18;
    
    // HP com cor baseada na porcentagem
    var _hp_percent = (hp_atual / hp_max) * 100;
    if (_hp_percent < 30) draw_set_color(c_red);
    else if (_hp_percent < 60) draw_set_color(c_yellow);
    else draw_set_color(c_white);
    
    draw_text(_text_x, _text_y, "HP: " + string(round(_hp_percent)) + "%");
    _text_y += 18;
    
    // Estado atual
    draw_set_color(make_color_rgb(0, 255, 255)); // Ciano
    var _estado_texto = "PARADO";
    if (estado == LanchaState.MOVENDO) _estado_texto = "NAVEGANDO";
    else if (estado == LanchaState.PATRULHANDO) _estado_texto = "PATRULHANDO";
    else if (estado == LanchaState.ATACANDO) _estado_texto = "ATACANDO";
    
    draw_text(_text_x, _text_y, "Estado: " + _estado_texto);
    _text_y += 18;
    
    // Modo atual
    if (modo_combate == LanchaMode.ATAQUE) {
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