// ===============================================
// HEGEMONIA GLOBAL - MENU DE RECRUTAMENTO MILITAR
// Interface Visual Inspirada no Quartel de Marinha
// ===============================================

// === DEBUG: VERIFICAR SE DRAW ESTÁ EXECUTANDO ===
if (global.game_frame mod 60 == 0) { // A cada 1 segundo
    show_debug_message("🎨 DRAW EVENT EXECUTANDO - Menu ID: " + string(id));
    show_debug_message("   Posição: (" + string(x) + ", " + string(y) + ")");
    show_debug_message("   Display: " + string(display_get_gui_width()) + "x" + string(display_get_gui_height()));
}

// Verificar se o quartel ainda existe
if (id_do_quartel == noone || !instance_exists(id_do_quartel)) {
    show_debug_message("❌ Quartel não existe mais - destruindo menu");
    instance_destroy();
    exit;
}

// ✅ OVERLAY DE FUNDO ESCURO (igual ao quartel de marinha)
draw_set_alpha(0.85);
draw_set_color(make_color_rgb(15, 20, 30));
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
draw_set_alpha(1.0);

// ✅ CENTRALIZAÇÃO AUTOMÁTICA (igual ao quartel de marinha)
var _mw = display_get_gui_width() * 0.5;   // 50% da largura da tela
var _mh = display_get_gui_height() * 0.6;   // 60% da altura da tela
var _mx = (display_get_gui_width() - _mw) / 2;   // Centralizar horizontalmente
var _my = (display_get_gui_height() - _mh) / 2;   // Centralizar verticalmente

// ✅ VISUAL IGUAL AO QUARTEL DE MARINHA
// Sombra do painel
draw_set_color(make_color_rgb(0, 0, 0));
draw_set_alpha(0.3);
draw_roundrect_ext(_mx + 4, _my + 4, _mx + _mw + 4, _my + _mh + 4, 12, 12, false);
draw_set_alpha(1);

// Fundo do painel principal - verde escuro militar
draw_set_color(make_color_rgb(25, 45, 35));
draw_set_alpha(0.95);
draw_roundrect_ext(_mx, _my, _mx + _mw, _my + _mh, 12, 12, false);
draw_set_alpha(1);

// Borda do painel
draw_set_color(make_color_rgb(70, 120, 90));
draw_roundrect_ext(_mx, _my, _mx + _mw, _my + _mh, 12, 12, true);

// ✅ TÍTULO IGUAL AO QUARTEL DE MARINHA
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Título principal (centralizado sem ícone)
draw_set_color(make_color_rgb(220, 250, 230));
draw_set_font(-1);
draw_text(_mx + _mw/2, _my + 40, "QUARTEL MILITAR");

// Subtítulo
draw_set_color(make_color_rgb(180, 220, 200));
draw_text(_mx + _mw/2, _my + 70, "Recrutamento de Unidades Terrestres");

// Dinheiro no canto superior esquerdo
draw_set_halign(fa_left);
draw_set_color(make_color_rgb(255, 215, 0));
draw_text(_mx + 20, _my + 25, "Dinheiro: $" + string(global.dinheiro));

// ✅ LAYOUT ORGANIZADO COM ESPAÇAMENTO ADEQUADO
var _content_start_y = _my + 100;

// === SEÇÃO DE UNIDADES (4 UNIDADES EM GRID 2x2) ===
var _unit_section_y = _content_start_y;
var _unit_card_w = (_mw - 60) / 2; // 2 colunas
var _unit_card_h = 140; // Altura aumentada para acomodar mais informações
var _unit_spacing_x = 20;
var _unit_spacing_y = 20;

// Obter informações das unidades do quartel
var _unidades = id_do_quartel.unidades_disponiveis;
var _num_unidades = ds_list_size(_unidades);

// Desenhar cards das unidades em grid 2x2
for (var i = 0; i < _num_unidades; i++) {
    var _unidade = ds_list_find_value(_unidades, i);
    
    // Calcular posição do card
    var _col = i mod 2;
    var _row = floor(i / 2);
    var _unit_card_x = _mx + 20 + (_col * (_unit_card_w + _unit_spacing_x));
    var _unit_card_y = _unit_section_y + (_row * (_unit_card_h + _unit_spacing_y));
    
    // Verificar se pode produzir esta unidade
    var _can_produce = true;
    if (instance_exists(id_do_quartel)) {
        _can_produce = !id_do_quartel.esta_treinando && global.dinheiro >= _unidade.custo_dinheiro;
    }
    
    // Fundo do card da unidade
    draw_set_color(make_color_rgb(30, 55, 40));
    draw_set_alpha(0.9);
    draw_roundrect_ext(_unit_card_x, _unit_card_y, _unit_card_x + _unit_card_w, _unit_card_y + _unit_card_h, 8, 8, false);
    draw_set_alpha(1);
    
    // Borda do card (cor baseada na disponibilidade)
    var _border_color = _can_produce ? make_color_rgb(70, 150, 100) : make_color_rgb(100, 100, 100);
    draw_set_color(_border_color);
    draw_roundrect_ext(_unit_card_x, _unit_card_y, _unit_card_x + _unit_card_w, _unit_card_y + _unit_card_h, 8, 8, true);
    
    // === ÍCONE DA UNIDADE ===
    var _icon_x = _unit_card_x + 20;
    var _icon_y = _unit_card_y + 30;
    if (sprite_exists(_unidade.sprite)) {
        draw_sprite_ext(_unidade.sprite, 0, _icon_x, _icon_y, 2.0, 2.0, 0, make_color_rgb(255, 255, 255), 1);
    }
    
    // === INFORMAÇÕES DA UNIDADE ===
    var _info_x = _unit_card_x + 80;
    var _info_y = _unit_card_y + 20;
    
    draw_set_halign(fa_left);
    draw_set_color(make_color_rgb(255, 255, 255));
    draw_text(_info_x, _info_y, _unidade.nome);
    
    _info_y += 25;
    draw_set_color(make_color_rgb(180, 220, 200));
    draw_text(_info_x, _info_y, _unidade.descricao);
    
    _info_y += 20;
    draw_set_color(make_color_rgb(255, 215, 0));
    draw_text(_info_x, _info_y, "Custo: $" + string(_unidade.custo_dinheiro));
    
    _info_y += 20;
    draw_set_color(make_color_rgb(150, 150, 150));
    draw_text(_info_x, _info_y, "Pop: " + string(_unidade.custo_populacao) + " | Tempo: " + string(_unidade.tempo_treino / 60) + "s");
    
    // === BOTÃO DE PRODUÇÃO ===
    var _btn_x = _unit_card_x + _unit_card_w - 100;
    var _btn_y = _unit_card_y + _unit_card_h - 35;
    var _btn_w = 80;
    var _btn_h = 30;
    
    // Cor do botão baseada na disponibilidade
    var _btn_color = _can_produce ? make_color_rgb(57, 125, 82) : make_color_rgb(100, 100, 100);
    
    // Fundo do botão
    draw_set_color(_btn_color);
    draw_roundrect_ext(_btn_x, _btn_y, _btn_x + _btn_w, _btn_y + _btn_h, 6, 6, false);
    
    // Borda do botão
    draw_set_color(make_color_rgb(255, 255, 255));
    draw_roundrect_ext(_btn_x, _btn_y, _btn_x + _btn_w, _btn_y + _btn_h, 6, 6, true);
    
    // Texto do botão
    draw_set_halign(fa_center);
    draw_set_color(make_color_rgb(255, 255, 255));
    draw_text(_btn_x + _btn_w/2, _btn_y + _btn_h/2, "RECRUTAR");
}

// === SEÇÃO DE STATUS DO QUARTEL ===
var _status_section_y = _unit_section_y + (2 * (_unit_card_h + _unit_spacing_y)) + 20;
var _status_card_w = _mw - 40;
var _status_card_h = 100;
var _status_card_x = _mx + 20;
var _status_card_y = _status_section_y;

// Fundo do card de status
draw_set_color(make_color_rgb(30, 55, 40));
draw_set_alpha(0.9);
draw_roundrect_ext(_status_card_x, _status_card_y, _status_card_x + _status_card_w, _status_card_y + _status_card_h, 8, 8, false);
draw_set_alpha(1);

// Borda do card
draw_set_color(make_color_rgb(70, 150, 100));
draw_roundrect_ext(_status_card_x, _status_card_y, _status_card_x + _status_card_w, _status_card_y + _status_card_h, 8, 8, true);

// Título da seção
draw_set_halign(fa_center);
draw_set_color(make_color_rgb(200, 240, 220));
draw_text(_status_card_x + _status_card_w/2, _status_card_y + 20, "STATUS DO QUARTEL");

// Informações do quartel
if (id_do_quartel != noone && instance_exists(id_do_quartel)) {
    var _fila_size = ds_queue_size(id_do_quartel.fila_recrutamento);
    var _unidades_treinadas = id_do_quartel.unidades_criadas;
    
    var _status_info_y = _status_card_y + 45;
    
    // Fila de recrutamento
    draw_set_halign(fa_left);
    draw_set_color(make_color_rgb(180, 220, 200));
    draw_text(_status_card_x + 20, _status_info_y, "Fila: " + string(_fila_size) + " unidades");
    
    // Unidades treinadas
    draw_text(_status_card_x + 20, _status_info_y + 20, "Treinadas: " + string(_unidades_treinadas) + " unidades");
    
    // Status do quartel
    var _status_text = "";
    var _status_color = make_color_rgb(255, 255, 255);
    
    if (id_do_quartel.esta_treinando) {
        _status_text = "TREINANDO...";
        _status_color = make_color_rgb(255, 180, 0);
    } else {
        _status_text = "OCIOSO";
        _status_color = make_color_rgb(80, 200, 80);
    }
    
    draw_set_color(_status_color);
    draw_text(_status_card_x + 20, _status_info_y + 40, "Status: " + _status_text);
}

// === SEÇÃO DE INSTRUÇÕES ===
var _instr_y = _status_card_y + _status_card_h + 20;
draw_set_halign(fa_center);
draw_set_color(make_color_rgb(150, 150, 150));
draw_text(_mx + _mw/2, _instr_y, "Clique em RECRUTAR para adicionar unidade à fila de treinamento");

// === BOTÃO FECHAR ===
var _close_w = 110;
var _close_h = 44;
var _close_x = _mx + _mw - _close_w - 20;
var _close_y = _my + _mh - 60;

draw_set_color(make_color_rgb(122, 41, 41));
draw_roundrect_ext(_close_x, _close_y, _close_x + _close_w, _close_y + _close_h, 4, 4, false);

draw_set_color(make_color_rgb(255, 255, 255));
draw_roundrect_ext(_close_x, _close_y, _close_x + _close_w, _close_y + _close_h, 4, 4, true);

draw_set_color(make_color_rgb(255, 255, 255));
draw_text(_close_x + _close_w/2, _close_y + _close_h/2, "FECHAR");

// Resetar alinhamento
draw_set_halign(fa_left);
