// ===============================================
// HEGEMONIA GLOBAL - CAÇA SU-35 (Draw)
// ===============================================

// Efeito de altitude com sombra
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_black, 0.4);
draw_sprite_ext(sprite_index, image_index, x, y - altura_voo, image_xscale, image_yscale, image_angle, image_blend, image_alpha);

// --- FEEDBACK VISUAL (SE SELECIONADO) ---
if (selecionado) {
    var _draw_y = y - altura_voo;
    
    // Círculo de seleção
    draw_set_color(c_green);
    draw_set_alpha(0.3);
    draw_circle(x, _draw_y, 40, true);
    
    // Círculo do Radar
    draw_set_color(modo_ataque ? c_red : c_gray);
    draw_set_alpha(0.2);
    draw_circle(x, _draw_y, radar_alcance, false);
    
    // Linha para o destino
    if (velocidade_atual > 0) {
        if (estado == "atacando") {
            draw_set_color(c_red); // Linha vermelha quando atacando
            draw_set_alpha(0.7);
        } else {
            draw_set_color(c_yellow); // Linha amarela para movimento normal
            draw_set_alpha(0.5);
        }
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
    
    var _status_color = c_gray;
    if (estado == "atacando") _status_color = c_red;
    else if (estado == "patrulhando") _status_color = c_orange;
    else if (estado == "definindo_patrulha") _status_color = c_lime;
    else if (estado == "pousando") _status_color = c_yellow;
    else if (estado == "movendo") _status_color = make_color_rgb(0, 255, 255); // c_aqua
    
    // Desenha o status acima do avião
    draw_set_color(_status_color);
    draw_text(x, _draw_y - 60, "SU-35 - " + _status_text);
    
    // Desenha os controles disponíveis
    draw_set_color(c_white);
    draw_text(x, _draw_y - 45, "[K] Patrulha | [L] Pousar");
    draw_text(x, _draw_y - 30, "[P] Passivo | [O] Ataque Agressivo");

    draw_set_halign(fa_left);
}

// ======================================================================
// ✅ NOVA LÓGICA: DESENHAR A ROTA DE PATRULHA (SEMPRE VISÍVEL DURANTE A CRIAÇÃO)
// ======================================================================
// ✅ CORREÇÃO: Verificação direta e segura da variável global
if (estado == "patrulhando" || (variable_global_exists("definindo_patrulha_unidade") && global.definindo_patrulha_unidade == id)) {

    if (ds_list_size(pontos_patrulha) > 0) {
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
// ======================================================================
