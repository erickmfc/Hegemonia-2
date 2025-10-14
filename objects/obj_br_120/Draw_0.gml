draw_self();

// Seleção simples
if (selecionado) {
    draw_set_alpha(0.08);
    draw_set_color(c_aqua);
    draw_circle(x, y, 24, false);
    draw_set_alpha(1);
}
