// ===============================================
// HEGEMONIA GLOBAL - BOTÃO DE CONSTRUÇÃO
// Bloco 3, Fase 1: Interface Visual
// ===============================================

// Posição fixa do botão na GUI
var btn_x = display_get_gui_width() - 80;
var btn_y = display_get_gui_height() - 80;

// Detectar hover do mouse
var mouse_gui_x = device_mouse_x_to_gui(0);
var mouse_gui_y = device_mouse_y_to_gui(0);
var is_hovering = (mouse_gui_x >= btn_x && mouse_gui_x <= btn_x + button_width && 
                  mouse_gui_y >= btn_y && mouse_gui_y <= btn_y + button_height);

// === SOMBRA DO BOTÃO ===
draw_set_color(c_black);
draw_set_alpha(0.3);
draw_roundrect_ext(btn_x + 3, btn_y + 3, btn_x + button_width + 3, btn_y + button_height + 3, 8, 8, false);

// === FUNDO DO BOTÃO ===
var bg_color = global.modo_construcao ? make_color_rgb(80, 150, 80) : make_color_rgb(60, 90, 120);
if (is_hovering) {
    bg_color = global.modo_construcao ? make_color_rgb(100, 180, 100) : make_color_rgb(80, 120, 160);
}

draw_set_color(bg_color);
draw_set_alpha(0.9);
draw_roundrect_ext(btn_x, btn_y, btn_x + button_width, btn_y + button_height, 8, 8, false);

// === BORDA DO BOTÃO ===
var border_color = global.modo_construcao ? make_color_rgb(120, 220, 120) : make_color_rgb(100, 140, 180);
draw_set_color(border_color);
draw_set_alpha(1.0);
draw_roundrect_ext(btn_x, btn_y, btn_x + button_width, btn_y + button_height, 8, 8, true);

// === ÍCONE DO MARTELO (DESENHO SIMPLES) ===
draw_set_color(c_white);
draw_set_alpha(1.0);

// Cabo do martelo
var center_x = btn_x + button_width/2;
var center_y = btn_y + button_height/2;
draw_line_width(center_x - 5, center_y + 15, center_x - 5, center_y - 10, 3);

// Cabeça do martelo
draw_rectangle(center_x - 12, center_y - 15, center_x + 2, center_y - 5, false);

// === TEXTO DE ESTADO ===
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);

if (font_exists(fnt_ui_main)) {
    draw_set_font(fnt_ui_main);
} else {
    draw_set_font(-1);
}

var status_text = global.modo_construcao ? "ATIVO" : "OFF";
draw_text_transformed(center_x, btn_y + button_height + 15, status_text, 0.7, 0.7, 0);

// Indicação da tecla de controle
draw_set_color(make_color_rgb(200, 200, 200));
draw_text_transformed(center_x, btn_y + button_height + 30, "(Tecla C)", 0.6, 0.6, 0);

// === INDICADOR DE MODO ===
if (global.modo_construcao) {
    // Círculo verde pulsante quando ativo
    var pulse = sin(current_time * 0.01) * 0.3 + 0.7;
    draw_set_color(make_color_rgb(100, 255, 100));
    draw_set_alpha(pulse);
    draw_circle(btn_x + button_width - 8, btn_y + 8, 4, false);
}

// Reset configurações de desenho
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_set_alpha(1.0);
draw_set_font(-1);
