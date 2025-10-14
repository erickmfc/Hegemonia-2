// ================================================
// HEGEMONIA GLOBAL - OBJETO: TIRO SIMPLES
// Draw Event - Visual do Projétil
// ================================================

// === DESENHAR O TIRO ===
draw_set_color(c_yellow);
draw_set_alpha(image_alpha);

// Desenhar círculo amarelo como tiro
draw_circle(x, y, 4, false);
draw_circle(x, y, 2, true);

// Desenhar borda
draw_set_color(c_orange);
draw_set_alpha(image_alpha * 0.7);
draw_circle(x, y, 4, true);

// Resetar configurações
draw_set_alpha(1);
draw_set_color(c_white);
/// @description Inserir descrição aqui
// Você pode escrever seu código neste editor
