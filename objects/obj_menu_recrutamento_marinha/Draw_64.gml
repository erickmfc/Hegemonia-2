// ===============================================
// HEGEMONIA GLOBAL - MENU DE RECRUTAMENTO NAVAL
// Interface Visual Redesenhada e Organizada
// ===============================================

// Verificar se o quartel ainda existe
if (meu_quartel_id == noone || !instance_exists(meu_quartel_id)) {
    instance_destroy();
    exit;
}

// ✅ OVERLAY DE FUNDO ESCURO MELHORADO
draw_set_alpha(0.9);
draw_set_color(make_color_rgb(10, 15, 25));
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
draw_set_alpha(1.0);

// ✅ DIMENSÕES OTIMIZADAS PARA MELHOR ORGANIZAÇÃO
var _mw = display_get_gui_width() * 0.65;   // 65% da largura
var _mh = display_get_gui_height() * 0.75;  // 75% da altura
var _mx = (display_get_gui_width() - _mw) / 2;
var _my = (display_get_gui_height() - _mh) / 2;

// ✅ DESIGN MODERNO COM SOMBRAS E GRADIENTES
// Sombra principal
draw_set_color(make_color_rgb(0, 0, 0));
draw_set_alpha(0.5);
draw_roundrect_ext(_mx + 8, _my + 8, _mx + _mw + 8, _my + _mh + 8, 20, 20, false);
draw_set_alpha(1);

// Fundo principal com gradiente naval
draw_set_color(make_color_rgb(20, 35, 55));
draw_set_alpha(0.98);
draw_roundrect_ext(_mx, _my, _mx + _mw, _my + _mh, 20, 20, false);

// Borda principal com efeito de brilho
draw_set_color(make_color_rgb(70, 130, 220));
draw_set_alpha(0.9);
draw_roundrect_ext(_mx, _my, _mx + _mw, _my + _mh, 20, 20, true);

// ✅ HEADER REDESENHADO COM MELHOR ESPAÇAMENTO
var _header_h = 80;
var _header_y = _my + 20;

// Background do header
draw_set_color(make_color_rgb(40, 60, 90));
draw_set_alpha(0.95);
draw_roundrect_ext(_mx + 20, _header_y, _mx + _mw - 20, _header_y + _header_h, 15, 15, false);

// Efeito de brilho no header
draw_set_color(make_color_rgb(120, 180, 255));
draw_set_alpha(0.2);
draw_roundrect_ext(_mx + 22, _header_y + 2, _mx + _mw - 22, _header_y + 25, 13, 13, false);
draw_set_alpha(1);

// ✅ TÍTULO PRINCIPAL COM FONTE MELHORADA
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Aplicar fonte melhorada
if (font_exists(fnt_ui_main)) {
    draw_set_font(fnt_ui_main);
} else {
    draw_set_font(-1);
}

// Título principal com melhor espaçamento (sem emojis para compatibilidade)
draw_set_color(make_color_rgb(255, 255, 255));
draw_text_transformed(_mx + _mw/2, _header_y + 30, "QUARTEL DE MARINHA", 1.4, 1.4, 0);

// Subtítulo com espaçamento adequado
draw_set_color(make_color_rgb(200, 220, 240));
draw_text_transformed(_mx + _mw/2, _header_y + 55, "Centro de Recrutamento Naval Avançado", 1.0, 1.0, 0);

// ✅ DINHEIRO REPOSICIONADO COM MELHOR VISIBILIDADE
draw_set_halign(fa_left);
draw_set_color(make_color_rgb(255, 215, 0));
draw_text_transformed(_mx + 30, _my + 15, "Dinheiro: $" + string(global.dinheiro), 1.1, 1.1, 0);

// ✅ LAYOUT ORGANIZADO COM SEÇÕES BEM DEFINIDAS
var _content_start_y = _my + 120; // Mais espaço após o header

// === SEÇÃO DE UNIDADE NAVAL REDESENHADA ===
var _unit_section_y = _content_start_y;
var _unit_card_w = _mw - 50;
var _unit_card_h = 160; // Mais alto para melhor organização
var _unit_card_x = _mx + 25;
var _unit_card_y = _unit_section_y;

// Fundo do card com gradiente moderno
draw_set_color(make_color_rgb(35, 55, 80));
draw_set_alpha(0.95);
draw_roundrect_ext(_unit_card_x, _unit_card_y, _unit_card_x + _unit_card_w, _unit_card_y + _unit_card_h, 15, 15, false);

// Borda com efeito de brilho
draw_set_color(make_color_rgb(80, 140, 220));
draw_roundrect_ext(_unit_card_x, _unit_card_y, _unit_card_x + _unit_card_w, _unit_card_y + _unit_card_h, 15, 15, true);

// Efeito de brilho no topo
draw_set_color(make_color_rgb(120, 180, 255));
draw_set_alpha(0.2);
draw_roundrect_ext(_unit_card_x + 3, _unit_card_y + 3, _unit_card_x + _unit_card_w - 3, _unit_card_y + 25, 12, 12, false);
draw_set_alpha(1);

// ✅ ÍCONE DA UNIDADE REPOSICIONADO (DENTRO DO MENU)
var _icon_x = _unit_card_x + 30;
var _icon_y = _unit_card_y + 80; // Posicionado mais abaixo para ficar dentro do card

if (sprite_exists(spr_lancha_patrulha)) {
    // Fundo circular para o ícone
    draw_set_color(make_color_rgb(60, 80, 120));
    draw_set_alpha(0.8);
    draw_circle(_icon_x, _icon_y, 35, false);
    
    // Ícone da lancha (tamanho reduzido para caber no menu)
    draw_sprite_ext(spr_lancha_patrulha, 0, _icon_x, _icon_y, 2.0, 2.0, 0, make_color_rgb(255, 255, 255), 1);
    draw_set_alpha(1);
}

// ✅ INFORMAÇÕES DA UNIDADE COM MELHOR ESPAÇAMENTO
var _info_x = _icon_x + 100; // Mais espaço entre ícone e texto
var _info_y = _unit_card_y + 25;

draw_set_halign(fa_left);
draw_set_color(make_color_rgb(255, 255, 255));
draw_text_transformed(_info_x, _info_y, "LANCHA PATRULHA", 1.2, 1.2, 0);

_info_y += 35; // Mais espaço entre linhas
draw_set_color(make_color_rgb(200, 220, 240));
draw_text_transformed(_info_x, _info_y, "Unidade naval rápida e versátil", 0.9, 0.9, 0);

_info_y += 30;
draw_set_color(make_color_rgb(255, 215, 0));
draw_text_transformed(_info_x, _info_y, "Custo: $50", 1.0, 1.0, 0);

_info_y += 30;
draw_set_color(make_color_rgb(180, 200, 220));
draw_text_transformed(_info_x, _info_y, "Tempo: 3 segundos", 0.9, 0.9, 0);

// ✅ BOTÃO DE PRODUÇÃO REDESENHADO
var _btn_x = _unit_card_x + _unit_card_w - 160;
var _btn_y = _unit_card_y + (_unit_card_h - 50) / 2;
var _btn_w = 150;
var _btn_h = 50;

// Verificar se pode produzir
var _can_produce = true;
if (instance_exists(meu_quartel_id)) {
    _can_produce = !meu_quartel_id.produzindo && global.dinheiro >= 50;
}

// Cor do botão baseada na disponibilidade
var _btn_color = _can_produce ? make_color_rgb(70, 130, 220) : make_color_rgb(120, 120, 120);

// Fundo do botão com gradiente
draw_set_color(_btn_color);
draw_roundrect_ext(_btn_x, _btn_y, _btn_x + _btn_w, _btn_y + _btn_h, 12, 12, false);

// Borda destacada
draw_set_color(make_color_rgb(255, 255, 255));
draw_set_alpha(0.9);
draw_roundrect_ext(_btn_x, _btn_y, _btn_x + _btn_w, _btn_y + _btn_h, 12, 12, true);

// Efeito de brilho quando disponível
if (_can_produce) {
    draw_set_color(make_color_rgb(120, 180, 255));
    draw_set_alpha(0.3);
    draw_roundrect_ext(_btn_x + 3, _btn_y + 3, _btn_x + _btn_w - 3, _btn_y + 18, 9, 9, false);
}

// Texto do botão centralizado
draw_set_halign(fa_center);
draw_set_color(make_color_rgb(255, 255, 255));
draw_text_transformed(_btn_x + _btn_w/2, _btn_y + _btn_h/2, "PRODUZIR", 1.0, 1.0, 0);
draw_set_alpha(1);

// === SEÇÃO DE STATUS REDESENHADA ===
var _status_section_y = _unit_card_y + _unit_card_h + 30; // Mais espaço entre seções
var _status_card_w = _mw - 50;
var _status_card_h = 140;
var _status_card_x = _mx + 25;
var _status_card_y = _status_section_y;

// Fundo do card de status
draw_set_color(make_color_rgb(35, 55, 80));
draw_set_alpha(0.95);
draw_roundrect_ext(_status_card_x, _status_card_y, _status_card_x + _status_card_w, _status_card_y + _status_card_h, 15, 15, false);

// Borda com efeito de brilho
draw_set_color(make_color_rgb(80, 140, 220));
draw_roundrect_ext(_status_card_x, _status_card_y, _status_card_x + _status_card_w, _status_card_y + _status_card_h, 15, 15, true);

// Efeito de brilho no topo
draw_set_color(make_color_rgb(120, 180, 255));
draw_set_alpha(0.2);
draw_roundrect_ext(_status_card_x + 3, _status_card_y + 3, _status_card_x + _status_card_w - 3, _status_card_y + 25, 12, 12, false);
draw_set_alpha(1);

// Título da seção
draw_set_halign(fa_center);
draw_set_color(make_color_rgb(220, 240, 255));
draw_text_transformed(_status_card_x + _status_card_w/2, _status_card_y + 30, "STATUS DO QUARTEL", 1.1, 1.1, 0);

// Informações do quartel com melhor espaçamento
if (meu_quartel_id != noone && instance_exists(meu_quartel_id)) {
    var _fila_size = ds_queue_size(meu_quartel_id.fila_producao);
    var _unidades_produzidas = meu_quartel_id.unidades_produzidas;
    
    var _status_info_y = _status_card_y + 60;
    
    // Fila de produção
    draw_set_halign(fa_left);
    draw_set_color(make_color_rgb(200, 220, 240));
    draw_text_transformed(_status_card_x + 30, _status_info_y, "Fila: " + string(_fila_size) + " unidades", 0.9, 0.9, 0);
    
    // Unidades produzidas
    draw_text_transformed(_status_card_x + 30, _status_info_y + 30, "Produzidas: " + string(_unidades_produzidas) + " lanchas", 0.9, 0.9, 0);
    
    // Status do quartel
    var _status_text = "";
    var _status_color = make_color_rgb(255, 255, 255);
    var _status_icon = "";
    
    if (meu_quartel_id.produzindo) {
        _status_text = "PRODUZINDO...";
        _status_color = make_color_rgb(255, 200, 0);
        _status_icon = "";
    } else {
        _status_text = "OCIOSO";
        _status_color = make_color_rgb(100, 220, 100);
        _status_icon = "";
    }
    
    draw_set_color(_status_color);
    draw_text_transformed(_status_card_x + 30, _status_info_y + 60, "Status: " + _status_text, 0.9, 0.9, 0);
}

// === SEÇÃO DE INSTRUÇÕES COM MELHOR POSICIONAMENTO ===
var _instr_y = _status_card_y + _status_card_h + 25;
draw_set_halign(fa_center);
draw_set_color(make_color_rgb(160, 180, 200));
draw_text_transformed(_mx + _mw/2, _instr_y, "Clique em PRODUZIR para adicionar lancha à fila de produção", 0.8, 0.8, 0);

// === BOTÃO FECHAR REDESENHADO ===
var _close_w = 130;
var _close_h = 50;
var _close_x = _mx + _mw - _close_w - 25;
var _close_y = _my + _mh - 65;

// Fundo do botão com gradiente vermelho
draw_set_color(make_color_rgb(180, 60, 60));
draw_roundrect_ext(_close_x, _close_y, _close_x + _close_w, _close_y + _close_h, 10, 10, false);

// Borda destacada
draw_set_color(make_color_rgb(255, 255, 255));
draw_set_alpha(0.9);
draw_roundrect_ext(_close_x, _close_y, _close_x + _close_w, _close_y + _close_h, 10, 10, true);

// Texto do botão
draw_set_color(make_color_rgb(255, 255, 255));
draw_text_transformed(_close_x + _close_w/2, _close_y + _close_h/2, "FECHAR", 0.9, 0.9, 0);
draw_set_alpha(1);

// Resetar alinhamento
draw_set_halign(fa_left);
draw_set_valign(fa_top);