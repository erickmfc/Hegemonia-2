/// @description Draw GUI - Desenhar botão voltar ao menu
// Desenha o botão usando coordenadas GUI para funcionar em qualquer resolução

// === DIMENSÕES E POSICIONAMENTO ===
var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

// Menu ocupa 85% da tela (mesmo padrão do obj_texto_instrucoes)
var _menu_w = _gui_w * 0.85;
var _menu_h = _gui_h * 0.85;
var _menu_x = (_gui_w - _menu_w) / 2;
var _menu_y = (_gui_h - _menu_h) / 2;

// === BOTÃO VOLTAR AO MENU (FIXO NO FOOTER) ===
var _btn_voltar_y = _menu_y + _menu_h - 80;
var _btn_voltar_x = _menu_x + _menu_w / 2;
var _btn_width = 250;
var _btn_height = 60;

// Verificar se mouse está sobre o botão (para efeito hover)
var _mouse_gui_x = device_mouse_x_to_gui(0);
var _mouse_gui_y = device_mouse_y_to_gui(0);
var _btn_left = _btn_voltar_x - _btn_width/2;
var _btn_right = _btn_voltar_x + _btn_width/2;
var _btn_top = _btn_voltar_y;
var _btn_bottom = _btn_voltar_y + _btn_height;
var _mouse_over = (_mouse_gui_x >= _btn_left && _mouse_gui_x <= _btn_right &&
                   _mouse_gui_y >= _btn_top && _mouse_gui_y <= _btn_bottom);

// === DESENHAR FUNDO DO BOTÃO ===
if (_mouse_over) {
    draw_set_color(make_color_rgb(60, 100, 150)); // Mais claro quando hover
} else {
    draw_set_color(make_color_rgb(40, 80, 120)); // Cor normal
}
draw_set_alpha(0.9);
draw_roundrect_ext(_btn_left, _btn_top, _btn_right, _btn_bottom, 15, 15, false);

// === DESENHAR BORDA DO BOTÃO ===
draw_set_alpha(1.0);
if (_mouse_over) {
    draw_set_color(make_color_rgb(100, 150, 200)); // Borda mais clara quando hover
} else {
    draw_set_color(make_color_rgb(80, 120, 160)); // Borda normal
}
draw_roundrect_ext(_btn_left, _btn_top, _btn_right, _btn_bottom, 15, 15, true);

// === DESENHAR TEXTO DO BOTÃO ===
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
if (font_exists(fnt_ui_main)) {
    draw_set_font(fnt_ui_main);
} else {
    draw_set_font(-1); // Fonte padrão se fnt_ui_main não existir
}
draw_text_transformed(_btn_voltar_x, _btn_voltar_y + _btn_height/2, "VOLTAR AO MENU", 0.65, 0.65, 0);

// === RESETAR CONFIGURAÇÕES DE DESENHO ===
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1.0);
