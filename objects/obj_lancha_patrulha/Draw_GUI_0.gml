// =========================================================
if (selecionado) {
    var _box_x = 15;
    var _box_y = display_get_gui_height() - 115;
    var _line_height = 18;

    // ESTADOS
    var _estado_texto = "PARADO";
    switch(estado) {
        case LanchaState.MOVENDO: _estado_texto = "MOVENDO"; break;
        case LanchaState.ATACANDO: _estado_texto = "ATACANDO"; break;
    }

    var _modo_texto = (modo_combate == LanchaMode.ATAQUE) ? "ATAQUE" : "PASSIVO";
    var _modo_cor = (modo_combate == LanchaMode.ATAQUE) ? c_red : c_gray;
    var _hp_texto = string(hp_atual) + "/" + string(hp_max);

    var _patrulha_texto = "";

    draw_set_font(fnt_ui_main);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    var y_pos = _box_y;
    draw_set_color(c_white);
    draw_text(_box_x + 15, y_pos, "LANCHA PATRULHA");
    y_pos += _line_height;
    draw_text(_box_x + 15, y_pos, "Estado: " + _estado_texto);
    y_pos += _line_height;

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
}