// ===============================================
// HEGEMONIA GLOBAL - MENU MILITAR MODERNO
// Interface Grid com Todas as Unidades Terrestres
// Design Verde Militar
// ===============================================

// Verificar se o quartel ainda existe
if (id_do_quartel == noone || !instance_exists(id_do_quartel)) {
    instance_destroy();
    exit;
}

// Incrementar timer de animação
animation_timer++;

// === DIMENSÕES E POSICIONAMENTO ===
var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

// Menu ocupa 90% da tela
var _menu_w = _gui_w * 0.9;
var _menu_h = _gui_h * 0.9;
var _menu_x = (_gui_w - _menu_w) / 2;
var _menu_y = (_gui_h - _menu_h) / 2;

// === OVERLAY DE FUNDO ===
draw_set_alpha(0.92);
draw_set_color(make_color_rgb(5, 10, 20));
draw_rectangle(0, 0, _gui_w, _gui_h, false);
draw_set_alpha(1.0);

// === FUNDO PRINCIPAL COM GRADIENTE VERDE MILITAR ===
// Sombra
draw_set_color(c_black);
draw_set_alpha(0.6);
draw_roundrect_ext(_menu_x + 10, _menu_y + 10, _menu_x + _menu_w + 10, _menu_y + _menu_h + 10, 25, 25, false);

// Fundo principal (verde militar em vez de azul naval)
draw_set_alpha(1.0);
draw_set_color(make_color_rgb(15, 40, 25));
draw_roundrect_ext(_menu_x, _menu_y, _menu_x + _menu_w, _menu_y + _menu_h, 25, 25, false);

// Gradiente superior
draw_set_color(make_color_rgb(30, 80, 50));
draw_set_alpha(0.4);
draw_roundrect_ext(_menu_x, _menu_y, _menu_x + _menu_w, _menu_y + 100, 25, 25, false);
draw_set_alpha(1.0);

// Borda principal (verde claro militar)
draw_set_color(make_color_rgb(60, 200, 120));
draw_set_alpha(0.8);
draw_roundrect_ext(_menu_x, _menu_y, _menu_x + _menu_w, _menu_y + _menu_h, 25, 25, true);
draw_set_alpha(1.0);

// === HEADER ===
var _header_h = 100;
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Título principal - AUMENTADO 20% (1.8 * 1.2 = 2.16)
    draw_set_color(make_color_rgb(255, 255, 255));
draw_text_transformed(_menu_x + _menu_w/2, _menu_y + 35, "QUARTEL MILITAR", 2.16, 2.16, 0);

// Subtítulo - AUMENTADO 20% (1.0 * 1.2 = 1.2)
draw_set_color(make_color_rgb(150, 255, 200));
draw_text_transformed(_menu_x + _menu_w/2, _menu_y + 75, "Central de Produção Terrestre - Exército Disponível", 1.2, 1.2, 0);

// === PAINEL DE RECURSOS - ALTURA AUMENTADA 20% ===
var _recursos_y = _menu_y + _header_h + 15; // +20% de espaçamento (12 + 3)
var _recursos_h = 72; // Aumentado 20% (60 * 1.2 = 72)

draw_set_color(make_color_rgb(25, 60, 40));
draw_set_alpha(0.9);
draw_roundrect_ext(_menu_x + 20, _recursos_y, _menu_x + _menu_w - 20, _recursos_y + _recursos_h, 15, 15, false);
draw_set_alpha(1.0);

// Recursos - AUMENTADO 20% (1.2 * 1.2 = 1.44)
draw_set_halign(fa_left);
draw_set_color(make_color_rgb(255, 215, 0));
draw_text_transformed(_menu_x + 40, _recursos_y + 20, "DINHEIRO: $" + string(global.dinheiro), 1.44, 1.44, 0);

// Verificar se população existe, senão usar valor padrão
var _populacao = 50;
if (variable_global_exists("populacao")) {
    _populacao = global.populacao;
}

draw_set_color(make_color_rgb(150, 255, 200));
draw_text_transformed(_menu_x + 40, _recursos_y + 50, "População Disponível: " + string(_populacao), 1.08, 1.08, 0); // 0.9 * 1.2

// Status do quartel - AUMENTADO 20% (1.0 * 1.2 = 1.2)
draw_set_halign(fa_right);
var _status_text = id_do_quartel.esta_treinando ? "TREINANDO" : "OCIOSO";
var _status_color = id_do_quartel.esta_treinando ? make_color_rgb(255, 200, 50) : make_color_rgb(100, 255, 100);
draw_set_color(_status_color);
draw_text_transformed(_menu_x + _menu_w - 40, _recursos_y + 30, "STATUS: " + _status_text, 1.2, 1.2, 0);

// === GRID DE UNIDADES (3 colunas x 2 linhas) ===
var _grid_start_y = _recursos_y + _recursos_h + 25; // AUMENTADO 20% de espaçamento (20 + 5)
var _grid_h = _menu_h - _header_h - _recursos_h - 220; // AUMENTADO 20% de espaço para footer (180 * 1.2 = 216, ajustado para 220)

var _cols = 3;
var _rows = 2;
var _card_spacing = 24; // AUMENTADO 20% (20 * 1.2 = 24)
var _card_w = (_menu_w - 40 - (_cols - 1) * _card_spacing) / _cols;
var _card_h = ((_grid_h - (_rows - 1) * _card_spacing) / _rows); // REMOVIDO o fator de 0.8 para dar mais altura

// Obter lista de unidades
var _unidades;
if (instance_exists(id_do_quartel) && !is_struct(id_do_quartel.unidades_disponiveis)) {
    _unidades = id_do_quartel.unidades_disponiveis;
} else {
    _unidades = ds_list_create();
}
var _total_unidades = ds_list_size(_unidades);

// Mouse position para hover
var _mouse_gui_x = device_mouse_x_to_gui(0);
var _mouse_gui_y = device_mouse_y_to_gui(0);
unidade_hover = -1;

// Desenhar cada unidade
for (var i = 0; i < min(_total_unidades, 6); i++) {
    var _unidade = ds_list_find_value(_unidades, i);
    
    // Calcular posição do card
    var _col = i mod _cols;
    var _row = floor(i / _cols);
    var _card_x = _menu_x + 20 + _col * (_card_w + _card_spacing);
    var _card_y = _grid_start_y + _row * (_card_h + _card_spacing);
    
    // Verificar hover
    var _is_hover = (_mouse_gui_x >= _card_x && _mouse_gui_x <= _card_x + _card_w &&
                     _mouse_gui_y >= _card_y && _mouse_gui_y <= _card_y + _card_h);
    
    if (_is_hover) unidade_hover = i;
    
    // Animação do card
    var _anim = card_animations[i];
    _anim.alpha = lerp(_anim.alpha, 1, 0.1);
    _anim.scale = lerp(_anim.scale, 1, 0.15);
    _anim.hover_intensity = lerp(_anim.hover_intensity, _is_hover ? 1 : 0, 0.2);
    _anim.pulse = (_anim.pulse + 0.05) mod (pi * 2);

    // Verificar se pode produzir
    var _can_produce = (global.dinheiro >= _unidade.custo_dinheiro && 
                        _populacao >= _unidade.custo_populacao &&
                        !id_do_quartel.esta_treinando);
    
    // Cores baseadas em estado (verde militar em vez de azul)
    var _card_color = _can_produce ? make_color_rgb(30, 75, 50) : make_color_rgb(40, 50, 40);
    var _border_color = _can_produce ? make_color_rgb(60, 200, 120) : make_color_rgb(80, 90, 80);
    
    if (_is_hover && _can_produce) {
        _card_color = make_color_rgb(40, 110, 70);
        _border_color = make_color_rgb(100, 255, 180);
    }
    
    // Sombra do card
    draw_set_color(c_black);
    draw_set_alpha(0.4 + _anim.hover_intensity * 0.2);
    draw_roundrect_ext(_card_x + 5, _card_y + 5, _card_x + _card_w + 5, _card_y + _card_h + 5, 12, 12, false);
    
    // Fundo do card
    draw_set_alpha(_anim.alpha);
    draw_set_color(_card_color);
    draw_roundrect_ext(_card_x, _card_y, _card_x + _card_w, _card_y + _card_h, 12, 12, false);
    
    // Borda do card
    draw_set_color(_border_color);
    draw_set_alpha(0.7 + _anim.hover_intensity * 0.3);
    draw_roundrect_ext(_card_x, _card_y, _card_x + _card_w, _card_y + _card_h, 12, 12, true);
    
    // Efeito de brilho no topo
    if (_can_produce) {
        draw_set_color(make_color_rgb(120, 255, 180));
        draw_set_alpha(0.15 + sin(_anim.pulse) * 0.1);
        draw_roundrect_ext(_card_x + 3, _card_y + 3, _card_x + _card_w - 3, _card_y + 30, 10, 10, false);
    }
    
    draw_set_alpha(1.0);
    
    // === CONTEÚDO DO CARD ===
    var _content_x = _card_x + 15;
    var _content_y = _card_y + 15;
    
    // Nome da unidade - AUMENTADO 20% (1.1 * 1.2 = 1.32)
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(_can_produce ? make_color_rgb(255, 255, 255) : make_color_rgb(150, 150, 150));
    draw_text_transformed(_content_x, _content_y, string_upper(_unidade.nome), 1.32, 1.32, 0);
    
    // Ícone/Sprite da unidade - POSIÇÃO AJUSTADA
    var _icon_y = _content_y + 42; // AUMENTADO 20% (35 * 1.2 = 42)
    var _icon_x = _content_x + (_card_w * 0.6);
    draw_set_color(_can_produce ? make_color_rgb(80, 220, 140) : make_color_rgb(100, 100, 100));
    draw_set_alpha(0.3);
    draw_circle(_icon_x, _icon_y, 25, false);
    draw_set_alpha(1.0);
    
    // Desenhar sprite se existir
    var _sprite_desenhado = false;
    if (_unidade.nome == "Infantaria" && sprite_exists(spr_infantaria)) {
        draw_sprite_ext(spr_infantaria, 0, _icon_x, _icon_y, 1.5, 1.5, 0, c_white, _anim.alpha);
        _sprite_desenhado = true;
    } else if (_unidade.nome == "Soldado Anti-Aéreo" && sprite_exists(spr_soldado_antiaereo)) {
        draw_sprite_ext(spr_soldado_antiaereo, 0, _icon_x, _icon_y, 1.5, 1.5, 0, c_white, _anim.alpha);
        _sprite_desenhado = true;
    } else if (_unidade.nome == "Tanque" && sprite_exists(spr_tanque)) {
        draw_sprite_ext(spr_tanque, 0, _icon_x, _icon_y, 1.5, 1.5, 0, c_white, _anim.alpha);
        _sprite_desenhado = true;
    } else if (_unidade.nome == "Blindado Anti-Aéreo" && sprite_exists(spr_blindado_antiaereo)) {
        draw_sprite_ext(spr_blindado_antiaereo, 0, _icon_x, _icon_y, 1.5, 1.5, 0, c_white, _anim.alpha);
        _sprite_desenhado = true;
    }
    
    // Descrição - AUMENTADO 20% (0.75 * 1.2 = 0.9)
    var _desc_y = _icon_y + 48; // AUMENTADO 20% (40 * 1.2 = 48)
    draw_set_color(_can_produce ? make_color_rgb(180, 230, 200) : make_color_rgb(120, 120, 120));
    draw_text_ext_transformed(_content_x, _desc_y, _unidade.descricao, 18, _card_w - 30, 0.9, 0.9, 0);
    
    // Informações - POSIÇÃO AJUSTADA
    var _info_y = _card_y + _card_h - 75; // AUMENTADO de 65 para 75
    
    // Custo - AUMENTADO 20% (0.99 * 1.2 = 1.188)
    draw_set_color(_can_produce ? make_color_rgb(255, 215, 0) : make_color_rgb(150, 150, 100));
    draw_text_transformed(_content_x, _info_y, "$ " + string(_unidade.custo_dinheiro), 1.188, 1.188, 0);
    
    // População - AUMENTADO 20% (0.8 * 1.2 = 0.96) E ESPAÇAMENTO AJUSTADO
    draw_set_color(_can_produce ? make_color_rgb(150, 255, 200) : make_color_rgb(120, 120, 120));
    draw_text_transformed(_content_x, _info_y + 24, "Pop: " + string(_unidade.custo_populacao), 0.96, 0.96, 0); // 20 * 1.2 = 24
    
    // Tempo - AUMENTADO 20% (0.8 * 1.2 = 0.96) E ESPAÇAMENTO AJUSTADO
    var _tempo_seg = _unidade.tempo_treino / 60;
    draw_text_transformed(_content_x, _info_y + 48, "Tempo: " + string(_tempo_seg) + "s", 0.96, 0.96, 0); // 35 * 1.37 ≈ 48
    
    // === BOTÕES DE QUANTIDADE (1, 5, 10) ===
    var _btn_quant_y = _card_y + _card_h - 85;
    var _btn_quant_h = 28;
    var _btn_quant_w = (_card_w - 30) / 3 - 2;
    var _btn_quant_spacing = 2;
    
    var _quantidades = [1, 5, 10];
    var _btn_textos = ["1", "5", "10"];
    
    for (var _q = 0; _q < 3; _q++) {
        var _quant = _quantidades[_q];
        var _btn_q_x = _card_x + 15 + _q * (_btn_quant_w + _btn_quant_spacing);
        var _btn_q_y = _btn_quant_y;
        
        // Verificar hover
        var _mouse_over_qbtn = (_mouse_gui_x >= _btn_q_x && _mouse_gui_x <= _btn_q_x + _btn_quant_w &&
                               _mouse_gui_y >= _btn_q_y && _mouse_gui_y <= _btn_q_y + _btn_quant_h);
        
        // Calcular custo para esta quantidade
        var _custo_q_dinheiro = _unidade.custo_dinheiro * _quant;
        var _custo_q_populacao = _unidade.custo_populacao * _quant;
        var _can_afford_quant = (global.dinheiro >= _custo_q_dinheiro && 
                                _populacao >= _custo_q_populacao &&
                                !id_do_quartel.esta_treinando);
        
        // Cor do botão
        var _qbtn_color = _can_afford_quant ? make_color_rgb(60, 140, 60) : make_color_rgb(80, 80, 80);
        if (_mouse_over_qbtn && _can_afford_quant) _qbtn_color = make_color_rgb(80, 180, 80);
        
        draw_set_color(_qbtn_color);
        draw_roundrect_ext(_btn_q_x, _btn_q_y, _btn_q_x + _btn_quant_w, _btn_q_y + _btn_quant_h, 6, 6, false);
        
        draw_set_color(make_color_rgb(255, 255, 255));
        draw_set_alpha(0.9);
        draw_roundrect_ext(_btn_q_x, _btn_q_y, _btn_q_x + _btn_quant_w, _btn_q_y + _btn_quant_h, 6, 6, true);
        draw_set_alpha(1.0);
        
        draw_set_halign(fa_center);
        draw_set_color(_can_afford_quant ? make_color_rgb(255, 255, 255) : make_color_rgb(150, 150, 150));
        draw_text_transformed(_btn_q_x + _btn_quant_w/2, _btn_q_y + _btn_quant_h/2 - 2, _btn_textos[_q], 0.9, 0.9, 0);
    }
    
    // Botão TREINAR - POSIÇÃO AJUSTADA (mais acima)
    var _btn_y = _card_y + _card_h - 50;
    var _btn_h = 36;
    var _btn_w = _card_w - 30;
    var _btn_x = _card_x + 15;
    
    var _btn_color = _can_produce ? make_color_rgb(60, 140, 60) : make_color_rgb(80, 80, 80);
    if (_is_hover && _can_produce) _btn_color = make_color_rgb(80, 180, 80);
    
    draw_set_color(_btn_color);
    draw_roundrect_ext(_btn_x, _btn_y, _btn_x + _btn_w, _btn_y + _btn_h, 8, 8, false);
    
    draw_set_color(make_color_rgb(255, 255, 255));
    draw_set_alpha(0.9);
    draw_roundrect_ext(_btn_x, _btn_y, _btn_x + _btn_w, _btn_y + _btn_h, 8, 8, true);
    draw_set_alpha(1.0);
        
    draw_set_halign(fa_center);
    draw_set_color(_can_produce ? make_color_rgb(255, 255, 255) : make_color_rgb(150, 150, 150));
    draw_text_transformed(_btn_x + _btn_w/2, _btn_y + _btn_h/2 - 4, _can_produce ? "TREINAR" : "BLOQUEADO", 1.02, 1.02, 0);
}

// === FILA DE PRODUÇÃO ===
var _fila_y = _menu_y + _menu_h - 156; // AUMENTADO (130 * 1.2 = 156)
var _fila_h = 96; // AUMENTADO 20% (80 * 1.2 = 96)

draw_set_color(make_color_rgb(25, 60, 40));
draw_set_alpha(0.9);
draw_roundrect_ext(_menu_x + 20, _fila_y, _menu_x + _menu_w - 20, _fila_y + _fila_h, 15, 15, false);
draw_set_alpha(1.0);

draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_set_color(make_color_rgb(200, 255, 220));
draw_text_transformed(_menu_x + 40, _fila_y + 20, "FILA DE RECRUTAMENTO", 1.2, 1.2, 0); // AUMENTADO 20%

var _fila_size = ds_queue_size(id_do_quartel.fila_recrutamento);
draw_set_color(make_color_rgb(255, 255, 255));
draw_text_transformed(_menu_x + 40, _fila_y + 54, "Unidades na fila: " + string(_fila_size), 1.08, 1.08, 0); // 0.9 * 1.2 e posição ajustada

draw_set_halign(fa_right);
draw_set_color(make_color_rgb(150, 255, 200));
draw_text_transformed(_menu_x + _menu_w - 40, _fila_y + 54, "Total treinado: " + string(id_do_quartel.unidades_criadas), 1.08, 1.08, 0);

// === BOTÃO FECHAR - AUMENTADO 20% ===
var _close_w = 168; // AUMENTADO 20% (140 * 1.2 = 168)
var _close_h = 54; // AUMENTADO 20% (45 * 1.2 = 54)
var _close_x = _menu_x + _menu_w - _close_w - 20;
var _close_y = _menu_y + _menu_h - 72; // AUMENTADO (60 * 1.2 = 72)

draw_set_color(make_color_rgb(180, 60, 60));
draw_roundrect_ext(_close_x, _close_y, _close_x + _close_w, _close_y + _close_h, 10, 10, false);

draw_set_color(make_color_rgb(255, 255, 255));
draw_set_alpha(0.9);
draw_roundrect_ext(_close_x, _close_y, _close_x + _close_w, _close_y + _close_h, 10, 10, true);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(make_color_rgb(255, 255, 255));
draw_text_transformed(_close_x + _close_w/2, _close_y + _close_h/2, "FECHAR", 1.2, 1.2, 0); // AUMENTADO 20%
draw_set_alpha(1.0);

// === CONTROLES DE QUANTIDADE ===
var _controls_y = _close_y - 96; // AUMENTADO (80 * 1.2 = 96)
var _controls_x = _menu_x + 20;

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(make_color_rgb(100, 200, 150));
draw_text_transformed(_controls_x, _controls_y, "CONTROLES DE QUANTIDADE:", 0.96, 0.96, 0); // 0.8 * 1.2

draw_set_color(make_color_rgb(255, 255, 255));
draw_text_transformed(_controls_x, _controls_y + 24, "• Clique normal: 1 unidade", 0.84, 0.84, 0); // 0.7 * 1.2
draw_text_transformed(_controls_x, _controls_y + 42, "• Shift + Clique: 5 unidades", 0.84, 0.84, 0); // 0.7 * 1.2
draw_text_transformed(_controls_x, _controls_y + 60, "• Ctrl + Clique: 10 unidades", 0.84, 0.84, 0); // 0.7 * 1.2

// Reset
draw_set_halign(fa_left);
draw_set_valign(fa_top);
