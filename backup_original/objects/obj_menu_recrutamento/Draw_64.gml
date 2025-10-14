// ===============================================
// HEGEMONIA GLOBAL - MENU DE RECRUTAMENTO
// Bloco 4, Fase 3: Interface Moderna Inspirada no Centro de Pesquisa
// ===============================================

// Configurar fonte
if (font_exists(fnt_ui_main)) {
    draw_set_font(fnt_ui_main);
} else {
    draw_set_font(-1);
}

// === OVERLAY DE FUNDO ===
draw_set_alpha(0.85);
draw_set_color(make_color_rgb(15, 20, 30));
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
draw_set_alpha(1);

// === PAINEL PRINCIPAL - OCUPA 50% DA TELA (MENOR QUE PESQUISA) ===
var _mw = display_get_gui_width() * 0.5;
var _mh = display_get_gui_height() * 0.6;
var _mx = (display_get_gui_width() - _mw) / 2;
var _my = (display_get_gui_height() - _mh) / 2;

// Sombra do painel
draw_set_color(make_color_rgb(0, 0, 0));
draw_set_alpha(0.3);
draw_roundrect_ext(_mx + 4, _my + 4, _mx + _mw + 4, _my + _mh + 4, 12, 12, false);
draw_set_alpha(1);

// Fundo do painel principal - azul escuro militar
draw_set_color(make_color_rgb(25, 35, 55));
draw_set_alpha(0.95);
draw_roundrect_ext(_mx, _my, _mx + _mw, _my + _mh, 12, 12, false);
draw_set_alpha(1);

// Borda do painel
draw_set_color(make_color_rgb(70, 90, 120));
draw_roundrect_ext(_mx, _my, _mx + _mw, _my + _mh, 12, 12, true);

// === CUSTOS DA INFANTARIA (VALORES DEFINIDOS DIRETAMENTE) ===
var _custo_dinheiro = 100;
var _custo_populacao = 1;
var _tempo_treino = 300;

// === CABEÇALHO ===
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Título principal
draw_set_color(make_color_rgb(220, 230, 250));
draw_text_transformed(_mx + _mw/2, _my + 40, "QUARTEL MILITAR", 1.2, 1.2, 0);

// Subtítulo
draw_set_color(make_color_rgb(180, 200, 220));
draw_text_transformed(_mx + _mw/2, _my + 70, "Recrutamento de Unidades", 0.8, 0.8, 0);

// Dinheiro no canto superior esquerdo
draw_set_halign(fa_left);
draw_set_color(make_color_rgb(255, 215, 0));
draw_text_transformed(_mx + 20, _my + 25, "Dinheiro: $" + string(global.dinheiro), 0.9, 0.9, 0);

// População no canto superior direito
draw_set_halign(fa_right);
draw_set_color(make_color_rgb(100, 200, 250));
draw_text_transformed(_mx + _mw - 20, _my + 25, "População: " + string(global.populacao), 0.9, 0.9, 0);

// === CARD DA INFANTARIA (CENTRALIZADO) ===
var _card_width = _mw * 0.8;   // 80% da largura do painel (maior para acomodar 3 botões)
var _card_height = _mh * 0.5;  // 50% da altura do painel (maior para acomodar mais conteúdo)
var _card_x = _mx + (_mw - _card_width) / 2;
var _card_y = _my + 120;

// Aumentar a área do card (borda verde) 15% para os lados e 30% para baixo
_card_width = _card_width * 1.15;
_card_height = _card_height * 1.30;
_card_x = _mx + (_mw - _card_width) / 2; // recentrar

// === SOMBRA DO CARD ===
draw_set_color(make_color_rgb(0, 0, 0));
draw_set_alpha(0.2);
draw_roundrect_ext(_card_x + 3, _card_y + 3, _card_x + _card_width + 3, _card_y + _card_height + 3, 8, 8, false);
draw_set_alpha(1);

// === FUNDO DO CARD ===
var _bg_color = make_color_rgb(30, 45, 70);
// Verificar se o quartel está treinando
if (instance_exists(id_do_quartel) && id_do_quartel.esta_treinando) {
    _bg_color = make_color_rgb(60, 45, 30); // Cor quente para treinando
}

draw_set_color(_bg_color);
draw_set_alpha(0.9);
draw_roundrect_ext(_card_x, _card_y, _card_x + _card_width, _card_y + _card_height, 8, 8, false);
draw_set_alpha(1);

// === BORDA DO CARD ===
var _border_color = make_color_rgb(70, 130, 200); // Azul padrão
if (global.dinheiro >= _custo_dinheiro && global.populacao >= _custo_populacao) {
    if (instance_exists(id_do_quartel) && !id_do_quartel.esta_treinando) {
        _border_color = make_color_rgb(80, 200, 80); // Verde - disponível
    } else {
        _border_color = make_color_rgb(255, 180, 0); // Amarelo - treinando
    }
} else {
    _border_color = make_color_rgb(200, 80, 80); // Vermelho - sem recursos
}

draw_set_color(_border_color);
draw_roundrect_ext(_card_x, _card_y, _card_x + _card_width, _card_y + _card_height, 8, 8, true);

// === ÍCONE DA INFANTARIA - TOPO CENTRALIZADO ===
if (sprite_exists(spr_infantaria)) {
    var _icon_x = _card_x + _card_width/2;
    var _icon_y = _card_y + 40;
    draw_sprite_ext(spr_infantaria, 0, _icon_x, _icon_y, 3.0, 3.0, 0, c_white, 1);
}

// === NOME DA UNIDADE ===
draw_set_halign(fa_center);
draw_set_color(c_white);
var _name_y = _card_y + 90;
draw_text_transformed(_card_x + _card_width/2, _name_y, "INFANTARIA", 1.1, 1.1, 0);

// === CUSTOS ===
var _cost_y = _name_y + 25;
draw_set_color(make_color_rgb(255, 215, 0));
draw_text_transformed(_card_x + _card_width/2, _cost_y, "Custo Unitário: $" + string(_custo_dinheiro) + " | Pop: " + string(_custo_populacao), 0.8, 0.8, 0);

// === TEMPO DE TREINO ===
var _time_y = _cost_y + 20;
draw_set_color(make_color_rgb(180, 180, 180));
draw_text_transformed(_card_x + _card_width/2, _time_y, "Tempo: " + string(_tempo_treino / 60) + "s por unidade", 0.7, 0.7, 0);

// === TÍTULO DOS BOTÕES ===
var _buttons_y = _time_y + 35;
draw_set_color(make_color_rgb(200, 220, 240));
draw_text_transformed(_card_x + _card_width/2, _buttons_y, "SELECIONE A QUANTIDADE:", 0.9, 0.9, 0);

// === BOTÕES DE QUANTIDADE (1, 5, 10) ===
var _button_start_y = _buttons_y + 25;
var _button_height_orig = 35;
var _button_height = _button_height_orig * 1.05; // aumenta 5%
_button_start_y -= (_button_height_orig * 0.05); // sobe 5%
var _button_spacing = 10;
var _button_width = (_card_width - 40 - 2 * _button_spacing) / 3; // 3 botões com espaçamento

// Botão 1 UNIDADE
var _btn1_x = _card_x + 20;
var _btn1_y = _button_start_y;
var _btn1_w = _button_width;
var _btn1_h = _button_height;

// Botão 5 UNIDADES  
var _btn5_x = _btn1_x + _button_width + _button_spacing;
var _btn5_y = _button_start_y;
var _btn5_w = _button_width;
var _btn5_h = _button_height;

// Botão 10 UNIDADES
var _btn10_x = _btn5_x + _button_width + _button_spacing;
var _btn10_y = _button_start_y;
var _btn10_w = _button_width;
var _btn10_h = _button_height;

// Função para desenhar botão
function draw_quantity_button(_x, _y, _w, _h, _quantity, _can_afford, _custo_unit_d, _custo_unit_p) {
    // Cor do botão baseada na disponibilidade
    var _btn_color = _can_afford ? make_color_rgb(70, 130, 200) : make_color_rgb(100, 100, 100);
    
    // Fundo do botão
    draw_set_color(_btn_color);
    draw_roundrect_ext(_x, _y, _x + _w, _y + _h, 4, 4, false);
    
    // Borda do botão
    draw_set_color(c_white);
    draw_roundrect_ext(_x, _y, _x + _w, _y + _h, 4, 4, true);
    
    // Texto do botão - quantidade
    draw_set_halign(fa_center);
    draw_set_color(c_white);
    draw_text_transformed(_x + _w/2, _y + 8, string(_quantity), 1.0, 1.0, 0);
    
    // Texto do botão - custo total (subir 10%)
    var _total_cost_d = _custo_unit_d * _quantity;
    var _total_cost_p = _custo_unit_p * _quantity;
    draw_set_color(_can_afford ? c_lime : c_red);
    draw_text_transformed(_x + _w/2, _y + 22 - (_h * 0.10), "$" + string(_total_cost_d), 0.7, 0.7, 0);
}

// Verificar se pode pagar cada quantidade
var _can_afford_1 = (global.dinheiro >= _custo_dinheiro * 1 && global.populacao >= _custo_populacao * 1);
var _can_afford_5 = (global.dinheiro >= _custo_dinheiro * 5 && global.populacao >= _custo_populacao * 5);
var _can_afford_10 = (global.dinheiro >= _custo_dinheiro * 10 && global.populacao >= _custo_populacao * 10);

// Desenhar os três botões
draw_quantity_button(_btn1_x, _btn1_y, _btn1_w, _btn1_h, 1, _can_afford_1 && (!instance_exists(id_do_quartel) || !id_do_quartel.esta_treinando), _custo_dinheiro, _custo_populacao);
draw_quantity_button(_btn5_x, _btn5_y, _btn5_w, _btn5_h, 5, _can_afford_5 && (!instance_exists(id_do_quartel) || !id_do_quartel.esta_treinando), _custo_dinheiro, _custo_populacao);
draw_quantity_button(_btn10_x, _btn10_y, _btn10_w, _btn10_h, 10, _can_afford_10 && (!instance_exists(id_do_quartel) || !id_do_quartel.esta_treinando), _custo_dinheiro, _custo_populacao);

// === SEÇÃO ADICIONAL: TANQUE DE GUERRA (ABAIXO DOS BOTÕES) ===
var _tank_y = _button_start_y + _button_height + 30;
var _tank_h = 100; // Aumentado para acomodar botões de quantidade

// Fundo do card menor
draw_set_color(make_color_rgb(35, 50, 75));
draw_set_alpha(0.9);
draw_roundrect_ext(_card_x, _tank_y, _card_x + _card_width, _tank_y + _tank_h, 8, 8, false);
draw_set_alpha(1);

// Borda
draw_set_color(make_color_rgb(90, 130, 190));
draw_roundrect_ext(_card_x, _tank_y, _card_x + _card_width, _tank_y + _tank_h, 8, 8, true);

// Ícone (se existir)
if (sprite_exists(spr_tanque)) {
    // mover 50% para a direita
    draw_sprite_ext(spr_tanque, 0, _card_x + 28 + (_card_width * 0.5), _tank_y + 35, 1.2, 1.2, 0, c_white, 1);
}

// Título e custos
draw_set_halign(fa_left);
draw_set_color(c_white);
draw_text_transformed(_card_x + 55, _tank_y + 12, "TANQUE", 0.95, 0.95, 0);
draw_set_color(make_color_rgb(255, 215, 0));
draw_text_transformed(_card_x + 55, _tank_y + 32, "Custo Unitário: $500 | Pop: 3", 0.8, 0.8, 0);
draw_set_color(make_color_rgb(180, 180, 180));
draw_text_transformed(_card_x + 55, _tank_y + 50, "Tempo: 15s por unidade", 0.7, 0.7, 0);

// === BOTÕES DE QUANTIDADE PARA TANQUE ===
var _tank_btn_w = 45;
var _tank_btn_h = 28;
var _tank_btn_spacing = 5;
var _tank_btn_start_x = _card_x + (_card_width * 0.70);
var _tank_btn_y = _tank_y + 65;

// Custos para tanque
var _tank_custo_dinheiro = 500;
var _tank_custo_populacao = 3;

// Verificar se pode pagar
var _can_afford_tank_1 = (global.dinheiro >= _tank_custo_dinheiro && global.populacao >= _tank_custo_populacao);
var _can_afford_tank_6 = (global.dinheiro >= (_tank_custo_dinheiro * 6) && global.populacao >= (_tank_custo_populacao * 6));
var _can_afford_tank_10 = (global.dinheiro >= (_tank_custo_dinheiro * 10) && global.populacao >= (_tank_custo_populacao * 10));

// Desenhar botões de quantidade para tanque
draw_quantity_button(_tank_btn_start_x, _tank_btn_y, _tank_btn_w, _tank_btn_h, 1, _can_afford_tank_1 && (!instance_exists(id_do_quartel) || !id_do_quartel.esta_treinando), _tank_custo_dinheiro, _tank_custo_populacao);
draw_quantity_button(_tank_btn_start_x + _tank_btn_w + _tank_btn_spacing, _tank_btn_y, _tank_btn_w, _tank_btn_h, 6, _can_afford_tank_6 && (!instance_exists(id_do_quartel) || !id_do_quartel.esta_treinando), _tank_custo_dinheiro, _tank_custo_populacao);
draw_quantity_button(_tank_btn_start_x + (_tank_btn_w + _tank_btn_spacing) * 2, _tank_btn_y, _tank_btn_w, _tank_btn_h, 10, _can_afford_tank_10 && (!instance_exists(id_do_quartel) || !id_do_quartel.esta_treinando), _tank_custo_dinheiro, _tank_custo_populacao);

// === SEÇÃO DE STATUS ===
var _status_y = _my + _mh - 120;
draw_set_color(make_color_rgb(180, 200, 220));
draw_text_transformed(_mx + _mw/2, _status_y, "STATUS DO QUARTEL", 0.9, 0.9, 0);

_status_y += 25;
if (instance_exists(id_do_quartel)) {
    if (id_do_quartel.esta_treinando) {
        draw_set_color(make_color_rgb(255, 180, 0));
        var _tempo_restante = max(0, id_do_quartel.alarm[0]);
        draw_text_transformed(_mx + _mw/2, _status_y, "Treinando... " + string(ceil(_tempo_restante / 60)) + "s restantes", 0.8, 0.8, 0);
    } else {
        draw_set_color(make_color_rgb(80, 200, 80));
        draw_text_transformed(_mx + _mw/2, _status_y, "Quartel disponível para recrutamento", 0.8, 0.8, 0);
    }
} else {
    draw_set_color(make_color_rgb(200, 80, 80));
    draw_text_transformed(_mx + _mw/2, _status_y, "Erro: Quartel não encontrado", 0.8, 0.8, 0);
}

// === BOTÃO FECHAR === (aumentar 15%)
var _close_w0 = 80;
var _close_h0 = 35;
var _close_w = _close_w0 * 1.15;
var _close_h = _close_h0 * 1.15;
var _close_x = _mx + _mw - _close_w0 - 20 - ((_close_w - _close_w0) / 2);
var _close_y = _my + _mh - 60 - ((_close_h - _close_h0) / 2);

draw_set_color(make_color_rgb(150, 50, 50));
draw_roundrect_ext(_close_x, _close_y, _close_x + _close_w, _close_y + _close_h, 4, 4, false);

draw_set_color(c_white);
draw_roundrect_ext(_close_x, _close_y, _close_x + _close_w, _close_y + _close_h, 4, 4, true);

draw_set_color(c_white);
draw_text_transformed(_close_x + _close_w/2, _close_y + _close_h/2, "FECHAR", 0.8, 0.8, 0);

// === INSTRUÇÕES ===
var _instr_y = _my + _mh - 30;
draw_set_color(make_color_rgb(150, 150, 150));
draw_text_transformed(_mx + _mw/2, _instr_y, "Clique no botão para recrutar ou fora do menu para fechar", 0.6, 0.6, 0);

// === RESETAR CONFIGURAÇÕES ===
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);