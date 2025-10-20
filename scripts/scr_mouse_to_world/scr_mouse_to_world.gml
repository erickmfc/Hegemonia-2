/// @description scr_mouse_to_world()
/// Retorna [x_world, y_world] convertendo a posição do mouse para coordenadas do room

function scr_mouse_to_world() {
    // ✅ CORREÇÃO: Sistema de conversão de coordenadas mais robusto
    var _mouse_gui_x = device_mouse_x_to_gui(0);
    var _mouse_gui_y = device_mouse_y_to_gui(0);
    var _cam = view_camera[0];
    
    // Verificar se a câmera existe (usando verificação mais simples)
    if (_cam == -1 || _cam == noone) {
        show_debug_message("❌ ERRO: Câmera não existe!");
        return [0, 0];
    }
    
    var _cam_x = camera_get_view_x(_cam);
    var _cam_y = camera_get_view_y(_cam);
    var _cam_w = camera_get_view_width(_cam);
    var _cam_h = camera_get_view_height(_cam);
    
    // Verificar se as dimensões são válidas
    if (_cam_w <= 0 || _cam_h <= 0) {
        show_debug_message("❌ ERRO: Dimensões da câmera inválidas!");
        return [0, 0];
    }
    
    var _zoom_level_x = _cam_w / display_get_gui_width();
    var _zoom_level_y = _cam_h / display_get_gui_height();
    
    // ✅ CORREÇÃO: Usar a média dos zooms para evitar inconsistências
    var _zoom_level = (_zoom_level_x + _zoom_level_y) / 2;
    
    var _mx = _cam_x + (_mouse_gui_x * _zoom_level);
    var _my = _cam_y + (_mouse_gui_y * _zoom_level);
    
    // Debug para identificar problemas
    if (abs(_zoom_level_x - _zoom_level_y) > 0.1) {
        show_debug_message("⚠️ AVISO: Zoom inconsistente - X: " + string(_zoom_level_x) + " Y: " + string(_zoom_level_y));
    }
    
    return [_mx, _my];
}