/// @description Draw Event da Independence
// ===============================================
// HEGEMONIA GLOBAL - INDEPENDENCE (HERDA DE NAVIO_BASE)
// Draw Event - Indicadores específicos
// ===============================================

// Chamar o Draw do objeto pai (herda indicadores básicos)
event_inherited();

// === INDICADORES ESPECÍFICOS DA INDEPENDENCE ===
if (selecionado) {
    // Círculo de seleção específico da Independence
    draw_set_color(c_red);
    draw_set_alpha(0.3);
    draw_circle(x, y, 40, false);
    draw_set_alpha(1.0);
    
    // Indicador de nome específico
    draw_set_halign(fa_center);
    draw_set_color(c_red);
    draw_text_transformed(x, y - 120, "INDEPENDENCE", 1.0, 1.0, 0);
    
    // Indicador de metralhadora
    if (metralhadora_ativa) {
        draw_set_color(c_yellow);
        draw_text_transformed(x, y - 100, "METRALHANDO!", 0.8, 0.8, 0);
    }
}