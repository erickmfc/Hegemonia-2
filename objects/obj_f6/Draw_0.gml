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
// ✅ SISTEMA DE EXIBIÇÃO DE VIDA
// ======================================================================
// Desenhar barra de vida do F-6
if (hp_atual > 0) {
    var _barra_w = 60;  // Largura da barra
    var _barra_h = 8;   // Altura da barra
    var _barra_x = x - _barra_w/2;  // Centralizada no avião
    var _barra_y = y - 25;  // Acima do avião
    
    // Fundo da barra (vermelho)
    draw_set_color(c_red);
    draw_set_alpha(0.7);
    draw_rectangle(_barra_x, _barra_y, _barra_x + _barra_w, _barra_y + _barra_h, false);
    
    // Barra de vida atual (verde)
    var _vida_percentual = hp_atual / hp_max;
    var _vida_w = _barra_w * _vida_percentual;
    
    draw_set_color(c_green);
    draw_set_alpha(0.8);
    draw_rectangle(_barra_x, _barra_y, _barra_x + _vida_w, _barra_y + _barra_h, false);
    
    // Borda da barra (branco)
    draw_set_color(c_white);
    draw_set_alpha(1.0);
    draw_rectangle(_barra_x, _barra_y, _barra_x + _barra_w, _barra_y + _barra_h, true);
    
    // Texto com HP atual/máximo
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text(_barra_x + _barra_w/2, _barra_y - 12, string(hp_atual) + "/" + string(hp_max));
    
    // Indicador de estado
    var _estado_texto = "";
    var _cor_estado = c_white;
    
    switch (estado) {
        case "pousado": _estado_texto = "POUSADO"; _cor_estado = c_gray; break;
        case "decolando": _estado_texto = "DECOLANDO"; _cor_estado = c_yellow; break;
        case "patrulhando": _estado_texto = "PATRULHANDO"; _cor_estado = c_blue; break;
        case "caçando": _estado_texto = "CAÇANDO!"; _cor_estado = c_red; break;
        case "movendo": _estado_texto = "MOVENDO"; _cor_estado = c_lime; break;
        case "pousando": _estado_texto = "POUSANDO"; _cor_estado = c_orange; break;
        default: _estado_texto = estado; _cor_estado = c_white; break;
    }
    
    draw_set_color(_cor_estado);
    draw_text(_barra_x + _barra_w/2, _barra_y - 25, _estado_texto);
    
    // Resetar configurações
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1.0);
}

// ======================================================================
// ✅ DESENHAR A ROTA DE PATRULHA (SEMPRE VISÍVEL PARA TESTE)
// ======================================================================
// DESENHO DA ÁREA DE PATRULHA RETANGULAR
if (estado == "patrulhando" && patrulha_ativa) {
    // Desenhar área retangular de patrulha
    draw_set_color(c_orange); // Laranja para F-6
    draw_set_alpha(0.3);
    
    // Desenhar retângulo da área de patrulha
    draw_rectangle(patrulha_x_min, patrulha_y_min, patrulha_x_max, patrulha_y_max, false);
    
    // Desenhar bordas mais visíveis
    draw_set_alpha(0.6);
    draw_set_color(c_red);
    draw_rectangle(patrulha_x_min, patrulha_y_min, patrulha_x_max, patrulha_y_max, true);
    
    // Desenhar pontos de patrulha se existirem
    if (ds_list_size(pontos_patrulha) > 0) {
        draw_set_color(c_orange);
        draw_set_alpha(0.8);
        
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
    }
    
    draw_set_alpha(1.0);
}
// ======================================================================