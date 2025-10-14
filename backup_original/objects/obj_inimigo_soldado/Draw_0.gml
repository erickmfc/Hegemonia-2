// ================================================
// HEGEMONIA GLOBAL - OBJETO: INIMIGO SOLDADO
// Draw Event - Sistema Simples e Funcional
// ================================================

// === DESENHAR SPRITE ===
draw_self();

// === BARRA DE VIDA ===
var w = 40;
var h = 5;
var perc = max(0, vida) / 100;

// Background vermelho
draw_set_color(make_color_rgb(255, 0, 0));
draw_rectangle(x - w/2, y - 40, x + w/2, y - 40 + h, false);

// Vida verde
draw_set_color(make_color_rgb(0, 255, 0));
draw_rectangle(x - w/2, y - 40, x - w/2 + (w * perc), y - 40 + h, false);

// Reset da cor
draw_set_color(make_color_rgb(255, 255, 255));
