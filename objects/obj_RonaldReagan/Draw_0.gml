/// @description Draw - Indicadores do Porta-Aviões
// ===============================================
// HEGEMONIA GLOBAL - RONALD REAGAN (PORTA-AVIÕES)
// Draw - Mostrar capacidade e unidades armazenadas
// ===============================================

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

// === CÍRCULO PULSANTE DE EMBARQUE ===
if (variable_instance_exists(id, "estado_embarque") && estado_embarque == "embarcando") {
    // Círculo verde pulsante para indicar área de embarque
    var _alpha = 0.3 + 0.2 * sin(current_time * 0.01);
    draw_set_color(c_lime);
    draw_set_alpha(_alpha);
    draw_circle(x, y, raio_embarque, false);
    draw_set_alpha(1.0);
}
