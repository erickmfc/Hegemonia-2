// ===============================================
// HEGEMONIA GLOBAL - NAVIO TRANSPORTE (Draw)
// Sistema Visual com Indicadores de Carga
// ===============================================

// Desenhar sombra (simples deslocamento preto com transparência)
draw_set_color(c_black);
draw_set_alpha(0.4);
draw_sprite_ext(sprite_index, image_index, x + 4, y + 4, image_xscale, image_yscale, image_angle, c_black, 0.4);

// Desenhar sprite do navio
draw_set_color(c_white);
draw_set_alpha(1.0);
draw_self();

// --- FEEDBACK VISUAL (SE SELECIONADO) ---
if (selecionado) {
    var _draw_y = y;
    
    // Círculo de seleção
    draw_set_color(c_green);
    draw_set_alpha(0.3);
    draw_circle(x, _draw_y, 40, true);
    
    // Círculo do Radar
    draw_set_color(modo_combate == LanchaMode.ATAQUE ? c_red : c_gray);
    draw_set_alpha(0.2);
    draw_circle(x, _draw_y, radar_alcance, false);
    
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
            var _prev_y = _draw_y;
            
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
            draw_line(x, _draw_y, _target_x, _target_y);
            
            // Círculo no destino (marcador visual)
            draw_circle(_target_x, _target_y, 8, false);
            draw_circle(_target_x, _target_y, 4, true);
        }
        
        draw_set_alpha(1);
    }
    
    // Desenhar linha quando atacando
    if (estado == LanchaState.ATACANDO) {
        if (variable_instance_exists(id, "alvo_unidade") && instance_exists(alvo_unidade)) {
            draw_set_color(c_red);
            draw_set_alpha(0.7);
            draw_line(x, _draw_y, alvo_unidade.x, alvo_unidade.y);
        }
    }
    
    // ✅ REMOVIDO: Informações de status movidas para o menu de carga (J)
    // As informações de status agora aparecem apenas no menu J
}

// === DESENHAR ROTA DE PATRULHA ===
if (estado == LanchaState.PATRULHANDO || estado == LanchaState.DEFININDO_PATRULHA || 
    (variable_global_exists("definindo_patrulha_unidade") && global.definindo_patrulha_unidade == id)) {

    if (ds_list_size(pontos_patrulha) > 0) {
        draw_set_color(c_blue);
        draw_set_alpha(0.8);
        
        for (var i = 0; i < ds_list_size(pontos_patrulha) - 1; i++) {
            var _p1 = pontos_patrulha[| i];
            var _p2 = pontos_patrulha[| i + 1];
            draw_line(_p1[0], _p1[1], _p2[0], _p2[1]);
        }
        
        for (var i = 0; i < ds_list_size(pontos_patrulha); i++) {
            var _ponto = pontos_patrulha[| i];
            if (i == indice_patrulha_atual) {
                draw_set_color(c_yellow);
                draw_circle(_ponto[0], _ponto[1], 8, true);
            } else {
                draw_set_color(c_blue);
                draw_circle(_ponto[0], _ponto[1], 5, true);
            }
        }
        
        if (estado == LanchaState.DEFININDO_PATRULHA || 
            (variable_global_exists("definindo_patrulha_unidade") && global.definindo_patrulha_unidade == id)) {
            var _ultimo_ponto = pontos_patrulha[| ds_list_size(pontos_patrulha) - 1];
            var _mouse_gui_x = device_mouse_x_to_gui(0);
            var _mouse_gui_y = device_mouse_y_to_gui(0);
            var _cam = view_camera[0];
            var _cam_x = camera_get_view_x(_cam);
            var _cam_y = camera_get_view_y(_cam);
            var _cam_w = camera_get_view_width(_cam);
            var _cam_h = camera_get_view_height(_cam);
            var _zoom_level_x = _cam_w / display_get_gui_width();
            var _zoom_level_y = _cam_h / display_get_gui_height();
            var _mouse_world_x = _cam_x + (_mouse_gui_x * _zoom_level_x);
            var _mouse_world_y = _cam_y + (_mouse_gui_y * _zoom_level_y);
            draw_set_color(c_lime);
            draw_set_alpha(0.8);
            draw_line(_ultimo_ponto[0], _ultimo_ponto[1], _mouse_world_x, _mouse_world_y);
        }
        else if (estado == LanchaState.PATRULHANDO && ds_list_size(pontos_patrulha) > 1) {
            var _ultimo_ponto = pontos_patrulha[| ds_list_size(pontos_patrulha) - 1];
            var _primeiro_ponto = pontos_patrulha[| 0];
            draw_line(_ultimo_ponto[0], _ultimo_ponto[1], _primeiro_ponto[0], _primeiro_ponto[1]);
        }
        
        draw_set_alpha(1.0);
    }
}

// === DESENHAR ÁREA DE CAPTURA (RETÂNGULO VERDE) ===
// ✅ APENAS quando modo embarque está ATIVO (portas abertas) e pode receber unidades
// ✅ NÃO mostrar quando portas estão fechadas (EMBARCADO) ou em qualquer outro estado
var _mostrar_retangulo = false;
if (variable_instance_exists(id, "estado_transporte") && 
    variable_instance_exists(id, "modo_embarque")) {
    
    // ✅ Só mostrar se EXATAMENTE em modo EMBARQUE_ATIVO com portas abertas
    if (estado_transporte == NavioTransporteEstado.EMBARQUE_ATIVO && modo_embarque) {
        // Verificar se ainda tem espaço para embarcar
        var _total_embarcado = soldados_count + unidades_count + avioes_count;
        var _capacidade_total = soldados_max + unidades_max + avioes_max;
        var _pode_embarcar = (_total_embarcado < _capacidade_total);
        
        // ✅ Só mostrar retângulo se PODE embarcar (tem espaço) E portas estão abertas
        if (_pode_embarcar) {
            _mostrar_retangulo = true;
        }
    }
}

// ✅ Desenhar retângulo APENAS se todas as condições forem verdadeiras
if (_mostrar_retangulo) {
        draw_set_color(c_lime);
        draw_set_alpha(0.2); // Verde transparente
        
        // Desenhar retângulo que cobre o navio (aumentado 20%)
        var _largura = variable_instance_exists(id, "largura_embarque") ? largura_embarque : 293.76; // ✅ AUMENTADO 50%
        var _altura = variable_instance_exists(id, "altura_embarque") ? altura_embarque : 352.08; // ✅ AUMENTADO 50%
        
        // Calcular posição do retângulo baseado na rotação do navio
        var _angulo_rad = degtorad(image_angle);
        var _cos_a = dcos(_angulo_rad);
        var _sin_a = dsin(_angulo_rad);
        
        // Pontos do retângulo (centrado no navio)
        var _half_w = _largura / 2;
        var _half_h = _altura / 2;
        
        // Canto superior esquerdo (antes da rotação)
        var _x1 = -_half_w;
        var _y1 = -_half_h;
        // Canto superior direito
        var _x2 = _half_w;
        var _y2 = -_half_h;
        // Canto inferior direito
        var _x3 = _half_w;
        var _y3 = _half_h;
        // Canto inferior esquerdo
        var _x4 = -_half_w;
        var _y4 = _half_h;
        
        // Rotacionar pontos
        var _rx1 = x + (_x1 * _cos_a - _y1 * _sin_a);
        var _ry1 = y + (_x1 * _sin_a + _y1 * _cos_a);
        var _rx2 = x + (_x2 * _cos_a - _y2 * _sin_a);
        var _ry2 = y + (_x2 * _sin_a + _y2 * _cos_a);
        var _rx3 = x + (_x3 * _cos_a - _y3 * _sin_a);
        var _ry3 = y + (_x3 * _sin_a + _y3 * _cos_a);
        var _rx4 = x + (_x4 * _cos_a - _y4 * _sin_a);
        var _ry4 = y + (_x4 * _sin_a + _y4 * _cos_a);
        
        // Desenhar retângulo rotacionado (preenchido)
        draw_primitive_begin(pr_trianglefan);
        draw_vertex(_rx1, _ry1);
        draw_vertex(_rx2, _ry2);
        draw_vertex(_rx3, _ry3);
        draw_vertex(_rx4, _ry4);
        draw_primitive_end();
        
        // Borda do retângulo (um pouco mais visível)
        draw_set_alpha(0.4);
        draw_set_color(c_lime);
        draw_line(_rx1, _ry1, _rx2, _ry2);
        draw_line(_rx2, _ry2, _rx3, _ry3);
        draw_line(_rx3, _ry3, _rx4, _ry4);
        draw_line(_rx4, _ry4, _rx1, _ry1);
        
        draw_set_alpha(1.0);
        draw_set_color(c_white);
    }