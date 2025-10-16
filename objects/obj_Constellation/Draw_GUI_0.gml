// ===============================================
// HEGEMONIA GLOBAL - CONSTELLATION FUNCIONAL
// Interface GUI Completa
// ===============================================

// === SÓ DESENHA SE SELECIONADO ===
if (selecionado) {
    var _box_x = 20;
    var _box_y = display_get_gui_height() - 150;
    
    // Fundo da interface
    draw_set_color(c_black);
    draw_set_alpha(0.8);
    draw_rectangle(_box_x, _box_y, _box_x + 300, _box_y + 130, false);
    
    // Borda da interface
    draw_set_color(c_blue);
    draw_set_alpha(1.0);
    draw_rectangle(_box_x, _box_y, _box_x + 300, _box_y + 130, true);
    
    // Texto da interface
    draw_set_alpha(1.0);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    
    draw_text(_box_x + 10, _box_y + 10, "CONSTELLATION - NAVIO DE GUERRA");
    draw_text(_box_x + 10, _box_y + 30, "HP: " + string(hp_atual) + "/" + string(hp_max));
    draw_text(_box_x + 10, _box_y + 50, "Estado: " + string_upper(estado));
    draw_text(_box_x + 10, _box_y + 70, "Posição: (" + string(round(x)) + ", " + string(round(y)) + ")");
    
    if (estado == "movendo") {
        draw_text(_box_x + 10, _box_y + 90, "Destino: (" + string(round(destino_x)) + ", " + string(round(destino_y)) + ")");
    }
    
    if (estado == "atacando" && instance_exists(alvo_unidade)) {
        draw_text(_box_x + 10, _box_y + 90, "Atacando: " + string(alvo_unidade));
    }
    
    // Controles
    draw_text(_box_x + 10, _box_y + 110, "Controles: [S] Parar | [A] Atacar | Clique Direito: Mover");
}