// ===============================================
// HEGEMONIA GLOBAL - MENU RECRUTAMENTO REORGANIZADO
// Layout Limpo e Organizado - Cada Elemento em Seu Lugar
// ===============================================

// Configurar fonte e definir cor básica
draw_set_font(fnt_ui_main);
draw_set_color(c_white);

// === OVERLAY DE FUNDO ANIMADO ===
draw_set_alpha(overlay_alpha);
draw_set_color(make_color_rgb(5, 8, 15));
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
draw_set_alpha(1);

// === PAINEL PRINCIPAL COM SCALE E ALPHA ANIMADOS ===
var _mw = 1430;
var _mh = 786;
var _mx = (display_get_gui_width() - _mw) / 2;
var _my = (display_get_gui_height() - _mh) / 2;

// Aplicar transformações de animação
var _scale_offset_x = (_mw * (1 - menu_scale)) / 2;
var _scale_offset_y = (_mh * (1 - menu_scale)) / 2;
var _animated_mx = _mx + _scale_offset_x;
var _animated_my = _my + _scale_offset_y;
var _animated_mw = _mw * menu_scale;
var _animated_mh = _mh * menu_scale;

// Sombra do painel principal
draw_set_color(make_color_rgb(0, 0, 0));
draw_set_alpha(0.4 * menu_alpha);
draw_roundrect_ext(_animated_mx + 12, _animated_my + 12, _animated_mx + _animated_mw + 12, _animated_my + _animated_mh + 12, 24, 24, false);
draw_set_alpha(1);

// Fundo do painel principal - gradiente militar animado
draw_set_alpha(menu_alpha);
draw_set_color(make_color_rgb(12, 18, 28));
draw_roundrect_ext(_animated_mx, _animated_my, _animated_mx + _animated_mw, _animated_my + _animated_mh, 24, 24, false);

// Gradiente interno sutil
draw_set_color(make_color_rgb(18, 28, 42));
draw_roundrect_ext(_animated_mx + 2, _animated_my + 2, _animated_mx + _animated_mw - 2, _animated_my + _animated_mh - 2, 22, 22, false);

// Borda principal com efeito de brilho animado
draw_set_color(make_color_rgb(45 + 15 * header_glow_intensity, 70 + 20 * header_glow_intensity, 105 + 25 * header_glow_intensity));
draw_roundrect_ext(_animated_mx, _animated_my, _animated_mx + _animated_mw, _animated_my + _animated_mh, 24, 24, true);
draw_set_alpha(1);

// === SEÇÃO 1: CABEÇALHO LIMPO ===
var _header_h = 70;
draw_set_alpha(menu_alpha);

// Gradiente vertical no cabeçalho
var _gradient_steps = 15;
for (var i = 0; i < _gradient_steps; i++) {
    var _step_alpha = i / _gradient_steps;
    var _step_color = make_color_rgb(
        20 + 15 * _step_alpha,
        30 + 20 * _step_alpha,
        45 + 15 * _step_alpha
    );
    var _step_y = _animated_my + (i * _header_h / _gradient_steps);
    var _step_height = _header_h / _gradient_steps;
    
    draw_set_color(_step_color);
    draw_rectangle(_animated_mx, _step_y, _animated_mx + _animated_mw, _step_y + _step_height, false);
}

// Linha divisória animada
draw_set_color(make_color_rgb(60 + 20 * header_glow_intensity, 100 + 30 * header_glow_intensity, 150 + 40 * header_glow_intensity));
draw_set_alpha(header_line_alpha * menu_alpha);
draw_rectangle(_animated_mx + 20, _animated_my + _header_h - 3, _animated_mx + _animated_mw - 20, _animated_my + _header_h, false);
draw_set_alpha(1);

// Título principal centralizado
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(make_color_rgb(192 + 30 * header_glow_intensity, 168 + 20 * header_glow_intensity, 98 + 15 * header_glow_intensity));
draw_text_transformed(_animated_mx + _animated_mw/2, _animated_my + 25, "QUARTEL MILITAR", 1.0, 1.0, 0);

// Subtítulo separado
draw_set_color(make_color_rgb(200, 200, 200));
draw_set_alpha(menu_alpha * header_line_alpha);
draw_text_transformed(_animated_mx + _animated_mw/2, _animated_my + 50, "Recrutamento de Unidades Terrestres", 0.8, 0.8, 0);
draw_set_alpha(1);

// === SEÇÃO 2: PAINEL DE STATUS (ESQUERDA SUPERIOR) ===
var _status_w = 280;
var _status_h = 120;
var _status_x = _animated_mx + 20;
var _status_y = _animated_my + 80;

draw_set_alpha(menu_alpha);

// Fundo do painel de status
draw_set_color(make_color_rgb(25, 35, 45));
draw_roundrect_ext(_status_x, _status_y, _status_x + _status_w, _status_y + _status_h, 12, 12, false);

// Borda do painel
draw_set_color(make_color_rgb(60, 100, 150));
draw_roundrect_ext(_status_x, _status_y, _status_x + _status_w, _status_y + _status_h, 12, 12, true);

// Título do painel
draw_set_halign(fa_center);
draw_set_color(make_color_rgb(192, 168, 98));
draw_text(_status_x + _status_w/2, _status_y + 15, "STATUS DO QUARTEL");

// Linha divisória
draw_set_color(make_color_rgb(60, 100, 150));
draw_set_alpha(0.6 * menu_alpha);
draw_rectangle(_status_x + 15, _status_y + 35, _status_x + _status_w - 15, _status_y + 37, false);
draw_set_alpha(1);

// Conteúdo organizado em linhas separadas
draw_set_halign(fa_left);
var _line_y = _status_y + 50;
var _line_spacing = 20;

// Status do quartel
draw_set_color(make_color_rgb(200, 200, 200));
draw_text(_status_x + 15, _line_y, "Status:");
if (instance_exists(id_do_quartel) && id_do_quartel.esta_treinando) {
    draw_set_color(make_color_rgb(255, 165, 0));
    draw_text(_status_x + 80, _line_y, "Treinando");
} else {
    draw_set_color(make_color_rgb(50, 205, 50));
    draw_text(_status_x + 80, _line_y, "Disponível");
}

// Tempo restante (se treinando)
if (instance_exists(id_do_quartel) && id_do_quartel.esta_treinando) {
    var _tempo_restante = max(0, id_do_quartel.alarm[0]);
    draw_set_color(make_color_rgb(200, 200, 200));
    draw_text(_status_x + 15, _line_y + _line_spacing, "Tempo:");
    draw_set_color(make_color_rgb(255, 255, 255));
    draw_text(_status_x + 80, _line_y + _line_spacing, string(_tempo_restante / 60) + "s");
}

// === SEÇÃO 3: PAINEL DE RECURSOS (DIREITA SUPERIOR) ===
var _recursos_w = 280;
var _recursos_h = 120;
var _recursos_x = _animated_mx + _animated_mw - _recursos_w - 20;
var _recursos_y = _animated_my + 80;

// Fundo do painel de recursos
draw_set_color(make_color_rgb(25, 35, 45));
draw_roundrect_ext(_recursos_x, _recursos_y, _recursos_x + _recursos_w, _recursos_y + _recursos_h, 12, 12, false);

// Borda do painel
draw_set_color(make_color_rgb(60, 100, 150));
draw_roundrect_ext(_recursos_x, _recursos_y, _recursos_x + _recursos_w, _recursos_y + _recursos_h, 12, 12, true);

// Título do painel
draw_set_halign(fa_center);
draw_set_color(make_color_rgb(192, 168, 98));
draw_text(_recursos_x + _recursos_w/2, _recursos_y + 15, "RECURSOS");

// Linha divisória
draw_set_color(make_color_rgb(60, 100, 150));
draw_set_alpha(0.6 * menu_alpha);
draw_rectangle(_recursos_x + 15, _recursos_y + 35, _recursos_x + _recursos_w - 15, _recursos_y + 37, false);
draw_set_alpha(1);

// Recursos organizados
draw_set_halign(fa_left);
var _res_y = _recursos_y + 50;

// Dinheiro
draw_set_color(make_color_rgb(255, 215, 0));
draw_text(_recursos_x + 15, _res_y, "Dinheiro:");
draw_set_color(make_color_rgb(255, 255, 255));
draw_text(_recursos_x + 100, _res_y, "$" + string(global.dinheiro));

// População
draw_set_color(make_color_rgb(100, 200, 255));
draw_text(_recursos_x + 15, _res_y + 20, "População:");
draw_set_color(make_color_rgb(255, 255, 255));
draw_text(_recursos_x + 100, _res_y + 20, string(global.populacao) + "/20");

// Feedback de confirmação
if (recruitment_confirmation && confirmation_timer > 0) {
    var _confirmation_alpha = confirmation_timer / 30.0;
    var _confirmation_y = _res_y + 50;
    
    draw_set_color(make_color_rgb(50, 205, 50));
    draw_set_alpha(_confirmation_alpha * menu_alpha);
    draw_text(_recursos_x + 15, _confirmation_y, "✓ " + confirmation_text);
    draw_set_alpha(1);
}

draw_set_alpha(1);

// === SEÇÃO 4: GRID DE UNIDADES (CENTRO) ===
var _grid_x = _animated_mx + 20;
var _grid_y = _animated_my + 220; // Bem separado dos painéis superiores
var _grid_w = _animated_mw - 40;
var _grid_h = 400;

// Título da seção de unidades
draw_set_halign(fa_center);
draw_set_color(make_color_rgb(192, 168, 98));
draw_text(_grid_x + _grid_w/2, _grid_y - 30, "UNIDADES DISPONÍVEIS");

// Obter unidades disponíveis
var _unidades = [];
if (instance_exists(id_do_quartel)) {
    _unidades = id_do_quartel.unidades_disponiveis;
}

// Cards das unidades com espaçamento adequado
var card_width = 300;
var card_height = 200;
var card_spacing_x = 40;
var card_spacing_y = 30;

// Desenhar cards organizados em grid 2x2
for (var i = 0; i < min(4, ds_list_size(_unidades)); i++) {
    var _unidade = ds_list_find_value(_unidades, i);
    var _row = i div 2;
    var _col = i mod 2;
    
    var _card_x = _grid_x + _col * (card_width + card_spacing_x);
    var _card_y = _grid_y + _row * (card_height + card_spacing_y);
    
    // Aplicar animações do card
    var card = card_animations[i];
    var hover = card_hover_effects[i];
    
    // Aplicar offsets de animação
    _card_y += card.offset_y;
    
    // Aplicar scale de animação
    var _card_scale = card.scale;
    var _scaled_width = card_width * _card_scale;
    var _scaled_height = card_height * _card_scale;
    var _scale_offset_x = (card_width - _scaled_width) / 2;
    var _scale_offset_y = (card_height - _scaled_height) / 2;
    
    _card_x += _scale_offset_x;
    _card_y += _scale_offset_y;
    
    // === CARD DA UNIDADE ORGANIZADO ===
    
    // Verificar disponibilidade
    var _can_afford = (global.dinheiro >= _unidade.custo_dinheiro && global.populacao >= _unidade.custo_populacao);
    var _quartel_livre = (!instance_exists(id_do_quartel) || !id_do_quartel.esta_treinando);
    var _disponivel = _can_afford && _quartel_livre;
    
    // Alpha do card baseado na animação
    var _card_alpha = card.alpha * menu_alpha;
    
    // Cores baseadas na disponibilidade
    var _card_color = c_white;
    var _border_color = c_white;
    
    if (_disponivel) {
        _card_color = make_color_rgb(40 + 20 * hover.hover_alpha, 65 + 15 * hover.hover_alpha, 55 + 10 * hover.hover_alpha);
        _border_color = make_color_rgb(70 + 25 * hover.hover_alpha, 95 + 20 * hover.hover_alpha, 85 + 15 * hover.hover_alpha);
    } else if (!_can_afford) {
        _card_color = make_color_rgb(170 + 20 * hover.hover_alpha, 70 + 15 * hover.hover_alpha, 70 + 10 * hover.hover_alpha);
        _border_color = make_color_rgb(190 + 25 * hover.hover_alpha, 100 + 20 * hover.hover_alpha, 100 + 15 * hover.hover_alpha);
    } else {
        _card_color = make_color_rgb(180 + 20 * hover.hover_alpha, 155 + 15 * hover.hover_alpha, 85 + 10 * hover.hover_alpha);
        _border_color = make_color_rgb(200 + 25 * hover.hover_alpha, 175 + 20 * hover.hover_alpha, 105 + 15 * hover.hover_alpha);
    }
    
    // Sombra do card
    draw_set_color(make_color_rgb(0, 0, 0));
    draw_set_alpha(0.3 * _card_alpha);
    draw_roundrect_ext(_card_x + 3, _card_y + 3, _card_x + _scaled_width + 3, _card_y + _scaled_height + 3, 12, 12, false);
    
    // Fundo do card
    draw_set_color(_card_color);
    draw_set_alpha(0.95 * _card_alpha);
    draw_roundrect_ext(_card_x, _card_y, _card_x + _scaled_width, _card_y + _scaled_height, 12, 12, false);
    
    // Borda do card
    draw_set_color(_border_color);
    draw_set_alpha(_card_alpha);
    draw_roundrect_ext(_card_x, _card_y, _card_x + _scaled_width, _card_y + _scaled_height, 12, 12, true);
    
    // Efeito de glow quando disponível
    if (_disponivel && hover.glow_intensity > 0) {
        draw_set_color(make_color_rgb(100, 200, 100));
        draw_set_alpha(hover.glow_intensity * _card_alpha);
        draw_roundrect_ext(_card_x - 3, _card_y - 3, _card_x + _scaled_width + 3, _card_y + _scaled_height + 3, 15, 15, true);
    }
    
    draw_set_alpha(1);
    
    // === ÁREA DO ÍCONE (TOP) ===
    var _icon_area_h = 60;
    draw_set_halign(fa_center);
    
    // Ícone da unidade
    if (sprite_exists(_unidade.sprite)) {
        draw_sprite_ext(_unidade.sprite, 0, _card_x + _scaled_width/2, _card_y + _icon_area_h/2, 1.2 * _card_scale, 1.2 * _card_scale, 0, c_white, _card_alpha);
    }
    
    // === ÁREA DO NOME (CENTRO) ===
    var _name_y = _card_y + _icon_area_h + 10;
    draw_set_color(make_color_rgb(192, 168, 98));
    draw_set_alpha(_card_alpha);
    draw_text(_card_x + _scaled_width/2, _name_y, _unidade.nome);
    
    // Linha divisória
    draw_set_color(make_color_rgb(60, 100, 150));
    draw_set_alpha(0.6 * _card_alpha);
    draw_rectangle(_card_x + 20, _name_y + 20, _card_x + _scaled_width - 20, _name_y + 22, false);
    draw_set_alpha(1);
    
    // === ÁREA DE INFORMAÇÕES (CENTRO-BAIXO) ===
    var _info_y = _name_y + 35;
    var _info_spacing = 18;
    
    draw_set_halign(fa_left);
    draw_set_alpha(_card_alpha);
    
    // Custo em dinheiro
    draw_set_color(make_color_rgb(255, 215, 0));
    draw_text(_card_x + 20, _info_y, "$" + string(_unidade.custo_dinheiro));
    
    // Custo em população
    draw_set_color(make_color_rgb(100, 200, 255));
    draw_text(_card_x + 20, _info_y + _info_spacing, string(_unidade.custo_populacao) + " POP");
    
    // Tempo de treino
    draw_set_color(make_color_rgb(180, 180, 180));
    draw_text(_card_x + 20, _info_y + (_info_spacing * 2), string(_unidade.tempo_treino / 60) + "s");
    
    draw_set_alpha(1);
    
    // === ÁREA DO BOTÃO (BAIXO) ===
    var _btn_w = _scaled_width - 40;
    var _btn_h = 35;
    var _btn_x = _card_x + 20;
    var _btn_y = _card_y + _scaled_height - _btn_h - 15;
    
    // Verificar hover no botão
    var _mouse_gui_x = device_mouse_x_to_gui(0);
    var _mouse_gui_y = device_mouse_y_to_gui(0);
    var _mouse_over_btn = (_mouse_gui_x >= _btn_x && _mouse_gui_x <= _btn_x + _btn_w && 
                          _mouse_gui_y >= _btn_y && _mouse_gui_y <= _btn_y + _btn_h);
    
    // Cor do botão baseada na disponibilidade
    var _btn_color = c_white;
    var _text_color = c_white;
    
    if (_disponivel) {
        if (_mouse_over_btn) {
            _btn_color = make_color_rgb(80, 140, 210);
        } else {
            _btn_color = make_color_rgb(60, 120, 190);
        }
        _text_color = c_white;
    } else if (!_can_afford) {
        _btn_color = make_color_rgb(190, 90, 90);
        _text_color = c_white;
    } else {
        _btn_color = make_color_rgb(110, 110, 110);
        _text_color = make_color_rgb(190, 190, 190);
    }
    
    // Sombra do botão
    draw_set_color(make_color_rgb(0, 0, 0));
    draw_set_alpha(0.3 * _card_alpha);
    draw_roundrect_ext(_btn_x + 2, _btn_y + 2, _btn_x + _btn_w + 2, _btn_y + _btn_h + 2, 8, 8, false);
    
    // Fundo do botão
    draw_set_color(_btn_color);
    draw_set_alpha(_card_alpha);
    draw_roundrect_ext(_btn_x, _btn_y, _btn_x + _btn_w, _btn_y + _btn_h, 8, 8, false);
    
    // Texto do botão
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(_text_color);
    var _btn_text = _disponivel ? "RECRUTAR" : (!_can_afford ? "SEM RECURSOS" : "QUARTEL OCUPADO");
    draw_text(_btn_x + _btn_w/2, _btn_y + _btn_h/2, _btn_text);
    
    // Efeito de brilho no hover
    if (_mouse_over_btn && _disponivel) {
        draw_set_color(make_color_rgb(255, 255, 255));
        draw_set_alpha(0.2 * _card_alpha);
        draw_roundrect_ext(_btn_x, _btn_y, _btn_x + _btn_w, _btn_y + _btn_h, 8, 8, false);
    }
    
    draw_set_alpha(1);
    
    // Dica visual quando mouse está sobre card disponível
    var _mouse_over_card = (_mouse_gui_x >= _card_x && _mouse_gui_x <= _card_x + _scaled_width && 
                           _mouse_gui_y >= _card_y && _mouse_gui_y <= _card_y + _scaled_height);
    
    if (_disponivel && _mouse_over_card) {
        // Borda pulsante
        draw_set_color(make_color_rgb(100, 200, 100));
        draw_set_alpha(0.6 * _card_alpha);
        draw_roundrect_ext(_card_x - 2, _card_y - 2, _card_x + _scaled_width + 2, _card_y + _scaled_height + 2, 14, 14, true);
        
        // Texto de dica
        draw_set_halign(fa_center);
        draw_set_color(make_color_rgb(255, 255, 255));
        draw_set_alpha(_card_alpha);
        draw_text(_card_x + _scaled_width/2, _card_y - 15, "Clique para recrutar");
        draw_set_alpha(1);
    }
}

// === SEÇÃO 5: RODAPÉ LIMPO ===
var _footer_h = 50;
var _footer_y = _animated_my + _animated_mh - _footer_h;

draw_set_alpha(footer_alpha * menu_alpha);

// Fundo do rodapé com gradiente horizontal
var _gradient_steps = 15;
for (var i = 0; i < _gradient_steps; i++) {
    var _step_alpha = i / _gradient_steps;
    var _step_color = make_color_rgb(
        20 + 10 * _step_alpha,
        30 + 15 * _step_alpha,
        45 + 10 * _step_alpha
    );
    var _step_x = _animated_mx + (i * _animated_mw / _gradient_steps);
    var _step_width = _animated_mw / _gradient_steps;
    
    draw_set_color(_step_color);
    draw_rectangle(_step_x, _footer_y, _step_x + _step_width, _animated_my + _animated_mh, false);
}

// Instrução clara
draw_set_halign(fa_left);
draw_set_color(make_color_rgb(220, 220, 220));
draw_text(_animated_mx + 20, _footer_y + 15, "Clique em uma unidade para recrutar");

// Botão fechar separado
var _close_w = 100;
var _close_h = 30;
var _close_x = _animated_mx + _animated_mw - _close_w - 20;
var _close_y = _footer_y + 10;

// Verificar hover no botão fechar
var _mouse_gui_x = device_mouse_x_to_gui(0);
var _mouse_gui_y = device_mouse_y_to_gui(0);
var _mouse_over_close = (_mouse_gui_x >= _close_x && _mouse_gui_x <= _close_x + _close_w && 
                        _mouse_gui_y >= _close_y && _mouse_gui_y <= _close_y + _close_h);

// Cores do botão fechar
var _close_color = _mouse_over_close ? make_color_rgb(220, 80, 80) : make_color_rgb(184, 76, 76);

// Sombra do botão fechar
draw_set_color(make_color_rgb(0, 0, 0));
draw_set_alpha(0.3 * footer_alpha * menu_alpha);
draw_roundrect_ext(_close_x + 2, _close_y + 2, _close_x + _close_w + 2, _close_y + _close_h + 2, 8, 8, false);

// Fundo do botão fechar
draw_set_color(_close_color);
draw_roundrect_ext(_close_x, _close_y, _close_x + _close_w, _close_y + _close_h, 8, 8, false);

// Texto do botão fechar
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text(_close_x + _close_w/2, _close_y + _close_h/2, "FECHAR");

// Brilho adicional no hover
if (_mouse_over_close) {
    draw_set_color(make_color_rgb(255, 255, 255));
    draw_set_alpha(0.15 * footer_alpha * menu_alpha);
    draw_roundrect_ext(_close_x, _close_y, _close_x + _close_w, _close_y + _close_h, 8, 8, false);
}

draw_set_alpha(1);

// === RESETAR CONFIGURAÇÕES ===
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);