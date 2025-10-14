// ===============================================
// HEGEMONIA GLOBAL - MENU DE RECRUTAMENTO NAVAL
// Interface Visual Simplificada
// ===============================================

// === DEBUG: VERIFICAR SE DRAW ESTÁ EXECUTANDO ===
if (global.game_frame mod 60 == 0) { // A cada 1 segundo
    show_debug_message("🎨 DRAW EVENT EXECUTANDO - Menu ID: " + string(id));
    show_debug_message("   Posição: (" + string(x) + ", " + string(y) + ")");
    show_debug_message("   Display: " + string(display_get_gui_width()) + "x" + string(display_get_gui_height()));
}

// Verificar se o quartel ainda existe
if (meu_quartel_id == noone || !instance_exists(meu_quartel_id)) {
    show_debug_message("❌ Quartel não existe mais - destruindo menu");
    instance_destroy();
    exit;
}

// ✅ CORRIGIDO: Overlay de fundo escuro como quartel militar
draw_set_alpha(0.85);
draw_set_color(make_color_rgb(15, 20, 30));
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
draw_set_alpha(1.0);

// ✅ CORRIGIDO: Centralização automática como quartel militar
var _mw = display_get_gui_width() * 0.5;   // 50% da largura da tela
var _mh = display_get_gui_height() * 0.6;   // 60% da altura da tela
var _mx = (display_get_gui_width() - _mw) / 2;   // Centralizar horizontalmente
var _my = (display_get_gui_height() - _mh) / 2;   // Centralizar verticalmente

// ✅ CORRIGIDO: Visual igual ao quartel militar
// Sombra do painel
draw_set_color(make_color_rgb(0, 0, 0));
draw_set_alpha(0.3);
draw_roundrect_ext(_mx + 4, _my + 4, _mx + _mw + 4, _my + _mh + 4, 12, 12, false);
draw_set_alpha(1);

// Fundo do painel principal - azul escuro naval
draw_set_color(make_color_rgb(25, 35, 55));
draw_set_alpha(0.95);
draw_roundrect_ext(_mx, _my, _mx + _mw, _my + _mh, 12, 12, false);
draw_set_alpha(1);

// Borda do painel
draw_set_color(make_color_rgb(70, 90, 120));
draw_roundrect_ext(_mx, _my, _mx + _mw, _my + _mh, 12, 12, true);

// ✅ CORRIGIDO: Título igual ao quartel militar - AUMENTADO
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Título principal (centralizado sem ícone) - AUMENTADO 1.8x (1.5 * 1.2)
draw_set_color(make_color_rgb(220, 230, 250));
draw_set_font(-1);
draw_text_transformed(_mx + _mw/2, _my + 40, "QUARTEL DE MARINHA", 1.8, 1.8, 0);

// Subtítulo - AUMENTADO 1.56x (1.3 * 1.2)
draw_set_color(make_color_rgb(180, 200, 220));
draw_text_transformed(_mx + _mw/2, _my + 70, "Recrutamento de Unidades Navais", 1.56, 1.56, 0);

// Dinheiro no canto superior esquerdo - AUMENTADO 1.44x (1.2 * 1.2)
draw_set_halign(fa_left);
draw_set_color(make_color_rgb(255, 215, 0));
draw_text_transformed(_mx + 20, _my + 25, "Dinheiro: $" + string(global.dinheiro), 1.44, 1.44, 0);

// ✅ CORRIGIDO: Layout organizado com espaçamento adequado
var _content_start_y = _my + 100;

// === SEÇÃO DE UNIDADE NAVAL ===
var _unit_section_y = _content_start_y;
var _unit_card_w = _mw - 40;
var _unit_card_h = 120;
var _unit_card_x = _mx + 20;
var _unit_card_y = _unit_section_y;

// Fundo do card da unidade
draw_set_color(make_color_rgb(30, 45, 70));
draw_set_alpha(0.9);
draw_roundrect_ext(_unit_card_x, _unit_card_y, _unit_card_x + _unit_card_w, _unit_card_y + _unit_card_h, 8, 8, false);
draw_set_alpha(1);

// Borda do card
draw_set_color(make_color_rgb(70, 130, 200));
draw_roundrect_ext(_unit_card_x, _unit_card_y, _unit_card_x + _unit_card_w, _unit_card_y + _unit_card_h, 8, 8, true);

// === ÍCONE DA UNIDADE (MOVIDO 20% PARA A DIREITA) ===
var _icon_x = _unit_card_x + 20 + (_unit_card_w * 0.2); // Movido 20% para a direita
var _icon_y = _unit_card_y + _unit_card_h/2;
if (sprite_exists(spr_lancha_patrulha)) {
    draw_sprite_ext(spr_lancha_patrulha, 0, _icon_x, _icon_y, 2.5, 2.5, 0, make_color_rgb(255, 255, 255), 1);
}

// === INFORMAÇÕES DA UNIDADE (MOVIDAS 15% PARA A DIREITA) ===
var _info_x = _icon_x + 80 + (_unit_card_w * 0.15); // Movido 15% para a direita (era 25%, agora 10% menos)
var _info_y = _unit_card_y + 25;

draw_set_halign(fa_left);
draw_set_color(make_color_rgb(255, 255, 255));
draw_text_transformed(_info_x, _info_y, "LANCHA PATRULHA", 1.56, 1.56, 0); // 1.3 * 1.2

_info_y += 30; // Mais espaço entre linhas
draw_set_color(make_color_rgb(180, 200, 220));
draw_text_transformed(_info_x, _info_y, "Unidade naval rápida e versátil", 1.32, 1.32, 0); // 1.1 * 1.2

_info_y += 25; // Mais espaço entre linhas
draw_set_color(make_color_rgb(255, 215, 0));
draw_text_transformed(_info_x, _info_y, "Custo: $50", 1.32, 1.32, 0); // 1.1 * 1.2

_info_y += 25; // Mais espaço entre linhas
draw_set_color(make_color_rgb(150, 150, 150));
draw_text_transformed(_info_x, _info_y, "Tempo: 3 segundos", 1.32, 1.32, 0); // 1.1 * 1.2

// === BOTÃO DE PRODUÇÃO (LADO DIREITO) - AUMENTADO MAIS 20% ===
var _btn_x = _unit_card_x + _unit_card_w - 180; // Ajustado para botão maior (160 + 20)
var _btn_y = _unit_card_y + (_unit_card_h - 60) / 2; // Ajustado para botão maior (50 + 10)
var _btn_w = 168; // Aumentado de 140 para 168 (140 * 1.2)
var _btn_h = 60; // Aumentado de 50 para 60 (50 * 1.2)

// Verificar se pode produzir
var _can_produce = true;
if (instance_exists(meu_quartel_id)) {
    _can_produce = !meu_quartel_id.produzindo && global.dinheiro >= 50;  // ✅ CUSTO CORRETO
}

// Cor do botão baseada na disponibilidade (azul 20% mais escuro - era 15%, agora +5%)
var _btn_color = _can_produce ? make_color_rgb(57, 105, 162) : make_color_rgb(100, 100, 100); // Azul 20% mais escuro

// Fundo do botão
draw_set_color(_btn_color);
draw_roundrect_ext(_btn_x, _btn_y, _btn_x + _btn_w, _btn_y + _btn_h, 8, 8, false);

// Borda do botão (proporcional ao tamanho)
draw_set_color(make_color_rgb(255, 255, 255));
draw_roundrect_ext(_btn_x, _btn_y, _btn_x + _btn_w, _btn_y + _btn_h, 8, 8, true);

// Texto do botão - AUMENTADO 1.44x (1.2 * 1.2)
draw_set_halign(fa_center);
draw_set_color(make_color_rgb(255, 255, 255));
draw_text_transformed(_btn_x + _btn_w/2, _btn_y + _btn_h/2, "PRODUZIR", 1.44, 1.44, 0);

// === SEÇÃO DE STATUS DO QUARTEL (MOVIDA 10% PARA CIMA) ===
var _status_section_y = _unit_card_y + _unit_card_h + 20; // Reduzido de 30 para 20 (10% para cima)
var _status_card_w = _mw - 40;
var _status_card_h = 100;
var _status_card_x = _mx + 20;
var _status_card_y = _status_section_y;

// Fundo do card de status
draw_set_color(make_color_rgb(30, 45, 70));
draw_set_alpha(0.9);
draw_roundrect_ext(_status_card_x, _status_card_y, _status_card_x + _status_card_w, _status_card_y + _status_card_h, 8, 8, false);
draw_set_alpha(1);

// Borda do card
draw_set_color(make_color_rgb(70, 130, 200));
draw_roundrect_ext(_status_card_x, _status_card_y, _status_card_x + _status_card_w, _status_card_y + _status_card_h, 8, 8, true);

// Título da seção - AUMENTADO 1.44x (1.2 * 1.2)
draw_set_halign(fa_center);
draw_set_color(make_color_rgb(200, 220, 240));
draw_text_transformed(_status_card_x + _status_card_w/2, _status_card_y + 20, "STATUS DO QUARTEL", 1.44, 1.44, 0);

// Informações do quartel
if (meu_quartel_id != noone && instance_exists(meu_quartel_id)) {
    var _fila_size = ds_queue_size(meu_quartel_id.fila_producao);
    var _unidades_produzidas = meu_quartel_id.unidades_produzidas;
    
    var _status_info_y = _status_card_y + 45;
    
    // Fila de produção - AUMENTADO 1.32x (1.1 * 1.2)
    draw_set_halign(fa_left);
    draw_set_color(make_color_rgb(180, 200, 220));
    draw_text_transformed(_status_card_x + 20, _status_info_y, "Fila: " + string(_fila_size) + " unidades", 1.32, 1.32, 0);
    
    // Unidades produzidas - AUMENTADO 1.32x (1.1 * 1.2)
    draw_text_transformed(_status_card_x + 20, _status_info_y + 20, "Produzidas: " + string(_unidades_produzidas) + " lanchas", 1.32, 1.32, 0);
    
    // Status do quartel
    var _status_text = "";
    var _status_color = make_color_rgb(255, 255, 255);
    
    if (meu_quartel_id.produzindo) {
        _status_text = "PRODUZINDO...";
        _status_color = make_color_rgb(255, 180, 0);
    } else {
        _status_text = "OCIOSO";
        _status_color = make_color_rgb(80, 200, 80);
    }
    
    draw_set_color(_status_color);
    draw_text_transformed(_status_card_x + 20, _status_info_y + 40, "Status: " + _status_text, 1.32, 1.32, 0);
}

// === SEÇÃO DE INSTRUÇÕES - AUMENTADO MAIS 20% ===
var _instr_y = _status_card_y + _status_card_h + 20;
draw_set_halign(fa_center);
draw_set_color(make_color_rgb(150, 150, 150));
draw_text_transformed(_mx + _mw/2, _instr_y, "Clique em PRODUZIR para adicionar lancha à fila de produção", 1.32, 1.32, 0); // 1.1 * 1.2

// === BOTÃO FECHAR - AUMENTADO MAIS 20% ===
var _close_w = 156; // Aumentado de 130 para 156 (130 * 1.2)
var _close_h = 60;  // Aumentado de 50 para 60 (50 * 1.2)
var _close_x = _mx + _mw - _close_w - 20;
var _close_y = _my + _mh - 60;

draw_set_color(make_color_rgb(122, 41, 41));
draw_roundrect_ext(_close_x, _close_y, _close_x + _close_w, _close_y + _close_h, 4, 4, false);

draw_set_color(make_color_rgb(255, 255, 255));
draw_roundrect_ext(_close_x, _close_y, _close_x + _close_w, _close_y + _close_h, 4, 4, true);

draw_set_color(make_color_rgb(255, 255, 255));
draw_text_transformed(_close_x + _close_w/2, _close_y + _close_h/2, "FECHAR", 1.44, 1.44, 0); // 1.2 * 1.2

// Resetar alinhamento
draw_set_halign(fa_left);