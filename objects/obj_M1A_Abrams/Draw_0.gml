// ================================================
// HEGEMONIA GLOBAL - M1A ABRAMS
// Draw Event - Desenho Modular (Casco + Torre + Cano)
// ================================================

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

// =============================================
// DESENHO MODULAR DO TANQUE
// =============================================

// ✅ Se destruído, desenhar sprite de destruído
if (destruido) {
    if (sprite_exists(spr_abrams_destruido)) {
        draw_sprite_ext(spr_abrams_destruido, 0, x, y, 1.0, 1.0, image_angle, c_white, 1.0);
    }
} else {
    // ✅ DESENHO MODULAR: 3 camadas separadas
    
    // ✅ ESCALA: Tanque aumentado 15% (1.0 * 1.15 = 1.15)
    var _escala_tanque = 1.15;
    // ✅ ESCALA: Cano aumentado 25% + 10% adicional (1.25 * 1.10 = 1.375)
    var _escala_cano = 1.375;
    
    // CAMADA 1: CASCO (sem rotação - aponta na direção do movimento)
    if (sprite_exists(spr_abrams_casco)) {
        draw_sprite_ext(spr_abrams_casco, 0, x, y, _escala_tanque, _escala_tanque, image_angle, c_white, 1.0);
    }
    
    // CAMADA 2: TORRE (com rotação independente - angulo_torre)
    if (sprite_exists(spr_abrams_torre)) {
        var _torre_x = x + offset_torre_x;
        var _torre_y = y + offset_torre_y;
        draw_sprite_ext(spr_abrams_torre, 0, _torre_x, _torre_y, _escala_tanque, _escala_tanque, angulo_torre, c_white, 1.0);
    }
    
    // CAMADA 3: CANO (com rotação independente - angulo_torre, mesma rotação da torre)
    // ✅ CANO: Aumentado 25% em relação ao tamanho base
    if (sprite_exists(spr_abrams_cano)) {
        var _cano_x = x + offset_torre_x;
        var _cano_y = y + offset_torre_y;
        draw_sprite_ext(spr_abrams_cano, 0, _cano_x, _cano_y, _escala_cano, _escala_cano, angulo_torre, c_white, 1.0);
    }
}

// =============================================
// INDICADORES DE SELEÇÃO
// =============================================
if (selecionado && !destruido) {
    // Círculo de alcance de tiro (cinza translúcido)
    draw_set_color(c_gray);
    draw_set_alpha(0.05);
    draw_circle(x, y, alcance_tiro, false);
    draw_set_alpha(1);

    // Cantoneiras verdes em volta da caixa de colisão
    draw_set_color(c_lime);
    // Linha superior
    draw_line(bbox_left - 5, bbox_top - 5, bbox_right + 5, bbox_top - 5);
    // Linha inferior
    draw_line(bbox_left - 5, bbox_bottom + 5, bbox_right + 5, bbox_bottom + 5);
    // Linha esquerda
    draw_line(bbox_left - 5, bbox_top - 5, bbox_left - 5, bbox_bottom + 5);
    // Linha direita
    draw_line(bbox_right + 5, bbox_top - 5, bbox_right + 5, bbox_bottom + 5);

    // ✅ NOVO: Desenhar rota de patrulha (sistema igual navios/aviões)
    var _esta_definindo_patrulha = (variable_global_exists("definindo_patrulha_unidade") && global.definindo_patrulha_unidade == id);
    if (estado == "patrulhando" || _esta_definindo_patrulha) {
        if (variable_instance_exists(id, "pontos_patrulha") && ds_exists(pontos_patrulha, ds_type_list)) {
            var _num_pontos = ds_list_size(pontos_patrulha);
            if (_num_pontos > 0) {
            draw_set_color(c_red); // Vermelho chamativo
            draw_set_alpha(0.8);
            
            // Desenha as linhas conectando os pontos
            for (var i = 0; i < _num_pontos - 1; i++) {
                var _p1 = pontos_patrulha[| i];
                var _p2 = pontos_patrulha[| i + 1];
                if (is_array(_p1) && is_array(_p2) && array_length(_p1) >= 2 && array_length(_p2) >= 2) {
                    draw_line(_p1[0], _p1[1], _p2[0], _p2[1]);
                }
            }
            
            // Desenha círculos nos pontos de patrulha
            for (var i = 0; i < _num_pontos; i++) {
                var _ponto = pontos_patrulha[| i];
                if (is_array(_ponto) && array_length(_ponto) >= 2) {
                    if (i == indice_patrulha_atual && estado == "patrulhando") {
                        draw_set_color(c_yellow); // Ponto atual em amarelo
                        draw_circle(_ponto[0], _ponto[1], 8, true);
                    } else {
                        draw_set_color(c_red); // Outros pontos em vermelho
                        draw_circle(_ponto[0], _ponto[1], 5, true);
                    }
                }
            }
            
            // Se estiver definindo a rota, desenha uma linha do último ponto até o mouse
            if (_esta_definindo_patrulha) {
                if (_num_pontos > 0) {
                    var _ultimo_ponto = pontos_patrulha[| _num_pontos - 1];
                    if (is_array(_ultimo_ponto) && array_length(_ultimo_ponto) >= 2) {
                        // Conversão de coordenadas do mouse para o mundo (usar scr_mouse_to_world se disponível)
                        var _mx = 0;
                        var _my = 0;
                        if (script_exists(scr_mouse_to_world)) {
                            var _coords = scr_mouse_to_world();
                            _mx = _coords[0];
                            _my = _coords[1];
                        } else {
                            // Fallback: conversão manual
                            var _mouse_gui_x = device_mouse_x_to_gui(0);
                            var _mouse_gui_y = device_mouse_y_to_gui(0);
                            var _cam = view_camera[0];
                            var _cam_x = camera_get_view_x(_cam);
                            var _cam_y = camera_get_view_y(_cam);
                            var _cam_w = camera_get_view_width(_cam);
                            var _cam_h = camera_get_view_height(_cam);
                            var _zoom_level_x = _cam_w / display_get_gui_width();
                            var _zoom_level_y = _cam_h / display_get_gui_height();
                            _mx = _cam_x + (_mouse_gui_x * _zoom_level_x);
                            _my = _cam_y + (_mouse_gui_y * _zoom_level_y);
                        }
                        draw_set_color(c_lime);
                        draw_set_alpha(0.8);
                        draw_line(_ultimo_ponto[0], _ultimo_ponto[1], _mx, _my);
                    }
                }
            }
            // Se já estiver patrulhando, fecha o loop visual
            else if (estado == "patrulhando" && _num_pontos > 1) {
                var _ultimo_ponto = pontos_patrulha[| _num_pontos - 1];
                var _primeiro_ponto = pontos_patrulha[| 0];
                if (is_array(_ultimo_ponto) && is_array(_primeiro_ponto) && 
                    array_length(_ultimo_ponto) >= 2 && array_length(_primeiro_ponto) >= 2) {
                    draw_line(_ultimo_ponto[0], _ultimo_ponto[1], _primeiro_ponto[0], _primeiro_ponto[1]);
                }
            }
            
            draw_set_alpha(1.0);
            }
        }
    }

    // Reset de desenho
    draw_set_alpha(1);
    draw_set_color(c_white);
}
