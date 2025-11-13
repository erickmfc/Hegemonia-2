// ✅ CORREÇÃO: Desenhar sprite explicitamente
if (sprite_index != -1) {
    draw_self();
} else {
    // Se não tem sprite, desenhar um retângulo branco como fallback
    draw_set_color(c_white);
    draw_rectangle(x - 20, y - 10, x + 20, y + 10, false);
}
