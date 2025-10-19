// ===============================================
// HEGEMONIA GLOBAL - LANCHA PATRULHA (Draw Adaptado)
// Sistema Visual Naval Completo
// ===============================================

// Desenhar a lancha (sem efeito de altitude)
draw_self();

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
    
    // Linha para o destino (CORRIGIDO: usar estado em vez de velocidade_atual)
    if (estado != LanchaState.PARADO) {
        if (estado == LanchaState.ATACANDO) {
            draw_set_color(c_red); // Linha vermelha quando atacando
            draw_set_alpha(0.7);
        } else {
            draw_set_color(c_yellow); // Linha amarela para movimento normal
            draw_set_alpha(0.5);
        }
        draw_line(x, _draw_y, alvo_x, alvo_y);
    }
    
    // --- INFORMAÇÕES DE STATUS E CONTROLES ---
    draw_set_alpha(1.0);
    draw_set_halign(fa_center);
    
    var _status_text = "PARADO";
    if (estado == LanchaState.ATACANDO) _status_text = "ATACANDO";
    else if (estado == LanchaState.PATRULHANDO) _status_text = "PATRULHANDO";
    else if (estado == LanchaState.MOVENDO) _status_text = "NAVEGANDO";
    else if (estado == LanchaState.DEFININDO_PATRULHA) _status_text = "DEFININDO ROTA";
    
    var _status_color = c_gray;
    if (estado == LanchaState.ATACANDO) _status_color = c_red;
    else if (estado == LanchaState.PATRULHANDO) _status_color = c_orange;
    else if (estado == LanchaState.MOVENDO) _status_color = c_aqua;
    else if (estado == LanchaState.DEFININDO_PATRULHA) _status_color = c_lime;
    
    // Desenha o status acima da lancha
    draw_set_color(_status_color);
    draw_text(x, _draw_y - 60, _status_text);
    
    // Desenha os controles disponíveis (adaptados para lancha)
    draw_set_color(c_white);
    draw_text(x, _draw_y - 45, "[K] Patrulha | [L] Parar");
    draw_text(x, _draw_y - 30, "[P] Passivo | [O] Ataque Agressivo");

    draw_set_halign(fa_left);
}

// ======================================================================
// ✅ DESENHAR A ROTA DE PATRULHA (CORRIGIDO)
// ======================================================================
if (estado == LanchaState.PATRULHANDO || estado == LanchaState.DEFININDO_PATRULHA || 
    (variable_global_exists("definindo_patrulha_unidade") && global.definindo_patrulha_unidade == id)) {

    if (ds_list_size(pontos_patrulha) > 0) {
        draw_set_color(c_blue); // Azul naval
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
                draw_set_color(c_blue); // Outros pontos em azul naval
                draw_circle(_ponto[0], _ponto[1], 5, true);
            }
        }
        
        // Se estiver definindo a rota, desenha uma linha do último ponto até o mouse
        if (estado == LanchaState.DEFININDO_PATRULHA || 
            (variable_global_exists("definindo_patrulha_unidade") && global.definindo_patrulha_unidade == id)) {
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
        else if (estado == LanchaState.PATRULHANDO && ds_list_size(pontos_patrulha) > 1) {
            var _ultimo_ponto = pontos_patrulha[| ds_list_size(pontos_patrulha) - 1];
            var _primeiro_ponto = pontos_patrulha[| 0];
            draw_line(_ultimo_ponto[0], _ultimo_ponto[1], _primeiro_ponto[0], _primeiro_ponto[1]);
        }
        
        draw_set_alpha(1.0);
    }
}
// ======================================================================