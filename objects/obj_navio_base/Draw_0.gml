// ===============================================
// HEGEMONIA GLOBAL - NAVIO BASE
// Draw Event - Otimizado
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

// Desenhar sprite do navio
draw_self();

// Indicadores visuais se selecionado (herdado pelos filhos)
if (variable_instance_exists(id, "selecionado") && selecionado) {
    // Círculo de seleção básico
    draw_set_color(c_yellow);
    draw_set_alpha(0.3);
    draw_circle(x, y, 50, true);
    draw_set_alpha(1.0);
    
    // ✅ LINHA VISUAL: Do navio até o destino (quando movendo)
    // ✅ CORREÇÃO: Verificar estado diretamente (mais confiável que is_moving)
    var _esta_movendo = false;
    if (variable_instance_exists(id, "estado")) {
        // Verificar estado diretamente (mais confiável)
        _esta_movendo = (estado == LanchaState.MOVENDO);
        // Também verificar is_moving se existir (para compatibilidade)
        if (variable_instance_exists(id, "is_moving")) {
            _esta_movendo = _esta_movendo || is_moving;
        }
    } else if (variable_instance_exists(id, "is_moving")) {
        // Fallback: usar is_moving se estado não existir
        _esta_movendo = is_moving;
    }
    
    if (_esta_movendo) {
        var _target_x = variable_instance_exists(id, "target_x") ? target_x : destino_x;
        var _target_y = variable_instance_exists(id, "target_y") ? target_y : destino_y;
        
        // Linha azul do navio até o destino
        draw_set_color(c_aqua);
        draw_set_alpha(0.6);
        draw_line(x, y, _target_x, _target_y);
        
        // Círculo no destino (marcador visual)
        draw_circle(_target_x, _target_y, 8, false);
        draw_circle(_target_x, _target_y, 4, true);
        
        draw_set_alpha(1);
    }
    
    // ✅ LINHA VISUAL: Quando atacando
    if (variable_instance_exists(id, "estado") && estado == LanchaState.ATACANDO) {
        if (variable_instance_exists(id, "alvo_unidade") && instance_exists(alvo_unidade)) {
            draw_set_color(c_red);
            draw_set_alpha(0.7);
            draw_line(x, y, alvo_unidade.x, alvo_unidade.y);
            draw_set_alpha(1);
        }
    }
}

// === DESENHAR ROTA DE PATRULHA ===
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
