// ===============================================
// HEGEMONIA GLOBAL - AEROPORTO MILITAR
// Evento Draw - Renderização Visual
// ===============================================

// Desenhar o aeroporto
draw_self();

// Desenhar círculo de interação se selecionado
if (selecionado) {
    draw_set_color(make_color_rgb(100, 150, 255));
    draw_set_alpha(0.3);
    draw_circle(x, y, raio_interacao, false);
    draw_set_alpha(1.0);
}

// Desenhar indicador de produção se estiver produzindo
if (produzindo && !ds_queue_empty(fila_producao)) {
    draw_set_color(make_color_rgb(255, 255, 0));
    draw_set_alpha(0.8);
    draw_circle(x, y - 30, 8, false);
    draw_set_alpha(1.0);
    
    // Texto de status
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(255, 255, 255));
    draw_text(x, y - 50, "PRODUZINDO");
}