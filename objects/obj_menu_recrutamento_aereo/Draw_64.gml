// ===============================================
// HEGEMONIA GLOBAL - MENU AÉREO MODERNO
// Interface Grid com Todas as Aeronaves
// ===============================================

// Verificar se o aeroporto ainda existe
if (id_do_aeroporto == noone || !instance_exists(id_do_aeroporto)) {
    instance_destroy();
    exit;
}

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
draw_set_color(make_color_rgb(10, 15, 25)); // Céu noturno
draw_rectangle(0, 0, _gui_w, _gui_h, false);
draw_set_alpha(1.0);

// === FUNDO PRINCIPAL COM GRADIENTE AÉREO ===
// Sombra
draw_set_color(c_black);
draw_set_alpha(0.6);
draw_roundrect_ext(_menu_x + 10, _menu_y + 10, _menu_x + _menu_w + 10, _menu_y + _menu_h + 10, 25, 25, false);

// Fundo principal
draw_set_alpha(1.0);
draw_set_color(make_color_rgb(20, 30, 50)); // Azul escuro aéreo
draw_roundrect_ext(_menu_x, _menu_y, _menu_x + _menu_w, _menu_y + _menu_h, 25, 25, false);

// Gradiente superior (céu)
draw_set_color(make_color_rgb(40, 60, 100)); // Azul céu escuro
draw_set_alpha(0.4);
draw_roundrect_ext(_menu_x, _menu_y, _menu_x + _menu_w, _menu_y + 100, 25, 25, false);
draw_set_alpha(1.0);

// Borda principal
draw_set_color(make_color_rgb(100, 150, 220)); // Azul céu claro
draw_set_alpha(0.8);
draw_roundrect_ext(_menu_x, _menu_y, _menu_x + _menu_w, _menu_y + _menu_h, 25, 25, true);
draw_set_alpha(1.0);

// === HEADER ===
var _header_h = 100;
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Título principal
draw_set_color(make_color_rgb(255, 255, 255));
draw_text_transformed(_menu_x + _menu_w/2, _menu_y + 35, "AEROPORTO MILITAR", 2.07, 2.07, 0);

// Subtítulo
draw_set_color(make_color_rgb(180, 210, 255)); // Azul céu claro
draw_text_transformed(_menu_x + _menu_w/2, _menu_y + 70, "Central de Produção Aérea - Frota Disponível", 1.15, 1.15, 0);

// === PAINEL DE RECURSOS ===
var _recursos_y = _menu_y + _header_h + 10;
var _recursos_h = 60;

draw_set_color(make_color_rgb(30, 45, 70)); // Azul escuro
draw_set_alpha(0.9);
draw_roundrect_ext(_menu_x + 20, _recursos_y, _menu_x + _menu_w - 20, _recursos_y + _recursos_h, 15, 15, false);
draw_set_alpha(1.0);

// Recursos
draw_set_halign(fa_left);
draw_set_color(make_color_rgb(255, 215, 0));
draw_text_transformed(_menu_x + 40, _recursos_y + 20, "DINHEIRO: $" + string(global.dinheiro), 1.38, 1.38, 0);

// Verificar se população existe, senão usar valor padrão
var _populacao = 50;
if (variable_global_exists("populacao")) {
    _populacao = global.populacao;
}

draw_set_color(make_color_rgb(180, 210, 255));
draw_text_transformed(_menu_x + 40, _recursos_y + 45, "População Disponível: " + string(_populacao), 1.035, 1.035, 0);

// Status do aeroporto
draw_set_halign(fa_right);
var _status_text = id_do_aeroporto.produzindo ? "PRODUZINDO" : "OCIOSO";
var _status_color = id_do_aeroporto.produzindo ? make_color_rgb(255, 200, 50) : make_color_rgb(100, 255, 100);
draw_set_color(_status_color);
draw_text_transformed(_menu_x + _menu_w - 40, _recursos_y + 30, "STATUS: " + _status_text, 1.15, 1.15, 0);

// === GRID DE AERONAVES (3 colunas x 2 linhas) ===
var _grid_start_y = _recursos_y + _recursos_h + 20;
var _grid_h = _menu_h - _header_h - _recursos_h - 180; // Espaço para footer

var _cols = 3;
var _rows = 2;
var _card_spacing = 20;
var _card_w = (_menu_w - 40 - (_cols - 1) * _card_spacing) / _cols;
var _card_h = ((_grid_h - (_rows - 1) * _card_spacing) / _rows) * 0.8; // Encurtado em 20%

// Obter lista de aeronaves
var _aeronaves = id_do_aeroporto.unidades_disponiveis;
var _total_aeronaves = ds_list_size(_aeronaves);

// Mouse position para hover
var _mouse_gui_x = device_mouse_x_to_gui(0);
var _mouse_gui_y = device_mouse_y_to_gui(0);
aeronave_hover = -1;

// Desenhar cada aeronave
for (var i = 0; i < min(_total_aeronaves, 6); i++) {
    var _aeronave = _aeronaves[| i];
    
    // Calcular posição do card
    var _col = i mod _cols;
    var _row = floor(i / _cols);
    var _card_x = _menu_x + 20 + _col * (_card_w + _card_spacing);
    var _card_y = _grid_start_y + _row * (_card_h + _card_spacing);
    
    // Verificar hover
    var _is_hover = (_mouse_gui_x >= _card_x && _mouse_gui_x <= _card_x + _card_w &&
                     _mouse_gui_y >= _card_y && _mouse_gui_y <= _card_y + _card_h);
    
    if (_is_hover) aeronave_hover = i;
    
    // Animação do card
    var _anim = card_animations[i];
    _anim.alpha = lerp(_anim.alpha, 1, 0.1);
    _anim.scale = lerp(_anim.scale, 1, 0.15);
    _anim.hover_intensity = lerp(_anim.hover_intensity, _is_hover ? 1 : 0, 0.2);
    _anim.pulse = (_anim.pulse + 0.05) mod (pi * 2);

    // Verificar se pode produzir
    var _can_produce = (global.dinheiro >= _aeronave.custo_dinheiro && 
                        _populacao >= _aeronave.custo_populacao &&
                        !id_do_aeroporto.produzindo);
    
    // Cores baseadas em estado
    var _card_color = _can_produce ? make_color_rgb(35, 55, 85) : make_color_rgb(40, 40, 50);
    var _border_color = _can_produce ? make_color_rgb(100, 150, 220) : make_color_rgb(80, 80, 90);
    
    if (_is_hover && _can_produce) {
        _card_color = make_color_rgb(45, 75, 120);
        _border_color = make_color_rgb(130, 190, 255);
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
        draw_set_color(make_color_rgb(130, 190, 255));
        draw_set_alpha(0.15 + sin(_anim.pulse) * 0.1);
        draw_roundrect_ext(_card_x + 3, _card_y + 3, _card_x + _card_w - 3, _card_y + 30, 10, 10, false);
    }
    
    draw_set_alpha(1.0);
    
    // === CONTEÚDO DO CARD ===
    var _content_x = _card_x + 15;
    var _content_y = _card_y + 15;
    
    // Nome da aeronave
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(_can_produce ? make_color_rgb(255, 255, 255) : make_color_rgb(150, 150, 150));
    draw_text_transformed(_content_x, _content_y, string_upper(_aeronave.nome), 1.265, 1.265, 0);
    
    // Ícone/Sprite da aeronave (placeholder) - Movido 15% para baixo
    var _icon_y = _content_y + 50;
    var _icon_x = _content_x + (_card_w * 0.6); // 60% da largura do card
    draw_set_color(_can_produce ? make_color_rgb(100, 160, 240) : make_color_rgb(100, 100, 100));
    draw_set_alpha(0.3);
    draw_circle(_icon_x, _icon_y, 25, false);
    draw_set_alpha(1.0);
    
    // Tentar desenhar sprite se existir
    if (_aeronave.nome == "Caça F-5" && sprite_exists(spr_caca_f5)) {
        draw_sprite_ext(spr_caca_f5, 0, _icon_x, _icon_y, 1.5, 1.5, 0, c_white, _anim.alpha);
    } else if (_aeronave.nome == "F-15 Eagle" && sprite_exists(spr_f15)) {
        draw_sprite_ext(spr_f15, 0, _icon_x, _icon_y, 0.75, 0.75, 0, c_white, _anim.alpha); // ✅ Reduzido 50%
    } else if (_aeronave.nome == "Helicóptero Militar" && sprite_exists(spr_helicoptero_militar)) {
        draw_sprite_ext(spr_helicoptero_militar, 0, _icon_x, _icon_y, 1.5, 1.5, 0, c_white, _anim.alpha);
    } else if (_aeronave.nome == "C-100 Transporte" && sprite_exists(spr_c100)) {
        draw_sprite_ext(spr_c100, 0, _icon_x, _icon_y, 0.75, 0.75, 0, c_white, _anim.alpha); // ✅ Reduzido 50%
    }
    
    // Descrição
    var _desc_y = _icon_y + 40;
    draw_set_color(_can_produce ? make_color_rgb(200, 220, 240) : make_color_rgb(120, 120, 120));
    draw_text_ext_transformed(_content_x, _desc_y, _aeronave.descricao, 18, _card_w - 30, 0.8625, 0.8625, 0);
    
    // Informações - Movido 15% para cima
    var _info_y = _card_y + _card_h - 65;
    
    // Custo - Aumentado em 10%
    draw_set_color(_can_produce ? make_color_rgb(255, 215, 0) : make_color_rgb(150, 150, 100));
    draw_text_transformed(_content_x, _info_y, "$ " + string(_aeronave.custo_dinheiro), 1.1385, 1.1385, 0);
    
    // População
    draw_set_color(_can_produce ? make_color_rgb(180, 210, 255) : make_color_rgb(120, 120, 120));
    draw_text_transformed(_content_x, _info_y + 20, "Pop: " + string(_aeronave.custo_populacao), 0.92, 0.92, 0);
    
    // Tempo
    var _tempo_seg = _aeronave.tempo_treino / 60;
    draw_text_transformed(_content_x, _info_y + 35, "Tempo: " + string(_tempo_seg) + "s", 0.92, 0.92, 0);
    
    // Botão PRODUZIR
    var _btn_y = _card_y + _card_h - 35;
    var _btn_h = 30;
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
    draw_text_transformed(_btn_x + _btn_w/2, _btn_y + _btn_h/2 - 8, _can_produce ? "PRODUZIR" : "BLOQUEADO", 0.9775, 0.9775, 0);
}

// === FILA DE PRODUÇÃO ===
var _fila_y = _menu_y + _menu_h - 130;
var _fila_h = 80;

draw_set_color(make_color_rgb(30, 45, 70));
draw_set_alpha(0.9);
draw_roundrect_ext(_menu_x + 20, _fila_y, _menu_x + _menu_w - 20, _fila_y + _fila_h, 15, 15, false);
draw_set_alpha(1.0);

draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_set_color(make_color_rgb(220, 230, 255));
draw_text_transformed(_menu_x + 40, _fila_y + 20, "FILA DE PRODUÇÃO", 1.15, 1.15, 0);

var _fila_size = ds_queue_size(id_do_aeroporto.fila_producao);
draw_set_color(make_color_rgb(255, 255, 255));
draw_text_transformed(_menu_x + 40, _fila_y + 45, "Unidades na fila: " + string(_fila_size), 1.035, 1.035, 0);

draw_set_halign(fa_right);
draw_set_color(make_color_rgb(180, 210, 255));
draw_text_transformed(_menu_x + _menu_w - 40, _fila_y + 45, "Total produzido: " + string(id_do_aeroporto.unidades_produzidas), 1.035, 1.035, 0);

// === BOTÃO FECHAR ===
var _close_w = 140;
var _close_h = 45;
var _close_x = _menu_x + _menu_w - _close_w - 20;
var _close_y = _menu_y + _menu_h - 60;

draw_set_color(make_color_rgb(180, 60, 60));
draw_roundrect_ext(_close_x, _close_y, _close_x + _close_w, _close_y + _close_h, 10, 10, false);

draw_set_color(make_color_rgb(255, 255, 255));
draw_set_alpha(0.9);
draw_roundrect_ext(_close_x, _close_y, _close_x + _close_w, _close_y + _close_h, 10, 10, true);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(make_color_rgb(255, 255, 255));
draw_text_transformed(_close_x + _close_w/2, _close_y + _close_h/2, "FECHAR", 1.15, 1.15, 0);
draw_set_alpha(1.0);

// === CONTROLES DE QUANTIDADE ===
var _controls_y = _close_y - 80;
var _controls_x = _menu_x + 20;

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(make_color_rgb(120, 170, 220));
draw_text_transformed(_controls_x, _controls_y, "CONTROLES DE QUANTIDADE:", 0.92, 0.92, 0);

draw_set_color(make_color_rgb(255, 255, 255));
draw_text_transformed(_controls_x, _controls_y + 20, "• Clique normal: 1 unidade", 0.805, 0.805, 0);
draw_text_transformed(_controls_x, _controls_y + 35, "• Shift + Clique: 5 unidades", 0.805, 0.805, 0);
draw_text_transformed(_controls_x, _controls_y + 50, "• Ctrl + Clique: 10 unidades", 0.805, 0.805, 0);

// Reset
draw_set_halign(fa_left);
draw_set_valign(fa_top);
