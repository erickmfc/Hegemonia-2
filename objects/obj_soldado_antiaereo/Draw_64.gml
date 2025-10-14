// ==========================================
// HEGEMONIA GLOBAL - INFANTARIA
// Draw Event - Sistema Simplificado
// ==========================================

// === DESENHAR UNIDADE ===
draw_set_color(c_blue);
draw_set_alpha(0.9);

// Desenhar círculo principal da unidade
draw_circle(x, y, raio_selecao, false);

// Desenhar borda mais escura
draw_set_color(c_black);
draw_set_alpha(0.7);
draw_circle(x, y, raio_selecao, true);

// === DESENHAR INDICADOR DE SELEÇÃO ===
if (selecionado) {
    draw_set_color(c_white);
    draw_set_alpha(0.9);
    draw_circle(x, y, raio_selecao + 8, false);
    draw_circle(x, y, raio_selecao + 8, true);
}

// === DESENHAR DESTINO DE MOVIMENTO ===
if (movendo) {
    // Linha para o destino
    draw_set_color(c_green);
    draw_set_alpha(0.6);
    draw_line_width(x, y, destino_x, destino_y, 2);
    
    // Círculo no destino
    draw_set_color(c_green);
    draw_set_alpha(0.8);
    draw_circle(destino_x, destino_y, 15, false);
}

// === RESETAR CONFIGURAÇÕES ===
draw_set_color(c_white);
draw_set_alpha(1.0);
