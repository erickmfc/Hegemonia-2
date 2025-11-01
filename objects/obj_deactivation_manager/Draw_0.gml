// =============================================
// DEBUG VISUAL (OPCIONAL)
// =============================================

if (!variable_global_exists("debug_enabled") || !global.debug_enabled) {
    exit;
}

if (!instance_exists(obj_input_manager)) {
    exit;
}

// Desenhar área de ativação
var cam = view_camera[0];
if (cam == noone) exit;

var cam_x = camera_get_view_x(cam);
var cam_y = camera_get_view_y(cam);
var cam_w = camera_get_view_width(cam);
var cam_h = camera_get_view_height(cam);

// Área visível (viewport)
draw_set_color(c_green);
draw_set_alpha(0.3);
draw_rectangle(cam_x, cam_y, cam_x + cam_w, cam_y + cam_h, false);

// Área de ativação (viewport + margem)
draw_set_color(c_yellow);
draw_set_alpha(0.2);
draw_rectangle(cam_x - margin_padding, cam_y - margin_padding,
               cam_x + cam_w + margin_padding, cam_y + cam_h + margin_padding, false);

// Texto de debug
draw_set_alpha(1.0);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_text(cam_x + 10, cam_y + 10, "Ativadas: " + string(stats_activated));
draw_text(cam_x + 10, cam_y + 30, "Desativadas: " + string(stats_deactivated));
draw_text(cam_x + 10, cam_y + 50, "Checks: " + string(stats_check_count));
