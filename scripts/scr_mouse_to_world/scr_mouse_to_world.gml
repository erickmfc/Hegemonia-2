/// @description scr_mouse_to_world()
/// Retorna [x_world, y_world] convertendo a posição do mouse para coordenadas do room

function scr_mouse_to_world() {
    // ✅ CORREÇÃO: Sistema de coordenadas simplificado e mais eficiente
    var _cam = view_camera[0];
    
    // Fallback seguro se câmera não existe
    if (_cam == -1 || _cam == noone) {
        return [mouse_x, mouse_y];
    }
    
    // Obter posição e dimensões da câmera
    var _cam_x = camera_get_view_x(_cam);
    var _cam_y = camera_get_view_y(_cam);
    var _cam_w = camera_get_view_width(_cam);
    var _cam_h = camera_get_view_height(_cam);
    
    // Verificar se dimensões são válidas
    if (_cam_w <= 0 || _cam_h <= 0) {
        return [mouse_x, mouse_y];
    }
    
    // Converter mouse GUI para coordenadas de tela
    var _mouse_gui_x = device_mouse_x_to_gui(0);
    var _mouse_gui_y = device_mouse_y_to_gui(0);
    
    // ✅ CORREÇÃO: Converter usando proporção da câmera vs display GUI
    // A posição do mouse na GUI precisa ser convertida para posição na câmera
    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();
    
    // Calcular a posição do mouse dentro da viewport (0.0 a 1.0)
    var _viewport_x = _mouse_gui_x / _gui_w;
    var _viewport_y = _mouse_gui_y / _gui_h;
    
    // Converter para posição no mundo baseado na câmera
    var _mx = _cam_x + (_viewport_x * _cam_w);
    var _my = _cam_y + (_viewport_y * _cam_h);
    
    return [_mx, _my];
}
