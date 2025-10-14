// ===============================================
// HEGEMONIA GLOBAL - QUARTEL MILITAR PADRONIZADO
// Layout Moderno 960x520px - Design Militar Consistente
// ===============================================

// Configurar fonte e definir cor básica
draw_set_font(fnt_ui_main);
draw_set_color(c_white);

// === OVERLAY DE FUNDO MODERNO ===
draw_set_alpha(0.9);
draw_set_color(make_color_rgb(10, 15, 25));
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
draw_set_alpha(1);

// === PAINEL PRINCIPAL - LAYOUT REFINADO 800x440px ===
var _mw = 800;  // Largura ideal refinada
var _mh = 440;  // Altura ideal refinada
var _mx = (display_get_gui_width() - _mw) / 2;
var _my = (display_get_gui_height() - _mh) / 2; // Centralização vertical perfeita

// Sombra do painel principal (mais dramática)
draw_set_color(make_color_rgb(0, 0, 0));
draw_set_alpha(0.5);
draw_roundrect_ext(_mx + 8, _my + 8, _mx + _mw + 8, _my + _mh + 8, 20, 20, false);
draw_set_alpha(1);

// Fundo do painel principal - gradiente militar
draw_set_color(make_color_rgb(15, 25, 40));
draw_set_alpha(0.98);
draw_roundrect_ext(_mx, _my, _mx + _mw, _my + _mh, 20, 20, false);
draw_set_alpha(1);

// Borda principal com efeito de brilho
draw_set_color(make_color_rgb(50, 80, 120));
draw_roundrect_ext(_mx, _my, _mx + _mw, _my + _mh, 20, 20, true);

// === CABEÇALHO REFINADO (50px altura) ===
var _header_h = 50;
draw_set_color(make_color_rgb(27, 40, 56)); // Azul militar #1B2838
draw_roundrect_ext(_mx, _my, _mx + _mw, _my + _header_h, 16, 16, false);

// Linha divisória clara na base
draw_set_color(make_color_rgb(60, 100, 150));
draw_rectangle(_mx + 20, _my + _header_h - 2, _mx + _mw - 20, _my + _header_h, false);

// === TÍTULO E SUBTÍTULO REFINADOS ===
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Título principal - centralizado perfeitamente
draw_set_color(make_color_rgb(192, 168, 98)); // Dourado #C0A862
draw_text_transformed(_mx + _mw/2, _my + 20, "🪖 QUARTEL MILITAR 🪖", 1.1, 1.1, 0);

// Subtítulo - 4px mais abaixo, fonte menor (14px)
draw_set_color(make_color_rgb(216, 216, 216)); // Cinza #D8D8D8
draw_text_transformed(_mx + _mw/2, _my + 38, "Recrutamento de Unidades Terrestres", 0.8, 0.8, 0);

// === PAINEL LATERAL REFINADO (200x120px, canto superior direito) ===
var _info_w = 200; // Largura refinada
var _info_h = 120; // Altura refinada
var _info_x = _mx + _mw - _info_w - 20; // Canto superior direito
var _info_y = _my + 10; // No mesmo plano do cabeçalho

// Fundo do painel lateral - semibrilho translúcido (opacidade ~70%)
draw_set_color(make_color_rgb(46, 74, 62)); // Verde militar #2E4A3E
draw_set_alpha(0.7); // Opacidade refinada
draw_roundrect_ext(_info_x, _info_y, _info_x + _info_w, _info_y + _info_h, 12, 12, false);
draw_set_alpha(1);

// Borda do painel lateral - mais sutil
draw_set_color(make_color_rgb(60, 100, 150));
draw_roundrect_ext(_info_x, _info_y, _info_x + _info_w, _info_y + _info_h, 12, 12, true);

// Título do painel refinado
draw_set_halign(fa_left);
draw_set_color(make_color_rgb(192, 168, 98)); // Dourado #C0A862
draw_text(_info_x + 15, _info_y + 15, "📊 RECURSOS E STATUS");

// Linha decorativa abaixo do título
draw_set_color(make_color_rgb(60, 100, 150));
draw_rectangle(_info_x + 15, _info_y + 35, _info_x + _info_w - 15, _info_y + 37, false);

// === INFORMAÇÕES DE RECURSOS REFINADAS ===
var _res_y = _info_y + 50; // Posição refinada

// Dinheiro com ícone pequeno
draw_set_color(make_color_rgb(255, 215, 0));
draw_text_transformed(_info_x + 15, _res_y, "💰", 0.8, 0.8, 0);
draw_set_color(make_color_rgb(216, 216, 216)); // Cinza #D8D8D8
draw_text(_info_x + 35, _res_y, "Dinheiro: $" + string(global.dinheiro));

// População com ícone pequeno (4px espaçamento vertical)
draw_set_color(make_color_rgb(192, 192, 192));
draw_text_transformed(_info_x + 15, _res_y + 20, "👥", 0.8, 0.8, 0);
draw_set_color(make_color_rgb(216, 216, 216)); // Cinza #D8D8D8
draw_text(_info_x + 35, _res_y + 20, "População: " + string(global.populacao) + "/20");

// Status do quartel com ícone pequeno (4px espaçamento vertical)
draw_set_color(make_color_rgb(192, 168, 98)); // Dourado #C0A862
draw_text_transformed(_info_x + 15, _res_y + 40, "🏗️", 0.8, 0.8, 0);
draw_set_color(make_color_rgb(216, 216, 216)); // Cinza #D8D8D8

if (instance_exists(id_do_quartel)) {
    if (id_do_quartel.esta_treinando) {
        draw_text(_info_x + 35, _res_y + 40, "Status: Treinando");
    } else {
        draw_text(_info_x + 35, _res_y + 40, "Status: Disponível");
    }
} else {
    draw_text(_info_x + 35, _res_y + 40, "Status: Erro");
}

// === GRID DE UNIDADES MILITARES REFINADO (2x2) ===
var _grid_x = _mx + 20; // Posicionado à esquerda
var _grid_y = _my + _header_h + 20; // Alinhado com cabeçalho
var _grid_w = _mw - _info_w - 40; // Espaço para painel lateral
var _grid_h = _mh - _header_h - 52; // Espaço para rodapé refinado

// Cards refinados 180x100px (mais largos e mais baixos)
var card_width = 180;  // Largura refinada
var card_height = 100; // Altura refinada
var card_spacing = 20; // Espaçamento mantido

// Ajustar o tamanho dos ícones
var icon_scale = 1.5;  // Reduzir o tamanho

// Obter unidades disponíveis
var _unidades = [];
if (instance_exists(id_do_quartel)) {
    _unidades = id_do_quartel.unidades_disponiveis;
}

// Desenhar cards das unidades militares (grade 2x2 padronizada)
for (var i = 0; i < min(4, ds_list_size(_unidades)); i++) {
    var _unidade = ds_list_find_value(_unidades, i);
    var _row = i div 2;
    var _col = i mod 2;
    
    var _card_x = _grid_x + _col * (card_width + card_spacing);
    var _card_y = _grid_y + _row * (card_height + card_spacing);
    
    // Determinar cor baseada na disponibilidade
    var _can_afford = (global.dinheiro >= _unidade.custo_dinheiro && global.populacao >= _unidade.custo_populacao);
    var _quartel_livre = (!instance_exists(id_do_quartel) || !id_do_quartel.esta_treinando);
    var _disponivel = _can_afford && _quartel_livre;
    
    // Cores refinadas baseadas no status
    var _card_color = _disponivel ? make_color_rgb(46, 74, 62) : // Verde militar #2E4A3E
                     (!_can_afford ? make_color_rgb(184, 76, 76) : make_color_rgb(192, 168, 98)); // Vermelho ou dourado
    
    var _border_color = _disponivel ? make_color_rgb(75, 91, 95) : // #4B5B5F (borda mais fina)
                       (!_can_afford ? make_color_rgb(192, 128, 128) : make_color_rgb(192, 200, 128)); // Vermelho ou amarelo suave
    
    // Sombra do card refinada
    draw_set_color(make_color_rgb(0, 0, 0));
    draw_set_alpha(0.3);
    draw_roundrect_ext(_card_x + 2, _card_y + 2, _card_x + card_width + 2, _card_y + card_height + 2, 8, 8, false);
    draw_set_alpha(1);
    
    // Fundo do card refinado
    draw_set_color(_card_color);
    draw_set_alpha(0.95);
    draw_roundrect_ext(_card_x, _card_y, _card_x + card_width, _card_y + card_height, 8, 8, false);
    draw_set_alpha(1);

    // Borda do card refinada (1px em vez de 2px)
    draw_set_color(_border_color);
    draw_roundrect_ext(_card_x, _card_y, _card_x + card_width, _card_y + card_height, 8, 8, true);
    
    // === ÍCONE DA UNIDADE (10px margem do topo) ===
    if (sprite_exists(_unidade.sprite)) {
        var _icon_x = _card_x + card_width / 2;
        var _icon_y = _card_y + 20; // 10px margem do topo
        
        // Fundo circular para o ícone
        draw_set_color(make_color_rgb(40, 50, 70));
        draw_set_alpha(0.8);
        draw_circle(_icon_x, _icon_y, 20, true);
        draw_set_alpha(1);

        // Ícone da unidade
        draw_sprite_ext(_unidade.sprite, 0, _icon_x, _icon_y, 1.0, 1.0, 0, c_white, 1);
    }

    // === NOME DA UNIDADE (logo abaixo do ícone) ===
    draw_set_halign(fa_center);
    draw_set_color(make_color_rgb(192, 168, 98)); // Dourado #C0A862
    draw_text(_card_x + card_width / 2, _card_y + 45, _unidade.nome);
    
    // Linha divisória (opacidade 50%, azul-claro)
    draw_set_color(make_color_rgb(60, 100, 150));
    draw_set_alpha(0.5);
    draw_rectangle(_card_x + 10, _card_y + 60, _card_x + card_width - 10, _card_y + 62, false);
    draw_set_alpha(1);
    
    // === INFORMAÇÕES ALINHADAS HORIZONTALMENTE ===
    var _info_y = _card_y + 70;
    
    // Dinheiro
    draw_set_color(make_color_rgb(255, 215, 0));
    draw_text(_card_x + 10, _info_y, "$" + string(_unidade.custo_dinheiro));
    
    // População
    draw_set_color(make_color_rgb(192, 192, 192));
    draw_text(_card_x + card_width/2 - 20, _info_y, string(_unidade.custo_populacao) + "POP");
    
    // Tempo
    draw_set_color(make_color_rgb(180, 180, 180));
    draw_text(_card_x + card_width - 30, _info_y, string(_unidade.tempo_treino / 60) + "s");
    
    // === BOTÃO DE RECRUTAR REFINADO (90px largura, 22px altura) ===
    var _btn_w = 90; // Largura refinada
    var _btn_h = 22; // Altura refinada
    var _btn_x = _card_x + (card_width - _btn_w) / 2; // Centralizado
    var _btn_y = _card_y + card_height - 30; // Posição fixa no rodapé do card
    
    // Cor do botão baseada na disponibilidade
    var _btn_color = _disponivel ? make_color_rgb(70, 130, 200) : make_color_rgb(100, 100, 100);
    
    // Fundo do botão
    draw_set_color(_btn_color);
    draw_roundrect_ext(_btn_x, _btn_y, _btn_x + _btn_w, _btn_y + _btn_h, 6, 6, false);
    
    // Borda do botão
    draw_set_color(c_white);
    draw_roundrect_ext(_btn_x, _btn_y, _btn_x + _btn_w, _btn_y + _btn_h, 6, 6, true);
    
    // Texto do botão
    draw_set_halign(fa_center);
    draw_set_color(c_white);
    var _btn_text = _disponivel ? "RECRUTAR" : (!_can_afford ? "SEM RECURSOS" : "QUARTEL OCUPADO");
    draw_text(_btn_x + _btn_w/2, _btn_y + _btn_h/2, _btn_text);
}

// === RODAPÉ REFINADO (32px altura) ===
var _footer_h = 32;
var _footer_y = _my + _mh - _footer_h;

// Fundo do rodapé - azul militar escuro contínuo, sem borda superior
draw_set_color(make_color_rgb(27, 40, 56)); // Azul militar #1B2838
draw_roundrect_ext(_mx, _footer_y, _mx + _mw, _my + _mh, 0, 16, false);

// Instrução à esquerda em branco-cinza
draw_set_halign(fa_left);
draw_set_color(make_color_rgb(200, 200, 200)); // Branco-cinza
draw_text(_mx + 20, _footer_y + 8, "Clique em uma unidade para recrutar.");

// Botão fechar à direita com espaçamento de 20px da borda
var _close_w = 70;
var _close_h = 22;
var _close_x = _mx + _mw - _close_w - 20; // 20px da borda
var _close_y = _footer_y + 5;

// Verificar se o mouse está sobre o botão para brilho vermelho
var _mouse_over_close = (mouse_x >= _close_x && mouse_x <= _close_x + _close_w && 
                        mouse_y >= _close_y && mouse_y <= _close_y + _close_h);

// Fundo do botão fechar com brilho condicional
var _close_color = _mouse_over_close ? make_color_rgb(200, 60, 60) : make_color_rgb(184, 76, 76); // Brilho vermelho no hover
draw_roundrect_ext(_close_x, _close_y, _close_x + _close_w, _close_y + _close_h, 6, 6, false);

// Borda do botão
draw_set_color(c_white);
draw_roundrect_ext(_close_x, _close_y, _close_x + _close_w, _close_y + _close_h, 6, 6, true);

// Texto do botão
draw_set_halign(fa_center);
draw_set_color(c_white);
draw_text(_close_x + _close_w/2, _close_y + _close_h/2, "FECHAR");

// === RESETAR CONFIGURAÇÕES ===
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
