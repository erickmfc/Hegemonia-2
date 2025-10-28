// ===============================================
// HEGEMONIA GLOBAL - IA PRESIDENTE 1
// Visualização e Status
// ===============================================

// Desenhar marcador circular da IA
draw_set_color(c_red);
draw_set_alpha(0.5);
draw_circle(x, y, 50, false);

// Desenhar nome da IA
draw_set_alpha(1.0);
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(x, y - 70, nome_ia);

// Desenhar status atual
draw_set_color(make_color_rgb(255, 100, 100));
draw_text(x, y - 55, "Objetivo: " + objetivo_atual);

// Desenhar recursos
var _cam = view_camera[0];
var _cam_x = camera_get_view_x(_cam);
var _cam_y = camera_get_view_y(_cam);

// Desenhar painel de recursos se estiver próximo à câmera
if (point_distance(x, y, _cam_x + camera_get_view_width(_cam)/2, _cam_y + camera_get_view_height(_cam)/2) < 400) {
    var _text_y = y - 40;
    
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    
    var _display_x = x - 100;
    draw_text(_display_x, _text_y, "💰 $" + string(global.ia_dinheiro));
    _text_y += 15;
    
    draw_text(_display_x, _text_y, "⛏️ " + string(global.ia_minerio) + " minério");
    _text_y += 15;
    
    draw_text(_display_x, _text_y, "👥 " + string(estruturas_totais) + " estruturas");
}

// Resetar configurações
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1.0);

