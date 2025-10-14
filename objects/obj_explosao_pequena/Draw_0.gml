// ================================================
// HEGEMONIA GLOBAL - EXPLOSÃO PEQUENA
// Draw Event - Efeito Visual Simples
// ================================================

// === DESENHAR O SPRITE BASE ===
draw_self();

// === EFEITOS ADICIONAIS ===
// Adicionar brilho se necessário
if (variable_instance_exists(id, "brilho")) {
    draw_set_color(c_yellow);
    draw_circle(x, y, 10, false);
    draw_set_color(c_white);
}
