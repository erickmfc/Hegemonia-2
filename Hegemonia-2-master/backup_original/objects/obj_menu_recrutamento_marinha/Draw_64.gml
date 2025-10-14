// ===============================================
// HEGEMONIA GLOBAL - MENU DE RECRUTAMENTO MARINHA
// Interface Naval Moderna - AJUSTES VISUAIS APLICADOS
// ===============================================

// Configurar fonte
if (font_exists(fnt_ui_main)) {
    draw_set_font(fnt_ui_main);
} else {
    draw_set_font(-1);
}

// === OVERLAY DE FUNDO ===
draw_set_alpha(0.85);
draw_set_color(make_color_rgb(5, 15, 25)); // Azul marinho mais escuro
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
draw_set_alpha(1);

// === PAINEL PRINCIPAL - DIMENSÕES REDUZIDAS ===
var _mw = display_get_gui_width() * 0.4875;  // 65% - 25% = 48.75%
var _mh = display_get_gui_height() * 0.6;    // 75% - 20% = 60%
var _mx = (display_get_gui_width() - _mw) / 2;
var _my = (display_get_gui_height() - _mh) / 2;

// Sombra do painel
draw_set_color(make_color_rgb(0, 0, 0));
draw_set_alpha(0.3);
draw_roundrect_ext(_mx + 4, _my + 4, _mx + _mw + 4, _my + _mh + 4, 12, 12, false);
draw_set_alpha(1);

// Fundo do painel principal - azul marinho
draw_set_color(make_color_rgb(15, 25, 40));
draw_set_alpha(0.95);
draw_roundrect_ext(_mx, _my, _mx + _mw, _my + _mh, 12, 12, false);
draw_set_alpha(1);

// Borda do painel
draw_set_color(make_color_rgb(40, 80, 150));
draw_roundrect_ext(_mx, _my, _mx + _mw, _my + _mh, 12, 12, true);

// === CABEÇALHO ===
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Título principal - fonte reduzida em 15%
draw_set_color(make_color_rgb(200, 220, 255));
draw_text_transformed(_mx + _mw/2, _my + 30, "QUARTEL MARINHA", 1.02, 1.02, 0); // 1.2 - 15% = 1.02

// Subtítulo - fonte reduzida em 10%
draw_set_color(make_color_rgb(150, 180, 220));
draw_text_transformed(_mx + _mw/2, _my + 50, "Recrutamento de Unidades Navais", 0.72, 0.72, 0); // 0.8 - 10% = 0.72

// === BOTÃO FECHAR - ÁREA CLICÁVEL AUMENTADA ===
var _fechar_w = 77;  // 70 + 10% = 77
var _fechar_h = 33;  // 30 + 10% = 33
var _fechar_x = _mx + _mw - (_mw * 0.05) - _fechar_w; // 5% da largura do painel
var _fechar_y = _my + (_mh * 0.03); // 3% da altura do painel

draw_set_color(make_color_rgb(200, 50, 50));
draw_set_alpha(0.8);
draw_roundrect_ext(_fechar_x, _fechar_y, _fechar_x + _fechar_w, _fechar_y + _fechar_h, 6, 6, false);
draw_set_color(make_color_rgb(255, 100, 100));
draw_set_alpha(0.6);
draw_roundrect_ext(_fechar_x, _fechar_y, _fechar_x + _fechar_w, _fechar_y + _fechar_h, 6, 6, true);
draw_set_alpha(1);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text_transformed(_fechar_x + _fechar_w/2, _fechar_y + _fechar_h/2, "FECHAR", 0.72, 0.72, 0); // 0.8 - 10% = 0.72

// Recursos (somente dinheiro no canto superior esquerdo) - fonte reduzida em 10%
draw_set_halign(fa_left);
draw_set_color(make_color_rgb(255, 215, 0));
draw_text_transformed(_mx + 20, _my + 25, "Dinheiro: $" + string(global.dinheiro), 0.81, 0.81, 0); // 0.9 - 10% = 0.81

// === UNIDADES NAVALES ===
var _unidades_start_y = _my + 80;  // Ajustado para novo layout
var _unidade_height = 80; // 100 - 20% = 80
var _unidade_spacing = 15;

// Obter dados do quartel
var quartel = quartel_referencia;
if (instance_exists(quartel)) {
    var unidades_disponiveis = quartel.unidades_disponiveis;
    
    // Desenhar cada unidade naval
    for (var i = 0; i < ds_list_size(unidades_disponiveis); i++) {
        var unidade_naval = ds_list_find_value(unidades_disponiveis, i);
        var _unidade_y = _unidades_start_y + (i * (_unidade_height + _unidade_spacing));
        
        // === CARD DA UNIDADE NAVAL ===
        var _card_width = _mw * 0.95;
        var _card_height = _unidade_height;
        var _card_x = _mx + (_mw - _card_width) / 2;
        var _card_y = _unidade_y;
        
        // Verificar se pode recrutar (sem custo por enquanto)
        var pode_recrutar = true;
        
        // Cores do card
        var _bg_color = pode_recrutar ? make_color_rgb(30, 50, 80) : make_color_rgb(60, 40, 40);
        var _border_color = pode_recrutar ? make_color_rgb(80, 140, 220) : make_color_rgb(150, 80, 80);
        
        // Sombra do card
        draw_set_color(make_color_rgb(0, 0, 0));
        draw_set_alpha(0.2);
        draw_roundrect_ext(_card_x + 3, _card_y + 3, _card_x + _card_width + 3, _card_y + _card_height + 3, 8, 8, false);
        draw_set_alpha(1);
        
        // Fundo do card
        draw_set_color(_bg_color);
        draw_set_alpha(0.9);
        draw_roundrect_ext(_card_x, _card_y, _card_x + _card_width, _card_y + _card_height, 8, 8, false);
        draw_set_alpha(1);
        
        // Borda do card
        draw_set_color(_border_color);
        draw_roundrect_ext(_card_x, _card_y, _card_x + _card_width, _card_y + _card_height, 8, 8, true);
        
        // Nome e classe - fonte reduzida em 10%
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_color(c_white);
        var _classe_txt = "";
        if (is_undefined(unidade_naval.classe)) {
            _classe_txt = "";
        } else {
            switch (unidade_naval.classe) {
                case NAVAL_CLASS.CORVETA: _classe_txt = " • Corveta"; break;
                case NAVAL_CLASS.FRAGATA: _classe_txt = " • Fragata"; break;
                case NAVAL_CLASS.DESTROYER: _classe_txt = " • Destroyer"; break;
                case NAVAL_CLASS.CRUZADOR: _classe_txt = " • Cruzador"; break;
                case NAVAL_CLASS.PORTA_AVIOES: _classe_txt = " • Porta-aviões"; break;
            }
        }
        draw_text_transformed(_card_x + 15, _card_y + 12, unidade_naval.nome + _classe_txt, 0.99, 0.99, 0); // 1.1 - 10% = 0.99
        
        // Tempo de treinamento - fonte reduzida em 10%
        draw_set_color(make_color_rgb(180, 200, 220));
        draw_text_transformed(_card_x + 15, _card_y + 32, "Tempo: " + string(unidade_naval.tempo_treino/60) + "s", 0.81, 0.81, 0); // 0.9 - 10% = 0.81
        
        // Descrição - fonte reduzida em 15%
        draw_set_color(make_color_rgb(150, 180, 220));
        draw_text_transformed(_card_x + 15, _card_y + 48, unidade_naval.descricao, 0.68, 0.68, 0); // 0.8 - 15% = 0.68
        
        // === BOTÕES DE QUANTIDADE - TAMANHO REDUZIDO EM 20% ===
        var _btn_width = 56;  // 70 - 20% = 56
        var _btn_height = 32; // 40 - 20% = 32
        var _btn_spacing = 15.75; // 15 + 5% = 15.75
        var _btn_start_x = _card_x + _card_width - 200; // Ajustado para novos tamanhos
        var _btn_y = _card_y + 20;
        
        // Botão 1 unidade
        var _btn1_x = _btn_start_x;
        draw_set_color(make_color_rgb(60, 120, 200));
        draw_set_alpha(0.9);
        draw_roundrect_ext(_btn1_x, _btn_y, _btn1_x + _btn_width, _btn_y + _btn_height, 6, 6, false);
        
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_white);
        draw_text_transformed(_btn1_x + _btn_width/2, _btn_y + _btn_height/2 - 4, "1", 1.08, 1.08, 0); // 1.2 - 10% = 1.08
        draw_text_transformed(_btn1_x + _btn_width/2, _btn_y + _btn_height/2 + 10, "$0", 0.72, 0.72, 0); // 0.8 - 10% = 0.72
        
        // Botão 3 unidades
        var _btn3_x = _btn_start_x + _btn_width + _btn_spacing;
        draw_set_color(make_color_rgb(60, 120, 200));
        draw_set_alpha(0.9);
        draw_roundrect_ext(_btn3_x, _btn_y, _btn3_x + _btn_width, _btn_y + _btn_height, 6, 6, false);
        
        draw_set_color(c_white);
        draw_text_transformed(_btn3_x + _btn_width/2, _btn_y + _btn_height/2 - 4, "3", 1.08, 1.08, 0); // 1.2 - 10% = 1.08
        draw_text_transformed(_btn3_x + _btn_width/2, _btn_y + _btn_height/2 + 10, "$0", 0.72, 0.72, 0); // 0.8 - 10% = 0.72
        
        // Botão 5 unidades
        var _btn5_x = _btn_start_x + (_btn_width + _btn_spacing) * 2;
        draw_set_color(make_color_rgb(60, 120, 200));
        draw_set_alpha(0.9);
        draw_roundrect_ext(_btn5_x, _btn_y, _btn5_x + _btn_width, _btn_y + _btn_height, 6, 6, false);
        
        draw_set_color(c_white);
        draw_text_transformed(_btn5_x + _btn_width/2, _btn_y + _btn_height/2 - 4, "5", 1.08, 1.08, 0); // 1.2 - 10% = 1.08
        draw_text_transformed(_btn5_x + _btn_width/2, _btn_y + _btn_height/2 + 10, "$0", 0.72, 0.72, 0); // 0.8 - 10% = 0.72
    }
}

// === STATUS DE RECRUTAMENTO - MOVIDO PARA 10% ACIMA DA BORDA INFERIOR ===
var _status_y = _my + _mh - (_mh * 0.1) - 60; // 10% acima da borda inferior
var _status_height = 60;
var _status_width = _mw - 40;
var _status_x = _mx + 20;

// Background do status
draw_set_color(make_color_rgb(20, 30, 45));
draw_set_alpha(0.9);
draw_roundrect_ext(_status_x, _status_y, _status_x + _status_width, _status_y + _status_height, 10, 10, false);
draw_set_alpha(1);

// Borda do status
draw_set_color(make_color_rgb(60, 100, 180));
draw_roundrect_ext(_status_x, _status_y, _status_x + _status_width, _status_y + _status_height, 10, 10, true);

if (instance_exists(quartel) && quartel.recrutamento_em_andamento) {
    var unidade_atual = ds_list_find_value(quartel.unidades_disponiveis, quartel.unidade_selecionada);
    draw_set_color(make_color_rgb(100, 200, 255));
    draw_text_transformed(_status_x + 15, _status_y + 15, "CONSTRUINDO: " + unidade_atual.nome, 0.81, 0.81, 0); // 0.9 - 10% = 0.81
    
    // Tempo restante - fonte reduzida em 10%
    draw_set_color(c_white);
    draw_text_transformed(_status_x + 15, _status_y + 35, "Tempo restante: " + string(ceil(quartel.tempo_treinamento_restante / 60)) + "s", 0.72, 0.72, 0); // 0.8 - 10% = 0.72
    
} else {
    draw_set_color(make_color_rgb(100, 255, 150));
    draw_text_transformed(_status_x + 15, _status_y + 15, "PRONTO PARA CONSTRUIR", 0.81, 0.81, 0); // 0.9 - 10% = 0.81
    draw_text_transformed(_status_x + 15, _status_y + 35, "Selecione um navio e clique na quantidade desejada", 0.72, 0.72, 0); // 0.8 - 10% = 0.72
    if (instance_exists(quartel)) {
        draw_set_color(make_color_rgb(150, 180, 220));
        draw_text_transformed(_status_x + 15, _status_y + 60, "Navios construídos: " + string(quartel.unidades_treinadas_total), 0.675, 0.675, 0); // 0.75 - 10% = 0.675
    }
}

// === INSTRUÇÕES - fonte reduzida em 10% ===
draw_set_halign(fa_center);
draw_set_color(make_color_rgb(180, 200, 255));
draw_text_transformed(_mx + _mw/2, _my + _mh - 20, "Clique nos navios para selecionar • Clique fora para fechar", 0.63, 0.63, 0); // 0.7 - 10% = 0.63

// === RESET DE CONFIGURAÇÕES DE DESENHO ===
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1.0);