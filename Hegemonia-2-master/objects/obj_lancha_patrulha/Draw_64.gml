/// @description Inserir descrição aqui
// Você pode escrever seu código neste editor
// =========================================================
// HEGEMONIA GLOBAL - LANCHA PATRULHA DRAW GUI EVENT
// v3.0 - Novo Painel de Status Detalhado
// =========================================================

if (selecionado) {
    // --- Configurações da Caixa de Status ---
    var _box_x = 15;
    var _box_y = display_get_gui_height() - 100; // Posição no canto inferior esquerdo
    var _line_height = 18; // Espaçamento entre linhas de texto

    // --- Preparação dos Textos Dinâmicos ---
    // Estado
    var _estado_texto = "PARADO";
    switch(estado) {
        case LanchaState.MOVENDO: _estado_texto = "MOVENDO"; break;
        case LanchaState.ATACANDO: _estado_texto = "ATACANDO"; break;
        case LanchaState.PATRULHANDO: _estado_texto = "PATRULHANDO"; break;
    }
    if (modo_definicao_patrulha) _estado_texto = "DEFININDO ROTA";

    // Modo de Combate
    var _modo_texto = (modo_combate == LanchaMode.ATAQUE) ? "ATAQUE" : "PASSIVO";
    var _modo_cor = (modo_combate == LanchaMode.ATAQUE) ? c_red : c_gray;

    // HP
    var _hp_texto = string(hp_atual) + "/" + string(hp_max);

    // Patrulha
    var _patrulha_texto = "";
    if (estado == LanchaState.PATRULHANDO && ds_list_size(pontos_patrulha) > 0) {
        var _ponto_atual = indice_patrulha_atual + 1;
        var _total_pontos = ds_list_size(pontos_patrulha);
        _patrulha_texto = "Patrulha: Ponto " + string(_ponto_atual) + "/" + string(_total_pontos);
    }

    // --- Desenho do Painel de Status ---
    // =================================================================
    // ✅ CORREÇÃO 1: Usar o nome exato do recurso da fonte: "hegemonia_main"
    // =================================================================
    draw_set_font(hegemonia_main);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    // Linha 1: Título
    var y_pos = _box_y;
    draw_set_color(c_white);
    draw_text(_box_x + 15, y_pos, "LANCHA PATRULHA");

    // Linha 2: Estado
    y_pos += _line_height;
    draw_text(_box_x + 15, y_pos, "Estado: " + _estado_texto);

    // Linha 3: Modo de Combate (com cor)
    y_pos += _line_height;
    draw_set_color(c_white);
    draw_text(_box_x + 15, y_pos, "Modo: ");
    var _text_width = string_width("Modo: ");
    draw_set_color(_modo_cor);
    draw_text(_box_x + 15 + _text_width, y_pos, _modo_texto);
    draw_set_color(c_white);

    // Linha 4: HP
    y_pos += _line_height;
    draw_text(_box_x + 15, y_pos, "HP: " + _hp_texto);

    // Linha 5: Patrulha (apenas se estiver patrulhando)
    if (_patrulha_texto != "") {
        y_pos += _line_height;
        draw_text(_box_x + 15, y_pos, _patrulha_texto);
    }

    // --- Desenho da Borda da Caixa ---
    var _box_width = 280;
    var _box_height = y_pos - _box_y + _line_height;
    draw_set_color(c_aqua);
    // =================================================================
    // ✅ CORREÇÃO 2: A função correta é "string_repeat"
    // =================================================================
    draw_text(_box_x, _box_y - 5, "┌" + string_repeat("─", 36) + "┐");
    draw_text(_box_x, y_pos + 5, "└" + string_repeat("─", 36) + "┘");
    for (var i = 0; i < (_box_height / _line_height) + 1; i++) {
        draw_text(_box_x, _box_y + (i * 15) - 3, "│");
        draw_text(_box_x + _box_width - 1, _box_y + (i * 15) - 3, "│");
    }
    
    // Resetar alinhamento e cor
    draw_set_halign(fa_left);
    draw_set_color(c_white);
}