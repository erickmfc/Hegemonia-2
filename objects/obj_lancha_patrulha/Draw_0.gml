// ===============================================
// HEGEMONIA GLOBAL - LANCHA PATRULHA (Draw Adaptado)
// Sistema Visual Naval Completo
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

// Desenhar sombra (simples deslocamento preto com transparência)
draw_set_color(c_black);
draw_set_alpha(0.4);
draw_sprite_ext(sprite_index, image_index, x + 4, y + 4, image_xscale, image_yscale, image_angle, c_black, 0.4);

// Desenhar a Lancha oficial
draw_set_color(c_white);
draw_set_alpha(1.0);
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_white, 1);

// --- FEEDBACK VISUAL (SE SELECIONADO) ---
if (selecionado) {
    var _draw_y = y; // Sem altitude para lancha
    
    // Círculo de seleção
    draw_set_color(c_green);
    draw_set_alpha(0.3);
    draw_circle(x, _draw_y, 40, true);
    
    // Círculo do Radar
    draw_set_color(modo_combate == LanchaMode.ATAQUE ? c_red : c_gray);
    draw_set_alpha(0.2);
    draw_circle(x, _draw_y, radar_alcance, false);
    
    // Desenhar linha quando atacando
    if (estado == LanchaState.ATACANDO) {
        if (variable_instance_exists(id, "alvo_unidade") && instance_exists(alvo_unidade)) {
            draw_set_color(c_red);
            draw_set_alpha(0.7);
            draw_line(x, _draw_y, alvo_unidade.x, alvo_unidade.y);
        }
    }
    
    // LINHA VISUAL: Da lancha até o destino (igual aos outros navios)
    if (variable_instance_exists(id, "is_moving") && is_moving) {
        var _target_x = variable_instance_exists(id, "target_x") ? target_x : destino_x;
        var _target_y = variable_instance_exists(id, "target_y") ? target_y : destino_y;
        
        // Linha azul da lancha até o destino (estilo dos outros navios)
        draw_set_color(c_aqua);
        draw_set_alpha(0.6);
        draw_line(x, _draw_y, _target_x, _target_y);
        
        // Círculo no destino (marcador visual)
        draw_circle(_target_x, _target_y, 8, false);
        draw_circle(_target_x, _target_y, 4, true);
        
        draw_set_alpha(1);
    }
    
    // --- INFORMAÇÕES DE STATUS E CONTROLES ---
    draw_set_alpha(1.0);
    draw_set_halign(fa_center);
    
    var _status_text = "PARADO";
    if (estado == LanchaState.ATACANDO) _status_text = "ATACANDO";
    else if (estado == LanchaState.MOVENDO) _status_text = "MOVENDO";
    else if (estado == LanchaState.PATRULHANDO) _status_text = "PATRULHANDO";
    else if (estado == LanchaState.DEFININDO_PATRULHA) _status_text = "DEFININDO ROTA";
    
    var _status_color = c_gray;
    if (estado == LanchaState.ATACANDO) _status_color = c_red;
    else if (estado == LanchaState.MOVENDO) _status_color = c_aqua;
    else if (estado == LanchaState.PATRULHANDO) _status_color = c_orange;
    else if (estado == LanchaState.DEFININDO_PATRULHA) _status_color = c_yellow;
    
    // ✅ CORREÇÃO: Usar fonte padrão como no navio de transporte
    draw_set_font(-1);
    
    // Desenha o status acima da lancha (com fundo escuro para legibilidade)
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
    
    // Desenha os controles disponíveis (adaptados para lancha)
    draw_set_color(c_white);
    draw_set_alpha(0.9);
    draw_text(x, _draw_y - 35, "[K] Patrulha | [L] Parar");
    draw_text(x, _draw_y - 20, "[P] Passivo | [O] Ataque Agressivo");
    draw_set_alpha(1.0);

    draw_set_halign(fa_left);
}

// === DESENHAR ROTA DE PATRULHA (igual aos outros navios) ===
if (variable_instance_exists(id, "estado") && 
    (estado == LanchaState.PATRULHANDO || estado == LanchaState.DEFININDO_PATRULHA || 
     (variable_global_exists("definindo_patrulha_unidade") && global.definindo_patrulha_unidade == id))) {

    if (variable_instance_exists(id, "pontos_patrulha") && ds_exists(pontos_patrulha, ds_type_list) && ds_list_size(pontos_patrulha) > 0) {
        draw_set_color(c_blue); // Azul naval
        draw_set_alpha(0.8);
        
        // Desenha as linhas conectando os pontos
        for (var i = 0; i < ds_list_size(pontos_patrulha) - 1; i++) {
            var _p1 = pontos_patrulha[| i];
            var _p2 = pontos_patrulha[| i + 1];
            if (is_array(_p1) && is_array(_p2) && array_length(_p1) >= 2 && array_length(_p2) >= 2) {
                draw_line(_p1[0], _p1[1], _p2[0], _p2[1]);
            }
        }
        
        // Desenha círculos nos pontos de patrulha
        for (var i = 0; i < ds_list_size(pontos_patrulha); i++) {
            var _ponto = pontos_patrulha[| i];
            if (is_array(_ponto) && array_length(_ponto) >= 2) {
                if (variable_instance_exists(id, "indice_patrulha_atual") && i == indice_patrulha_atual) {
                    draw_set_color(c_yellow); // Ponto atual em amarelo
                    draw_circle(_ponto[0], _ponto[1], 8, true);
                } else {
                    draw_set_color(c_blue); // Outros pontos em azul naval
                    draw_circle(_ponto[0], _ponto[1], 5, true);
                }
            }
        }
        
        // Se estiver definindo a rota, desenha uma linha do último ponto até o mouse
        if (estado == LanchaState.DEFININDO_PATRULHA || 
            (variable_global_exists("definindo_patrulha_unidade") && global.definindo_patrulha_unidade == id)) {
            var _ultimo_ponto = pontos_patrulha[| ds_list_size(pontos_patrulha) - 1];
            if (is_array(_ultimo_ponto) && array_length(_ultimo_ponto) >= 2) {
                // Conversão de coordenadas do mouse para o mundo (com zoom)
                var _coords = scr_mouse_to_world();
                var _mouse_world_x = _coords[0];
                var _mouse_world_y = _coords[1];
                draw_set_color(c_lime);
                draw_set_alpha(0.8);
                draw_line(_ultimo_ponto[0], _ultimo_ponto[1], _mouse_world_x, _mouse_world_y);
            }
        }
        // Se já estiver patrulhando, fecha o loop visual
        else if (estado == LanchaState.PATRULHANDO && ds_list_size(pontos_patrulha) > 1) {
            var _ultimo_ponto = pontos_patrulha[| ds_list_size(pontos_patrulha) - 1];
            var _primeiro_ponto = pontos_patrulha[| 0];
            if (is_array(_ultimo_ponto) && is_array(_primeiro_ponto) && 
                array_length(_ultimo_ponto) >= 2 && array_length(_primeiro_ponto) >= 2) {
                draw_line(_ultimo_ponto[0], _ultimo_ponto[1], _primeiro_ponto[0], _primeiro_ponto[1]);
            }
        }
        
        draw_set_alpha(1.0);
    }
}
