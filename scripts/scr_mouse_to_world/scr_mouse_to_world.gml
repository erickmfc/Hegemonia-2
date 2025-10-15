/// @description scr_mouse_to_world()
/// Retorna [x_world, y_world] convertendo a posição do mouse para coordenadas do room

function scr_mouse_to_world() {
    // Conversão de coordenadas do mouse para o mundo (com zoom)
    var _mouse_gui_x = device_mouse_x_to_gui(0);
    var _mouse_gui_y = device_mouse_y_to_gui(0);
    var _cam = view_camera[0];
    var _cam_x = camera_get_view_x(_cam);
    var _cam_y = camera_get_view_y(_cam);
    var _cam_w = camera_get_view_width(_cam);
    var _cam_h = camera_get_view_height(_cam);
    var _zoom_level_x = _cam_w / display_get_gui_width();
    var _zoom_level_y = _cam_h / display_get_gui_height();
    var _mx = _cam_x + (_mouse_gui_x * _zoom_level_x);
    var _my = _cam_y + (_mouse_gui_y * _zoom_level_y);
    
    return [_mx, _my];
}