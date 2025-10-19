/// @description Inserir descrição aqui
// Você pode escrever seu código neste editor
// ===============================================
// HEGEMONIA GLOBAL - CONSTELLATION (HERDA DE NAVIO_BASE)
// Draw Event - Indicadores específicos
// ===============================================

// Chamar o Draw do objeto pai (herda indicadores básicos)
event_inherited();

// === INDICADORES ESPECÍFICOS DO CONSTELLATION ===
if (selecionado) {
    // Círculo de seleção específico do Constellation
    draw_set_color(c_yellow);
    draw_set_alpha(0.3);
    draw_circle(x, y, 35, false);
    draw_set_alpha(1.0);
    
    // Indicador de nome específico
    draw_set_halign(fa_center);
    draw_set_color(c_yellow);
    draw_text_transformed(x, y - 100, "CONSTELLATION", 0.9, 0.9, 0);
}