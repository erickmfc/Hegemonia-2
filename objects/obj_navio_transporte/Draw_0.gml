// ===============================================
// HEGEMONIA GLOBAL - NAVIO TRANSPORTE (Draw)
// Sistema Visual com Indicadores de Carga
// ===============================================

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
    
    // Linha para o destino
    if (estado != LanchaState.PARADO) {
        if (estado == LanchaState.ATACANDO) {
            draw_set_color(c_red);
            draw_set_alpha(0.7);
        } else {
            draw_set_color(c_yellow);
            draw_set_alpha(0.5);
        }
        draw_line(x, _draw_y, destino_x, destino_y);
    }
    
    // --- INFORMAÇÕES DE STATUS ---
    draw_set_alpha(1.0);
    draw_set_halign(fa_center);
    
    // PRIORIDADE: Mostrar status de EMBARQUE primeiro (mais importante)
    var _transporte_texto = "";
    var _transporte_cor = c_white;
    
    if (estado_transporte == NavioTransporteEstado.EMBARQUE_ATIVO) {
        _transporte_texto = "🚚 EMBARQUE ATIVO";
        _transporte_cor = c_yellow;
    } else if (estado_transporte == NavioTransporteEstado.EMBARQUE_OFF) {
        _transporte_texto = "✅ CHEIO";
        _transporte_cor = c_orange;
    } else if (estado_transporte == NavioTransporteEstado.DESEMBARCANDO) {
        _transporte_texto = "📦 DESEMBARQUE";
        _transporte_cor = c_lime;
    } else if (estado_transporte == NavioTransporteEstado.NAVEGANDO) {
        _transporte_texto = "⚓ NAVEGANDO";
        _transporte_cor = make_color_rgb(0, 255, 255); // c_aqua
    } else {
        // Status normal de movimento
        if (estado == LanchaState.ATACANDO) _transporte_texto = "⚔️ ATACANDO";
        else if (estado == LanchaState.PATRULHANDO) _transporte_texto = "🔄 PATRULHANDO";
        else if (estado == LanchaState.MOVENDO) _transporte_texto = "⛵ NAVEGANDO";
        else if (estado == LanchaState.DEFININDO_PATRULHA) _transporte_texto = "📍 DEFININDO ROTA";
        else _transporte_texto = "⏸️ PARADO";
        
        if (estado == LanchaState.ATACANDO) _transporte_cor = c_red;
        else if (estado == LanchaState.PATRULHANDO) _transporte_cor = c_orange;
        else if (estado == LanchaState.MOVENDO) _transporte_cor = make_color_rgb(0, 255, 255); // c_aqua
        else _transporte_cor = c_gray;
    }
    
    // Desenhar status PRINCIPAL (GRANDE)
    draw_set_color(_transporte_cor);
    draw_set_font(-1);  // Fonte padrão maior
    draw_text(x, _draw_y - 50, _transporte_texto);
    
    // Controles
    draw_set_color(c_white);
    draw_text(x, _draw_y - 35, "[K] Patrulha | [L] Parar");
    draw_text(x, _draw_y - 20, "[P] Embarcar/Desembarcar");
    draw_text(x, _draw_y - 5, "[O] Ataque | [J] Menu Carga");
    
    // --- INDICADOR DE CARGA ---
    var _percentual = ((avioes_count + unidades_count + soldados_count) / (avioes_max + unidades_max + soldados_max)) * 100;
    var _barra_width = 80;
    var _barra_height = 6;
    
    draw_set_color(c_gray);
    draw_rectangle(x - _barra_width/2, _draw_y + 10, 
                    x + _barra_width/2, _draw_y + 10 + _barra_height, false);
    
    var _cor_carga = c_green;
    if (_percentual > 75) _cor_carga = c_orange;
    if (_percentual >= 100) _cor_carga = c_red;
    
    draw_set_color(_cor_carga);
    draw_rectangle(x - _barra_width/2, _draw_y + 10,
                    x - _barra_width/2 + (_barra_width * _percentual / 100),
                    _draw_y + 10 + _barra_height, false);
    
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_text(x, _draw_y + 20, string(round(_percentual)) + "%");
    
    draw_set_halign(fa_left);
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

draw_set_alpha(1.0);