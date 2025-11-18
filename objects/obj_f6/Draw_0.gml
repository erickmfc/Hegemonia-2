// ===============================================
// HEGEMONIA GLOBAL - CAÇA F-6 (ALVO DE TESTE)
// Draw Event - Visual diferenciado para identificação
// ===============================================

// =============================================
// DRAW - Otimizado com verificação de visibilidade
// =============================================

// ✅ OTIMIZAÇÃO: Verificar se deve desenhar
if (!scr_should_draw(id)) {
    if (instance_exists(obj_draw_optimizer)) {
        obj_draw_optimizer.objects_skipped++;
    }
    exit;
}

// ✅ CORREÇÃO: Efeito de altitude com sombra
// Quando pousado (altura_voo = 0), desenha em y (posição do mapa)
// Quando voando (altura_voo > 0), desenha em y - altura_voo (acima do chão)
var _draw_y = y - altura_voo; // ✅ Posição de desenho baseada na altitude
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_black, 0.4); // Sombra no chão
draw_sprite_ext(sprite_index, image_index, x, _draw_y, image_xscale, image_yscale, image_angle, image_blend, image_alpha); // Sprite na altitude correta

// --- FEEDBACK VISUAL (SE SELECIONADO) ---
if (selecionado) {
    // ✅ Usar _draw_y já calculado acima
    
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
    
    // ✅ CORREÇÃO: Definir fonte padrão antes de desenhar (evita fonte gigante)
    draw_set_font(-1);
    
    // Desenha o status acima do avião (com fundo escuro para legibilidade)
    var _status_x = x;
    var _status_y = _draw_y - 65;
    var _status_w = string_width(_status_text) + 20;
    var _status_h = 25;
    
    draw_set_color(c_black);
    draw_set_alpha(0.8);
    draw_rectangle(_status_x - _status_w/2, _status_y - _status_h/2, 
                    _status_x + _status_w/2, _status_y + _status_h/2, false);
    draw_set_alpha(1.0);
    
    // Borda do status
    draw_set_color(_status_color);
    draw_set_alpha(0.6);
    draw_rectangle(_status_x - _status_w/2, _status_y - _status_h/2, 
                    _status_x + _status_w/2, _status_y + _status_h/2, true);
    draw_set_alpha(1.0);
    
    // Desenhar status PRINCIPAL
    draw_set_color(_status_color);
    draw_text(_status_x, _status_y, _status_text);
    
    // Desenha informações de teste (menor)
    draw_set_color(c_red);
    draw_set_alpha(0.9);
    draw_text(x, _draw_y - 40, "F-6 ALVO DE TESTE");
    
    // Desenha HP (menor)
    draw_set_color(c_white);
    draw_set_alpha(0.9);
    draw_text(x, _draw_y - 25, "HP: " + string(hp_atual) + "/" + string(hp_max));
    
    // Desenha informações de patrulha (menor)
    if (estado == "patrulhando") {
        draw_text(x, _draw_y - 10, "Patrulha: " + string(indice_patrulha_atual + 1) + "/" + string(ds_list_size(pontos_patrulha)));
    }
    draw_set_alpha(1.0);

    draw_set_halign(fa_left);
}

// ======================================================================
// ✅ CORREÇÃO: Barra de vida removida - agora é desenhada pelo obj_game_manager centralizadamente
// Isso evita conflito e piscar das barras
// ======================================================================

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