/// @description Draw Event do Canhão
// ===============================================
// HEGEMONIA GLOBAL - CANHÃO DA INDEPENDENCE
// Desenho do Canhão
// ===============================================

// Desenhar sprite do canhão
draw_self();

// === INDICADORES DE DEBUG ===
if (variable_global_exists("debug_enabled") && global.debug_enabled) {
    // Linha de mira
    if (variable_instance_exists(navio_pai, "alvo_unidade") && instance_exists(navio_pai.alvo_unidade)) {
        draw_set_color(c_red);
        draw_set_alpha(0.5);
        draw_line(x, y, navio_pai.alvo_unidade.x, navio_pai.alvo_unidade.y);
        draw_set_alpha(1.0);
    }
}