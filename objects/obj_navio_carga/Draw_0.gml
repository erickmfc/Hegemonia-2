// ===============================================
// HEGEMONIA GLOBAL - NAVIO DE CARGA (Draw)
// ===============================================

// Desenhar navio
draw_self();

// Indicador de nação (jogador = azul)
if (variable_instance_exists(id, "nacao_proprietaria")) {
    if (nacao_proprietaria == 1) {
        draw_set_color(c_cyan);  // Ciano para navios do jogador
        draw_set_alpha(0.3);
        draw_rectangle(x - sprite_width/2 - 2, y - sprite_height/2 - 2, 
                      x + sprite_width/2 + 2, y + sprite_height/2 + 2, false);
    }
    draw_set_color(c_white);
    draw_set_alpha(1.0);
}

// === INDICADOR DE CARGA ===
if (carga_atual > 0) {
    var _carga_percent = carga_atual / carga_maxima;
    
    // Fundo
    draw_set_color(c_black);
    draw_set_alpha(0.7);
    draw_rectangle(x - 20, y - 35, x + 20, y - 30, false);
    
    // Barra de carga (amarelo)
    draw_set_color(c_yellow);
    draw_rectangle(x - 20, y - 35, x - 20 + (40 * _carga_percent), y - 30, false);
    
    // Reset
    draw_set_color(c_white);
    draw_set_alpha(1.0);
}
