/// @description Interface GUI da Lancha Patrulha

if (selecionado) {
    var pad = 8;
    var w = 220;
    var h = 80;
    var gx = 20;
    var gy = display_get_gui_height() - h - 20;

    // Desenhar borda estilo caixa com caracteres ASCII
    var linha_sup = "┌" + string_repeat("─", w div 8) + "┐";
    var linha_inf = "└" + string_repeat("─", w div 8) + "┘";
    draw_text(gx, gy, linha_sup);
    draw_text(gx, gy + h - 16, linha_inf);

    // Conteúdo
    var status_text = string_format("HP: %d/%d", hp_atual, hp_max);
    draw_text(gx + pad, gy + 16, status_text);

    var modo_txt = (modo_combate == LanchaMode.ATAQUE) ? "ATAQUE" : "PASSIVO";
    if (modo_combate == LanchaMode.ATAQUE) {
        // desenhar ATAQUE em vermelho
        draw_set_color(c_red);
        draw_text(gx + pad, gy + 32, modo_txt);
        draw_set_color(c_white);
    } else {
        draw_text(gx + pad, gy + 32, modo_txt);
    }

    // Informações de patrulha
    if (ds_list_size(pontos_patrulha) > 0) {
        var total = ds_list_size(pontos_patrulha);
        var atual = (estado == LanchaState.PATRULHANDO) ? indice_patrulha_atual + 1 : 0;
        var patr_text = (estado == LanchaState.PATRULHANDO) ? string_format("Patrulha: Ponto %d/%d", atual, total) : "Patrulha: -";
        draw_text(gx + pad, gy + 48, patr_text);
    } else {
        draw_text(gx + pad, gy + 48, "Patrulha: -");
    }
}
