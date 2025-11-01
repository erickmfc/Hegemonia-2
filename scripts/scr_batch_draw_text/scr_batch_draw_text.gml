/// @description Desenha múltiplos textos em batch (otimizado)
/// @param {array} _text_array Array de objetos {x, y, text, color, font}
/// @param {real} _base_x Offset X base (opcional)
/// @param {real} _base_y Offset Y base (opcional)

function scr_batch_draw_text(_text_array, _base_x = 0, _base_y = 0) {
    
    if (array_length(_text_array) == 0) return;
    
    // Configurar font e alinhamento uma vez
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(-1);
    
    // Desenhar todos os textos
    for (var i = 0; i < array_length(_text_array); i++) {
        var _entry = _text_array[i];
        
        if (is_undefined(_entry)) continue;
        
        var _x = _base_x + (is_undefined(_entry.x) ? 0 : _entry.x);
        var _y = _base_y + (is_undefined(_entry.y) ? 0 : _entry.y);
        var _text = is_undefined(_entry.text) ? "" : _entry.text;
        var _color = is_undefined(_entry.color) ? c_white : _entry.color;
        var _font = is_undefined(_entry.font) ? -1 : _entry.font;
        
        if (_font != -1) {
            draw_set_font(_font);
        }
        
        draw_set_color(_color);
        draw_text(_x, _y, _text);
    }
    
    // Reset
    draw_set_font(-1);
    draw_set_color(c_white);
}

