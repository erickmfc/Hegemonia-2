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
    
    // ✅ PRIORIDADE: Mostrar status de EMBARQUE primeiro (mais importante e legível)
    var _transporte_texto = "";
    var _transporte_cor = c_white;
    
    if (estado_transporte == NavioTransporteEstado.EMBARQUE_ATIVO) {
        _transporte_texto = "EMBARQUE";
        _transporte_cor = c_yellow;
    } else if (estado_transporte == NavioTransporteEstado.EMBARQUE_OFF) {
        _transporte_texto = "EMBARCADO";
        _transporte_cor = c_lime;
    } else if (estado_transporte == NavioTransporteEstado.DESEMBARCANDO) {
        _transporte_texto = "DESEMBARQUE";
        _transporte_cor = c_orange;
    } else if (estado_transporte == NavioTransporteEstado.NAVEGANDO) {
        _transporte_texto = "NAVEGANDO";
        _transporte_cor = make_color_rgb(0, 255, 255); // c_aqua
    } else {
        // Status normal de movimento
        if (estado == LanchaState.ATACANDO) _transporte_texto = "ATACANDO";
        else if (estado == LanchaState.PATRULHANDO) _transporte_texto = "PATRULHANDO";
        else if (estado == LanchaState.MOVENDO) _transporte_texto = "NAVEGANDO";
        else if (estado == LanchaState.DEFININDO_PATRULHA) _transporte_texto = "DEFININDO ROTA";
        else _transporte_texto = "PARADO";
        
        if (estado == LanchaState.ATACANDO) _transporte_cor = c_red;
        else if (estado == LanchaState.PATRULHANDO) _transporte_cor = c_orange;
        else if (estado == LanchaState.MOVENDO) _transporte_cor = make_color_rgb(0, 255, 255); // c_aqua
        else _transporte_cor = c_gray;
    }
    
    // ✅ NOVO: Fundo escuro para legibilidade do status
    var _status_x = x;
    var _status_y = _draw_y - 65;
    var _status_w = string_width(_transporte_texto) + 20;
    var _status_h = 25;
    
    draw_set_color(c_black);
    draw_set_alpha(0.8);
    draw_rectangle(_status_x - _status_w/2, _status_y - _status_h/2, 
                    _status_x + _status_w/2, _status_y + _status_h/2, false);
    draw_set_alpha(1.0);
    
    // Borda do status
    draw_set_color(_transporte_cor);
    draw_set_alpha(0.6);
    draw_rectangle(_status_x - _status_w/2, _status_y - _status_h/2, 
                    _status_x + _status_w/2, _status_y + _status_h/2, true);
    draw_set_alpha(1.0);
    
    // Desenhar status PRINCIPAL (GRANDE e legível)
    draw_set_color(_transporte_cor);
    draw_set_font(-1);  // Fonte padrão maior
    draw_text(_status_x, _status_y, _transporte_texto);
    
    // Controles (menor, abaixo do status)
    draw_set_color(c_white);
    draw_set_alpha(0.9);
    draw_text(x, _draw_y - 35, "[K] Patrulha | [L] Parar");
    draw_text(x, _draw_y - 20, "[P] Embarcar | [PP] Fechar | [PPP] Desembarcar");
    draw_text(x, _draw_y - 5, "[O] Ataque | [J] Menu Carga");
    draw_set_alpha(1.0);
    
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
        
        // Desenhar retângulo que cobre o navio (reduzido 20%)
        var _largura = variable_instance_exists(id, "largura_embarque") ? largura_embarque : 136; // ✅ REDUZIDO 20%
        var _altura = variable_instance_exists(id, "altura_embarque") ? altura_embarque : 163; // ✅ REDUZIDO 20%
        
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