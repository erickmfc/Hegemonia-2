/// @description Inserir descrição aqui
// Você pode escrever seu código neste editor
// =========================================================
if (selecionado) {
    show_debug_message("🚢 Constellation GUI - Desenhando interface!");
    var _box_x = 15;
    var _box_y = display_get_gui_height() - 115;
    var _line_height = 18;

    // ESTADOS
    var _estado_texto = "PARADO";
    switch(estado) {
        case ConstellationState.MOVENDO: _estado_texto = "MOVENDO"; break;
        case ConstellationState.ATACANDO: _estado_texto = "ATACANDO"; break;
        case ConstellationState.PATRULHANDO: _estado_texto = "PATRULHANDO"; break;
        case ConstellationState.DEFININDO_PATRULHA: _estado_texto = "DEFININDO ROTA"; break;
    }

    var _modo_texto = (modo_combate == ConstellationMode.ATAQUE) ? "ATAQUE" : "PASSIVO";
    var _modo_cor = (modo_combate == ConstellationMode.ATAQUE) ? c_red : c_gray;
    var _hp_texto = string(hp_atual) + "/" + string(hp_max);

    var _patrulha_texto = "";
    if (estado == ConstellationState.PATRULHANDO && ds_list_size(pontos_patrulha) > 0) {
        var _ponto_atual = indice_patrulha_atual + 1;
        var _total_pontos = ds_list_size(pontos_patrulha);
        _patrulha_texto = "Patrulha: Ponto " + string(_ponto_atual) + "/" + string(_total_pontos);
    }

    draw_set_font(fnt_ui_main);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    var y_pos = _box_y;
    draw_set_color(c_white);
    draw_text(_box_x + 15, y_pos, "CONSTELLATION");
    y_pos += _line_height;
    draw_text(_box_x + 15, y_pos, "Estado: " + _estado_texto);
    y_pos += _line_height;
    show_debug_message("🚢 GUI: Estado desenhado: " + _estado_texto);

    draw_text(_box_x + 15, y_pos, "Modo: ");
    var _text_width = string_width("Modo: ");
    draw_set_color(_modo_cor);
    draw_text(_box_x + 15 + _text_width, y_pos, _modo_texto);
    draw_set_color(c_white);
    y_pos += _line_height;

    draw_text(_box_x + 15, y_pos, "HP: " + _hp_texto);
    if (_patrulha_texto != "") {
        y_pos += _line_height;
        draw_text(_box_x + 15, y_pos, _patrulha_texto);
    }
    show_debug_message("🚢 GUI: HP desenhado: " + _hp_texto);

    draw_set_color(c_aqua);
    draw_text(_box_x, _box_y - 5, "┌" + string_repeat("─", 36) + "┐");
    draw_text(_box_x, y_pos + 5, "└" + string_repeat("─", 36) + "┘");
    var line_count = (y_pos - _box_y + _line_height) / 15;
    for (var i = 0; i < line_count; i++) {
        draw_text(_box_x, _box_y + (i * 15) - 3, "│");
        draw_text(_box_x + 280, _box_y + (i * 15) - 3, "│");
    }

    draw_set_halign(fa_left);
    draw_set_color(c_white);
    show_debug_message("🚢 GUI: Interface completa desenhada!");
}