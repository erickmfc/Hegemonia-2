/// @description Draw - Indicadores do Porta-Aviões
// ===============================================
// HEGEMONIA GLOBAL - RONALD REAGAN (PORTA-AVIÕES)
// Draw - Mostrar capacidade e unidades armazenadas
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

// Chamar Draw do pai
// GM2040: Verificar se há parent antes de chamar event_inherited
if (object_get_parent(object_index) != -1) {
    event_inherited();
}

// Porta-aviões só desenha indicadores se estiver selecionado
if (variable_instance_exists(id, "selecionado") && selecionado) {
    // Círculo de seleção (maior para navio grande)
    draw_set_color(c_blue);
    draw_set_alpha(0.3);
    draw_circle(x, y, 70, false); // Navio grande
    draw_set_alpha(1.0);
    
    // Nome
    draw_set_halign(fa_center);
    draw_set_color(c_blue);
    draw_text_transformed(x, y - 160, "RONALD REAGAN", 1.3, 1.3, 0);
    
    // Capacidade de armazenamento (com verificação)
    var _avioes = variable_instance_exists(id, "avioes_count") ? avioes_count : 0;
    var _avioes_max = variable_instance_exists(id, "avioes_max") ? avioes_max : 0;
    var _unidades = variable_instance_exists(id, "unidades_count") ? unidades_count : 0;
    var _unidades_max = variable_instance_exists(id, "unidades_max") ? unidades_max : 0;
    var _soldados = variable_instance_exists(id, "soldados_count") ? soldados_count : 0;
    var _soldados_max = variable_instance_exists(id, "soldados_max") ? soldados_max : 0;
    
    draw_set_color(make_color_rgb(0, 255, 255)); // c_aqua
    draw_set_halign(fa_center);
    draw_text_transformed(x, y - 130, "✈️ Aviação: " + string(_avioes) + "/" + string(_avioes_max), 0.9, 0.9, 0);
    draw_text_transformed(x, y - 110, "🚗 Unidades: " + string(_unidades) + "/" + string(_unidades_max), 0.9, 0.9, 0);
    draw_text_transformed(x, y - 90, "👥 Soldados: " + string(_soldados) + "/" + string(_soldados_max), 0.9, 0.9, 0);
    
    // Total
    var _total_unidades = _avioes + _unidades + _soldados;
    var _total_max = _avioes_max + _unidades_max + _soldados_max;
    draw_text_transformed(x, y - 70, "Total: " + string(_total_unidades) + "/" + string(_total_max), 0.95, 0.95, 0);
    
    // === INDICADOR DE ESTADO DE EMBARQUE ===
    if (variable_instance_exists(id, "estado_embarque")) {
        var _estado = variable_instance_exists(id, "estado_embarque") ? estado_embarque : "navegando";
        draw_set_color(c_yellow);
        
        if (_estado == "embarcando") {
            draw_text_transformed(x, y - 50, "🟢 PORTAS ABERTAS - P para fechar", 0.85, 0.85, 0);
        } else if (_estado == "embarcado") {
            draw_text_transformed(x, y - 50, "🔴 PORTAS FECHADAS", 0.85, 0.85, 0);
        }
    }
    
    // Status
    if (variable_instance_exists(id, "desembarque_ativo") && desembarque_ativo) {
        draw_set_color(c_yellow);
        draw_text_transformed(x, y - 50, "DESEMBARCANDO...", 1.0, 1.0, 0);
        draw_set_color(make_color_rgb(0, 255, 255)); // c_aqua
    }
    
    // HP Bar maior (navio com muita vida)
    if (variable_instance_exists(id, "hp_atual") && variable_instance_exists(id, "hp_max") && hp_max > 0) {
        var _hp_percent = hp_atual / hp_max;
        var _bar_width = 200;
        var _bar_height = 12;
        var _bar_x = x - _bar_width / 2;
        var _bar_y = y - 200;
        
        // Fundo vermelho
        draw_set_color(c_red);
        draw_set_alpha(0.8);
        draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_width, _bar_y + _bar_height, false);
        
        // Barra verde de HP
        draw_set_color(c_green);
        draw_set_alpha(0.8);
        draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_width * _hp_percent, _bar_y + _bar_height, false);
        
        // Texto de HP
        draw_set_alpha(1.0);
        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_text(_bar_x + _bar_width / 2, _bar_y - 2, string(round(hp_atual)) + "/" + string(hp_max));
    }
    
    // Resetar
    draw_set_halign(fa_left);
    draw_set_alpha(1.0);
    draw_set_color(c_white);
}

// === RETÂNGULO DE EMBARQUE (IGUAL AO PAI) ===
if (variable_instance_exists(id, "estado_embarque") && estado_embarque == "embarcando") {
    // ✅ CORREÇÃO: Cor transparente (verde claro muito transparente) em vez de azul
    draw_set_color(c_lime);
    draw_set_alpha(0.15); // ✅ MUITO TRANSPARENTE: era 0.3, agora 0.15
    
    // ✅ NOVO: Desenhar retângulo que cobre o navio (em vez de círculo)
    var _largura = variable_instance_exists(id, "largura_embarque") ? largura_embarque : 200;
    var _altura = variable_instance_exists(id, "altura_embarque") ? altura_embarque : 960; // ✅ AUMENTADO: 50% proa + 50% popa (960 = 480 + 240 + 240)
    
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
    
    // Desenhar retângulo rotacionado
    draw_primitive_begin(pr_trianglefan);
    draw_vertex(_rx1, _ry1);
    draw_vertex(_rx2, _ry2);
    draw_vertex(_rx3, _ry3);
    draw_vertex(_rx4, _ry4);
    draw_primitive_end();
    
    // Borda do retângulo (transparente)
    draw_set_alpha(0.3); // ✅ TRANSPARENTE: era 0.6, agora 0.3
    draw_set_color(c_lime);
    draw_line(_rx1, _ry1, _rx2, _ry2);
    draw_line(_rx2, _ry2, _rx3, _ry3);
    draw_line(_rx3, _ry3, _rx4, _ry4);
    draw_line(_rx4, _ry4, _rx1, _ry1);
    draw_set_alpha(1.0);
}
