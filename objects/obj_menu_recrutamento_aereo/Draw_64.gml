// ===============================================
// HEGEMONIA GLOBAL - MENU DE RECRUTAMENTO AÉREO
// Interface Visual Completa Inspirada nos Outros Menus
// ===============================================

// Verificar se o aeroporto ainda existe
if (id_do_aeroporto == noone || !instance_exists(id_do_aeroporto)) {
    instance_destroy();
    exit;
}

// === CONFIGURAÇÃO DE FONTE ===
if (font_exists(fnt_ui_main)) {
    draw_set_font(fnt_ui_main);
} else {
    draw_set_font(-1);
}

// === OVERLAY DE FUNDO ESCURO ===
draw_set_alpha(0.85);
draw_set_color(make_color_rgb(15, 20, 30));
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
draw_set_alpha(1);

// === PAINEL PRINCIPAL CENTRALIZADO ===
var _mw = display_get_gui_width() * 0.5;   // 50% da largura da tela
var _mh = display_get_gui_height() * 0.6;   // 60% da altura da tela
var _mx = (display_get_gui_width() - _mw) / 2;   // Centralizar horizontalmente
var _my = (display_get_gui_height() - _mh) / 2;   // Centralizar verticalmente

// Sombra do painel
draw_set_color(make_color_rgb(0, 0, 0));
draw_set_alpha(0.3);
draw_roundrect_ext(_mx + 4, _my + 4, _mx + _mw + 4, _my + _mh + 4, 12, 12, false);
draw_set_alpha(1);

// Fundo do painel principal - azul escuro aéreo
draw_set_color(make_color_rgb(25, 35, 55));
draw_set_alpha(0.95);
draw_roundrect_ext(_mx, _my, _mx + _mw, _my + _mh, 12, 12, false);
draw_set_alpha(1);

// Borda do painel
draw_set_color(make_color_rgb(70, 90, 120));
draw_roundrect_ext(_mx, _my, _mx + _mw, _my + _mh, 12, 12, true);

// === CABEÇALHO ===
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Título principal
draw_set_color(make_color_rgb(220, 230, 250));
scr_desenhar_texto_ui(_mx + _mw/2, _my + 40, "AEROPORTO MILITAR", 1.2, 1.2);

// Subtítulo
draw_set_color(make_color_rgb(180, 200, 220));
scr_desenhar_texto_ui(_mx + _mw/2, _my + 70, "Recrutamento de Unidades Aéreas", 0.8, 0.8);

// Dinheiro no canto superior esquerdo
draw_set_halign(fa_left);
draw_set_color(make_color_rgb(255, 215, 0));
scr_desenhar_texto_ui(_mx + 20, _my + 25, "Dinheiro: $" + string(global.dinheiro), 0.9, 0.9);

// === OBTER DADOS DAS UNIDADES DO AEROPORTO ===
var _unidades = id_do_aeroporto.unidades_disponiveis;
var _content_start_y = _my + 100;

// === UNIDADE 1: CAÇA F-5 ===
if (ds_list_size(_unidades) > 0) {
    var _unidade_f5 = ds_list_find_value(_unidades, 0);
    
    var _card_w = _mw - 40;
    var _card_h = 100;
    var _card_x = _mx + 20;
    var _card_y = _content_start_y;
    
    // Verificar se pode produzir
    var _pode_produzir_f5 = (global.dinheiro >= _unidade_f5.custo_dinheiro);
    var _card_color = _pode_produzir_f5 ? make_color_rgb(30, 45, 70) : make_color_rgb(45, 30, 30);
    var _border_color = _pode_produzir_f5 ? make_color_rgb(70, 130, 200) : make_color_rgb(200, 80, 80);
    
    // Fundo do card
    draw_set_color(_card_color);
    draw_set_alpha(0.9);
    draw_roundrect_ext(_card_x, _card_y, _card_x + _card_w, _card_y + _card_h, 8, 8, false);
    draw_set_alpha(1);
    
    // Borda do card
    draw_set_color(_border_color);
    draw_roundrect_ext(_card_x, _card_y, _card_x + _card_w, _card_y + _card_h, 8, 8, true);
    
    // Ícone da unidade (se existir)
    if (sprite_exists(spr_caca_f5)) {
        var _icon_x = _card_x + 20;
        var _icon_y = _card_y + _card_h/2;
        draw_sprite_ext(spr_caca_f5, 0, _icon_x, _icon_y, 2.0, 2.0, 0, c_white, 1);
    }
    
    // Informações da unidade
    var _info_x = _card_x + 80;
    var _info_y = _card_y + 20;
    
    draw_set_halign(fa_left);
    draw_set_color(c_white);
    scr_desenhar_texto_ui(_info_x, _info_y, _unidade_f5.nome, 1.0, 1.0);
    
    _info_y += 25;
    draw_set_color(make_color_rgb(180, 200, 220));
    scr_desenhar_texto_ui(_info_x, _info_y, _unidade_f5.descricao, 0.8, 0.8);
    
    _info_y += 20;
    draw_set_color(make_color_rgb(255, 215, 0));
    scr_desenhar_texto_ui(_info_x, _info_y, "Custo: $" + string(_unidade_f5.custo_dinheiro), 0.9, 0.9);
    
    _info_y += 20;
    draw_set_color(make_color_rgb(150, 150, 150));
    scr_desenhar_texto_ui(_info_x, _info_y, "População: " + string(_unidade_f5.custo_populacao), 0.8, 0.8);
    
    // Botão de produção
    var _btn_w = 120;
    var _btn_h = 35;
    var _btn_x = _card_x + _card_w - _btn_w - 15;
    var _btn_y = _card_y + (_card_h - _btn_h) / 2;
    
    scr_desenhar_botao_ui(_btn_x, _btn_y, _btn_w, _btn_h, "PRODUZIR", _pode_produzir_f5, 0.9);
}

// === UNIDADE 2: HELICÓPTERO MILITAR ===
if (ds_list_size(_unidades) > 1) {
    var _unidade_heli = ds_list_find_value(_unidades, 1);
    
    var _card_w = _mw - 40;
    var _card_h = 100;
    var _card_x = _mx + 20;
    var _card_y = _content_start_y + 120;
    
    // Verificar se pode produzir
    var _pode_produzir_heli = (global.dinheiro >= _unidade_heli.custo_dinheiro);
    var _card_color = _pode_produzir_heli ? make_color_rgb(30, 45, 70) : make_color_rgb(45, 30, 30);
    var _border_color = _pode_produzir_heli ? make_color_rgb(70, 130, 200) : make_color_rgb(200, 80, 80);
    
    // Fundo do card
    draw_set_color(_card_color);
    draw_set_alpha(0.9);
    draw_roundrect_ext(_card_x, _card_y, _card_x + _card_w, _card_y + _card_h, 8, 8, false);
    draw_set_alpha(1);
    
    // Borda do card
    draw_set_color(_border_color);
    draw_roundrect_ext(_card_x, _card_y, _card_x + _card_w, _card_y + _card_h, 8, 8, true);
    
    // Ícone da unidade (se existir)
    if (sprite_exists(spr_helicoptero_militar)) {
        var _icon_x = _card_x + 20;
        var _icon_y = _card_y + _card_h/2;
        draw_sprite_ext(spr_helicoptero_militar, 0, _icon_x, _icon_y, 2.0, 2.0, 0, c_white, 1);
    }
    
    // Informações da unidade
    var _info_x = _card_x + 80;
    var _info_y = _card_y + 20;
    
    draw_set_halign(fa_left);
    draw_set_color(c_white);
    scr_desenhar_texto_ui(_info_x, _info_y, _unidade_heli.nome, 1.0, 1.0);
    
    _info_y += 25;
    draw_set_color(make_color_rgb(180, 200, 220));
    scr_desenhar_texto_ui(_info_x, _info_y, _unidade_heli.descricao, 0.8, 0.8);
    
    _info_y += 20;
    draw_set_color(make_color_rgb(255, 215, 0));
    scr_desenhar_texto_ui(_info_x, _info_y, "Custo: $" + string(_unidade_heli.custo_dinheiro), 0.9, 0.9);
    
    _info_y += 20;
    draw_set_color(make_color_rgb(150, 150, 150));
    scr_desenhar_texto_ui(_info_x, _info_y, "População: " + string(_unidade_heli.custo_populacao), 0.8, 0.8);
    
    // Botão de produção
    var _btn_w = 120;
    var _btn_h = 35;
    var _btn_x = _card_x + _card_w - _btn_w - 15;
    var _btn_y = _card_y + (_card_h - _btn_h) / 2;
    
    scr_desenhar_botao_ui(_btn_x, _btn_y, _btn_w, _btn_h, "PRODUZIR", _pode_produzir_heli, 0.9);
}

// === UNIDADE 3: C-100 TRANSPORTE ===
if (ds_list_size(_unidades) > 2) {
    var _unidade_c100 = ds_list_find_value(_unidades, 2);
    
    var _card_w = _mw - 40;
    var _card_h = 100;
    var _card_x = _mx + 20;
    var _card_y = _content_start_y + 240;
    
    var _pode_produzir_c100 = (global.dinheiro >= _unidade_c100.custo_dinheiro);
    var _card_color = _pode_produzir_c100 ? make_color_rgb(30, 45, 70) : make_color_rgb(45, 30, 30);
    var _border_color = _pode_produzir_c100 ? make_color_rgb(70, 130, 200) : make_color_rgb(200, 80, 80);
    
    draw_set_color(_card_color);
    draw_set_alpha(0.9);
    draw_roundrect_ext(_card_x, _card_y, _card_x + _card_w, _card_y + _card_h, 8, 8, false);
    draw_set_alpha(1);
    
    draw_set_color(_border_color);
    draw_roundrect_ext(_card_x, _card_y, _card_x + _card_w, _card_y + _card_h, 8, 8, true);
    
    if (sprite_exists(spr_c100)) {
        var _icon_x = _card_x + 20;
        var _icon_y = _card_y + _card_h/2;
        draw_sprite_ext(spr_c100, 0, _icon_x, _icon_y, 1.0, 1.0, 0, c_white, 1);
    }
    
    var _info_x = _card_x + 80;
    var _info_y = _card_y + 20;
    draw_set_halign(fa_left);
    draw_set_color(c_white);
    scr_desenhar_texto_ui(_info_x, _info_y, _unidade_c100.nome, 1.0, 1.0);
    _info_y += 25;
    draw_set_color(make_color_rgb(180, 200, 220));
    scr_desenhar_texto_ui(_info_x, _info_y, _unidade_c100.descricao, 0.8, 0.8);
    _info_y += 20;
    draw_set_color(make_color_rgb(255, 215, 0));
    scr_desenhar_texto_ui(_info_x, _info_y, "Custo: $" + string(_unidade_c100.custo_dinheiro), 0.9, 0.9);
    _info_y += 20;
    draw_set_color(make_color_rgb(150, 150, 150));
    scr_desenhar_texto_ui(_info_x, _info_y, "População: " + string(_unidade_c100.custo_populacao), 0.8, 0.8);
    
    var _btn_w = 120;
    var _btn_h = 35;
    var _btn_x = _card_x + _card_w - _btn_w - 15;
    var _btn_y = _card_y + (_card_h - _btn_h) / 2;
    
    scr_desenhar_botao_ui(_btn_x, _btn_y, _btn_w, _btn_h, "PRODUZIR", _pode_produzir_c100, 0.9);
}

// === STATUS DE PRODUÇÃO ===
if (id_do_aeroporto.produzindo) {
    var _status_y = _my + _mh - 60;
    draw_set_halign(fa_center);
    draw_set_color(make_color_rgb(255, 180, 0));
    scr_desenhar_texto_ui(_mx + _mw/2, _status_y, "⚠️ PRODUZINDO UNIDADE...", 1.0, 1.0);
    
    // Barra de progresso
    var _bar_w = _mw - 80;
    var _bar_h = 15;
    var _bar_x = _mx + 40;
    var _bar_y = _status_y + 25;
    
    // Fundo da barra
    draw_set_color(make_color_rgb(50, 50, 50));
    draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_w, _bar_y + _bar_h, false);
    
    // Progresso
    if (!ds_queue_empty(id_do_aeroporto.fila_producao)) {
        var _unidade_atual = ds_queue_head(id_do_aeroporto.fila_producao);
        var _progresso = id_do_aeroporto.timer_producao / _unidade_atual.tempo_treino;
        var _progresso_w = _bar_w * _progresso;
        
        draw_set_color(make_color_rgb(100, 200, 100));
        draw_rectangle(_bar_x, _bar_y, _bar_x + _progresso_w, _bar_y + _bar_h, false);
    }
    
    // Borda da barra
    draw_set_color(make_color_rgb(200, 200, 200));
    draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_w, _bar_y + _bar_h, true);
}

// === BOTÃO FECHAR ===
var _fechar_w = 80;
var _fechar_h = 30;
var _fechar_x = _mx + _mw - _fechar_w - 20;
var _fechar_y = _my + _mh - _fechar_h - 20;

scr_desenhar_botao_ui(_fechar_x, _fechar_y, _fechar_w, _fechar_h, "FECHAR", true, 0.8);

// === INSTRUÇÕES ===
draw_set_halign(fa_center);
draw_set_color(make_color_rgb(150, 150, 150));
scr_desenhar_texto_ui(_mx + _mw/2, _my + _mh - 15, "Clique nos botões para produzir unidades aéreas", 0.7, 0.7);

// Reset alinhamento
draw_set_halign(fa_left);
draw_set_valign(fa_top);
