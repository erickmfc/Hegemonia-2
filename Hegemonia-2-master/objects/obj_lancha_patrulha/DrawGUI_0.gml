// =========================================================
// HEGEMONIA GLOBAL - LANCHA PATRULHA DRAW GUI EVENT
// v5.1 - Versão Simplificada e Testada - SEM ERROS
// =========================================================

if (selecionado) {
    // === CONFIGURAÇÕES BÁSICAS ===
    var _box_x = 20;
    var _box_y = display_get_gui_height() - 150;
    var _box_width = 300;
    var _line_height = 18;
    var _padding = 10;
    
    // === APLICAR FONTE COM FALLBACK ===
    if (font_exists(hegemonia_main)) {
        draw_set_font(hegemonia_main);
    } else {
        draw_set_font(-1); // Fonte padrão
    }
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    
    // === PREPARAR DADOS DINÂMICOS ===
    // Estado da lancha
    var _estado_texto = "PARADO";
    var _estado_cor = c_gray;
    
    if (variable_instance_exists(id, "estado")) {
        switch(estado) {
            case "movendo":
                _estado_texto = "MOVENDO";
                _estado_cor = c_lime;
                break;
            case "atacando":
                _estado_texto = "ATACANDO";
                _estado_cor = c_red;
                break;
            case "patrulhando":
                _estado_texto = "PATRULHANDO";
                _estado_cor = c_aqua;
                break;
        }
    }
    
    // Modo de combate
    var _modo_texto = "PASSIVO";
    var _modo_cor = c_gray;
    if (variable_instance_exists(id, "modo_ataque") && modo_ataque) {
        _modo_texto = "ATAQUE AGRESSIVO";
        _modo_cor = c_red;
    }
    
    // HP
    var _hp_texto = "300/300 (100%)";
    var _hp_cor = c_green;
    if (variable_instance_exists(id, "hp_atual") && variable_instance_exists(id, "hp_max")) {
        var _hp_percent = (hp_atual / hp_max) * 100;
        _hp_cor = (_hp_percent > 70) ? c_green : (_hp_percent > 40) ? c_yellow : c_red;
        _hp_texto = string(hp_atual) + "/" + string(hp_max) + " (" + string(round(_hp_percent)) + "%)";
    }
    
    // Velocidade
    var _velocidade_texto = "0.0/3.5";
    if (variable_instance_exists(id, "velocidade_atual") && variable_instance_exists(id, "velocidade_maxima")) {
        _velocidade_texto = string(round(velocidade_atual * 10) / 10) + "/" + string(velocidade_maxima);
    }
    
    // === DESENHAR FUNDO DO PAINEL ===
    // Fundo principal
    draw_set_color(c_black);
    draw_set_alpha(0.8);
    draw_rectangle(_box_x, _box_y, _box_x + _box_width, _box_y + 100, false);
    draw_set_alpha(1.0);
    
    // Borda
    draw_set_color(c_aqua);
    draw_set_alpha(0.9);
    draw_rectangle(_box_x, _box_y, _box_x + _box_width, _box_y + 100, true);
    draw_set_alpha(1.0);
    
    // === DESENHAR CONTEÚDO ===
    var _current_y = _box_y + _padding;
    
    // Título
    draw_set_color(c_white);
    draw_text(_box_x + _padding, _current_y, "🚢 LANCHA PATRULHA");
    _current_y += _line_height + 5;
    
    // Linha separadora
    draw_set_color(c_aqua);
    draw_set_alpha(0.6);
    draw_line(_box_x + _padding, _current_y, _box_x + _box_width - _padding, _current_y);
    draw_set_alpha(1.0);
    _current_y += 8;
    
    // Estado
    draw_set_color(c_white);
    draw_text(_box_x + _padding, _current_y, "Estado: ");
    var _text_width = string_width("Estado: ");
    draw_set_color(_estado_cor);
    draw_text(_box_x + _padding + _text_width, _current_y, _estado_texto);
    draw_set_color(c_white);
    _current_y += _line_height;
    
    // Modo
    draw_text(_box_x + _padding, _current_y, "Modo: ");
    _text_width = string_width("Modo: ");
    draw_set_color(_modo_cor);
    draw_text(_box_x + _padding + _text_width, _current_y, _modo_texto);
    draw_set_color(c_white);
    _current_y += _line_height;
    
    // HP
    draw_text(_box_x + _padding, _current_y, "HP: ");
    _text_width = string_width("HP: ");
    draw_set_color(_hp_cor);
    draw_text(_box_x + _padding + _text_width, _current_y, _hp_texto);
    draw_set_color(c_white);
    _current_y += _line_height;
    
    // Velocidade
    draw_text(_box_x + _padding, _current_y, "Velocidade: ");
    _text_width = string_width("Velocidade: ");
    draw_set_color(c_lime);
    draw_text(_box_x + _padding + _text_width, _current_y, _velocidade_texto);
    draw_set_color(c_white);
    _current_y += _line_height;
    
    // Posição
    draw_text(_box_x + _padding, _current_y, "Posição: (" + string(round(x)) + ", " + string(round(y)) + ")");
    
    // === BARRA DE HP VISUAL ===
    if (variable_instance_exists(id, "hp_atual") && variable_instance_exists(id, "hp_max") && hp_atual < hp_max) {
        var _bar_x = _box_x + _padding;
        var _bar_y = _box_y + 85;
        var _bar_width = _box_width - (_padding * 2);
        var _bar_height = 8;
        var _hp_percent = (hp_atual / hp_max) * 100;
        
        // Fundo da barra
        draw_set_color(c_dkgray);
        draw_set_alpha(0.8);
        draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_width, _bar_y + _bar_height, false);
        draw_set_alpha(1.0);
        
        // Barra de HP
        draw_set_color(_hp_cor);
        draw_set_alpha(0.9);
        draw_rectangle(_bar_x, _bar_y, _bar_x + (_bar_width * _hp_percent / 100), _bar_y + _bar_height, false);
        draw_set_alpha(1.0);
        
        // Borda da barra
        draw_set_color(c_white);
        draw_set_alpha(0.7);
        draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_width, _bar_y + _bar_height, true);
        draw_set_alpha(1.0);
    }
    
    // Resetar configurações
    draw_set_color(c_white);
    draw_set_alpha(1.0);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}