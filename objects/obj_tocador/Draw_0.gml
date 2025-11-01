/// @description Desenhar ícone do estado da música
// Desenhar ícone diferente se está tocando ou pausado
if (musica_tocando) {
    // Desenhar ícone de som 🔊
    draw_set_color(c_green);
    draw_text(x, y, "🔊");
} else {
    // Desenhar ícone mudo 🔇
    draw_set_color(c_red);
    draw_text(x, y, "🔇");
}

// Desenhar sprite do objeto (se tiver)
draw_self();
