/// @description Draw do quartel com indicador visual de nação e barra de vida
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

// === BARRA DE VIDA ===
// ✅ CORREÇÃO: Sempre mostrar barra de vida dos quarteis
if (true) {  // Sempre mostrar
    var _barra_x = x - barra_vida_largura / 2;
    var _barra_y = y - sprite_height / 2 - 20;
    var _porcentagem = hp_atual / hp_max;
    var _barra_largura_preenchida = barra_vida_largura * _porcentagem;
    
    // Fundo preto da barra
    draw_set_color(c_black);
    draw_set_alpha(0.7);
    draw_rectangle(_barra_x, _barra_y, _barra_x + barra_vida_largura, _barra_y + barra_vida_altura, false);
    
    // Cor da barra baseada na vida
    if (_porcentagem > 0.5) {
        draw_set_color(c_lime); // Verde se > 50%
    } else if (_porcentagem > 0.25) {
        draw_set_color(c_yellow); // Amarelo se > 25%
    } else {
        draw_set_color(c_red); // Vermelho se <= 25%
    }
    
    draw_set_alpha(1.0);
    draw_rectangle(_barra_x, _barra_y, _barra_x + _barra_largura_preenchida, _barra_y + barra_vida_altura, false);
    
    // Borda da barra
    draw_set_color(c_white);
    draw_rectangle(_barra_x, _barra_y, _barra_x + barra_vida_largura, _barra_y + barra_vida_altura, true);
    
    // Reset
    draw_set_color(c_white);
    draw_set_alpha(1.0);
}
