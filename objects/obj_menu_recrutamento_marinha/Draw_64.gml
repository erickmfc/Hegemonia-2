// ===============================================
// HEGEMONIA GLOBAL - MENU NAVAL MODERNO
// Interface Grid com Todos os Navios
// ===============================================

// Verificar se o quartel ainda existe
if (meu_quartel_id == noone || !instance_exists(meu_quartel_id)) {
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
draw_set_color(make_color_rgb(5, 10, 20));
draw_rectangle(0, 0, _gui_w, _gui_h, false);
draw_set_alpha(1.0);

// === FUNDO PRINCIPAL COM GRADIENTE NAVAL ===
// Sombra
draw_set_color(c_black);
draw_set_alpha(0.6);
draw_roundrect_ext(_menu_x + 10, _menu_y + 10, _menu_x + _menu_w + 10, _menu_y + _menu_h + 10, 25, 25, false);

// Fundo principal
draw_set_alpha(1.0);
draw_set_color(make_color_rgb(15, 25, 40));
draw_roundrect_ext(_menu_x, _menu_y, _menu_x + _menu_w, _menu_y + _menu_h, 25, 25, false);

// Gradiente superior
draw_set_color(make_color_rgb(30, 50, 80));
draw_set_alpha(0.4);
draw_roundrect_ext(_menu_x, _menu_y, _menu_x + _menu_w, _menu_y + 100, 25, 25, false);
draw_set_alpha(1.0);

// Borda principal
draw_set_color(make_color_rgb(60, 120, 200));
draw_set_alpha(0.8);
draw_roundrect_ext(_menu_x, _menu_y, _menu_x + _menu_w, _menu_y + _menu_h, 25, 25, true);
draw_set_alpha(1.0);

// === HEADER ===
var _header_h = 100;
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Título principal
// ✅ CORREÇÃO: Tamanho de fonte reduzido para tamanho normal
draw_set_color(make_color_rgb(255, 255, 255));
draw_text_transformed(_menu_x + _menu_w/2, _menu_y + 35, "QUARTEL DE MARINHA", 1.0, 1.0, 0);

// Subtítulo
draw_set_color(make_color_rgb(150, 200, 255));
draw_text_transformed(_menu_x + _menu_w/2, _menu_y + 70, "Central de Produção Naval - Frota Disponível", 0.8, 0.8, 0);

// === PAINEL DE RECURSOS ===
var _recursos_y = _menu_y + _header_h + 10;
var _recursos_h = 60;

draw_set_color(make_color_rgb(25, 40, 60));
draw_set_alpha(0.9);
draw_roundrect_ext(_menu_x + 20, _recursos_y, _menu_x + _menu_w - 20, _recursos_y + _recursos_h, 15, 15, false);
draw_set_alpha(1.0);

// Recursos
// ✅ CORREÇÃO: Tamanho de fonte reduzido
draw_set_halign(fa_left);
draw_set_color(make_color_rgb(255, 215, 0));
draw_text_transformed(_menu_x + 40, _recursos_y + 20, "DINHEIRO: $" + string(global.dinheiro), 0.9, 0.9, 0);

// Verificar se população existe, senão usar valor padrão
var _populacao = 50;
if (variable_global_exists("populacao")) {
    _populacao = global.populacao;
}

draw_set_color(make_color_rgb(150, 200, 255));
draw_text_transformed(_menu_x + 40, _recursos_y + 45, "População Disponível: " + string(_populacao), 0.8, 0.8, 0);

// Status do quartel
draw_set_halign(fa_right);
var _status_text = meu_quartel_id.produzindo ? "PRODUZINDO" : "OCIOSO";
var _status_color = meu_quartel_id.produzindo ? make_color_rgb(255, 200, 50) : make_color_rgb(100, 255, 100);
draw_set_color(_status_color);
draw_text_transformed(_menu_x + _menu_w - 40, _recursos_y + 30, "STATUS: " + _status_text, 0.9, 0.9, 0);

// === GRID DE NAVIOS (3 colunas x 2 linhas) ===
var _grid_start_y = _recursos_y + _recursos_h + 20;
var _grid_h = _menu_h - _header_h - _recursos_h - 180; // Espaço para footer

var _cols = 3;
var _rows = 2;
var _card_spacing = 20;
// ✅ AJUSTE: Calcular tamanho considerando aumento de 20%, mas garantindo que caiba na tela
// Espaço disponível para cards (considerando margens e espaçamento)
var _espaco_disponivel_w = _menu_w - 40 - (_cols - 1) * _card_spacing;
var _espaco_disponivel_h = _grid_h - (_rows - 1) * _card_spacing;
// Usar 85% do espaço disponível para garantir que os cards caibam na tela mesmo com o aumento
var _card_w = (_espaco_disponivel_w / _cols) * 0.85; // 85% do espaço para garantir que caiba
var _card_h = (_espaco_disponivel_h / _rows) * 0.85 * 1.1; // 85% do espaço + 10% de aumento para baixo

// Obter lista de navios
var _navios = meu_quartel_id.unidades_disponiveis;
var _total_navios = ds_list_size(_navios);

// Mouse position para hover
var _mouse_gui_x = device_mouse_x_to_gui(0);
var _mouse_gui_y = device_mouse_y_to_gui(0);
navio_hover = -1;

// Desenhar cada navio
for (var i = 0; i < min(_total_navios, 6); i++) {
    var _navio = _navios[| i];
    
    // Calcular posição do card
    var _col = i mod _cols;
    var _row = floor(i / _cols);
    var _card_x = _menu_x + 20 + _col * (_card_w + _card_spacing);
    // ✅ AJUSTE: Mover cards de baixo em 20% para baixo
    var _card_y = _grid_start_y + _row * (_card_h + _card_spacing);
    if (_row == 1) {
        _card_y += _card_h * 0.2; // Mover segunda linha 20% para baixo
    }
    
    // Verificar hover
    var _is_hover = (_mouse_gui_x >= _card_x && _mouse_gui_x <= _card_x + _card_w &&
                     _mouse_gui_y >= _card_y && _mouse_gui_y <= _card_y + _card_h);
    
    if (_is_hover) navio_hover = i;
    
    // Animação do card
    var _anim = card_animations[i];
    _anim.alpha = lerp(_anim.alpha, 1, 0.1);
    _anim.scale = lerp(_anim.scale, 1, 0.15);
    _anim.hover_intensity = lerp(_anim.hover_intensity, _is_hover ? 1 : 0, 0.2);
    _anim.pulse = (_anim.pulse + 0.05) mod (pi * 2);

// Verificar se pode produzir
    var _can_produce = (global.dinheiro >= _navio.custo_dinheiro && 
                        _populacao >= _navio.custo_populacao &&
                        !meu_quartel_id.produzindo);
    
    // Cores baseadas em estado
    var _card_color = _can_produce ? make_color_rgb(30, 50, 75) : make_color_rgb(40, 40, 50);
    var _border_color = _can_produce ? make_color_rgb(60, 120, 200) : make_color_rgb(80, 80, 90);
    
    if (_is_hover && _can_produce) {
        _card_color = make_color_rgb(40, 70, 110);
        _border_color = make_color_rgb(100, 180, 255);
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
    draw_set_color(make_color_rgb(120, 180, 255));
        draw_set_alpha(0.15 + sin(_anim.pulse) * 0.1);
        draw_roundrect_ext(_card_x + 3, _card_y + 3, _card_x + _card_w - 3, _card_y + 30, 10, 10, false);
    }
    
    draw_set_alpha(1.0);
    
    // === CONTEÚDO DO CARD ===
    var _content_x = _card_x + 15;
    var _content_y = _card_y + 15;
    
    // Nome do navio
    // ✅ CORREÇÃO: Tamanho de fonte reduzido
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(_can_produce ? make_color_rgb(255, 255, 255) : make_color_rgb(150, 150, 150));
    draw_text_transformed(_content_x, _content_y, string_upper(_navio.nome), 0.85, 0.85, 0);
    
    // Ícone/Sprite do navio (placeholder) - Movido 30% para a direita
    // ✅ AJUSTE: Mover imagem para baixo 15% (adicionar 15% da posição)
    var _icon_y_base = _content_y + 35;
    var _icon_y = _icon_y_base + (_icon_y_base * 0.15);
    var _icon_x = _content_x + (_card_w * 0.6); // 60% da largura do card (30% mais à direita)
    draw_set_color(_can_produce ? make_color_rgb(80, 140, 220) : make_color_rgb(100, 100, 100));
    draw_set_alpha(0.3);
    draw_circle(_icon_x, _icon_y, 25, false);
    draw_set_alpha(1.0);
    
    // Tentar desenhar sprite se existir
    // ✅ AJUSTE: Diminuir imagens em 10% (multiplicar todas as escalas por 0.9)
    var _sprite_desenhado = false;
    if (_navio.nome == "Lancha Patrulha" && sprite_exists(spr_lancha_patrulha)) {
        draw_sprite_ext(spr_lancha_patrulha, 0, _icon_x, _icon_y, 1.5 * 0.9, 1.5 * 0.9, 0, c_white, _anim.alpha);
        _sprite_desenhado = true;
    } else if (_navio.nome == "Constellation" && sprite_exists(spr_Constellation)) {
        draw_sprite_ext(spr_Constellation, 0, _icon_x, _icon_y, 0.975 * 0.9, 0.975 * 0.9, 0, c_white, _anim.alpha);
        _sprite_desenhado = true;
    } else if (_navio.nome == "Independence" && sprite_exists(spr_Independence)) {
        draw_sprite_ext(spr_Independence, 0, _icon_x, _icon_y, 0.975 * 0.9, 0.975 * 0.9, 0, c_white, _anim.alpha);
        _sprite_desenhado = true;
    } else if (_navio.nome == "Ww-Hendrick" && sprite_exists(spr_wwhendrick)) {
        draw_sprite_ext(spr_wwhendrick, 0, _icon_x, _icon_y, 1.3 * 0.9, 1.3 * 0.9, 0, c_white, _anim.alpha);
        _sprite_desenhado = true;
        if (i == 0 || (animation_timer % 180 == 0)) { // Debug a cada 3 segundos
            show_debug_message("🌊 Sprite Ww-Hendrick desenhado! Pos: (" + string(_icon_x) + ", " + string(_icon_y) + ")");
        }
    } else if (_navio.nome == "Ronald Reagan" && sprite_exists(spr_RonaldReagan)) {
        draw_sprite_ext(spr_RonaldReagan, 0, _icon_x, _icon_y, 0.975 * 0.9, 0.975 * 0.9, 0, c_white, _anim.alpha);
        _sprite_desenhado = true;
    }
    
    // DEBUG: Se não desenhou sprite, mostrar mensagem
    if (!_sprite_desenhado && i == 4 && animation_timer % 180 == 0) {
        show_debug_message("⚠️ Navio: " + _navio.nome + " - Sprite não encontrado ou nome incorreto");
    }
    
    // Descrição
    // ✅ CORREÇÃO: Tamanho de fonte reduzido
    var _desc_y = _icon_y + 40;
    draw_set_color(_can_produce ? make_color_rgb(180, 200, 230) : make_color_rgb(120, 120, 120));
    draw_text_ext_transformed(_content_x, _desc_y, _navio.descricao, 18, _card_w - 30, 0.7, 0.7, 0);
    
    // ✅ AJUSTE: Informações simplificadas - apenas tipo (Aéreo/Terrestre/Submerso)
    var _info_y = _card_y + _card_h - 65;
    
    // Determinar tipo da unidade
    var _tipo = "TERRESTRE"; // Padrão
    if (_navio.nome == "Lancha Patrulha" || _navio.nome == "Constellation" || 
        _navio.nome == "Independence" || _navio.nome == "Ronald Reagan") {
        _tipo = "NAVAL"; // Navios de superfície
    } else if (_navio.nome == "Ww-Hendrick") {
        _tipo = "SUBMERSO"; // Submarino
    }
    
    // Tipo da unidade
    draw_set_color(_can_produce ? make_color_rgb(150, 200, 255) : make_color_rgb(120, 120, 120));
    draw_text_transformed(_content_x, _info_y, "Tipo: " + _tipo, 0.75, 0.75, 0);
    
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
    draw_text_transformed(_btn_x + _btn_w/2, _btn_y + _btn_h/2 - 8, _can_produce ? "PRODUZIR" : "BLOQUEADO", 0.8, 0.8, 0);
}

// === FILA DE PRODUÇÃO ===
var _fila_y = _menu_y + _menu_h - 130;
var _fila_h = 80;

draw_set_color(make_color_rgb(25, 40, 60));
draw_set_alpha(0.9);
draw_roundrect_ext(_menu_x + 20, _fila_y, _menu_x + _menu_w - 20, _fila_y + _fila_h, 15, 15, false);
draw_set_alpha(1.0);

draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_set_color(make_color_rgb(200, 220, 255));
draw_text_transformed(_menu_x + 40, _fila_y + 20, "FILA DE PRODUÇÃO", 0.9, 0.9, 0);

    var _fila_size = ds_queue_size(meu_quartel_id.fila_producao);
draw_set_color(make_color_rgb(255, 255, 255));
draw_text_transformed(_menu_x + 40, _fila_y + 45, "Unidades na fila: " + string(_fila_size), 0.8, 0.8, 0);

draw_set_halign(fa_right);
draw_set_color(make_color_rgb(150, 200, 255));
draw_text_transformed(_menu_x + _menu_w - 40, _fila_y + 45, "Total produzido: " + string(meu_quartel_id.unidades_produzidas), 0.8, 0.8, 0);

// === BOTÃO FECHAR (PADRONIZADO) ===
var _close_w = 168; // Padronizado com menu de recrutamento
var _close_h = 54;  // Padronizado com menu de recrutamento
var _close_x = _menu_x + _menu_w - _close_w - 20;
var _close_y = _menu_y + _menu_h - 72; // Ajustado para sincronizar com dimensões

draw_set_color(make_color_rgb(180, 60, 60));
draw_roundrect_ext(_close_x, _close_y, _close_x + _close_w, _close_y + _close_h, 10, 10, false);

draw_set_color(make_color_rgb(255, 255, 255));
draw_set_alpha(0.9);
draw_roundrect_ext(_close_x, _close_y, _close_x + _close_w, _close_y + _close_h, 10, 10, true);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(make_color_rgb(255, 255, 255));
draw_text_transformed(_close_x + _close_w/2, _close_y + _close_h/2, "FECHAR", 0.9, 0.9, 0);
draw_set_alpha(1.0);

// Reset
draw_set_halign(fa_left);
draw_set_valign(fa_top);