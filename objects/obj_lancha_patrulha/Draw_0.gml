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
    
    // ✅ NOVO: Desenhar linha do caminho A* quando em movimento (APENAS UMA LINHA)
    if (estado == LanchaState.MOVENDO) {
        // ✅ CORREÇÃO: Desenhar apenas o caminho A* completo (removida linha direta duplicada)
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
        }
    }
    
    // Desenhar linha quando atacando
    if (estado == LanchaState.ATACANDO) {
        if (variable_instance_exists(id, "alvo_unidade") && instance_exists(alvo_unidade)) {
            draw_set_color(c_red);
            draw_set_alpha(0.7);
            draw_line(x, _draw_y, alvo_unidade.x, alvo_unidade.y);
        }
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