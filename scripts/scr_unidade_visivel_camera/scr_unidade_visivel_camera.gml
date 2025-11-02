/// @description Verifica se uma unidade está visível na câmera/viewport
/// @param {real} unit_x Posição X da unidade no mundo
/// @param {real} unit_y Posição Y da unidade no mundo
/// @param {real} margin Margem extra em pixels (padrão: 100)
/// @return {bool} true se a unidade está visível na câmera

// ✅ CORREÇÃO: Usar sintaxe de script tradicional do GameMaker
var _unit_x = argument0;
var _unit_y = argument1;
var _margin = (argument_count >= 3) ? argument2 : 100; // Margem padrão: 100 pixels

var _cam = view_camera[0];

// Se não há câmera, considerar visível (fallback)
if (_cam == -1 || _cam == noone) {
    return true;
}

// Obter área visível da câmera
var _cam_x = camera_get_view_x(_cam);
var _cam_y = camera_get_view_y(_cam);
var _cam_w = camera_get_view_width(_cam);
var _cam_h = camera_get_view_height(_cam);

// Verificar se dimensões são válidas
if (_cam_w <= 0 || _cam_h <= 0) {
    return true; // Fallback: considerar visível
}

// Área visível com margem
var _view_left = _cam_x - _margin;
var _view_right = _cam_x + _cam_w + _margin;
var _view_top = _cam_y - _margin;
var _view_bottom = _cam_y + _cam_h + _margin;

// Verificar se a unidade está dentro da área visível
return (_unit_x >= _view_left && _unit_x <= _view_right && 
        _unit_y >= _view_top && _unit_y <= _view_bottom);

