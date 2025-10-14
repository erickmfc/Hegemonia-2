// Clique direito: define novo destino
if (mouse_check_button_pressed(mb_right)) {
    var mx = camera_get_view_x(view_camera[0]) + mouse_x;
    var my = camera_get_view_y(view_camera[0]) + mouse_y;
    destino_x = mx;
    destino_y = my;
}
