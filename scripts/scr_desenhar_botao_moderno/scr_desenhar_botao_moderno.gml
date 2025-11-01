// =========================================================
// FUNÇÃO: scr_desenhar_botao_moderno
// Desenha botões com design moderno e fonte maior
// =========================================================

function scr_desenhar_botao_moderno(_x, _y, _width, _height, _text, _enabled, _mouse_x = -1, _mouse_y = -1) {
    
    // ✅ OTIMIZADO: Calcular mouse apenas se não fornecido
    if (_mouse_x < 0 || _mouse_y < 0) {
        _mouse_x = device_mouse_x_to_gui(0);
        _mouse_y = device_mouse_y_to_gui(0);
    }
    
    // Verificar se mouse está sobre o botão
    var _hover = point_in_rectangle(_mouse_x, _mouse_y, _x, _y, _x + _width, _y + _height);
    
    // === CORES BASEADAS NO ESTADO ===
    var _bg_color, _text_color, _border_color;
    
    if (!_enabled) {
        // Botão desabilitado
        _bg_color = make_color_rgb(60, 60, 60);
        _text_color = make_color_rgb(120, 120, 120);
        _border_color = make_color_rgb(40, 40, 40);
    } else if (_hover) {
        // Botão com hover
        _bg_color = make_color_rgb(80, 120, 160);
        _text_color = make_color_rgb(255, 255, 255);
        _border_color = make_color_rgb(100, 140, 180);
    } else {
        // Botão normal
        _bg_color = make_color_rgb(60, 100, 140);
        _text_color = make_color_rgb(255, 255, 255);
        _border_color = make_color_rgb(80, 120, 160);
    }
    
    // === DESENHAR BOTÃO ===
    // Fundo principal
    draw_set_color(_bg_color);
    draw_rectangle(_x, _y, _x + _width, _y + _height, false);
    
    // Borda
    draw_set_color(_border_color);
    draw_rectangle(_x - 1, _y - 1, _x + _width + 1, _y + _height + 1, false);
    
    // === TEXTO COM FONTE MAIOR ===
    draw_set_font(fnt_ui_main); // Garantir que a fonte está aplicada
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(_text_color);
    
    // Aplicar escala global para texto maior
    var _text_scale = 1.0;
    if (variable_global_exists("ui_scale")) {
        _text_scale = global.ui_scale;
    }
    
    // Texto centralizado com escala
    draw_text_transformed(_x + _width / 2, _y + _height / 2, _text, _text_scale, _text_scale, 0);
    
    // === EFEITO DE SOMBRA NO TEXTO ===
    if (_enabled) {
        draw_set_color(make_color_rgb(0, 0, 0));
        draw_text_transformed(_x + _width / 2 + 1, _y + _height / 2 + 1, _text, _text_scale, _text_scale, 0);
        draw_set_color(_text_color);
        draw_text_transformed(_x + _width / 2, _y + _height / 2, _text, _text_scale, _text_scale, 0);
    }
}