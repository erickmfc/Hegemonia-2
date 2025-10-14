// ================================================
// HEGEMONIA GLOBAL - OBJETO: INIMIGO
// Draw Event - Sistema Simples e Funcional
// ================================================

// === DESENHAR O SPRITE BASE ===
draw_self();

// === BARRA DE VIDA SIMPLES ===
var w = 40;
var h = 5;
var vida_maxima = 500; // Vida máxima do inimigo
var perc = max(0, vida) / vida_maxima;

// Background da barra (vermelho)
draw_set_color(make_color_rgb(255, 0, 0));
draw_rectangle(x - w/2, y - 40, x + w/2, y - 40 + h, false);

// Vida restante (verde)
draw_set_color(make_color_rgb(0, 255, 0));
draw_rectangle(x - w/2, y - 40, x - w/2 + (w * perc), y - 40 + h, false);

// Reset da cor
draw_set_color(make_color_rgb(255, 255, 255));
