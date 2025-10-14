// ===============================================
// HEGEMONIA GLOBAL - DESTROYER
// Sistema de Controle com Coordenadas do Mundo
// ===============================================

// Clique direito para mover
if (mouse_check_button_pressed(mb_right)) {
    if (!selecionado) {
        show_debug_message("❌ DESTROYER NÃO SELECIONADO - Clique esquerdo primeiro!");
        exit;
    }
    
    // Conversão de coordenadas com zoom
    var _mouse_gui_x = device_mouse_x_to_gui(0);
    var _mouse_gui_y = device_mouse_y_to_gui(0);
    var _cam = view_camera[0];
    var _cam_x = camera_get_view_x(_cam);
    var _cam_y = camera_get_view_y(_cam);
    var _cam_w = camera_get_view_width(_cam);
    var _cam_h = camera_get_view_height(_cam);
    var _zoom_level_x = _cam_w / display_get_gui_width();
    var _zoom_level_y = _cam_h / display_get_gui_height();
    
    destino_x = _cam_x + (_mouse_gui_x * _zoom_level_x);
    destino_y = _cam_y + (_mouse_gui_y * _zoom_level_y);
    estado = "movendo";
    movendo = true;
    
    moving_to_target = true;
    target_x = destino_x;
    target_y = destino_y;
    
    show_debug_message("🚢 Destroyer movendo para: (" + string(destino_x) + ", " + string(destino_y) + ")");
}
