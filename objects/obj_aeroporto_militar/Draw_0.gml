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

// === BARRA DE VIDA ===
// ✅ CORREÇÃO: Sempre mostrar barra de vida do aeroporto
if (variable_instance_exists(id, "hp_atual") && variable_instance_exists(id, "hp_max")) {
    var _barra_w = 80;
    var _barra_h = 8;
    var _barra_x = x - _barra_w / 2;
    var _barra_y = y - sprite_height / 2 - 20;
    var _porcentagem = hp_atual / hp_max;
    var _barra_largura_preenchida = _barra_w * _porcentagem;
    
    // Fundo preto
    draw_set_color(c_black);
    draw_set_alpha(0.7);
    draw_rectangle(_barra_x, _barra_y, _barra_x + _barra_w, _barra_y + _barra_h, false);
    
    // Cor baseada em vida
    if (_porcentagem > 0.5) {
        draw_set_color(c_lime);
    } else if (_porcentagem > 0.25) {
        draw_set_color(c_yellow);
    } else {
        draw_set_color(c_red);
    }
    
    draw_set_alpha(1.0);
    draw_rectangle(_barra_x, _barra_y, _barra_x + _barra_largura_preenchida, _barra_y + _barra_h, false);
    
    // Borda branca
    draw_set_color(c_white);
    draw_rectangle(_barra_x, _barra_y, _barra_x + _barra_w, _barra_y + _barra_h, true);
    
    // Reset
    draw_set_color(c_white);
    draw_set_alpha(1.0);
}