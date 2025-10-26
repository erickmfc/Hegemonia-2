// ===============================================
// HEGEMONIA GLOBAL - NAVIO TRANSPORTE (DRAW GUI)
// Menu de Carga Interativo
// ===============================================

// CHAMAR O PAI PRIMEIRO (GARANTIR QUE BASE É EXECUTADO)
event_inherited();

// SE NÃO ESTÁ SELECIONADO, SAIR
if (!variable_instance_exists(id, "selecionado") || !selecionado) {
    exit;
}

var _cam = view_camera[0];
var _cam_x = camera_get_view_x(_cam);
var _cam_y = camera_get_view_y(_cam);
var _cam_w = camera_get_view_width(_cam);
var _cam_h = camera_get_view_height(_cam);

var _proj_x = (x - _cam_x) / (_cam_w / display_get_gui_width());
var _proj_y = (y - _cam_y) / (_cam_h / display_get_gui_height());

// === 1. CAIXA DE INFORMAÇÕES RÁPIDAS ===
var _info_x = _proj_x;
var _info_y = _proj_y - 100;
var _info_w = 180;
var _info_h = 120;

draw_set_color(c_black);
draw_set_alpha(0.85);
draw_rectangle(_info_x - _info_w/2, _info_y - _info_h/2, _info_x + _info_w/2, _info_y + _info_h/2, false);
draw_set_alpha(1.0);

draw_set_color(c_white);
draw_rectangle(_info_x - _info_w/2, _info_y - _info_h/2, _info_x + _info_w/2, _info_y + _info_h/2, true);

draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(c_yellow);

var _text_x = _info_x;
var _text_y = _info_y - _info_h/2 + 5;

draw_text(_text_x, _text_y, "NAVIO TRANSPORTE");
_text_y += 18;

// HP
var _hp_percent = (hp_atual / hp_max) * 100;
if (_hp_percent < 30) draw_set_color(c_red);
else if (_hp_percent < 60) draw_set_color(c_yellow);
else draw_set_color(c_white);

draw_text(_text_x, _text_y, "HP: " + string(round(_hp_percent)) + "%");
_text_y += 18;

// Estado
draw_set_color(make_color_rgb(0, 255, 255));
var _estado_texto = "PARADO";
if (variable_instance_exists(id, "estado")) {
    if (estado == LanchaState.MOVENDO) _estado_texto = "NAVEGANDO";
    else if (estado == LanchaState.PATRULHANDO) _estado_texto = "PATRULHANDO";
    else if (estado == LanchaState.ATACANDO) _estado_texto = "ATACANDO";
}

draw_text(_text_x, _text_y, "Estado: " + _estado_texto);
_text_y += 18;

// Modo combate
if (variable_instance_exists(id, "modo_combate")) {
    if (modo_combate == LanchaMode.ATAQUE) {
        draw_set_color(c_red);
        draw_text(_text_x, _text_y, "MODO ATAQUE");
    } else {
        draw_set_color(c_gray);
        draw_text(_text_x, _text_y, "MODO PASSIVO");
    }
}

// === 2. MENU DE CARGA (COMANDO J) ===
if (variable_instance_exists(id, "menu_carga_aberto") && menu_carga_aberto) {
    var _menu_x = 100;
    var _menu_y = 100;
    var _menu_w = 350;
    var _menu_h = 280;

    // Fundo do menu
    draw_set_alpha(0.95);
    draw_set_color(c_black);
    draw_rectangle(_menu_x, _menu_y, _menu_x + _menu_w, _menu_y + _menu_h, false);

    // Borda
    draw_set_alpha(1.0);
    draw_set_color(c_yellow);
    draw_rectangle(_menu_x, _menu_y, _menu_x + _menu_w, _menu_y + _menu_h, true);

    // Título
    draw_set_halign(fa_left);
    draw_set_color(c_yellow);
    draw_set_valign(fa_top);
    draw_text(_menu_x + 15, _menu_y + 15, "📦 CARGA DO NAVIO");

    var _line_y = _menu_y + 45;
    var _col1_x = _menu_x + 20;
    var _col2_x = _menu_x + 200;

    // ✈️ Aeronaves
    draw_set_color(c_white);
    draw_text(_col1_x, _line_y, "✈️ Aeronaves:");
    draw_set_color(make_color_rgb(0, 255, 255));
    draw_text(_col2_x, _line_y, string(avioes_count) + "/" + string(avioes_max));
    _line_y += 30;

    // 🚛 Veículos
    draw_set_color(c_white);
    draw_text(_col1_x, _line_y, "🚛 Veículos:");
    draw_set_color(make_color_rgb(0, 255, 255));
    draw_text(_col2_x, _line_y, string(unidades_count) + "/" + string(unidades_max));
    _line_y += 30;

    // 👥 Soldados
    draw_set_color(c_white);
    draw_text(_col1_x, _line_y, "👥 Soldados:");
    draw_set_color(make_color_rgb(0, 255, 255));
    draw_text(_col2_x, _line_y, string(soldados_count) + "/" + string(soldados_max));
    _line_y += 40;

    // Barra de carga
    var _percent = ((avioes_count + unidades_count + soldados_count) / (avioes_max + unidades_max + soldados_max)) * 100;
    draw_set_color(c_gray);
    draw_rectangle(_menu_x + 20, _line_y, _menu_x + _menu_w - 20, _line_y + 15, false);

    var _cor_barra = c_green;
    if (_percent > 75) _cor_barra = c_orange;
    if (_percent >= 100) _cor_barra = c_red;

    draw_set_color(_cor_barra);
    draw_rectangle(_menu_x + 20, _line_y, _menu_x + 20 + ((_menu_w - 40) * _percent / 100), _line_y + 15, false);

    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_text(_menu_x + _menu_w/2, _line_y + 2, string(round(_percent)) + "%");

    _line_y += 35;

    // Botão DESEMBARCAR TODOS
    draw_set_halign(fa_center);
    draw_set_valign(fa_center);
    var _btn1_x = _menu_x + 80;
    var _btn1_y = _line_y + 20;
    var _btn1_w = 120;
    var _btn1_h = 40;

    draw_set_color(c_yellow);
    draw_rectangle(_btn1_x - _btn1_w/2, _btn1_y - _btn1_h/2, _btn1_x + _btn1_w/2, _btn1_y + _btn1_h/2, false);
    draw_set_color(c_black);
    draw_text(_btn1_x, _btn1_y, "DESEMBARCAR");

    // Botão FECHAR
    var _btn2_x = _menu_x + 270;
    var _btn2_y = _line_y + 20;
    var _btn2_w = 60;
    var _btn2_h = 40;

    draw_set_color(c_red);
    draw_rectangle(_btn2_x - _btn2_w/2, _btn2_y - _btn2_h/2, _btn2_x + _btn2_w/2, _btn2_y + _btn2_h/2, false);
    draw_set_color(c_white);
    draw_text(_btn2_x, _btn2_y, "FECHAR");

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// Resetar configurações
draw_set_alpha(1.0);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
