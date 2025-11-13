/// @description Desenho do blindado antiaéreo com otimização

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

draw_self();

// Seleção (estilo da infantaria)
if (selecionado) {
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
    if (estado == "patrulhando" || (variable_global_exists("definindo_patrulha_unidade") && global.definindo_patrulha_unidade == id)) {
        if (variable_instance_exists(id, "pontos_patrulha") && ds_exists(pontos_patrulha, ds_type_list) && ds_list_size(pontos_patrulha) > 0) {
            draw_set_color(c_red); // Vermelho chamativo
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
                    draw_set_color(c_red); // Outros pontos em vermelho
                    draw_circle(_ponto[0], _ponto[1], 5, true);
                }
            }
            
            // Se estiver definindo a rota, desenha uma linha do último ponto até o mouse
            if (variable_global_exists("definindo_patrulha_unidade") && global.definindo_patrulha_unidade == id) {
                var _ultimo_ponto = pontos_patrulha[| ds_list_size(pontos_patrulha) - 1];
                // Conversão de coordenadas do mouse para o mundo (com zoom)
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
            // Se já estiver patrulhando, fecha o loop visual
            else if (estado == "patrulhando" && ds_list_size(pontos_patrulha) > 1) {
                var _ultimo_ponto = pontos_patrulha[| ds_list_size(pontos_patrulha) - 1];
                var _primeiro_ponto = pontos_patrulha[| 0];
                draw_line(_ultimo_ponto[0], _ultimo_ponto[1], _primeiro_ponto[0], _primeiro_ponto[1]);
            }
            
            draw_set_alpha(1.0);
        }
    }

    // Reset de desenho
    draw_set_alpha(1);
    draw_set_color(c_white);
}
