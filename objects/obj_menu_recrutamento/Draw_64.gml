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

// === PAINEL PRINCIPAL - LAYOUT MELHORADO 1430x786px (+25%) ===
var _mw = 1430;  // Largura aumentada em 25%
var _mh = 786;   // Altura aumentada em 25%
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

// === CABEÇALHO MELHORADO (90px altura) ===
var _header_h = 90; // Altura aumentada proporcionalmente (+25%)
draw_set_color(make_color_rgb(27, 40, 56)); // Azul militar #1B2838
draw_roundrect_ext(_mx, _my, _mx + _mw, _my + _header_h, 16, 16, false);

// Linha divisória clara na base
draw_set_color(make_color_rgb(60, 100, 150));
draw_rectangle(_mx + 20, _my + _header_h - 2, _mx + _mw - 20, _my + _header_h, false);

// === TÍTULO E SUBTÍTULO REFINADOS ===
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Título principal - escala reduzida para melhor organização
draw_set_color(make_color_rgb(192, 168, 98)); // Dourado #C0A862
draw_text_transformed(_mx + _mw/2, _my + 36, "QUARTEL MILITAR", 0.99, 0.99, 0);

// Subtítulo - escala reduzida e espaçamento otimizado
draw_set_color(make_color_rgb(216, 216, 216)); // Cinza #D8D8D8
draw_text_transformed(_mx + _mw/2, _my + 65, "Recrutamento de Unidades Terrestres", 0.72, 0.72, 0);

// === PAINEL LATERAL MELHORADO (358x215px, +25%) ===
var _info_w = 358; // Largura aumentada em 25%
var _info_h = 215; // Altura aumentada em 25%
var _info_x = _mx + _mw - _info_w - 20; // Canto superior direito
var _info_y = _my + 10 + 75; // Painel de recursos desce 35% (215 * 0.35 = 75px)

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
draw_text(_info_x + 15, _info_y + 15, "RECURSOS E STATUS");

// Linha decorativa abaixo do título
draw_set_color(make_color_rgb(60, 100, 150));
draw_rectangle(_info_x + 15, _info_y + 35, _info_x + _info_w - 15, _info_y + 37, false);

// === INFORMAÇÕES DE RECURSOS REFINADAS ===
var _res_y = _info_y + 50; // Posição refinada
var _resource_spacing = 25; // Espaçamento melhorado entre recursos

// Dinheiro
draw_set_color(make_color_rgb(255, 215, 0));
draw_text(_info_x + 15, _res_y, "Dinheiro: $" + string(global.dinheiro));

// População
draw_set_color(make_color_rgb(192, 192, 192));
draw_set_color(make_color_rgb(216, 216, 216)); // Cinza #D8D8D8
draw_text(_info_x + 15, _res_y + _resource_spacing, "População: " + string(global.populacao) + "/20");

// Status do quartel
draw_set_color(make_color_rgb(192, 168, 98)); // Dourado #C0A862
draw_set_color(make_color_rgb(216, 216, 216)); // Cinza #D8D8D8

if (instance_exists(id_do_quartel)) {
    if (id_do_quartel.esta_treinando) {
        draw_text(_info_x + 15, _res_y + (_resource_spacing * 2), "Status: Treinando");
    } else {
        draw_text(_info_x + 15, _res_y + (_resource_spacing * 2), "Status: Disponível");
    }
} else {
    draw_text(_info_x + 15, _res_y + (_resource_spacing * 2), "Status: Erro");
}

// === GRID DE UNIDADES MILITARES REFINADO (2x2) ===
var _grid_x = _mx + 20; // Posicionado à esquerda
var _grid_y = _my + _header_h + 20; // Alinhado com cabeçalho
var _grid_w = _mw - _info_w - 40; // Espaço para painel lateral
var _grid_h = _mh - _header_h - 57; // Rodapé ajustado

// Cards aumentados em 25% + 20% altura + 10% parte de baixo: 293x216px
var card_width = 293;  // +25% de 234px
var card_height = 216; // +25% de 130px + 20% adicional + 10% parte de baixo = 196px + 20px = 216px
var card_spacing = 33; // Espaçamento aumentado proporcionalmente (+25%)

// Ícones ajustados proporcionalmente
var icon_scale = 1.4; // Reduzido ligeiramente para melhor proporção

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
    
    // Todos os cards descem 35%
    _card_y += card_height * 0.35; // Descer 35% da altura do card
    
    // Cards de infantaria e soldado anti sobem 25%
    if (_unidade.nome == "Infantaria" || _unidade.nome == "Soldado Antiaéreo") {
        _card_y -= card_height * 0.25; // Subir 25% da altura do card
    }
    
    // === SISTEMA DE FEEDBACK VISUAL PARA CARDS ===
    // Verificar se o mouse está sobre o card
    var _mouse_gui_x = device_mouse_x_to_gui(0);
    var _mouse_gui_y = device_mouse_y_to_gui(0);
    var _mouse_over_card = (_mouse_gui_x >= _card_x && _mouse_gui_x <= _card_x + card_width && 
                           _mouse_gui_y >= _card_y && _mouse_gui_y <= _card_y + card_height);
    
    // Determinar cor baseada na disponibilidade
    var _can_afford = (global.dinheiro >= _unidade.custo_dinheiro && global.populacao >= _unidade.custo_populacao);
    var _quartel_livre = (!instance_exists(id_do_quartel) || !id_do_quartel.esta_treinando);
    var _disponivel = _can_afford && _quartel_livre;
    
    // Cores refinadas baseadas no status e hover
    var _card_color = c_white; // Cor padrão
    var _border_color = c_white; // Borda padrão
    
    if (_disponivel) {
        if (_mouse_over_card) {
            _card_color = make_color_rgb(56, 84, 72); // Verde mais claro no hover
            _border_color = make_color_rgb(85, 111, 105); // Borda mais brilhante
        } else {
            _card_color = make_color_rgb(46, 74, 62); // Verde militar padrão
            _border_color = make_color_rgb(75, 91, 95); // Borda padrão
        }
    } else if (!_can_afford) {
        if (_mouse_over_card) {
            _card_color = make_color_rgb(204, 96, 96); // Vermelho mais claro no hover
            _border_color = make_color_rgb(212, 148, 148); // Borda vermelha clara
        } else {
            _card_color = make_color_rgb(184, 76, 76); // Vermelho padrão
            _border_color = make_color_rgb(192, 128, 128); // Borda vermelha
        }
    } else {
        if (_mouse_over_card) {
            _card_color = make_color_rgb(212, 188, 118); // Dourado mais claro no hover
            _border_color = make_color_rgb(212, 220, 148); // Borda dourada clara
        } else {
            _card_color = make_color_rgb(192, 168, 98); // Dourado padrão
            _border_color = make_color_rgb(192, 200, 128); // Borda dourada
        }
    }
    
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
    
    // === ÍCONE DA UNIDADE ===
    if (sprite_exists(_unidade.sprite)) {
        var _icon_x = _card_x + card_width / 2;
        var _icon_y = _card_y + 41; // Posição ajustada para altura aumentada (+20%)
        
        // Fundo circular para o ícone
        draw_set_color(make_color_rgb(40, 50, 70));
        draw_set_alpha(0.8);
        draw_circle(_icon_x, _icon_y, 33, true); // Raio aumentado proporcionalmente (+25%)
        draw_set_alpha(1);

        // Ícone da unidade
        draw_sprite_ext(_unidade.sprite, 0, _icon_x, _icon_y, 1.1, 1.1, 0, c_white, 1);
    }

    // === NOME DA UNIDADE ===
    draw_set_halign(fa_center);
    draw_set_color(make_color_rgb(192, 168, 98)); // Dourado #C0A862
    draw_text(_card_x + card_width / 2, _card_y + 93, _unidade.nome);
    
    // Linha divisória
    draw_set_color(make_color_rgb(60, 100, 150));
    draw_set_alpha(0.5);
    draw_rectangle(_card_x + 10, _card_y + 123, _card_x + card_width - 10, _card_y + 125, false);
    draw_set_alpha(1);
    
    // === INFORMAÇÕES ALINHADAS ===
    var _info_y = _card_y + 137; // Posição ajustada para altura aumentada (+20%)
    
    // Dinheiro
    draw_set_color(make_color_rgb(255, 215, 0));
    draw_text(_card_x + 10, _info_y, "$" + string(_unidade.custo_dinheiro));
    
    // População
    draw_set_color(make_color_rgb(192, 192, 192));
    draw_text(_card_x + card_width/2 - 20, _info_y, string(_unidade.custo_populacao) + "POP");
    
    // Tempo
    draw_set_color(make_color_rgb(180, 180, 180));
    draw_text(_card_x + card_width - 30, _info_y, string(_unidade.tempo_treino / 60) + "s");
    
    // === BOTÃO DE RECRUTAR MELHORADO (+25% + 10%) ===
    var _btn_w = 161; // +10% de 146px = 161px
    var _btn_h = 40;  // +10% de 36px = 40px
    var _btn_x = _card_x + (card_width - _btn_w) / 2;
    var _btn_y = _card_y + card_height - 75; // Botão desce 10% adicional (66 + 9 = 75)
    
    // === SISTEMA DE FEEDBACK VISUAL MELHORADO ===
    // Verificar se o mouse está sobre o botão para feedback visual
    var _mouse_gui_x = device_mouse_x_to_gui(0);
    var _mouse_gui_y = device_mouse_y_to_gui(0);
    var _mouse_over_btn = (_mouse_gui_x >= _btn_x && _mouse_gui_x <= _btn_x + _btn_w && 
                          _mouse_gui_y >= _btn_y && _mouse_gui_y <= _btn_y + _btn_h);
    
    // Cor do botão baseada na disponibilidade e estado do mouse
    var _btn_color = c_white; // Cor padrão
    var _border_color = c_white; // Borda padrão
    var _text_color = c_white; // Texto padrão
    
    if (_disponivel) {
        if (_mouse_over_btn) {
            _btn_color = make_color_rgb(90, 150, 220); // Azul mais claro no hover
            _border_color = make_color_rgb(120, 180, 250); // Borda mais brilhante
        } else {
            _btn_color = make_color_rgb(70, 130, 200); // Azul padrão disponível
            _border_color = make_color_rgb(100, 160, 230); // Borda azul
        }
        _text_color = c_white;
    } else if (!_can_afford) {
        _btn_color = make_color_rgb(200, 100, 100); // Vermelho para sem recursos
        _border_color = make_color_rgb(220, 120, 120); // Borda vermelha
        _text_color = c_white;
    } else {
        _btn_color = make_color_rgb(120, 120, 120); // Cinza para quartel ocupado
        _border_color = make_color_rgb(140, 140, 140); // Borda cinza
        _text_color = make_color_rgb(200, 200, 200); // Texto cinza claro
    }
    
    // Sombra do botão para profundidade
    draw_set_color(make_color_rgb(0, 0, 0));
    draw_set_alpha(0.3);
    draw_roundrect_ext(_btn_x + 2, _btn_y + 2, _btn_x + _btn_w + 2, _btn_y + _btn_h + 2, 8, 8, false);
    draw_set_alpha(1);
    
    // Fundo do botão
    draw_set_color(_btn_color);
    draw_roundrect_ext(_btn_x, _btn_y, _btn_x + _btn_w, _btn_y + _btn_h, 8, 8, false);
    
    // Borda do botão (moldura melhorada)
    draw_set_color(_border_color);
    draw_roundrect_ext(_btn_x, _btn_y, _btn_x + _btn_w, _btn_y + _btn_h, 8, 8, true);
    
    // Texto do botão com melhor legibilidade
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(_text_color);
    var _btn_text = _disponivel ? "RECRUTAR" : (!_can_afford ? "SEM RECURSOS" : "QUARTEL OCUPADO");
    draw_text(_btn_x + _btn_w/2, _btn_y + _btn_h/2, _btn_text);
    
    // Indicador visual adicional para disponibilidade
    if (_disponivel && _mouse_over_btn) {
        // Brilho sutil no hover
        draw_set_color(make_color_rgb(255, 255, 255));
        draw_set_alpha(0.2);
        draw_roundrect_ext(_btn_x, _btn_y, _btn_x + _btn_w, _btn_y + _btn_h, 8, 8, false);
        draw_set_alpha(1);
    }
    
    // Dica visual quando mouse está sobre card disponível
    if (_disponivel && _mouse_over_card) {
        // Borda pulsante sutil
        draw_set_color(make_color_rgb(100, 200, 100));
        draw_set_alpha(0.6);
        draw_roundrect_ext(_card_x - 2, _card_y - 2, _card_x + card_width + 2, _card_y + card_height + 2, 10, 10, true);
        draw_set_alpha(1);
        
        // Texto de dica
        draw_set_halign(fa_center);
        draw_set_color(make_color_rgb(255, 255, 255));
        draw_text(_card_x + card_width/2, _card_y - 15, "Clique para recrutar");
    }
}

// === RODAPÉ MELHORADO ===
var _footer_h = 58; // Altura ajustada proporcionalmente (+25%)
var _footer_y = _my + _mh - _footer_h;

// Fundo do rodapé - azul militar escuro contínuo, sem borda superior
draw_set_color(make_color_rgb(27, 40, 56)); // Azul militar #1B2838
draw_roundrect_ext(_mx, _footer_y, _mx + _mw, _my + _mh, 0, 16, false);

// Instrução
draw_set_halign(fa_left);
draw_set_color(make_color_rgb(200, 200, 200)); // Branco-cinza
draw_text(_mx + 20, _footer_y + 15, "Clique em uma unidade para recrutar.");

// === BOTÃO FECHAR MELHORADO (+25%) ===
var _close_w = 114; // +25% de 91px
var _close_h = 36;  // +25% de 29px
var _close_x = _mx + _mw - _close_w - 20;
var _close_y = _footer_y + 10; // Posição ajustada (+25%)

// === SISTEMA DE FEEDBACK VISUAL PARA BOTÃO FECHAR ===
var _mouse_gui_x = device_mouse_x_to_gui(0);
var _mouse_gui_y = device_mouse_y_to_gui(0);
var _mouse_over_close = (_mouse_gui_x >= _close_x && _mouse_gui_x <= _close_x + _close_w && 
                        _mouse_gui_y >= _close_y && _mouse_gui_y <= _close_y + _close_h);

// Cores do botão fechar baseadas no estado do mouse
var _close_color = _mouse_over_close ? make_color_rgb(220, 80, 80) : make_color_rgb(184, 76, 76);
var _close_border = _mouse_over_close ? make_color_rgb(240, 100, 100) : make_color_rgb(200, 100, 100);

// Sombra do botão fechar
draw_set_color(make_color_rgb(0, 0, 0));
draw_set_alpha(0.3);
draw_roundrect_ext(_close_x + 2, _close_y + 2, _close_x + _close_w + 2, _close_y + _close_h + 2, 8, 8, false);
draw_set_alpha(1);

// Fundo do botão fechar
draw_set_color(_close_color);
draw_roundrect_ext(_close_x, _close_y, _close_x + _close_w, _close_y + _close_h, 8, 8, false);

// Borda do botão fechar (moldura melhorada)
draw_set_color(_close_border);
draw_roundrect_ext(_close_x, _close_y, _close_x + _close_w, _close_y + _close_h, 8, 8, true);

// Texto do botão fechar
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text(_close_x + _close_w/2, _close_y + _close_h/2, "FECHAR");

// Brilho adicional no hover
if (_mouse_over_close) {
    draw_set_color(make_color_rgb(255, 255, 255));
    draw_set_alpha(0.15);
    draw_roundrect_ext(_close_x, _close_y, _close_x + _close_w, _close_y + _close_h, 8, 8, false);
    draw_set_alpha(1);
}

// === RESETAR CONFIGURAÇÕES ===
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
