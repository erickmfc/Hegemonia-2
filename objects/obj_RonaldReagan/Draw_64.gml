// ===============================================
// HEGEMONIA GLOBAL - LANCHA PATRULHA DRAW GUI EVENT
// Interface Naval - só aparece quando selecionado
// ===============================================

// A interface SÓ será desenhada se o navio estiver selecionado
if (variable_instance_exists(id, "selecionado") && selecionado) {
    
    // --- 1. CONVERTE A POSIÇÃO DA LANCHA DO "MUNDO" PARA A "TELA" ---
    // Isso garante que a UI siga a lancha na tela, independente do zoom ou da câmera
    var _cam = view_camera[0];
    var _cam_x = camera_get_view_x(_cam);
    var _cam_y = camera_get_view_y(_cam);
    var _cam_w = camera_get_view_width(_cam);
    var _cam_h = camera_get_view_height(_cam);

    var _proj_x = (x - _cam_x) / (_cam_w / display_get_gui_width());
    var _proj_y = (y - _cam_y) / (_cam_h / display_get_gui_height());

    // --- 2. DEFINE A POSIÇÃO DA CAIXA DE INFORMAÇÕES ACIMA DA LANCHA ---
    var _info_x = _proj_x;
    var _info_y = _proj_y - 80; // Posição 80 pixels ACIMA da lancha
    var _info_w = 150;
    var _info_h = 90; // Aumentado para acomodar mais informações

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
    draw_text(_text_x, _text_y, "PORTA-AVIÕES RONALD REAGAN");
    _text_y += 18;
    
    // HP com cor baseada na porcentagem
    var _hp_percent = (hp_atual / hp_max) * 100;
    if (_hp_percent < 30) draw_set_color(c_red);
    else if (_hp_percent < 60) draw_set_color(c_yellow);
    else draw_set_color(c_white);
    
    draw_text(_text_x, _text_y, "HP: " + string(round(_hp_percent)) + "%");
    _text_y += 18;
    
    // Estado atual (CORRIGIDO para lancha)
    draw_set_color(make_color_rgb(0, 255, 255)); // Ciano
    var _estado_texto = "PARADO";
    if (estado == LanchaState.MOVENDO) _estado_texto = "NAVEGANDO";
    else if (estado == LanchaState.PATRULHANDO) _estado_texto = "PATRULHANDO";
    else if (estado == LanchaState.ATACANDO) _estado_texto = "ATACANDO";
    
    draw_text(_text_x, _text_y, "Estado: " + _estado_texto);
    _text_y += 18;
    
    // Modo atual (CORRIGIDO para lancha)
    if (modo_combate == LanchaMode.ATAQUE) {
        draw_set_color(c_red);
        draw_text(_text_x, _text_y, "MODO ATAQUE");
    } else {
        draw_set_color(c_gray);
        draw_text(_text_x, _text_y, "MODO PASSIVO");
    }
    _text_y += 18;
    
    // Timer de recarga (CORRIGIDO para lancha)
    if (reload_timer > 0) {
        draw_set_color(make_color_rgb(255, 165, 0)); // Laranja
        draw_text(_text_x, _text_y, "Recarga: " + string(ceil(reload_timer / 60)) + "s");
    } else {
        draw_set_color(make_color_rgb(0, 255, 0)); // Verde limão
        draw_text(_text_x, _text_y, "Pronto para atacar");
    }
    
    // Reset alinhamento
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// === MENU DE CARGA (COMANDO J) ===
if (menu_carga_aberto && variable_instance_exists(id, "selecionado") && selecionado) {
    var _menu_x = 100;
    var _menu_y = 100;
    var _menu_w = 350;
    var _menu_h = 320;

    // Fundo do menu
    draw_set_alpha(0.95);
    draw_set_color(c_black);
    draw_rectangle(_menu_x, _menu_y, _menu_x + _menu_w, _menu_y + _menu_h, false);

    // Borda
    draw_set_alpha(1.0);
    draw_set_color(c_yellow);
    draw_rectangle(_menu_x, _menu_y, _menu_x + _menu_w, _menu_y + _menu_h, true);

    // Título
    draw_set_halign(fa_left);
    draw_set_color(c_yellow);
    draw_set_valign(fa_top);
    draw_text(_menu_x + 15, _menu_y + 15, "📦 CARGA DO PORTA-AVIÕES");

    var _line_y = _menu_y + 45;
    var _col1_x = _menu_x + 20;
    var _col2_x = _menu_x + 200;

    // ✈️ Aeronaves
    draw_set_color(c_white);
    draw_text(_col1_x, _line_y, "✈️ Aeronaves:");
    draw_set_color(make_color_rgb(0, 255, 255));
    draw_text(_col2_x, _line_y, string(avioes_count) + "/" + string(avioes_max));
    _line_y += 30;

    // 🚛 Veículos
    draw_set_color(c_white);
    draw_text(_col1_x, _line_y, "🚛 Veículos:");
    draw_set_color(make_color_rgb(0, 255, 255));
    draw_text(_col2_x, _line_y, string(unidades_count) + "/" + string(unidades_max));
    _line_y += 30;

    // 👥 Soldados
    draw_set_color(c_white);
    draw_text(_col1_x, _line_y, "👥 Soldados:");
    draw_set_color(make_color_rgb(0, 255, 255));
    draw_text(_col2_x, _line_y, string(soldados_count) + "/" + string(soldados_max));
    _line_y += 40;

    // Barra de carga
    var _percent = ((avioes_count + unidades_count + soldados_count) / (avioes_max + unidades_max + soldados_max)) * 100;
    draw_set_color(c_gray);
    draw_rectangle(_menu_x + 20, _line_y, _menu_x + _menu_w - 20, _line_y + 15, false);

    var _cor_barra = c_green;
    if (_percent > 75) _cor_barra = c_orange;
    if (_percent >= 100) _cor_barra = c_red;

    draw_set_color(_cor_barra);
    draw_rectangle(_menu_x + 20, _line_y, _menu_x + 20 + ((_menu_w - 40) * _percent / 100), _line_y + 15, false);

    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_text(_menu_x + _menu_w/2, _line_y + 2, string(round(_percent)) + "%");

    _line_y += 35;

    // Informação de capacidade total
    draw_set_halign(fa_center);
    draw_set_color(c_yellow);
    draw_text(_menu_x + _menu_w/2, _line_y, "Capacidade: 155 unidades");
    
    draw_set_alpha(1.0);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}