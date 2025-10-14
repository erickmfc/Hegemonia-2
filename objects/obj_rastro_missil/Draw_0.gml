// ================================================
// HEGEMONIA GLOBAL - RASTRO DE MÍSSIL
// Draw Event - Efeito Visual Simples
// ================================================

// === DESENHAR O SPRITE BASE ===
draw_self();

// === EFEITOS ADICIONAIS ===
// Adicionar fumaça se necessário
if (variable_instance_exists(id, "fumaca")) {
    draw_set_color(c_gray);
    draw_circle(x, y, 5, false);
    draw_set_color(c_white);
}
