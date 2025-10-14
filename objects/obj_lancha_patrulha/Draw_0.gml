/// @description Renderização da Lancha Patrulha

// Desenha a sprite da lancha
if (sprite_index != -1) {
    draw_self();
} else {
    // Desenho simples caso não haja sprite
    draw_set_color(c_aqua);
    draw_circle(x, y, 12, false);
    draw_set_color(c_white);
}

// Círculo de seleção (sempre visível quando selecionada)
if (selecionado) {
    draw_set_color(c_lime);
    draw_set_alpha(0.3);
    draw_circle(x, y, 25, false);
    draw_set_alpha(0.8);
    draw_circle(x, y, 25, true);
    draw_set_alpha(1.0);
    
    // Linha para o destino quando movendo
    if (estado == LanchaState.MOVENDO) {
        draw_set_color(c_yellow);
        draw_set_alpha(0.8);
        draw_line_width(x, y, alvo_x, alvo_y, 2);
        draw_circle(alvo_x, alvo_y, 8, false);
        draw_set_alpha(1.0);
    }
    
    // Linha de ataque
    if (estado == LanchaState.ATACANDO && instance_exists(alvo_unidade)) {
        draw_set_color(c_red);
        draw_set_alpha(0.8);
        draw_line_width(x, y, alvo_unidade.x, alvo_unidade.y, 2);
        draw_circle(alvo_unidade.x, alvo_unidade.y, 10, true);
        draw_set_alpha(1.0);
    }
}

// Visualização do modo de definição de patrulha
if (selecionado && modo_definicao_patrulha && ds_list_size(pontos_patrulha) > 0) {
    draw_set_color(c_yellow);
    draw_set_alpha(0.9);
    
    for (var i = 0; i < ds_list_size(pontos_patrulha); i++) {
        var ponto = pontos_patrulha[| i];
        draw_circle(ponto[0], ponto[1], 8, false);
        
        // Número do ponto
        draw_set_color(c_white);
        draw_text(ponto[0] + 12, ponto[1] - 5, string(i + 1));
        draw_set_color(c_yellow);
        
        // Linha para o próximo ponto
        if (i < ds_list_size(pontos_patrulha) - 1) {
            var proximo = pontos_patrulha[| i + 1];
            draw_line_width(ponto[0], ponto[1], proximo[0], proximo[1], 2);
        }
    }
    
    // Linha do último ponto até o mouse
    if (ds_list_size(pontos_patrulha) > 0) {
        var ultimo = pontos_patrulha[| ds_list_size(pontos_patrulha) - 1];
        var _coords = scr_mouse_to_world();
        draw_set_alpha(0.5);
        draw_line_width(ultimo[0], ultimo[1], _coords[0], _coords[1], 2);
    }
    
    draw_set_alpha(1.0);
}

// Rota de patrulha ativa
if (estado == LanchaState.PATRULHANDO && ds_list_size(pontos_patrulha) > 1) {
    draw_set_color(c_aqua);
    draw_set_alpha(0.6);
    
    for (var i = 0; i < ds_list_size(pontos_patrulha); i++) {
        var p1 = pontos_patrulha[| i];
        var p2 = pontos_patrulha[| (i + 1) % ds_list_size(pontos_patrulha)];
        draw_line_width(p1[0], p1[1], p2[0], p2[1], 2);
        draw_circle(p1[0], p1[1], 6, false);
    }
    
    // Destaca ponto atual
    var atual = pontos_patrulha[| indice_patrulha_atual];
    draw_set_color(c_yellow);
    draw_set_alpha(1);
    draw_circle(atual[0], atual[1], 10, false);
    
    // Linha da lancha até o ponto atual
    draw_set_color(c_lime);
    draw_line_width(x, y, atual[0], atual[1], 2);
}

// Círculo de radar
if (selecionado) {
    if (modo_combate == LanchaMode.ATAQUE) {
        draw_set_color(c_red);
        draw_set_alpha(0.1);
        draw_circle(x, y, radar_alcance, false);
        draw_set_alpha(0.3);
        draw_circle(x, y, radar_alcance, true);
    } else {
        draw_set_color(c_gray);
        draw_set_alpha(0.05);
        draw_circle(x, y, radar_alcance, false);
        draw_set_alpha(0.2);
        draw_circle(x, y, radar_alcance, true);
    }
}

// ✅ SISTEMA DE STATUS VISUAL AVANÇADO (Adaptado do Avião)
if (selecionado) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    
    // Determina status e cor
    var _status_text = "PARADA";
    var _status_color = c_gray;

    if (estado == LanchaState.ATACANDO) {
        _status_text = "ATACANDO";
        _status_color = c_red;
    } else if (estado == LanchaState.PATRULHANDO) {
        _status_text = "PATRULHANDO";
        _status_color = c_aqua;
    } else if (modo_definicao_patrulha) {
        _status_text = "DEFININDO ROTA";
        _status_color = c_lime;
    } else if (estado == LanchaState.MOVENDO) {
        _status_text = "NAVEGANDO";
        _status_color = c_yellow;
    }

    // Desenha o status principal acima da lancha
    draw_set_color(_status_color);
    draw_text(x, y - 60, _status_text);
    
    // Desenha modo de combate
    var _modo_text = (modo_combate == LanchaMode.ATAQUE) ? "MODO ATAQUE" : "MODO PASSIVO";
    var _modo_color = (modo_combate == LanchaMode.ATAQUE) ? c_red : c_lime;
    draw_set_color(_modo_color);
    draw_text(x, y - 45, _modo_text);
    
    // Desenha os controles disponíveis
    draw_set_color(c_white);
    draw_text(x, y - 30, "[K] Patrulha | [L] Parar");
    draw_text(x, y - 15, "[P] Passivo | [O] Ataque");
    
    // Informações adicionais se em patrulha
    if (estado == LanchaState.PATRULHANDO && ds_list_size(pontos_patrulha) > 0) {
        draw_set_color(c_aqua);
        draw_text(x, y + 5, "Ponto " + string(indice_patrulha_atual + 1) + "/" + string(ds_list_size(pontos_patrulha)));
    }
    
    // Timer de recarga se aplicável
    if (reload_timer > 0) {
        draw_set_color(c_orange);
        draw_text(x, y + 20, "Recarga: " + string(ceil(reload_timer / 60)) + "s");
    } else if (modo_combate == LanchaMode.ATAQUE) {
        draw_set_color(c_lime);
        draw_text(x, y + 20, "Arma Pronta");
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// Restaura configurações
draw_set_color(c_white);
draw_set_alpha(1.0);