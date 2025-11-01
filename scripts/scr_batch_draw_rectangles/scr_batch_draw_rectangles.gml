/// @description Desenha múltiplos retângulos em batch (otimizado)
/// @param {array} _rect_array Array de objetos {x1, y1, x2, y2, color, alpha, filled}

function scr_batch_draw_rectangles(_rect_array) {
    
    if (array_length(_rect_array) == 0) return;
    
    // Agrupar por cor para reduzir mudanças de estado
    var _current_color = c_white;
    var _current_alpha = 1.0;
    var _current_filled = false;
    
    for (var i = 0; i < array_length(_rect_array); i++) {
        var _rect = _rect_array[i];
        
        if (is_undefined(_rect)) continue;
        
        var _color = is_undefined(_rect.color) ? c_white : _rect.color;
        var _alpha = is_undefined(_rect.alpha) ? 1.0 : _rect.alpha;
        var _filled = is_undefined(_rect.filled) ? false : _rect.filled;
        
        // Só mudar estado se necessário (otimização)
        if (_color != _current_color || _alpha != _current_alpha) {
            draw_set_color(_color);
            draw_set_alpha(_alpha);
            _current_color = _color;
            _current_alpha = _alpha;
        }
        
        // Desenhar retângulo
        draw_rectangle(_rect.x1, _rect.y1, _rect.x2, _rect.y2, _filled);
    }
    
    // Reset
    draw_set_color(c_white);
    draw_set_alpha(1.0);
}

