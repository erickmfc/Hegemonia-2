// ===============================================
// HEGEMONIA GLOBAL - FRAGATA DRAW EVENT
// Indicadores visuais e interface
// ===============================================

// Desenhar sombra (simples deslocamento preto com transparência)
draw_set_color(c_black);
draw_set_alpha(0.4);
draw_sprite_ext(sprite_index, image_index, x + 4, y + 4, image_xscale, image_yscale, image_angle, c_black, 0.4);

// Desenhar sprite base
draw_set_color(c_white);
draw_set_alpha(1.0);
draw_self();

// === INDICADORES DE SELEÇÃO ===
if (selecionado) {
    // Círculo de seleção (amarelo)
    draw_set_color(c_yellow);
    draw_set_alpha(0.3);
    draw_circle(x, y, raio_selecao, false);
    
    // Círculo de alcance de tiro (cinza)
    draw_set_color(c_gray);
    draw_set_alpha(0.2);
    draw_circle(x, y, alcance_tiro, false);
    
    // Cantoneiras de seleção (azul)
    draw_set_color(c_blue);
    draw_set_alpha(0.8);
    var _size = 15;
    draw_rectangle(x - _size, y - _size, x + _size, y + _size, false);
    
    draw_set_alpha(1);
}

// === INDICADOR DE MODO DE COMBATE ===
if (selecionado) {
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    
    if (modo_combate == "passivo") {
        draw_set_color(c_green);
        draw_text(x, y - 40, "PASSIVO");
    } else if (modo_combate == "atacando") {
        draw_set_color(c_red);
        draw_text(x, y - 40, "ATACANDO");
    }
}

// === INDICADOR DE PATRULHA ===
if (modo_definicao_patrulha && selecionado) {
    draw_set_color(c_yellow);
    draw_set_alpha(0.5);
    
    // Desenhar pontos de patrulha
    for (var i = 0; i < ds_list_size(pontos_patrulha); i++) {
        var _ponto = pontos_patrulha[| i];
        draw_circle(_ponto[0], _ponto[1], 8, false);
        
        // Conectar pontos com linha
        if (i > 0) {
            var _ponto_anterior = pontos_patrulha[| i-1];
            draw_line(_ponto_anterior[0], _ponto_anterior[1], _ponto[0], _ponto[1]);
        }
    }
    
    draw_set_alpha(1);
}

// === BARRA DE HP ===
if (hp_atual < hp_max) {
    var _barra_w = 40;
    var _barra_h = 4;
    var _hp_percent = hp_atual / hp_max;
    
    // Fundo da barra (vermelho)
    draw_set_color(c_red);
    draw_rectangle(x - _barra_w/2, y - 30, x + _barra_w/2, y - 30 + _barra_h, false);
    
    // Barra de HP (verde)
    draw_set_color(c_green);
    draw_rectangle(x - _barra_w/2, y - 30, x - _barra_w/2 + (_barra_w * _hp_percent), y - 30 + _barra_h, false);
}

// === INDICADOR DE MOVIMENTO ===
if (estado == "movendo" || movendo) {
    draw_set_color(c_blue);
    draw_set_alpha(0.6);
    draw_line(x, y, destino_x, destino_y);
    draw_circle(destino_x, destino_y, 10, false);
    draw_set_alpha(1);
}
