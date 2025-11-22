/// @description Draw Event da Independence
// ===============================================
// HEGEMONIA GLOBAL - INDEPENDENCE (HERDA DE NAVIO_BASE)
// Draw Event - Indicadores específicos
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
if (sprite_index != -1 && sprite_exists(sprite_index)) {
    draw_sprite_ext(sprite_index, image_index, x + 4, y + 4, image_xscale, image_yscale, image_angle, c_black, 0.4);
} else {
    // Fallback: tentar carregar sprite
    var _spr_independence = asset_get_index("spr_Independence");
    if (_spr_independence != -1 && sprite_exists(_spr_independence)) {
        sprite_index = _spr_independence;
        draw_sprite_ext(sprite_index, image_index, x + 4, y + 4, image_xscale, image_yscale, image_angle, c_black, 0.4);
    }
}

// ✅ CORREÇÃO: Desenhar sprite do navio PRIMEIRO
// Garantir que o sprite seja desenhado mesmo se o pai não desenhar
draw_set_color(c_white);
draw_set_alpha(1.0);
if (sprite_index != -1 && sprite_exists(sprite_index)) {
    draw_self();
} else {
    // Fallback: tentar carregar sprite
    var _spr_independence = asset_get_index("spr_Independence");
    if (_spr_independence != -1 && sprite_exists(_spr_independence)) {
        sprite_index = _spr_independence;
        draw_self();
    }
}

// Chamar o Draw do objeto pai (herda indicadores básicos)
if (object_get_parent(object_index) != -1) {
    event_inherited();
}

if (selecionado) {
    // Círculo de seleção
    draw_set_color(c_red);
    draw_set_alpha(0.3);
    draw_circle(x, y, 45, false);
    draw_set_alpha(1.0);
    
    // ✅ CORREÇÃO: Usar fonte padrão como no navio de transporte
    draw_set_font(-1);
    
    // Nome da unidade
    draw_set_halign(fa_center);
    draw_set_color(c_red);
    draw_text(x, y - 65, "INDEPENDENCE");
    
    // Indicadores de estado
    var _y_offset = -45;
    
    // Indicador de canhão ativo
    if (metralhadora_ativa && instance_exists(alvo_unidade)) {
        draw_set_color(c_yellow);
        if (object_is_ancestor(alvo_unidade.object_index, obj_aereo)) {
            draw_text(x, y + _y_offset, "🚀 DISPARANDO (AR)");
        } else {
            draw_text(x, y + _y_offset, "🔫 DISPARANDO");
        }
        _y_offset += 15;
    }
    
    // Indicador de status
    if (estado == LanchaState.ATACANDO) {
        draw_set_color(c_yellow);
        draw_text(x, y + _y_offset, "⚔️ ATACANDO");
    }
    
    // ✅ CORREÇÃO: Círculo de alcance dos mísseis
    if (variable_instance_exists(id, "missil_max_alcance")) {
        draw_set_color(c_red);
        draw_set_alpha(0.06);
        draw_circle(x, y, missil_max_alcance, false);
        draw_set_alpha(0.3);
        draw_circle(x, y, missil_max_alcance, true);
    }
    
    // ✅ CORREÇÃO: Círculo de alcance do radar (visão)
    if (variable_instance_exists(id, "radar_alcance")) {
        draw_set_color(c_blue);
        draw_set_alpha(0.08);
        draw_circle(x, y, radar_alcance, false);
        draw_set_alpha(0.2);
        draw_circle(x, y, radar_alcance, true);
    }
    
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
        
        // ✅ PRIORIDADE: Desenhar caminho A* se existir (mais preciso)
        if (variable_instance_exists(id, "meu_caminho") && meu_caminho != noone) {
            draw_set_color(c_aqua);
            draw_set_alpha(0.6);
            var _num_segments = 30; // Número de segmentos para desenhar o caminho
            var _prev_x = x;
            var _prev_y = y;
            
            // ✅ CORREÇÃO: path_get_x/y usa posição (0.0 a 1.0), não pixels
            for (var i = 1; i <= _num_segments; i++) {
                var _pos = i / _num_segments; // Posição de 0.0 a 1.0
                var _seg_x = path_get_x(meu_caminho, _pos);
                var _seg_y = path_get_y(meu_caminho, _pos);
                if (!is_undefined(_seg_x) && !is_undefined(_seg_y)) {
                    draw_line(_prev_x, _prev_y, _seg_x, _seg_y);
                    _prev_x = _seg_x;
                    _prev_y = _seg_y;
                }
            }
        } else {
            // ✅ FALLBACK: Desenhar linha direta se não houver caminho A*
            draw_set_color(c_aqua);
            draw_set_alpha(0.6);
            draw_line(x, y, _target_x, _target_y);
            
            // Círculo no destino (marcador visual)
            draw_circle(_target_x, _target_y, 8, false);
            draw_circle(_target_x, _target_y, 4, true);
        }
        
        draw_set_alpha(1);
    }
    
    // Desenhar linha quando atacando (apenas para alvo)
    if (variable_instance_exists(id, "estado") && estado == LanchaState.ATACANDO) {
        if (variable_instance_exists(id, "alvo_unidade") && instance_exists(alvo_unidade)) {
            draw_set_color(c_red);
            draw_set_alpha(0.7);
            draw_line(x, y, alvo_unidade.x, alvo_unidade.y);
        }
    }
    
    // ✅ CORREÇÃO: Desenhar pontos de patrulha se existirem
    if (variable_instance_exists(id, "pontos_patrulha") && ds_exists(pontos_patrulha, ds_type_list)) {
        var _total_pontos = ds_list_size(pontos_patrulha);
        if (_total_pontos > 0) {
            draw_set_color(c_aqua); // ✅ CORREÇÃO: c_cyan não existe, usar c_aqua (ciano)
            draw_set_alpha(0.4);
            // Desenhar linha conectando todos os pontos de patrulha
            for (var i = 0; i < _total_pontos; i++) {
                var _ponto_atual = pontos_patrulha[| i];
                var _ponto_proximo = pontos_patrulha[| ((i + 1) mod _total_pontos)];
                if (is_array(_ponto_atual) && is_array(_ponto_proximo) && array_length(_ponto_atual) >= 2 && array_length(_ponto_proximo) >= 2) {
                    draw_line_width(_ponto_atual[0], _ponto_atual[1], _ponto_proximo[0], _ponto_proximo[1], 1);
                }
            }
            // Desenhar círculos nos pontos de patrulha
            for (var i = 0; i < _total_pontos; i++) {
                var _ponto = pontos_patrulha[| i];
                if (is_array(_ponto) && array_length(_ponto) >= 2) {
                    var _cor_ponto = (i == indice_patrulha_atual) ? c_yellow : c_aqua; // ✅ CORREÇÃO: c_cyan não existe, usar c_aqua
                    draw_set_color(_cor_ponto);
                    draw_set_alpha(0.6);
                    draw_circle(_ponto[0], _ponto[1], 12, false);
                    draw_circle(_ponto[0], _ponto[1], 6, true);
                }
            }
        }
    }
    
    draw_set_alpha(1.0);
    
    // Resetar alinhamento
    draw_set_halign(fa_left);
}