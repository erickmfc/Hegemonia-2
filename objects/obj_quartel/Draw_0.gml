/// @description Draw do quartel com indicador visual de nação
// Desenhar sprite normal
draw_self();

// ✅ Indicador visual de nação
if (variable_instance_exists(id, "nacao_proprietaria")) {
    if (nacao_proprietaria == 2) {
        // IA - cor vermelha (borda)
        draw_set_color(c_red);
        draw_set_alpha(0.6);
        draw_rectangle(x - sprite_width/2 - 2, y - sprite_height/2 - 2, 
                      x + sprite_width/2 + 2, y + sprite_height/2 + 2, false);
    } else {
        // Jogador - cor verde (borda)
        draw_set_color(c_lime);
        draw_set_alpha(0.6);
        draw_rectangle(x - sprite_width/2 - 2, y - sprite_height/2 - 2, 
                      x + sprite_width/2 + 2, y + sprite_height/2 + 2, false);
    }
    // Reset
    draw_set_color(c_white);
    draw_set_alpha(1.0);
}
