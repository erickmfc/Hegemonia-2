// ===============================================
// HEGEMONIA GLOBAL - CAÇA F-6 (ALVO DE TESTE)
// Draw Event - Visual diferenciado para identificação
// ===============================================

// Efeito de altitude com sombra
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_black, 0.4);
draw_sprite_ext(sprite_index, image_index, x, y - altura_voo, image_xscale, image_yscale, image_angle, image_blend, image_alpha);

// --- FEEDBACK VISUAL (SE SELECIONADO) ---
if (selecionado) {
    var _draw_y = y - altura_voo;
    
    // Círculo de seleção (vermelho para inimigo)
    draw_set_color(c_red);
    draw_set_alpha(0.3);
    draw_circle(x, _draw_y, 40, true);
    
    // Círculo do Radar
    draw_set_color(c_red);
    draw_set_alpha(0.2);
    draw_circle(x, _draw_y, radar_alcance, false);
    
    // Linha para o destino
    if (velocidade_atual > 0) {
        draw_set_color(c_orange); // Laranja para F-6
        draw_set_alpha(0.6);
        draw_line(x, _draw_y, destino_x, destino_y);
    }
    
    // --- INFORMAÇÕES DE STATUS E CONTROLES ---
    draw_set_alpha(1.0);
    draw_set_halign(fa_center);
    
    var _status_text = "POUSADO";
    if (estado == "atacando") _status_text = "ATACANDO";
    else if (estado == "patrulhando") _status_text = "PATRULHANDO";
    else if (estado == "definindo_patrulha") _status_text = "DEFININDO ROTA";
    else if (estado == "pousando") _status_text = "POUSANDO";
    else if (estado == "movendo") _status_text = "VOANDO";
    else if (estado == "decolando") _status_text = "DECOLANDO";
    
    var _status_color = c_gray;
    if (estado == "atacando") _status_color = c_red;
    else if (estado == "patrulhando") _status_color = c_orange;
    else if (estado == "definindo_patrulha") _status_color = c_lime;
    else if (estado == "pousando") _status_color = c_yellow;
    else if (estado == "movendo") _status_color = c_aqua;
    else if (estado == "decolando") _status_color = c_blue;
    
    // Desenha o status acima do avião
    draw_set_color(_status_color);
    draw_text(x, _draw_y - 60, _status_text);
    
    // Desenha informações de teste
    draw_set_color(c_red);
    draw_text(x, _draw_y - 75, "F-6 ALVO DE TESTE");
    
    // Desenha HP
    draw_set_color(c_white);
    draw_text(x, _draw_y - 45, "HP: " + string(hp_atual) + "/" + string(hp_max));
    
    // Desenha informações de patrulha
    if (estado == "patrulhando") {
        draw_text(x, _draw_y - 30, "Patrulha: " + string(indice_patrulha_atual + 1) + "/" + string(ds_list_size(pontos_patrulha)));
    }

    draw_set_halign(fa_left);
}

// ======================================================================
// ✅ DESENHAR A ROTA DE PATRULHA (SEMPRE VISÍVEL PARA TESTE)
// ======================================================================
if (estado == "patrulhando" && ds_list_size(pontos_patrulha) > 0) {
    draw_set_color(c_orange); // Laranja para F-6
    draw_set_alpha(0.6);
    
    // Desenha as linhas conectando os pontos
    for (var i = 0; i < ds_list_size(pontos_patrulha) - 1; i++) {
        var _p1 = pontos_patrulha[| i];
        var _p2 = pontos_patrulha[| i + 1];
        draw_line(_p1[0], _p1[1], _p2[0], _p2[1]);
    }
    
    // Desenha círculos nos pontos de patrulha
    for (var i = 0; i < ds_list_size(pontos_patrulha); i++) {
        var _ponto = pontos_patrulha[| i];
        if (i == indice_patrulha_atual) {
            draw_set_color(c_yellow); // Ponto atual em amarelo
            draw_circle(_ponto[0], _ponto[1], 8, true);
        } else {
            draw_set_color(c_orange); // Outros pontos em laranja
            draw_circle(_ponto[0], _ponto[1], 5, true);
        }
    }
    
    // Fecha o loop visual
    if (ds_list_size(pontos_patrulha) > 1) {
        var _ultimo_ponto = pontos_patrulha[| ds_list_size(pontos_patrulha) - 1];
        var _primeiro_ponto = pontos_patrulha[| 0];
        draw_line(_ultimo_ponto[0], _ultimo_ponto[1], _primeiro_ponto[0], _primeiro_ponto[1]);
    }
    
    draw_set_alpha(1.0);
}
// ======================================================================